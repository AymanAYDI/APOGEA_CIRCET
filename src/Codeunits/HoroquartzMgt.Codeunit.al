codeunit 50017 "Horoquartz Mgt."
{

    var
        InterfaceSetup: Record "Interface Setup";
    /// <summary>
    /// CreateBatch : Création de la feuille projet
    /// </summary>
    /// <returns>Return value of type Text[250] : message d'erreur</returns>
    procedure CreateBatch(): Text[250]
    var
        JobJournalBatch: Record "Job Journal Batch";
        JobJournalTemplate: Record "Job Journal Template";
        JobLedgerEntry: Record "Job Ledger Entry";
        maxJournalBatchName: Code[10];
        RootJournalBatch: Code[10];
        lastNum: Integer;
        BATCH_NAME_Lbl: Label 'Batch import Horoquartz of %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Feuille import Horoquartz du %1"}]}';
        ERR_MAX_NUM_BATCH_Err: Label 'Err: Maximum number of Horoquartz batch of the day reached', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Nombre maximal de feuilles projet Horoquartz du jour atteint"}]}';
        ERR_NUM_LAST_BATCH_Err: Label 'Err : Numbering of the last batch Horoquartz of the day invalid', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Numérotation de la dernière feuille projet Horoquartz du jour invalide"}]}';
        ERR_PARAM_BATCH_Err: Label 'Err: Invalid setting of the Horoquartz template', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Paramétrage du modèle de feuille projet Horoquartz invalide"}]}';
        ERR_PARAM_INTERFACE_Err: Label 'Err : Interface setup missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Paramétrage interface absent"}]}';
        ERR_ROOT_MISSING_Err: label 'Err : Invalid setting of the Root Name Journal Batch', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Paramétrage Racine du nom feuille Horoquartz invalide"}]}';
    begin
        // Lecture des paramètres projets pour déterminer le modèle et la racine du nom de la feuille à créer
        IF NOT InterfaceSetup.GET() THEN EXIT(ERR_PARAM_INTERFACE_Err);

        // Vérification de la cohérence du paramétrage de la feuille
        IF NOT JobJournalTemplate.GET(InterfaceSetup."HQ Job Journal Template") THEN EXIT(ERR_PARAM_BATCH_Err);

        IF InterfaceSetup."HQ Root Name Journal Batch" = '' then exit(ERR_ROOT_MISSING_Err);

        // Evaluation de la racine du nom de la feuille
        RootJournalBatch := InterfaceSetup."HQ Root Name Journal Batch" + FORMAT(TODAY, 0, '<Year,2><Month,2><day,2>');

        // Recherche de la dernière feuille Horoquartz du jour non validée
        maxJournalBatchName := '';
        JobJournalBatch.RESET();
        JobJournalBatch.SETRANGE("Journal Template Name", InterfaceSetup."HQ Job Journal Template");
        JobJournalBatch.SETFILTER(Name, RootJournalBatch + '??');
        IF JobJournalBatch.FINDLAST() THEN
            maxJournalBatchName := JobJournalBatch.Name;

        // Recherche de la dernière écriture projet validée sur une feuille du jour
        JobLedgerEntry.RESET();
        JobLedgerEntry.SETCURRENTKEY("Document No.", "Posting Date", "Entry Type");
        JobLedgerEntry.SETFILTER("Document No.", RootJournalBatch + '??');
        JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Usage);
        IF JobLedgerEntry.FINDLAST() THEN
            IF JobLedgerEntry."Document No." > maxJournalBatchName THEN
                maxJournalBatchName := COPYSTR(JobLedgerEntry."Document No.", 1, 10);

        // Evaluation du nom de la feuille à créer
        IF maxJournalBatchName = '' THEN
            // Création du nom de la première feuille de la journée
            maxJournalBatchName := FORMAT(RootJournalBatch) + '01'
        ELSE BEGIN
            // Test numérotation valide de la dernière feuille du jour
            IF NOT (EVALUATE(lastNum, COPYSTR(maxJournalBatchName, STRLEN(RootJournalBatch) + 1, 2))) THEN
                EXIT(ERR_NUM_LAST_BATCH_Err);

            // Test si la création d'une nouvelle feuille de frais du jour est possible
            IF (lastNum = 99) THEN
                EXIT(ERR_MAX_NUM_BATCH_Err);

            // Création du nom de la prochaine feuille du jour
            maxJournalBatchName := INCSTR(maxJournalBatchName);
        END;

        // Création de la feuille
        JobJournalBatch.INIT();
        JobJournalBatch."Journal Template Name" := InterfaceSetup."HQ Job Journal Template";
        JobJournalBatch.Name := maxJournalBatchName;
        JobJournalBatch.Description := STRSUBSTNO(BATCH_NAME_Lbl, FORMAT(TODAY, 0, '<day,2>/<Month,2>/<Year,2>'));
        JobJournalBatch.INSERT(TRUE);

        EXIT(maxJournalBatchName);
    end;

    /// <summary>
    /// InsertDataBatch : Ajout d'une ligne d'activité dans une feuille projet
    /// </summary>
    /// <param name="pBatchName">Code[10] : nom de la feuille projet dans laquelle la ligne d'activité doit être ajoutée</param>
    /// <param name="pRegistrationNumber">Code[20] : matricule de la ressource concernée par l'activité</param>
    /// <param name="pActivityDate">Date : date à laquelle l'activité de la ressource a été effectuée</param>
    /// <param name="pPostingDate">Date : date à laquelle l'activité de la ressource doit être comptabilisée</param>
    /// <param name="pQuantity">Decimal : nombre de type de travail à déclarer</param>
    /// <param name="pWorkType">Code[10] : type de travail à déclarer</param>
    /// <param name="pJobNo">Code[20] : projet d'imputation de l'activité</param>
    /// <returns>Return value of type Text[250] : compte rendu du traitement </returns>
    procedure InsertDataBatch(pBatchName: Code[10]; pRegistrationNumber: Code[20]; pActivityDate: Date; pQuantity: Decimal; pWorkType: Code[10]; pJobNo: Code[20]): Text[250]
    var
        ARBCIRFRCommercialJob: Record ARBCIRFRCommercialJob;
        Job: Record "Job";
        OperativeJob: Record Job;
        JobJournalBatch: Record "Job Journal Batch";
        JobJournalLine: Record "Job Journal Line";
        JobJournalTemplate: Record "Job Journal Template";
        Resource: Record "Resource";
        WorkType: Record "Work Type";
        PostingDate: Date;
        numLigne: Integer;
        ERR_BATCH_MISSING_Err: Label 'Err : Batch template missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Feuille projet inexistante"}]}';
        ERR_JOB_MISSING_Err: Label 'Err : Job does not exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Projet inexistant"}]}';
        ERR_JOB_STATUS_Err: Label 'Err: Project not active', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Projet non actif"}]}';
        ERR_JOB_TYPE_Err: Label 'Err : Invalid project type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Type du projet invalide (K ou chantier)"}]}';
        ERR_PARAM_INTERFACE_Err: Label 'Err : Interface setup missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Paramétrage interface absent"}]}';
        ERR_PARAM_JOURNAL_TEMPLATE_Err: Label 'Invalid Journal Template setup', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Paramétrage du modèle de feuille projet invalide"}]}';
        ERR_RESOURCE_BLOCKED_Err: Label 'Err : Resource blocked', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Collaborateur bloqué"}]}';
        ERR_RESOURCE_MISSING_Err: Label 'Err : Resource does not exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Collaborateur inexistant"}]}';
        ERR_WORK_TYPE_MISSING_Err: Label 'Err: Work type does not exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Type de travail inexistant"}]}';
        PostingDate_Err: Text[250];
    begin
        // Lecture des paramètres projets pour vérifier le modèle de la feuille à alimenter
        IF NOT InterfaceSetup.GET() THEN EXIT(ERR_PARAM_INTERFACE_Err);

        // Vérification de la cohérence du paramétrage de la feuille
        IF NOT JobJournalTemplate.GET(InterfaceSetup."HQ Job Journal Template") THEN EXIT(ERR_PARAM_JOURNAL_TEMPLATE_Err);

        // Test existence de la feuille
        IF NOT JobJournalBatch.GET(JobJournalTemplate.Name, pBatchName) THEN EXIT(ERR_BATCH_MISSING_Err);

        // Test existence de la ressource
        IF NOT Resource.GET(pRegistrationNumber) THEN EXIT(ERR_RESOURCE_MISSING_Err);

        // Test statut de blocage de la ressource
        IF Resource.Blocked THEN EXIT(ERR_RESOURCE_BLOCKED_Err);

        // Test existence du projet et/ou du projet commercial
        IF (NOT Job.GET(pJobNo)) and (ARBCIRFRCommercialJob.Get(pJobNo))
        THEN
            EXIT(ERR_JOB_TYPE_Err)
        else
            If NOT Job.GET(pJobNo) then
                exit(ERR_JOB_MISSING_Err);

        // Test type du projet
        OperativeJob.SETRANGE("No.", pJobNo);
        OperativeJob.SETRANGE(ARBVRNJobMatrixWork, OperativeJob.ARBVRNJobMatrixWork::"Matrix Job");
        IF OperativeJob.ISEMPTY() THEN
            EXIT(ERR_JOB_TYPE_Err);

        // Test statut du projet
        IF Job.ARBCIRFRJobStatus <> Job.ARBCIRFRJobStatus::Active THEN EXIT(ERR_JOB_STATUS_Err);

        // Test existence du type de travail
        IF NOT WorkType.GET(pWorkType) THEN EXIT(ERR_WORK_TYPE_MISSING_Err);

        // Test validité de la date de comptabilisation par rapport à la date limite en dessous de laquelle
        PostingDate_Err := GetPostingDate(pActivityDate, PostingDate);
        if PostingDate_Err <> '' then
            exit(CopyStr(PostingDate_Err, 1, 250));

        // Recherche du N° de la dernière ligne de la feuille projet
        JobJournalLine.RESET();
        JobJournalLine.SETRANGE("Journal Template Name", JobJournalTemplate.Name);
        JobJournalLine.SETRANGE("Journal Batch Name", JobJournalBatch.Name);
        IF JobJournalLine.FINDLAST() THEN
            numLigne += JobJournalLine."Line No.";

        // Création de la ligne d'activité dans la feuille projet
        JobJournalLine.INIT();
        JobJournalLine."Journal Template Name" := JobJournalTemplate.Name;
        JobJournalLine."Journal Batch Name" := JobJournalBatch.Name;
        JobJournalLine."Line No." := numLigne + 10000;
        JobJournalLine."Document No." := JobJournalBatch.Name;
        JobJournalLine."Source Code" := JobJournalTemplate."Source Code";
        JobJournalLine."Reason Code" := JobJournalBatch."Reason Code";
        JobJournalLine."Posting No. Series" := JobJournalBatch."Posting No. Series";
        JobJournalLine.VALIDATE("Entry Type", JobJournalLine."Entry Type"::Usage);
        JobJournalLine.VALIDATE(Type, JobJournalLine.Type::Resource);
        JobJournalLine.VALIDATE("Job No.", pJobNo);
        JobJournalLine.VALIDATE("No.", pRegistrationNumber);
        JobJournalLine.VALIDATE("Start Date", pActivityDate);
        JobJournalLine.VALIDATE("Work Type Code", pWorkType);
        JobJournalLine.VALIDATE(Quantity, pQuantity);
        JobJournalLine.VALIDATE("Posting Date", PostingDate);
        JobJournalLine.INSERT(TRUE);

        EXIT('');
    end;

    /// <summary>
    /// ValidateBatch : Validation d’une feuille projet
    /// </summary>
    /// <param name="pBatchName">Code[10] : nom de la feuille projet à valider</param>
    /// <param name="pQuantity">Decimal : somme des quantités des lignes constituant la feuille à valider</param>
    /// <param name="pNbLines">Integer : nombre de lignes constituant la feuille à valider</param>
    /// <returns>Return value of type Text[250].</returns>
    procedure ValidateBatch(pBatchName: Code[10]; pQuantity: Decimal; pNbLines: Integer): Text[250]
    var
        JobJournalBatch: Record "Job Journal Batch";
        JobJournalLine: Record "Job Journal Line";
        JobJournalTemplate: Record "Job Journal Template";
        DateBatch: Date;
        Quantity: Decimal;
        noBatch: Integer;
        ERR_BATCH_MISSING_Err: Label 'Err : Batch template missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Feuille absente"}]}';
        ERR_BATCH_NAME_Err: Label 'Batch name no valid', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Nom de feuille invalide"}]}';
        ERR_NB_LINES_Err: Label 'Err : Invalid number of lines to validate', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Nombre de lignes à valider invalide"}]}';
        ERR_PARAM_JOB_Err: Label 'Inserface Setup Missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Paramétrage interface absent"}]}';
        ERR_PARAM_JOURNAL_TEMPLATE_Err: Label 'Invalid Journal Template setup', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Paramétrage du modèle de feuille projet invalide"}]}';
        ERR_QUANTITE_Err: Label 'Err : Invalid quantity to validate', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : Quantité à valider invalide"}]}';
    begin
        // Lecture des paramètres projets pour identifier le modèle de la feuille à alimenter
        IF NOT InterfaceSetup.GET() THEN EXIT(ERR_PARAM_JOB_Err);

        // Test cohérence de la racine de la feuille de frais
        IF COPYSTR(pBatchName, 1, STRLEN(InterfaceSetup."HQ Root Name Journal Batch")) <> InterfaceSetup."HQ Root Name Journal Batch" THEN
            EXIT(ERR_BATCH_NAME_Err);

        //Test cohérence de la date contenue dans le nom de la feuille
        IF NOT EVALUATE(DateBatch, COPYSTR(pBatchName, STRLEN(InterfaceSetup."HQ Root Name Journal Batch") + 5, 2) +
                                    COPYSTR(pBatchName, STRLEN(InterfaceSetup."HQ Root Name Journal Batch") + 3, 2) +
                                    COPYSTR(pBatchName, STRLEN(InterfaceSetup."HQ Root Name Journal Batch") + 1, 2)) THEN
            EXIT(ERR_BATCH_NAME_Err);

        // Test cohérence du n° de feuille
        IF NOT EVALUATE(noBatch, COPYSTR(pBatchName, STRLEN(InterfaceSetup."HQ Root Name Journal Batch") + 7, 2)) THEN
            EXIT(ERR_BATCH_NAME_Err);

        // Vérification de la cohérence du paramétrage de la feuille
        IF NOT JobJournalTemplate.GET(InterfaceSetup."HQ Job Journal Template") THEN EXIT(ERR_PARAM_JOURNAL_TEMPLATE_Err);

        // Test existence de la feuille
        IF NOT JobJournalBatch.GET(JobJournalTemplate.Name, pBatchName) THEN EXIT(ERR_BATCH_MISSING_Err);

        // Evaluation du nombre de lignes de la feuille et de la somme des quantités
        JobJournalLine.RESET();
        JobJournalLine.SETRANGE("Journal Template Name", InterfaceSetup."HQ Job Journal Template");
        JobJournalLine.SETRANGE("Journal Batch Name", pBatchName);
        IF JobJournalLine.COUNT() <> pNbLines THEN EXIT(ERR_NB_LINES_Err);
        Quantity := 0;
        IF NOT JobJournalLine.ISEMPTY() THEN BEGIN
            JobJournalLine.FINDSET();
            REPEAT
                Quantity += JobJournalLine.Quantity;
            UNTIL JobJournalLine.NEXT() = 0;
        END;
        IF pQuantity <> Quantity THEN EXIT(ERR_QUANTITE_Err);

        // Traitement de la validation de la feuille
        CLEARLASTERROR();
        IF NOT CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post Batch", JobJournalLine) THEN
            EXIT(COPYSTR(GETLASTERRORTEXT(), 1, 250));

        // Suppression de la feuille d'activité créée automatiquement au terme de la validation
        // Nom de la feuille créée = nom de la feuille validée + 1
        IF JobJournalBatch.GET(JobJournalLine."Journal Template Name", JobJournalLine."Journal Batch Name") THEN
            JobJournalBatch.DELETE(TRUE);

        EXIT('');
    end;

    local procedure GetPostingDate(pActivityDate: Date; var pPostingDate: Date): Text[250]
    var
        AccountingPeriod: Record "Accounting Period";
        lActivityClosingDate: Date;
        ACCOUNTING_PERIOD_MISSING_Err: Label 'Accounting Period is missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Période comptable manquante"}]}';
        ACTIVITY_CLOSING_DATE_MISSING_Err: Label 'Activity closing date is missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de clôture d''activité manquante"}]}';
    begin
        // Récupération de la période courante, Ex: Début de période entre le 01/06 et le 30/06
        AccountingPeriod.RESET();
        AccountingPeriod.SETFILTER(AccountingPeriod."Starting Date", '%1..%2', CALCDATE('<-CM-1M>', WORKDATE()), CALCDATE('<-CM-1D>', WORKDATE()));
        IF NOT AccountingPeriod.FINDFIRST() THEN
            EXIT(ACCOUNTING_PERIOD_MISSING_Err);

        IF (AccountingPeriod."Activity Closing Date" = 0D) THEN
            EXIT(ACTIVITY_CLOSING_DATE_MISSING_Err);

        lActivityClosingDate := AccountingPeriod."Activity Closing Date";

        //Si la date de l’activité concerne le mois en cours ou si la date de l’activité est postérieure à la date en cours : date compta=date activité
        if (pActivityDate in [CALCDATE('<-CM>', WorkDate()) .. CALCDATE('<CM>', WorkDate())]) OR (pActivityDate > WorkDate()) then
            pPostingDate := pActivityDate
        else
            //Sinon (date de l’activité antérieure au mois en cours) :
            if (pActivityDate < CALCDATE('<-CM>', WorkDate())) then
                //Si date courante inférieure ou égale à la  date de clôture
                if (WorkDate() <= lActivityClosingDate) then begin
                    //Si date activité concerne le mois précédent : date compta=date activité
                    if (pActivityDate in [CALCDATE('<-CM-1M>', WorkDate()) .. CALCDATE('<-CM-1D>', WorkDate())]) then
                        pPostingDate := pActivityDate
                    else
                        //Sinon (la date d’activité concerne un mois antérieur au mois précédent) : date compta= 1er jour du mois précédent
                        if (pActivityDate < CALCDATE('<-CM-1M>', WorkDate())) then
                            pPostingDate := CALCDATE('<-CM-1M>', WorkDate());
                end else
                    //Sinon (date courante > date de clôture) : date compta=1er jour du mois courant
                    if (WorkDate() > lActivityClosingDate) then
                        pPostingDate := CALCDATE('<-CM>', WorkDate());
        exit('');
    end;
}