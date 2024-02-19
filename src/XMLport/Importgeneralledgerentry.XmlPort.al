xmlport 50001 "Import General Ledger Entry"
{
    Caption = 'Import General Ledger Entry', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Import écriture comptable" }]}';
    Direction = Import;
    FieldDelimiter = 'None';
    FieldSeparator = ';';
    Format = VariableText;
    UseRequestPage = true;

    schema
    {
        textelement(root)
        {
            MinOccurs = Zero;
            tableelement(verifsociete; Integer)
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                MinOccurs = Zero;
                XmlName = 'VerifSociete';
                SourceTableView = SORTING(Number);
                textelement(CompName)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                var
                    CompName_Err: Label 'You are not in the right company to import your general ledger entries', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''êtes pas dans la bonne société pour importer vos écritures."}]}';
                begin
                    IF UPPERCASE(CONVERTSTR(CompName, FromCharacters_Txt, ToCharacters_Txt)) <> UPPERCASE(CONVERTSTR(COMPANYNAME(), FromCharacters_Txt, ToCharacters_Txt)) THEN
                        ERROR(CompName_Err);
                end;
            }
            tableelement(GenJournalLine; "Gen. Journal Line")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                MinOccurs = Zero;
                XmlName = 'GenJournalLine';
                SourceTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");
                textelement(JnlTemplateName)
                {
                    MinOccurs = Zero;
                }
                textelement(JnlBatchName)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterInsertRecord()
                var
                    GenJnlTemplateErr: Label 'General journal template %1 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modèle de feuille de compta %1 inconnu"}]}';
                    GenJnlBatchErr: Label 'General Journal Batch %1 unknown for the template %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Feuille de compta. %1 inconnue pour le modèle %2"}]}';
                    StrMenuOptionsLbl: Label 'Delete the existing lines and process the import, Keep the existing lines and process the import, Abandon import', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Supprimer les lignes existantes et traiter l''import,Conserver les lignes existantes et traiter l''import,Abandonner l''import"}]}';
                    ImportCanceledErr: Label 'Import canceled', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import annulé"}]}';
                begin
                    // Test existence du modèle de feuille
                    IF NOT GenJnlTemplate.GET(JnlTemplateName) THEN
                        ERROR(GenJnlTemplateErr, JnlTemplateName);

                    // Test existence de la feuille
                    IF NOT GenJnlBatch.GET(JnlTemplateName, JnlBatchName) THEN
                        ERROR(GenJnlBatchErr, JnlBatchName, GenJnlTemplate.Name);

                    // Evaluation du numéro de document à associer aux lignes à importer
                    IF GenJnlBatch."No. Series" <> '' THEN BEGIN
                        COMMIT(); // appel obligatoire pour pouvoir exploiter la valeur de retour de l'appel à la fonction TryGetNextNo du codeunit NoSeriesManagement.
                        CLEAR(NoSeriesMgt);
                        DocNo := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", WORKDATE());
                    END ELSE
                        DocNo := '';

                    // Evaluation du numéro de la dernière ligne de la feuille sélectionnée
                    LineNo := 0;
                    DelExistingLine := FALSE;
                    GenJnlLine.RESET();
                    GenJnlLine.SETRANGE("Journal Template Name", GenJnlTemplate.Name);
                    GenJnlLine.SETRANGE("Journal Batch Name", GenJnlBatch.Name);
                    IF GenJnlLine.FIND('+') THEN BEGIN
                        Selection := STRMENU(StrMenuOptionsLbl, 3);
                        CASE Selection OF
                            1:
                                DelExistingLine := TRUE;  // on supprime les lignes existantes
                            2:
                                LineNo := GenJnlLine."Line No."; // on récupère le n° de la dernière ligne
                            3:
                                currXMLport.QUIT();  // on arrête le dataport
                            ELSE
                                ERROR(ImportCanceledErr);
                        END;
                    END;
                end;
            }
            tableelement(Integer; Integer)
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                MinOccurs = Zero;
                XmlName = 'Integer';
                SourceTableView = SORTING(Number)
                                  ORDER(Ascending)
                                  WHERE(Number = FILTER(> 0));
                textelement(ExtDocNo)
                {
                    MinOccurs = Zero;
                }
                textelement(PostDate)
                {
                    MinOccurs = Zero;
                }
                textelement(DocDate)
                {
                    MinOccurs = Zero;
                }
                textelement(AccountType)
                {
                    MinOccurs = Zero;
                }
                textelement(AccountNo)
                {
                    MinOccurs = Zero;
                }
                textelement(Description)
                {
                    MinOccurs = Zero;
                }
                textelement(DebitAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(CreditAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(JobNo)
                {
                    MinOccurs = Zero;
                }
                textelement(CodeDept)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterInitRecord()
                begin
                    // Reset données d'import
                    CLEAR(ExtDocNo);
                    InExtDocNo := '';
                    CLEAR(PostDate);
                    InPostDate := 0D;
                    CLEAR(DocDate);
                    InDocDate := 0D;
                    CLEAR(AccountType);
                    InAccountType := '';
                    CLEAR(AccountNo);
                    InAccountNo := '';
                    CLEAR(Description);
                    InDescription := '';
                    CLEAR(DebitAmount);
                    InDebitAmount := 0;
                    CLEAR(CreditAmount);
                    inCreditAmount := 0;
                    CLEAR(JobNo);
                    InJobNo := '';
                    CLEAR(CodeDept);
                    InCodeDept := '';
                end;

                trigger OnAfterInsertRecord()
                var
                    GeneralApplicationSetup: Record "General Application Setup";
                    DocNumberErr: Label 'LINE %1 - External document number too long (%2 characters max)', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - N° document externe trop long (%2 caractères maxi)"}]}';
                    DocDateErr: Label 'LINE %1 - Enter Posting date or Document date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Renseignez Date comptabilisation ou Date document"}]}';
                    PostingDateErr: Label 'LINE %1 - Posting date is not in the correct format', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 -Date comptabilisation n''est pas au bon format"}]}';
                    InvalidDocDateErr: Label 'LINE %1 - Document date is not in the correct format', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Date document n''est pas au bon format"}]}';
                    AccountTypeErr: Label 'LINE %1 - Account type is incorrect', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Type compte est incorrect"}]}';
                    GLAccountErr: Label 'LINE %1 - G/L Account %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Compte général %2 inconnu"}]}';
                    CustomerErr: Label 'LINE %1 - Customer %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Client %2 inconnu"}]}';
                    VendorErr: Label 'LINE %1 - Vendor %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Fournisseur %2 inconnu"}]}';
                    EmployeeErr: Label 'LINE %1 - Employee %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Salarié %2 inconnu"}]}';
                    ICPartnerErr: Label 'LINE %1 - IC Partner %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Partenaire IC %2 inconnu"}]}';
                    BankAccErr: Label 'LINE %1 - Bank account %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Banque %2 inconnue"}]}';
                    FixedAssetErr: Label 'LINE %1 - Fixed asset %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Immobilisation %2 inconnue"}]}';
                    DocDescrErr: Label 'LINE %1 - Description too long (%2 characters max)', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Description trop longue (%2 caractères maxi)"}]}';
                    DebitAmountErr: Label 'LINE %1 - Debit Amount is not in the correct format', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Montant débit n''est pas au bon format"}]}';
                    CreditAmountErr: Label 'LINE %1 - Credit Amount is not in the correct format', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Montant crédit n''est pas au bon format"}]}';
                    AmountErr: Label 'LINE %1 - Enter only debit OR credit amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Renseignez seulement Montant débit OU crédit"}]}';
                    JobErr: Label 'LINE %1 - Job %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Projet %2 inconnu"}]}';
                    DepartmentCodeJobErr: Label 'LINE %1 - Department code %2 unknown on Job %3', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Code département %2 inconnu sur projet %3"}]}';
                    DepartmentCodeJobBlockedErr: Label 'LINE %1 - Department code %2 blocked on Job %3', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Code département %2 bloqué sur projet %3"}]}';
                    DepartmentCodeErr: Label 'LINE %1 - Department code %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Code département %2 inconnu"}]}';
                    DepartmentCodeBlockedErr: Label 'LINE %1 - Department code %2 blocked', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LIGNE %1 - Code département %2 bloqué"}]}';
                begin
                    // vérification des données importées
                    FileLineNo += 1;
                    ExtDocNo := CONVERTSTR(ExtDocNo, FromCharacters_Txt, ToCharacterSpecial_Txt);
                    IF STRLEN(ExtDocNo) > MAXSTRLEN(InExtDocNo) THEN
                        InsertError(StrSubstNo(DocNumberErr, FORMAT(FileLineNo), FORMAT(MAXSTRLEN(InExtDocNo))))
                    ELSE
                        InExtDocNo := ExtDocNo;

                    IF (PostDate = '') AND (DocDate = '') THEN
                        InsertError(StrSubstNo(DocDateErr, FORMAT(FileLineNo)))
                    ELSE BEGIN
                        IF PostDate <> '' THEN
                            IF NOT EVALUATE(InPostDate, PostDate) THEN
                                InsertError(StrSubstNo(PostingDateErr, FORMAT(FileLineNo)))
                            ELSE
                                IF DocDate = '' THEN
                                    InDocDate := InPostDate;

                        IF DocDate <> '' THEN
                            IF NOT EVALUATE(InDocDate, DocDate) THEN
                                InsertError(StrSubstNo(InvalidDocDateErr, FORMAT(FileLineNo)))
                            ELSE
                                IF PostDate = '' THEN
                                    InPostDate := InDocDate;
                    END;

                    IF NOT (UPPERCASE(CONVERTSTR(AccountType, FromCharacters_Txt, ToCharacters_Txt)) IN
                            ['COMPTE GENERAL', 'CLIENT', 'FOURNISSEUR', 'COMPTE BANCAIRE', 'IMMOBILISATION', 'PARTENAIRE IC', 'SALARIE']) THEN
                        InsertError(StrSubstNo(AccountTypeErr, FORMAT(FileLineNo)))
                    ELSE
                        InAccountType := CopyStr(UPPERCASE(CONVERTSTR(AccountType, FromCharacters_Txt, ToCharacters_Txt)), 1, MaxStrLen(InAccountType));

                    CASE InAccountType OF
                        'COMPTE GENERAL':
                            IF NOT GLAccount.GET(AccountNo) THEN
                                InsertError(StrSubstNo(GLAccountErr, FORMAT(FileLineNo), AccountNo))
                            ELSE
                                InAccountNo := AccountNo;
                        'CLIENT':
                            IF NOT Customer.GET(AccountNo) THEN
                                InsertError(StrSubstNo(CustomerErr, Format(FileLineNo), AccountNo))
                            ELSE
                                InAccountNo := AccountNo;
                        'FOURNISSEUR':
                            IF NOT Vendor.GET(AccountNo) THEN
                                InsertError(StrSubstNo(VendorErr, FORMAT(FileLineNo), AccountNo))
                            ELSE
                                InAccountNo := AccountNo;
                        'COMPTE BANCAIRE':
                            IF NOT BankAccount.GET(AccountNo) THEN
                                InsertError(StrSubstNo(BankAccErr, FORMAT(FileLineNo), AccountNo))
                            ELSE
                                InAccountNo := AccountNo;
                        'IMMOBILISATION':
                            IF NOT FixedAsset.GET(AccountNo) THEN
                                InsertError(StrSubstNo(FixedAssetErr, FORMAT(FileLineNo), AccountNo))
                            ELSE
                                InAccountNo := AccountNo;
                        'PARTENAIRE IC':
                            if not ICPartner.Get(AccountNo) then
                                InsertError(StrSubstNo(ICPartnerErr, FORMAT(FileLineNo), AccountNo))
                            else
                                InAccountNo := AccountNo;
                        'SALARIE':
                            if not Employee.Get(AccountNo) then
                                InsertError(StrSubstNo(EmployeeErr, FORMAT(FileLineNo), AccountNo))
                            else
                                InAccountNo := AccountNo;
                    END;

                    Description := CONVERTSTR(Description, FromCharacters_Txt, ToCharacterSpecial_Txt);
                    IF STRLEN(Description) > MAXSTRLEN(InDescription) THEN
                        InsertError(StrSubstNo(DocDescrErr, FORMAT(FileLineNo), FORMAT(MAXSTRLEN(InDescription))))
                    ELSE
                        InDescription := Description;

                    IF DebitAmount = '' THEN
                        InDebitAmount := 0
                    ELSE
                        IF NOT EVALUATE(InDebitAmount, DebitAmount) THEN
                            InsertError(StrSubstNo(DebitAmountErr, FORMAT(FileLineNo)));

                    IF CreditAmount = '' THEN
                        inCreditAmount := 0
                    ELSE
                        IF NOT EVALUATE(inCreditAmount, CreditAmount) THEN
                            InsertError(StrSubstNo(CreditAmountErr, FORMAT(FileLineNo)));

                    IF (InDebitAmount <> 0) AND (inCreditAmount <> 0) THEN
                        InsertError(StrSubstNo(AmountErr, FORMAT(FileLineNo)));

                    IF InDebitAmount < 0 THEN BEGIN
                        inCreditAmount := -InDebitAmount;
                        InDebitAmount := 0;
                    END;

                    IF inCreditAmount < 0 THEN BEGIN
                        InDebitAmount := -inCreditAmount;
                        inCreditAmount := 0;
                    END;

                    IF JobNo = '' THEN
                        IF CodeDept = '' THEN BEGIN
                            // Evaluation du projet de paye par défaut
                            if GeneralApplicationSetup.Get() then
                                JobNo := GeneralApplicationSetup."Payroll Job No.";
                        END ELSE BEGIN
                            // Recherche du projet de paye associé au code département
                            DimValue.RESET();
                            DimValue.SETCURRENTKEY("Dimension Code", "Global Dimension No.");
                            DimValue.SETRANGE("Code", CodeDept);
                            DimValue.SETRANGE("Global Dimension No.", 1);
                            IF DimValue.FINDFIRST() THEN
                                JobNo := DimValue."Payroll Job Attribution";
                        END;

                    IF (NOT Job.GET(JobNo)) AND (JobNo <> '') THEN
                        InsertError(StrSubstNo(JobErr, FORMAT(FileLineNo), JobNo))
                    ELSE
                        InJobNo := JobNo;

                    IF CodeDept <> '' THEN BEGIN
                        DimValue.SETCURRENTKEY("Dimension Code", "Global Dimension No.");
                        DimValue.SETRANGE("Code", CodeDept);
                        DimValue.SETRANGE("Global Dimension No.", 1);
                        IF NOT DimValue.FIND('-') THEN
                            InsertError(StrSubstNo(DepartmentCodeErr, FORMAT(FileLineNo), CodeDept))
                        ELSE
                            IF DimValue.Blocked THEN
                                InsertError(StrSubstNo(DepartmentCodeBlockedErr, FORMAT(FileLineNo), CodeDept))
                            ELSE
                                InCodeDept := CodeDept;
                    END
                    // on teste le département du projet
                    ELSE
                        IF Job.GET(InJobNo) THEN begin
                            DimValue.SETCURRENTKEY(Code, "Global Dimension No.");
                            DimValue.SETRANGE(Code, Job."Global Dimension 1 Code");
                            DimValue.SETRANGE("Global Dimension No.", 1);
                            IF NOT DimValue.FIND('-') THEN
                                InsertError(StrSubstNo(DepartmentCodeJobErr, FORMAT(FileLineNo), CodeDept, InJobNo))
                            ELSE
                                IF DimValue.Blocked THEN
                                    InsertError(StrSubstNo(DepartmentCodeJobBlockedErr, FORMAT(FileLineNo), CodeDept, InJobNo))
                                ELSE
                                    InCodeDept := Job."Global Dimension 1 Code";
                        end;
                    VeronaSetup.Get();
                    GeneralLedgerSetup.Get();

                    // on n'a pas encore rencontré d'erreur dans le fichier donc on crée des lignes dans une table temporaire
                    // ces lignes seront versées dans la vraie table si pas d'errur à la fin du balayage du fichier
                    IF ErrorNo = 0 THEN BEGIN
                        // Evaluation du numéro de la ligne à créer
                        LineNo += 10;

                        // Création de la ligne dans la feuile de compta.
                        TempGenJnlLine.INIT();
                        TempGenJnlLine."Journal Template Name" := GenJnlTemplate.Name;
                        TempGenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
                        TempGenJnlLine."Line No." := LineNo;
                        TempGenJnlLine."Document No." := DocNo;
                        TempGenJnlLine."Posting Date" := InPostDate;
                        TempGenJnlLine."Source Code" := GenJnlTemplate."Source Code";
                        TempGenJnlLine."Document Date" := InDocDate;
                        TempGenJnlLine."External Document No." := InExtDocNo;
                        CASE InAccountType OF
                            'COMPTE GENERAL':
                                TempGenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            'CLIENT':
                                TempGenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                            'FOURNISSEUR':
                                TempGenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
                            'COMPTE BANCAIRE':
                                TempGenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                            'IMMOBILISATION':
                                TempGenJnlLine."Account Type" := GenJnlLine."Account Type"::"Fixed Asset";
                            'PARTENAIRE IC':
                                TempGenJnlLine."Account Type" := GenJnlLine."Account Type"::"IC Partner";
                            'SALARIE':
                                TempGenJnlLine."Account Type" := GenJnlLine."Account Type"::Employee;
                        END;
                        TempGenJnlLine."Account No." := InAccountNo;
                        TempGenJnlLine.Description := InDescription;

                        IF InDebitAmount <> 0 THEN
                            TempGenJnlLine."Debit Amount" := InDebitAmount;
                        IF inCreditAmount <> 0 THEN
                            TempGenJnlLine."Credit Amount" := inCreditAmount;

                        IF TempGenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" THEN BEGIN
                            TempGenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::Disposal;
                            TempGenJnlLine."Depr. until FA Posting Date" := TRUE;
                        END;

                        TempGenJnlLine."Shortcut Dimension 1 Code" := InCodeDept;
                        TempGenJnlLine."Job No." := InJobNo;
                        TempGenJnlLine.INSERT();
                        TempGenJnlLine."Shortcut Dimension 2 Code" := InJobNo;      // Utilisé pour stocker l'axe 4, sinon redéfinition de l'axe 1 si job no. <> ''
                        TempGenJnlLine.Modify();

                        // Mise à jour du compteur d'écritures importées
                        Integer.Number += 1;
                    END;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Options"}]}';
                    field(ActivatedField; ACYActivatedField)
                    {
                        Caption = 'Activated Validate Job No. Field', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Activer la validation du champ N° projet."}]}';
                        ToolTip = 'Activated Validate Job No. Field', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Si activé, l''intégration de la valeur n° projet viendra créer à la validation les écritures projets. Il n''est pas nécessaire de l''activer en période de situation."}]}';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPostXmlPort()
    var
        SuccessfulImportLbl: Label 'The lines in the file have been imported successfully.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Les lignes du fichier ont été importées avec succès."}]}';
        CanceledImportErr: Label 'The import was canceled due to file errors.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"L''import a été annulé à cause des erreurs du fichier."}]}';
    begin
        IF ErrorNo <> 0 THEN BEGIN
            COMMIT();
            TempErrorJnl.RESET();
            PAGE.RUNMODAL(50007, TempErrorJnl);
            ERROR(CanceledImportErr);
        END
        // on insère les ligne compta dans la vraie table si on n'a pas rencontré d'erreur dans le fichier
        ELSE BEGIN
            IF DelExistingLine THEN
                GenJnlLine.DELETEALL();
            TempGenJnlLine.RESET();
            IF TempGenJnlLine.FindSet() THEN
                REPEAT
                    GenJnlLine.INIT();
                    GenJnlLine."Journal Template Name" := TempGenJnlLine."Journal Template Name";
                    GenJnlLine."Journal Batch Name" := TempGenJnlLine."Journal Batch Name";
                    GenJnlLine."Line No." := TempGenJnlLine."Line No.";
                    GenJnlLine."Document No." := TempGenJnlLine."Document No.";
                    GenJnlLine."Source Code" := TempGenJnlLine."Source Code";
                    GenJnlLine.VALIDATE("Posting Date", TempGenJnlLine."Posting Date");
                    GenJnlLine.VALIDATE("Document Date", TempGenJnlLine."Document Date");
                    GenJnlLine.VALIDATE("External Document No.", TempGenJnlLine."External Document No.");
                    GenJnlLine.VALIDATE("Account Type", TempGenJnlLine."Account Type");
                    GenJnlLine.VALIDATE("Account No.", TempGenJnlLine."Account No.");

                    GenJnlLine.VALIDATE(Description, TempGenJnlLine.Description);

                    IF TempGenJnlLine."Debit Amount" <> 0 THEN
                        GenJnlLine.VALIDATE("Debit Amount", TempGenJnlLine."Debit Amount");
                    IF TempGenJnlLine."Credit Amount" <> 0 THEN
                        GenJnlLine.VALIDATE("Credit Amount", TempGenJnlLine."Credit Amount");

                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" THEN BEGIN
                        GenJnlLine.VALIDATE("FA Posting Type", GenJnlLine."FA Posting Type"::Disposal);
                        GenJnlLine.VALIDATE("Depr. until FA Posting Date", TRUE);
                    END;

                    GenJnlLine.ValidateShortcutDimCode(4, TempGenJnlLine."Shortcut Dimension 2 Code");      // Ce n'est pas une erreur.
                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", TempGenJnlLine."Shortcut Dimension 1 Code");
                    if ACYActivatedField then
                        GenJnlLine.Validate("Job No.", TempGenJnlLine."Job No.")
                    else
                        GenJnlLine."Job No." := TempGenJnlLine."Job No.";

                    GenJnlLine.VALIDATE("Gen. Posting Type", GenJnlLine."Gen. Posting Type"::" ");
                    GenJnlLine.VALIDATE("Gen. Bus. Posting Group", '');
                    GenJnlLine.VALIDATE("Gen. Prod. Posting Group", '');
                    GenJnlLine.VALIDATE("VAT Bus. Posting Group", '');
                    GenJnlLine.VALIDATE("VAT Prod. Posting Group", '');

                    GenJnlLine.INSERT(TRUE);
                UNTIL TempGenJnlLine.NEXT() = 0;
            MESSAGE(SuccessfulImportLbl);
        END;
    end;

    trigger OnPreXmlPort()
    begin
        // Reset du compteur d'écritures importées
        Integer.Number := 1;
        FileLineNo := 1;
    end;

    trigger OnInitXmlPort()
    begin
        ACYActivatedField := true;
    end;

    local procedure InsertError(Descr1: Text[70])
    begin
        ErrorNo += 1;
        TempErrorJnl.INIT();
        TempErrorJnl.Code := FORMAT(ErrorNo);
        TempErrorJnl.Designation := Descr1;
        TempErrorJnl.INSERT(FALSE);
    end;

    var
        VeronaSetup: Record ARBVRNVeronaSetup;
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        Employee: Record Employee;
        ICPartner: Record "IC Partner";
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        Job: Record Job;
        DimValue: Record "Dimension Value";
        TempErrorJnl: Record Anomaly temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ErrorNo: Integer;
        DelExistingLine: Boolean;
        DocNo: Code[20];
        LineNo: Integer;
        Selection: Integer;
        InExtDocNo: Code[20];
        InPostDate: Date;
        InDocDate: Date;
        InAccountType: Text[20];
        InAccountNo: Code[20];
        InDescription: Text[50];
        InDebitAmount: Decimal;
        inCreditAmount: Decimal;
        InJobNo: Code[20];
        InCodeDept: Code[20];
        FileLineNo: Integer;
        FromCharacters_Txt: Label 'ÔõÚÞÛÙ¯´¹³¶÷Ó';
        ToCharacters_Txt: Label 'aaeeeeiiuuooa';
        ToCharacterSpecial_Txt: Label 'âäéèêëîïûüôöà';
        ACYActivatedField: Boolean;
}