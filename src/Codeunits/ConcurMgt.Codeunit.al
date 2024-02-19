codeunit 50008 "Concur Mgt."
{
    /// <summary>
    /// Concur_CreateBatch.
    /// Création d'une feuille comptabilité et d'une feuille projet de frais avec un même nom construit en fonction de la date du jour sous
    /// </summary>
    /// <returns>Return value of type Text[250].
    /// Nom des feuilles créées ou compte rendu
    /// Erreur : la création des feuilles a échoué pour la raison indiquée dans le libellé
    /// </returns>
    procedure Concur_CreateBatch(): Text[250]
    var
        InterfaceSetup: Record "Interface Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GLEntry: Record "G/L Entry";
        JobJnlTemplate: Record "Job Journal Template";
        JobJnlBatch: Record "Job Journal Batch";
        JobEntry: Record "Job Ledger Entry";
        RootNameExpenseJournal: Code[10];
        MaxNameExpenseJournal: Code[20];
        LastNumb: Integer;
        InterfaceSettings_Err: Label 'Interface settings missing', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramétrage interface absent" }, { "lang": "FRB", "txt": "Paramétrage interface absent" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GenJnlTemplateSettings_Err: Label 'Invalid Gen. journal template settings', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramétrage du modèle de feuille comptable de frais invalide" }, { "lang": "FRB", "txt": "Paramétrage du modèle de feuille comptable de frais invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        JobJournalTempSettings_Err: Label 'Invalid Job journal template setting', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramétrage du modèle de feuille projet de frais invalide" }, { "lang": "FRB", "txt": "Paramétrage du modèle de feuille projet de frais invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        NumbLastJournal_Err: Label 'Numbering of the last expense journal of the day invalid', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Numérotation de la dernière feuille de frais du jour invalide" }, { "lang": "FRB", "txt": "Numérotation de la dernière feuille de frais du jour invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        MaxNumbJournal_Err: Label 'Maximum number of daily expense journal reached', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nombre maximal de feuilles de frais du jour atteint" }, { "lang": "FRB", "txt": "Nombre maximal de feuilles de frais du jour atteint" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        NameExpenseJournal_Lbl: Label 'Journal import expense reals of %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Feuille import frais réels du %1" }, { "lang": "FRB", "txt": "Feuille import frais réels du %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        // Lecture des paramètres comptables pour déterminer les modèles des feuilles à créer
        IF NOT InterfaceSetup.GET() THEN
            EXIT(InterfaceSettings_Err);

        // Vérification de la cohérence du paramétrage de la feuille comptable de frais
        IF NOT GenJnlTemplate.GET(InterfaceSetup."Expense Journal Template") THEN
            EXIT(GenJnlTemplateSettings_Err);

        // Vérification de la cohérence du paramétrage de la feuille projet de frais
        IF NOT JobJnlTemplate.GET(InterfaceSetup."Expense Job Journal Template") THEN
            EXIT(JobJournalTempSettings_Err);

        // Evaluation de la racine du nom de la feuille de frais du jour
        RootNameExpenseJournal := 'FR' + FORMAT(TODAY, 0, '<Year,2><Month,2><day,2>');

        // Recherche de la dernière feuille comptable de frais du jour
        MaxNameExpenseJournal := '';
        GenJnlBatch.RESET();
        GenJnlBatch.SETRANGE("Journal Template Name", InterfaceSetup."Expense Journal Template");
        GenJnlBatch.SETFILTER(Name, RootNameExpenseJournal + '??');
        IF GenJnlBatch.FINDLAST() THEN
            MaxNameExpenseJournal := GenJnlBatch.Name;

        // Recherche de la dernière feuille projet de frais du jour
        JobJnlBatch.RESET();
        JobJnlBatch.SETRANGE("Journal Template Name", InterfaceSetup."Expense Job Journal Template");
        JobJnlBatch.SETFILTER(Name, RootNameExpenseJournal + '??');
        IF JobJnlBatch.FINDLAST() THEN
            IF JobJnlBatch.Name > MaxNameExpenseJournal THEN
                MaxNameExpenseJournal := JobJnlBatch.Name;

        // Recherche de la dernière écriture comptable de frais validée ce jour
        GLEntry.RESET();
        GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
        GLEntry.SETRANGE("Posting Date", TODAY);
        GLEntry.SETFILTER("Document No.", RootNameExpenseJournal + '??-S*');
        IF GLEntry.FINDLAST() THEN
            IF GLEntry."Document No." > MaxNameExpenseJournal THEN
                MaxNameExpenseJournal := GLEntry."Document No.";

        // Recherche de la dernière écriture projet de frais validée ce jour
        JobEntry.RESET();
        JobEntry.SETCURRENTKEY("Document No.", "Posting Date", "Entry Type");
        JobEntry.SETRANGE("Posting Date", TODAY);
        JobEntry.SETRANGE("Entry Type", JobEntry."Entry Type"::Usage);
        JobEntry.SETFILTER("Document No.", RootNameExpenseJournal + '??-S*');
        IF JobEntry.FINDLAST() THEN
            IF JobEntry."Document No." > MaxNameExpenseJournal THEN
                MaxNameExpenseJournal := JobEntry."Document No.";

        // Evaluation du nom de la feuille de frais à créer
        IF MaxNameExpenseJournal = '' THEN
            // Création du nom de la première feuille de frais de la journée
            MaxNameExpenseJournal := RootNameExpenseJournal + '01'
        ELSE BEGIN
            // Test numérotation valide de la dernière feuille de frais du jour
            IF NOT (EVALUATE(LastNumb, COPYSTR(MaxNameExpenseJournal, STRLEN(RootNameExpenseJournal) + 1, 2))) THEN
                EXIT(NumbLastJournal_Err);

            // Test si la création d'une nouvelle feuille de frais du jour est possible
            IF (LastNumb = 99) THEN
                EXIT(MaxNumbJournal_Err);

            // Création du nom de la prochaine feuille de frais du jour
            MaxNameExpenseJournal := INCSTR(COPYSTR(MaxNameExpenseJournal, 1, STRLEN(RootNameExpenseJournal) + 2));
        END;

        // Création de la feuille comptable de frais
        GenJnlBatch.INIT();
        GenJnlBatch."Journal Template Name" := InterfaceSetup."Expense Journal Template";
        GenJnlBatch.Name := CopyStr(MaxNameExpenseJournal, 1, MaxStrLen(GenJnlBatch.Name));
        GenJnlBatch.Description := STRSUBSTNO(NameExpenseJournal_Lbl, FORMAT(TODAY, 0, '<day,2>/<Month,2>/<Year,2>'));
        GenJnlBatch.INSERT(TRUE);

        // Création de la feuille projet de frais
        JobJnlBatch.INIT();
        JobJnlBatch."Journal Template Name" := InterfaceSetup."Expense Job Journal Template";
        JobJnlBatch.Name := CopyStr(MaxNameExpenseJournal, 1, MaxStrLen(JobJnlBatch.Name));
        JobJnlBatch.Description := GenJnlBatch.Description;
        JobJnlBatch.INSERT(TRUE);

        EXIT(MaxNameExpenseJournal);
    end;

    /// <summary>
    /// Concur_InsertDataBatch.
    /// Alimentation des feuilles de frais. La fonctionnalité ajoute une ligne de frais dans une feuille de comptabilité et dans 
    /// une feuille projet ; la feuille projet est alimentée uniquement si la ligne ne concerne pas un compte de TVA. 
    /// La ligne est ajoutée en date de comptabilisation et de début du jour. 
    /// </summary>
    /// <param name="pJournalName">Code[10]: nom des feuilles de comptabilité et projet sur lesquelles il faut ajouter la ligne de frais</param>
    /// <param name="pRegistrationNumber">Code[20]: matricule de la ressource concernée par la ligne de frais</param>
    /// <param name="pJob">Code[20]: projet d'imputation de la ligne de frais</param>
    /// <param name="NoCG">Code[20]: N° du compte comptable d'imputation de la ligne de frais</param>
    /// <param name="pAmount">Decimal: montant de la ligne de frais</param>
    /// <param name="pTVA">Boolean: indicateur de ligne de TVA (Oui : ligne de compte de TVA / Faux : ligne de compte de charges)</param>
    /// <returns>Return value of type Text[250]:
    /// Vide : l'alimentation de la ligne a été traitée avec succès,
    /// Erreur : l'alimentation de la ligne a échoué pour la raison indiquée explicitement dans le compte rendu de traitement. 
    /// </returns>
    procedure Concur_InsertDataBatch(pJournalName: Code[10]; pRegistrationNumber: Code[20]; pJob: Code[20]; NoCG: Code[20]; pAmount: Decimal; pTVA: Boolean): Text[250]
    var
        WorkType: Record "Work Type";
        InterfaceSetup: Record "Interface Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        JobJnlTemplate: Record "Job Journal Template";
        JobJnlBatch: Record "Job Journal Batch";
        JobJnlLine: Record "Job Journal Line";
        Job: Record Job;
        Resource: Record Resource;
        Vendor: Record Vendor;
        Employee: Record Employee;
        GLAccount: Record "G/L Account";
        OperativeJob: Record Job;
        RootNameExpenseJournal: Code[8];
        NmbrExpenseJournal: Integer;
        LineNmbr: Integer;
        InterfaceSetup_Err: Label 'Interface Setup missing.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramétrage interface absent" }, { "lang": "FRB", "txt": "Paramétrage interface absent" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GenJnlTemplateSettings_Err: Label 'Invalid Gen. journal template settings', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramétrage du modèle de feuille comptable de frais invalide" }, { "lang": "FRB", "txt": "Paramétrage du modèle de feuille comptable de frais invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        JobJournalTempSettings_Err: Label 'Invalid Job journal template setting', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramétrage du modèle de feuille projet de frais invalide" }, { "lang": "FRB", "txt": "Paramétrage du modèle de feuille projet de frais invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        WorkTypeSetting_Err: Label 'Invalid Work type setting', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramétrage du type de travail invalide" }, { "lang": "FRB", "txt": "Paramétrage du type de travail invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        NameExpenseJournal_Err: Label 'Invalid Expense Journal Name', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom des feuilles de frais invalide" }, { "lang": "FRB", "txt": "Nom des feuilles de frais invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GenJournalBatch_Err: Label 'Non-existent Gen. journal batch', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Feuille comptable inexistante" }, { "lang": "FRB", "txt": "Feuille comptable inexistante" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        JobJournalBatch_Err: Label 'Non-existent Job journal batch', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Feuille projet inexistante" }, { "lang": "FRB", "txt": "Feuille projet inexistante" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Job_Err: Label 'Non-existent Job', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Projet inexistant" }, { "lang": "FRB", "txt": "Projet inexistant" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        JobType_Err: Label 'Invalid Job type', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type du projet invalide (K ou chantier)" }, { "lang": "FRB", "txt": "Type du projet invalide (K ou chantier)" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        InactiveJob_Err: Label 'Inactive Job', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Projet non actif" }, { "lang": "FRB", "txt": "Projet non actif" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Resource_Err: Label 'Non-existent Resource', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Collaborateur inexistant" }, { "lang": "FRB", "txt": "Collaborateur inexistant" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        ResourceBlocked_Err: Label 'Blocked Resource', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Collaborateur bloqué" }, { "lang": "FRB", "txt": "Collaborateur bloqué" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Employee_Err: Label 'Non-existent Employee', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Salarié inexistant" }, { "lang": "FRB", "txt": "Fournisseur salarié inexistant" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        VendorBlocked_Err: Label 'Blocked Vendor', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Fournisseur salarié bloqué" }, { "lang": "FRB", "txt": "Fournisseur salarié bloqué" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GLAccount_Err: Label 'Non-existent G/L Account', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Compte général inexistant" }, { "lang": "FRB", "txt": "Compte général inexistant" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GLAccountType_Err: Label 'Invalid G/L Account account type', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type compte général invalide" }, { "lang": "FRB", "txt": "Type compte général invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GLAccountBlocked_Err: Label '<ToComplete>', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Compte général bloqué" }, { "lang": "FRB", "txt": "Compte général bloqué" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        AmountNull_Err: Label 'Zero amount', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Montant nul" }, { "lang": "FRB", "txt": "Montant nul" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        // Test validité de la feuille de frais par rapport à la date du jour
        // Test cohérence de la racine de la feuille de frais
        RootNameExpenseJournal := 'FR' + FORMAT(TODAY, 0, '<Year,2><Month,2><day,2>');
        IF COPYSTR(pJournalName, 1, STRLEN(RootNameExpenseJournal)) <> RootNameExpenseJournal THEN
            EXIT(NameExpenseJournal_Err);

        // Test validité du n° de la feuille de frais
        IF NOT (EVALUATE(NmbrExpenseJournal, COPYSTR(pJournalName, STRLEN(RootNameExpenseJournal) + 1, 2))) THEN
            EXIT(NameExpenseJournal_Err);

        // Test si le n° est bien compris entre 1 et 99
        IF (NmbrExpenseJournal = 0) THEN
            EXIT(NameExpenseJournal_Err);

        // Lecture des paramètres comptables pour déterminer les modèles des feuilles à alimenter
        IF NOT InterfaceSetup.GET() THEN
            EXIT(InterfaceSetup_Err);

        // Vérification de la cohérence du paramétrage de la feuille comptable de frais
        IF NOT GenJnlTemplate.GET(InterfaceSetup."Expense Journal Template") THEN
            EXIT(GenJnlTemplateSettings_Err);

        // Vérification de la cohérence du paramétrage de la feuille projet de frais
        IF NOT JobJnlTemplate.GET(InterfaceSetup."Expense Job Journal Template") THEN
            EXIT(JobJournalTempSettings_Err);

        // Vérification de la cohérence du paramétrage du type de travail
        IF NOT WorkType.GET(InterfaceSetup."Work Type Expense") THEN
            EXIT(WorkTypeSetting_Err);

        // Test existence de la feuille comptable
        IF NOT GenJnlBatch.GET(GenJnlTemplate.Name, pJournalName) THEN
            EXIT(GenJournalBatch_Err);

        // Test existence de la feuille projet  
        IF NOT JobJnlBatch.GET(JobJnlTemplate.Name, pJournalName) THEN
            EXIT(JobJournalBatch_Err);

        // Test existence de la ressource
        IF NOT Resource.GET(pRegistrationNumber) THEN
            EXIT(Resource_Err);

        // Test statut de blocage de la ressource
        IF Resource.Blocked THEN
            EXIT(ResourceBlocked_Err);

        // Test existence du fournisseur
        IF NOT Employee.GET(pRegistrationNumber) THEN
            EXIT(Employee_Err);

        // Test statut du fournisseur
        IF Vendor.Blocked <> Vendor.Blocked::" " THEN
            EXIT(VendorBlocked_Err);

        // Test existence du projet
        IF NOT Job.GET(pJob) THEN
            EXIT(Job_Err);

        // Test type du projet
        OperativeJob.SETRANGE("No.", pJob);
        OperativeJob.SETRANGE(ARBVRNJobMatrixWork, OperativeJob.ARBVRNJobMatrixWork::"Matrix Job");
        IF OperativeJob.ISEMPTY() THEN
            EXIT(JobType_Err);

        // Test statut du projet
        IF Job.ARBCIRFRJobStatus <> Job."ARBCIRFRJobStatus"::Active THEN
            EXIT(InactiveJob_Err);

        // Test existence du compte comptable
        IF NOT GLAccount.GET(NoCG) THEN EXIT(GLAccount_Err);

        // Test si le compte comptable est du type imputable
        IF GLAccount."Account Type" <> GLAccount."Account Type"::Posting THEN
            EXIT(GLAccountType_Err);

        // Test statut de blocage du compte
        IF GLAccount.Blocked THEN
            EXIT(GLAccountBlocked_Err);

        // Arrondi du montant sur 2 digits
        pAmount := ROUND(pAmount, 0.01);

        // Test d'un montant à zéro
        IF pAmount = 0 THEN
            EXIT(AmountNull_Err);

        // --- Alimentation de la feuille comptable ---
        // Evaluation du n° de la prochaine ligne de la feuille comptable
        LineNmbr := 10000;
        GenJnlLine.RESET();
        GenJnlLine.SETRANGE("Journal Template Name", GenJnlTemplate.Name);
        GenJnlLine.SETRANGE("Journal Batch Name", GenJnlBatch.Name);
        IF GenJnlLine.FINDLAST() THEN
            LineNmbr += GenJnlLine."Line No.";

        // Création de la ligne de commpte général dans la feuille
        GenJnlLine.INIT();
        GenJnlLine.VALIDATE("Journal Template Name", GenJnlTemplate.Name);
        GenJnlLine.VALIDATE("Journal Batch Name", GenJnlBatch.Name);
        GenJnlLine.VALIDATE("Line No.", LineNmbr);
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Posting Date" := TODAY();
        GenJnlLine.VALIDATE("Account No.", NoCG);

        IF (NOT pTVA) THEN BEGIN
            GenJnlLine.VALIDATE("Job No.", pJob);
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
            GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", Job."Global Dimension 2 Code");
        END;

        GenJnlLine."Document No." := GenJnlBatch.Name + '-' + Format(pRegistrationNumber);
        GenJnlLine.VALIDATE(Amount, pAmount);
        GenJnlLine.VALIDATE("Gen. Posting Type", GenJnlLine."Gen. Posting Type"::" ");
        GenJnlLine.VALIDATE("Gen. Bus. Posting Group", '');
        GenJnlLine.VALIDATE("Gen. Prod. Posting Group", '');
        GenJnlLine.VALIDATE("VAT Bus. Posting Group", '');
        GenJnlLine.VALIDATE("VAT Prod. Posting Group", '');
        GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
        GenJnlLine.INSERT(TRUE);

        // Création d'une ligne de contre-partie de type salarié ou modification du montant de la ligne si elle existe déjà.
        // La ligne est créée dans le cas ou il n'existe pas déjà une ligne de type salarié qui porte sur le même salarié et le même projet.
        GenJnlLine.RESET();
        GenJnlLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Account Type", "Account No.", "Job No.");
        GenJnlLine.SETRANGE("Journal Template Name", GenJnlTemplate.Name);
        GenJnlLine.SETRANGE("Journal Batch Name", GenJnlBatch.Name);
        GenJnlLine.SETRANGE("Account Type", GenJnlLine."Account Type"::Employee);
        GenJnlLine.SETRANGE("Account No.", pRegistrationNumber);
        IF GenJnlLine.FINDFIRST() THEN BEGIN
            // Mise à jour du montant de la ligne de contre-partie existante
            GenJnlLine.VALIDATE(Amount, (GenJnlLine.Amount) - pAmount);
            GenJnlLine.MODIFY(TRUE);
        END ELSE BEGIN
            //  Création de la ligne de contre-partie
            LineNmbr += 10000;
            GenJnlLine.INIT();
            GenJnlLine.VALIDATE("Journal Template Name", GenJnlTemplate.Name);
            GenJnlLine.VALIDATE("Journal Batch Name", GenJnlBatch.Name);
            GenJnlLine.VALIDATE("Line No.", LineNmbr);
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Employee;
            GenJnlLine.VALIDATE("Account No.", pRegistrationNumber);
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", '');
            GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", '');
            GenJnlLine."Posting Date" := TODAY();
            GenJnlLine."Document No." := GenJnlBatch.Name + '-' + Format(pRegistrationNumber);
            GenJnlLine.VALIDATE(Amount, -pAmount);
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            GenJnlLine.INSERT(TRUE);
        END;

        // --- Alimentation de la feuille projet ---
        // L'alimentation est effectuée unqiuement si la ligne ne concerne pas un compte de TVA
        IF NOT pTVA THEN BEGIN
            // Création d'une ligne ou modification du montant de la ligne si elle existe déjà.
            // La ligne est créée dans le cas ou il n'existe pas déjà une ligne de type ressource qui porte sur le même collaborateur et le même projet.
            JobJnlLine.RESET();
            JobJnlLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", Type, "No.", "Entry Type", "Job No.");
            JobJnlLine.SETRANGE("Journal Template Name", JobJnlTemplate.Name);
            JobJnlLine.SETRANGE("Journal Batch Name", JobJnlBatch.Name);
            JobJnlLine.SETRANGE(Type, JobJnlLine.Type::Resource);
            JobJnlLine.SETRANGE("No.", pRegistrationNumber);
            JobJnlLine.SETRANGE("Entry Type", JobJnlLine."Entry Type"::Usage);
            JobJnlLine.SETRANGE("Job No.", pJob);
            IF JobJnlLine.FINDFIRST() THEN BEGIN
                // Mise à jour du montant de la ligne d'activité existante
                JobJnlLine.VALIDATE("Unit Cost", JobJnlLine."Unit Cost" + pAmount);
                JobJnlLine.MODIFY(TRUE);
            END ELSE BEGIN
                // Recherche du N° de la dernière ligne de la feuille projet
                LineNmbr := 10000;
                JobJnlLine.RESET();
                JobJnlLine.SETRANGE("Journal Template Name", JobJnlTemplate.Name);
                JobJnlLine.SETRANGE("Journal Batch Name", JobJnlBatch.Name);
                IF JobJnlLine.FINDLAST() THEN
                    LineNmbr += JobJnlLine."Line No.";

                // Création d'une nouvelle ligne d'activité
                JobJnlLine.INIT();
                JobJnlLine."Journal Template Name" := JobJnlTemplate.Name;
                JobJnlLine."Journal Batch Name" := JobJnlBatch.Name;
                JobJnlLine."Line No." := LineNmbr;
                JobJnlLine."Document No." := GenJnlBatch.Name + '-' + Format(pRegistrationNumber);
                JobJnlLine."Source Code" := JobJnlTemplate."Source Code";
                JobJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                JobJnlLine."Posting No. Series" := JobJnlBatch."Posting No. Series";
                JobJnlLine.VALIDATE("Entry Type", JobJnlLine."Entry Type"::Usage);
                JobJnlLine.VALIDATE(Type, JobJnlLine.Type::Resource);
                JobJnlLine.VALIDATE("Start Date", TODAY());
                JobJnlLine.VALIDATE("Job No.", pJob);
                JobJnlLine.VALIDATE("No.", pRegistrationNumber);
                JobJnlLine.VALIDATE("Work Type Code", WorkType.Code);
                JobJnlLine.VALIDATE(Quantity, 1);
                JobJnlLine.VALIDATE("Unit Cost", pAmount);
                JobJnlLine.VALIDATE("Posting Date", TODAY());
                JobJnlLine.INSERT(TRUE);
            END;
        END;
        EXIT('');
    end;

    /// <summary>
    /// Concur_GeneralBatch.
    /// Traitement de la validation d'une feuille de comptabilité de frais réels de manière à intégrer les frais en comptabilité.
    /// La validation est opérée uniquement si le montant et le nombre de lignes indiqués en paramètre sont cohérents par rapport au contenu actuel de la feuille à valider.  
    /// </summary>
    /// <param name="pJournalName">Code[10]: nom de la feuille à valider</param>
    /// <param name="pAmount">Decimal: montant total des frais attendus dans la feuille de frais (lignes de type compte général uniquement)</param>
    /// <param name="pLineNmbr">Integer: nombre de lignes attendues dans la feuille de frais (lignes de type compte général uniquement)</param>
    /// <returns>Return value of type Text[250].
    /// Vide : la validation de la feuille comptable a été traitée avec succès,
    /// Erreur : la validation de la feuille comptable a échoué pour la raison indiquée explicitement dans le compte rendu de traitement.
    ///</returns>
    procedure Concur_GeneralBatch(pJournalName: Code[10]; pAmount: Decimal; pLineNmbr: Integer): Text[250]
    var
        InterfaceSetup: Record "Interface Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        RootNameExpenseJournal: Code[8];
        NmbrExpenseJournal: Integer;
        GenJnlLineNmbr: Integer;
        NameExpenseJournal_Err: Label 'Invalid expense gen. journal name', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom de la feuille de frais comptable invalide" }, { "lang": "FRB", "txt": "Nom de la feuille de frais comptable invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        InterfaceSetup_Err: Label 'Interface Setup missing', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramétrage interface absent" }, { "lang": "FRB", "txt": "Paramétrage interface absent" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GenJnlTemplate_Err: Label 'Invalid Gen. journal template', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramétrage du modèle de feuille comptable de frais invalide" }, { "lang": "FRB", "txt": "Paramétrage du modèle de feuille comptable de frais invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GenJournalBatch_Err: Label 'Non-existent Gen. journal batch', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Feuille comptable inexistante" }, { "lang": "FRB", "txt": "Feuille comptable inexistante" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        LineValidate_Err: Label 'No lines to validate', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Absence de lignes à valider" }, { "lang": "FRB", "txt": "Absence de lignes à valider" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        NmbrLinesInvalid_Err: Label 'Number of lines to validate invalid', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nombre de lignes à valider invalide" }, { "lang": "FRB", "txt": "Nombre de lignes à valider invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        AmountValidate_Err: Label 'Amount to be validate invalide', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Montant à valider invalide" }, { "lang": "FRB", "txt": "Montant à valider invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GenJournalLineBalance_Err: Label 'Gen. journal line not balanced', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Feuille comptable déséquilibrée" }, { "lang": "FRB", "txt": "Feuille comptable déséquilibrée" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        // Test validité de la feuille de frais comptable par rapport à la date du jour
        // Test cohérence de la racine de la feuille de frais
        RootNameExpenseJournal := 'FR' + FORMAT(TODAY, 0, '<Year,2><Month,2><day,2>');
        IF COPYSTR(pJournalName, 1, STRLEN(RootNameExpenseJournal)) <> RootNameExpenseJournal THEN
            EXIT(NameExpenseJournal_Err);

        // Test validité du n° de la feuille de frais
        IF NOT (EVALUATE(NmbrExpenseJournal, COPYSTR(pJournalName, STRLEN(RootNameExpenseJournal) + 1, 2))) THEN
            EXIT(NameExpenseJournal_Err);

        // Test si le n° est bien compris entre 1 et 99
        IF (NmbrExpenseJournal = 0) THEN
            EXIT(NameExpenseJournal_Err);

        // Lecture des paramètres comptables pour déterminer le modèle de la feuille comptable à valider
        IF NOT InterfaceSetup.GET() THEN
            EXIT(InterfaceSetup_Err);

        // Vérification de la cohérence du paramétrage de la feuille comptable de frais
        IF NOT GenJnlTemplate.GET(InterfaceSetup."Expense Journal Template") THEN
            EXIT(GenJnlTemplate_Err);

        // Test existence de la feuille comptable
        IF NOT GenJnlBatch.GET(GenJnlTemplate.Name, pJournalName) THEN
            EXIT(GenJournalBatch_Err);

        // Evaluation du nombre et du montant total des lignes comptables de la feuille
        GenJnlLine.RESET();
        GenJnlLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Account Type", "Account No.", "Job No.");
        GenJnlLine.SETRANGE("Journal Template Name", GenJnlTemplate.Name);
        GenJnlLine.SETRANGE("Journal Batch Name", GenJnlBatch.Name);
        GenJnlLine.SETRANGE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLineNmbr := GenJnlLine.COUNT;

        // Test présence de lignes à valider
        IF GenJnlLineNmbr = 0 THEN BEGIN
            // Suppression de la feille comptable
            GenJnlBatch.DELETE(TRUE);
            EXIT(LineValidate_Err);
        END;

        // Test cohérence du nombre de lignes à valider
        IF GenJnlLineNmbr <> pLineNmbr THEN
            EXIT(NmbrLinesInvalid_Err);

        // Test cohérence du montant à valider
        GenJnlLine.CALCSUMS(Amount);
        IF GenJnlLine.Amount <> ROUND(pAmount, 0.01) THEN
            EXIT(AmountValidate_Err);

        // Test équilibre de la feuille comptable à valider
        GenJnlLine.SETRANGE("Account Type");
        GenJnlLine.CALCSUMS(Amount);
        IF GenJnlLine.Amount <> 0 THEN
            EXIT(GenJournalLineBalance_Err);

        // Traitement de la validation de la feuille
        GenJnlLine.FINDFIRST();
        CLEARLASTERROR();

        IF NOT CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine) THEN
            EXIT(COPYSTR(GETLASTERRORTEXT(), 1, 250));

        // Suppression de la feuille comptable créée automatiquemennt au terme de la validation
        //            Nom de la feuille créée = nom de la feuille validée + 1
        IF GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") THEN
            GenJnlBatch.DELETE(TRUE);
        EXIT('');
    end;

    /// <summary>
    /// Concur_JobBatch.
    /// Traitement de la validation d'une feuille projet de frais réels de manière à générer des charges projets sous la forme d'écritures projets.
    /// La validation est opérée uniquement si le montant et le nombre de lignes indiqués en paramètre sont cohérents par rapport au contenu  actuel de la feuille à valider. 
    /// </summary>
    /// <param name="pJournalName">Code[10]: nom de la feuille à valider</param>
    /// <param name="pAmount">Decimal: montant total des frais attendus dans la feuille de frais (part HT uniquement des frais intégrés dans les feuilles de frais)</param>
    /// <param name="pLineNmbr">Integer: nombre de lignes attendues dans la feuille de frais (nombre de lignes de frais qui concernent uniquement le HT parmi les  lignes intégrés dans les feuilles de frais)</param>
    /// <returns>Return value of type Text[250]. 
    /// Vide : la validation de la feuille projet a été traitée avec succès,
    /// Erreur : la validation de la feuille projet a échoué pour la raison indiquée explicitement dans le compte rendu de traitement.
    /// </returns>
    procedure Concur_JobBatch(pJournalName: Code[10]; pAmount: Decimal; pLineNmbr: Integer): Text[250]
    var
        InterfaceSetup: Record "Interface Setup";
        JobJnlTemplate: Record "Job Journal Template";
        JobJnlBatch: Record "Job Journal Batch";
        recJobJnlLine: Record "Job Journal Line";
        NmbrJobLine: Integer;
        RootNameExpenseJournal: Code[8];
        NmbrExpenseJournal: Integer;
        JobBatchName_Err: Label 'Invalid Job batch name', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom de la feuille de frais projet invalide" }, { "lang": "FRB", "txt": "Nom de la feuille de frais projet invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        InterfaceSetup_Err: Label 'Interface Setup missing', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramétrage interface absent" }, { "lang": "FRB", "txt": "Paramétrage interface absent" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        JobJournalBatch_Err: Label 'Invalid Job journal batch', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramétrage du modèle de feuille projet de frais invalide" }, { "lang": "FRB", "txt": "Paramétrage du modèle de feuille projet de frais invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        JobJournalBatchAbs_Err: Label 'Non-existent Job journal batch', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Feuille projet inexistante" }, { "lang": "FRB", "txt": "Feuille projet inexistante" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        LineValidate_Err: Label 'No lines to validate', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Absence de lignes à valider" }, { "lang": "FRB", "txt": "Absence de lignes à valider" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        NmbrLinesInvalid_Err: Label 'Number of lines to validate invalid', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nombre de lignes à valider invalide" }, { "lang": "FRB", "txt": "Nombre de lignes à valider invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        AmountValidate_Err: Label 'Amount to be validate invalide', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Montant à valider invalide" }, { "lang": "FRB", "txt": "Montant à valider invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        // Test validité de la feuille de frais projet par rapport à la date du jour
        // Test cohérence de la racine de la feuille de frais
        RootNameExpenseJournal := 'FR' + FORMAT(TODAY, 0, '<Year,2><Month,2><day,2>');
        IF COPYSTR(pJournalName, 1, STRLEN(RootNameExpenseJournal)) <> RootNameExpenseJournal THEN
            EXIT(JobBatchName_Err);

        // Test validité du n° de la feuille de frais
        IF NOT (EVALUATE(NmbrExpenseJournal, COPYSTR(pJournalName, STRLEN(RootNameExpenseJournal) + 1, 2))) THEN
            EXIT(JobBatchName_Err);

        // Test si le n° est bien compris entre 1 et 99
        IF (NmbrExpenseJournal = 0) THEN
            EXIT(JobBatchName_Err);

        // Lecture des paramètres comptables pour déterminer le modèle de la feuille projet à valider
        IF NOT InterfaceSetup.GET() THEN
            EXIT(InterfaceSetup_Err);

        // Vérification de la cohérence du paramétrage de la feuille projet de frais
        IF NOT JobJnlTemplate.GET(InterfaceSetup."Expense Job Journal Template") THEN
            EXIT(JobJournalBatch_Err);

        // Test existence de la feuille projet
        IF NOT JobJnlBatch.GET(JobJnlTemplate.Name, pJournalName) THEN
            EXIT(JobJournalBatchAbs_Err);

        // Evaluation du nombre et du montant total des lignes de la feuille
        recJobJnlLine.RESET();
        recJobJnlLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", Type, "No.", "Entry Type", "Job No.");
        recJobJnlLine.SETRANGE("Journal Template Name", JobJnlTemplate.Name);
        recJobJnlLine.SETRANGE("Journal Batch Name", JobJnlBatch.Name);
        NmbrJobLine := recJobJnlLine.COUNT;

        // Test présence de lignes à valider
        IF NmbrJobLine = 0 THEN BEGIN
            // Suppression de la feuille projet
            JobJnlBatch.DELETE(TRUE);
            EXIT(LineValidate_Err);
        END;

        // Test cohérence du nombre de lignes à valider
        IF NmbrJobLine <> pLineNmbr THEN
            EXIT(NmbrLinesInvalid_Err);

        // Test cohérence du montant à valider
        recJobJnlLine.CALCSUMS("Total Cost");
        IF recJobJnlLine."Total Cost" <> ROUND(pAmount, 0.01) THEN
            EXIT(AmountValidate_Err);

        // Traitement de la validation de la feuille
        recJobJnlLine.FINDFIRST();
        CLEARLASTERROR();

        IF NOT CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post Batch", recJobJnlLine) THEN
            EXIT(COPYSTR(GETLASTERRORTEXT(), 1, 250));
        // Suppression de la feuille projet
        JobJnlBatch.DELETE(TRUE);

        EXIT('');
    end;
}