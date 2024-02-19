xmlport 50002 "Import Sage Paie"
{
    Caption = 'Import payroll SAGE', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import SAGE PAIE"}]}';
    Direction = Import;
    Format = FixedText;
    FormatEvaluate = Legacy;
    TextEncoding = MSDOS;

    schema
    {
        textelement(root)
        {
            tableelement(GenJournalLine; "Gen. Journal Line")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'GenJournalLine';
                SourceTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.")
                               ORDER(Ascending);
                textelement(inCodeJournal)
                {
                    MinOccurs = Zero;
                    Width = 3;
                }
                textelement(inPostingDate)
                {
                    MinOccurs = Zero;
                    Width = 6;
                }
                textelement(inTextOD)
                {
                    MinOccurs = Zero;
                    Width = 2;
                }
                textelement(inGLAccount)
                {
                    MinOccurs = Zero;
                    Width = 6;
                }
                textelement(TxtVide)
                {
                    MinOccurs = Zero;
                    Width = 7;
                }
                textelement(inCodeTypeSection)
                {
                    MinOccurs = Zero;
                    Width = 2;
                }
                textelement(inCodeSection)
                {
                    MinOccurs = Zero;
                    Width = 7;
                }
                textelement(TxtVide1)
                {
                    MinOccurs = Zero;
                    Width = 5;
                }
                textelement(inDescription)
                {
                    MinOccurs = Zero;
                    Width = 30;
                }
                textelement(TxtVide2)
                {
                    MinOccurs = Zero;
                    Width = 15;
                }
                textelement(inDebitCredit)
                {
                    MinOccurs = Zero;
                    Width = 1;
                }
                textelement(TxtVide3)
                {
                    MinOccurs = Zero;
                    Width = 6;
                }
                textelement(inAmount)
                {
                    MinOccurs = Zero;
                    Width = 14;
                }
                textelement(TxtVide4)
                {
                    MinOccurs = Zero;
                    Width = 34;
                }
                textelement(inCurrency)
                {
                    MinOccurs = Zero;
                    Width = 3;
                }

                trigger OnAfterInitRecord()
                begin
                    // Reset des variables d'import
                    inCodeJournal := '';
                    inPostingDate := '';
                    inTextOD := '';
                    inGLAccount := '';
                    inCodeTypeSection := '';
                    inCodeSection := '';
                    inDescription := '';
                    inDebitCredit := '';
                    inAmount := '';
                    inCurrency := '';
                end;

                trigger OnBeforeInsertRecord()
                var
                    GLAccount: Record "G/L Account";
                    DimensionValue: Record "Dimension Value";
                    Employee: Record Employee;
                    Currency: Record Currency;
                    EmployeeNo: Code[20];
                    AmountVal: Decimal;
                    PostingDateErr: Label 'The posting date (%1) of line %2 is not valid.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La date de comptabilisation (%1) de la ligne %2 n''est pas valide."}]}';
                    GLAccountErr: Label 'The G/L account (%1) of line %2 does not exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le compte comptable (%1) de la ligne %2 n''existe pas."}]}';
                    PayrollJobAttritutionErr: Label 'The payroll job attribution is not specified for the department code %1 of line %2.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le projet d''imputation de la paie n''est pas spécifié pour le code département %1 de la ligne %2."}]}';
                    DepartmentCodeErr: Label 'The department code (%1) for line %2 is not valid.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le code département (%1) de la ligne %2 n''est pas valide."}]}';
                    EmployeeErr: Label 'The employee (%1) of line %2 does not exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le salarié %1 de la ligne %2 n''existe pas."}]}';
                    DebitCreditErr: Label 'The line %1 corresponds neither to a debit nor to a credit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La ligne %1 correspond ni à un débit ni à un crédit."}]}';
                    AmountTypeErr: Label 'Line %2 debit or credit amount (%1) is not a numeric.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le montant (%1) du débit ou du crédit de la ligne %2 n''est pas un numérique."}]}';
                    CurrencyErr: Label 'The currency (%1) of line %2 is not valid.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La devise (%1) de la ligne %2 n''existe pas."}]}';
                begin
                    // Mise à jour du compteur des lignes extraites du fichier d'import
                    ImportLineNo += 1;

                    // Exclusion des lignes de légende
                    IF inTextOD <> 'OD' THEN begin
                        ImportLineNo -= 1;
                        currXMLport.SKIP();
                    end;

                    // Exclusion des lignes concernant les comptes 471000, 6***** ou 7***** sans spécification de code département et de N° de salarié.
                    inCodeTypeSection := DELCHR(inCodeTypeSection, '>', ' ');
                    IF ((inCodeTypeSection = '') OR (inCodeTypeSection = 'X')) AND ((inGLAccount = '471000') OR (COPYSTR(inGLAccount, 1, 1) = '6') OR (COPYSTR(inGLAccount, 1, 1) = '7')) THEN begin
                        ImportLineNo -= 1;
                        currXMLport.SKIP();
                    end;

                    // Date de comptabilisation
                    IF NOT EVALUATE(PostingDateVal, inPostingDate) THEN
                        ERROR(PostingDateErr, COPYSTR(inPostingDate, 1, 2) + '/' + COPYSTR(inPostingDate, 3, 2) + '/' + COPYSTR(inPostingDate, 5, 2), ImportLineNo);

                    IF inCodeTypeSection <> 'XS' THEN BEGIN
                        // Compte comptable
                        IF NOT GLAccount.GET(inGLAccount) THEN
                            ERROR(GLAccountErr, inGLAccount, ImportLineNo);

                        // Code département
                        inCodeSection := COPYSTR(inCodeTypeSection, 2, 1) + DELCHR(inCodeSection, '>', ' ');
                        IF inCodeSection <> '' THEN BEGIN
                            DimensionValue.RESET();
                            DimensionValue.SETCURRENTKEY(Code, "Global Dimension No.");
                            DimensionValue.SETRANGE(Code, inCodeSection);
                            DimensionValue.SETRANGE("Global Dimension No.", 1);
                            IF NOT DimensionValue.FINDFIRST() THEN BEGIN
                                DimensionValue.RESET();
                                DimensionValue.SETCURRENTKEY("SAGE Code", "Global Dimension No.");
                                DimensionValue.SETRANGE("SAGE Code", inCodeSection);
                                DimensionValue.SETRANGE("Global Dimension No.", 1);
                                IF NOT DimensionValue.FINDFIRST() THEN
                                    ERROR(DepartmentCodeErr, inCodeSection, ImportLineNo)
                            END;
                            IF DimensionValue."Payroll Job Attribution" = '' THEN
                                ERROR(PayrollJobAttritutionErr, inCodeSection, ImportLineNo);
                        END;
                    END ELSE BEGIN
                        // Salarié
                        EmployeeNo := Format(COPYSTR(inCodeSection, 1, STRLEN(inCodeSection) -
                                                            STRLEN(DELCHR(CONVERTSTR(inCodeSection, ConvertStrFromTxt, ConvertStrToTxt), '<', '0'))));

                        IF Employee.GET(EmployeeIDRoot + EmployeeNo) THEN
                            EmployeeNo := Format(EmployeeIDRoot + EmployeeNo)
                        ELSE BEGIN
                            IF STRLEN(EmployeeNo) < EmployeeIDDigitNber THEN
                                EmployeeNo := EmployeeIDRoot + PADSTR('', EmployeeIDDigitNber - STRLEN(EmployeeNo), '0') + EmployeeNo
                            ELSE
                                EmployeeNo := EmployeeIDRoot + Format(EmployeeNo);
                            IF NOT Employee.GET(EmployeeNo) THEN
                                ERROR(EmployeeErr, EmployeeNo, ImportLineNo);
                        END;
                    END;
                    // Débit / Crédit
                    IF (inDebitCredit <> 'D') AND (inDebitCredit <> 'C') THEN
                        ERROR(DebitCreditErr, ImportLineNo);

                    // Montant du débit ou du crédit
                    IF NOT EVALUATE(AmountVal, inAmount) THEN
                        ERROR(AmountTypeErr, inAmount, ImportLineNo);

                    //Exclusion des montants vides lors de l'import
                    if (AmountVal = 0) then begin
                        ImportLineNo -= 1;
                        currXMLport.SKIP();
                    end;

                    // Devise
                    inCurrency := DELCHR(inCurrency, '>', ' ');
                    IF GenLedgerSetup."LCY Code" = inCurrency THEN
                        inCurrency := ''
                    ELSE
                        IF NOT Currency.GET(inCurrency) THEN
                            ERROR(CurrencyErr, inCurrency, ImportLineNo);

                    // Evaluation du numéro de la ligne à créer dans la feuille de comptabilité
                    JournalLineNo += 1000;

                    // Identifiant de la ligne
                    GenJnlLine.INIT();
                    GenJnlLine."Journal Template Name" := GenJnlTemplate.Name;
                    GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
                    GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
                    GenJnlLine."Line No." := JournalLineNo;
                    IF GenJnlBatch."No. Series" <> '' THEN BEGIN
                        CLEAR(NoSeriesMgt);
                        GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", PostingDateVal, FALSE);
                    END;

                    // Code motif
                    GenJnlLine.VALIDATE("Reason Code", GenJnlBatch."Reason Code");

                    // Date de comptabilisation
                    GenJnlLine.VALIDATE("Posting Date", PostingDateVal);

                    // Type de compte et N° de compte
                    IF inCodeTypeSection <> 'XS' THEN BEGIN
                        // Compte général
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        GenJnlLine.VALIDATE("Account No.", inGLAccount);

                        IF COPYSTR(GenJnlLine."Account No.", 1, 2) <> '44' THEN BEGIN
                            GenJnlLine.VALIDATE("Gen. Bus. Posting Group", '');
                            GenJnlLine.VALIDATE("VAT Bus. Posting Group", '');
                            GenJnlLine.VALIDATE("Gen. Prod. Posting Group", '');
                            GenJnlLine.VALIDATE("Gen. Posting Type", GenJnlLine."Gen. Posting Type"::" ");
                            GenJnlLine.VALIDATE("VAT Prod. Posting Group", '');
                        END;

                    END ELSE BEGIN
                        // Compte fournisseur
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Employee);
                        GenJnlLine.VALIDATE("Account No.", EmployeeNo);
                    END;
                    // Decription
                    GenJnlLine.VALIDATE(Description, inDescription);

                    // Devise
                    GenJnlLine.VALIDATE("Currency Code", inCurrency);

                    // Montant du débit ou du crédit
                    IF inDebitCredit = 'C' THEN
                        GenJnlLine.VALIDATE("Credit Amount", AmountVal)
                    ELSE
                        GenJnlLine.VALIDATE("Debit Amount", AmountVal);

                    // Initialisation du projet en fonction du code département d'imputation
                    GenJnlLine.VALIDATE("Job No.", DimensionValue."Payroll Job Attribution");

                    // Code département
                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", DimensionValue.Code);

                    // Création de la ligne de la feuille de comptabilité
                    GenJnlLine.INSERT(TRUE);
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    var
        HumanResourcesSetup: Record "Human Resources Setup";
        NoSeriesLine: Record "No. Series Line";
        GenJnlTemplateErr: Label 'General journal template %1 does not exist. \\', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le modèle de la feuille d''accueil des écritures de paye ''%1'' n''existe pas. \\"}]}';
        GenJnlBatchErr: Label 'The gen. journal batch %1 associated with the gen. journal template %2 does not exist. \\', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La feuille d''accueil des écritures de paye ''%1'' associée au modèle ''%2'' n''existe pas. \\"}]}';
        InterfaceSetupLbl: Label 'Please refer to the configuration of the interface setup.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Veuillez-vous reporter à la configuration des paramètres interface."}]}';
        NoSeriesLineErr: Label 'Series line relating to employees is incomplete.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La souche relative aux salariés est incomplète."}]}';
        GenJrnlLineErr: Label 'The general journal Line (template: %1 / sheet: %2) is not empty. \\ Do you want to delete it ?', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La feuille d''accueil de la paye (modèle : %1 / feuille : %2) n''est pas vide. \\ Voulez-vous l''effacer ?"}]}';

    begin

        IF GenLedgerSetup.GET() THEN;
        IF GenLedgerSetup."LCY Code" = '' THEN
            GenLedgerSetup."LCY Code" := 'EUR';

        IF InterfaceSetup.GET() THEN;
        // Test validité du modèle de la feuille d'accueil
        IF NOT GenJnlTemplate.GET(InterfaceSetup."SAGE PAIE Gen. Jnl. Template") THEN
            ERROR(FORMAT(GenJnlTemplateErr + InterfaceSetupLbl), InterfaceSetup."SAGE PAIE Gen. Jnl. Template");

        // Test validité de la feuille d'accueil
        IF NOT GenJnlBatch.GET(InterfaceSetup."SAGE PAIE Gen. Jnl. Template", InterfaceSetup."SAGE PAIE Gen. Journal Batch") THEN
            ERROR(Format(GenJnlBatchErr + InterfaceSetupLbl), InterfaceSetup."SAGE PAIE Gen. Journal Batch", InterfaceSetup."SAGE PAIE Gen. Jnl. Template");

        // Evaluation des caractéristiques d'identification d'un salarié (racine et nombre de digits de  la partie numérique).
        // Identification de la souche salarié
        IF HumanResourcesSetup.GET() THEN;

        // Recherche de la ligne de souche rattachée à la période la plus récente
        NoSeriesLine.RESET();
        NoSeriesLine.SETCURRENTKEY("Series Code", "Starting Date", "Starting No.");
        NoSeriesLine.SETRANGE("Series Code", HumanResourcesSetup."Employee Nos.");
        IF NOT NoSeriesLine.FindLast() THEN
            ERROR(NoSeriesLineErr);

        // Evaluation de la racine de l'identificateur des salariés
        EmployeeIDRoot := DELCHR(CONVERTSTR(NoSeriesLine."Starting No.", ConvertStrFromTxt, ConvertStrToTxt), '>', '0');

        // Evaluation du nombre de digits constituants la partie numérique de l'identificateur
        //                                    des salariés.
        EmployeeIDDigitNber := STRLEN(NoSeriesLine."Starting No.") - STRLEN(EmployeeIDRoot);

        // Test existence de lignes dans la feuille d'accueil
        GenJnlLine.RESET();
        GenJnlLine.SETRANGE("Journal Template Name", InterfaceSetup."SAGE PAIE Gen. Jnl. Template");
        GenJnlLine.SETRANGE("Journal Batch Name", InterfaceSetup."SAGE PAIE Gen. Journal Batch");
        IF GenJnlLine.FindFirst() THEN
            IF CONFIRM(STRSUBSTNO(GenJrnlLineErr, InterfaceSetup."SAGE PAIE Gen. Jnl. Template", InterfaceSetup."SAGE PAIE Gen. Journal Batch")) THEN
                // Vidange de la feuille d'accueil des écritures de paye
                GenJnlLine.DELETEALL()
            ELSE
                // Abandon de l'import
                currXMLport.QUIT();

        // Initialisation du compteur des lignes extraites du fichier d'import
        ImportLineNo := 0;

        // Initialisation du compteur des lignes à créer dans la feuille de comptabilité
        JournalLineNo := 0;
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE(FinalMessageLbl, FORMAT(ImportLineNo));
    end;

    var
        InterfaceSetup: Record "Interface Setup";
        GenLedgerSetup: Record "General Ledger Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmployeeIDRoot: Code[20];
        EmployeeIDDigitNber: Integer;
        ImportLineNo: Integer;
        JournalLineNo: Integer;
        PostingDateVal: Date;
        ConvertStrFromTxt: Label '0123456789';
        ConvertStrToTxt: Label '0000000000';
        FinalMessageLbl: Label 'Import %1 lines with success', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import %1 lignes avec succès"}]}';
}

