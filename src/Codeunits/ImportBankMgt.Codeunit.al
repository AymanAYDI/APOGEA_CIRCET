codeunit 50015 "Import Bank Mgt."
{
    trigger OnRun()
    begin
        // Fonction pour importer les réappro bancaire en masse pour ALLMYBANKS
        ExecuteImportBank();
    end;

    //Gestion du lettrage automatique sur plusieurs lignes
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Entry Set Recon.-No.", 'OnBeforeApplyEntries', '', false, false)]
    local procedure OnBeforeApplyEntries(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var Relation: Option);
    begin
        Relation := 1; //One-To-Many
                       /* Regression, desactivé provisoirement en attendant une correction 20288
                               BankAccReconciliationLine.Find();
                               if (BankAccReconciliationLine."Applied Entries" > 0) or (BankAccountLedgerEntry.IsApplied()) then
                                   Relation := 0;
                        */
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Reconciliation Post", 'OnBeforeInitPost', '', false, false)]
    local procedure OnBeforeInitPost(var BankAccReconciliation: Record "Bank Acc. Reconciliation");
    var
        lBankAccount: Record "Bank Account";
    begin
        IF lBankAccount.Get(BankAccReconciliation."Bank Account No.") THEN begin
            BankAccReconciliation."Last Statement No." := lBankAccount."Last Statement No.";
            BankAccReconciliation.MODIFY();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Reconciliation Post", 'OnAfterFinalizePost', '', false, false)]
    local procedure OnAfterFinalizePost(var BankAccReconciliation: Record "Bank Acc. Reconciliation");
    var
        lBankAccount: Record "Bank Account";
    begin
        IF lBankAccount.Get(BankAccReconciliation."Bank Account No.") THEN begin
            lBankAccount."Last Statement No." := BankAccReconciliation."Last Statement No.";
            lBankAccount.MODIFY();
        end;
    end;

    //Traitement du repertoire de fichier
    local procedure ExecuteImportBank()
    var
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        InterfaceLogMgt: Codeunit "Interface Log Mgt.";
        InterfaceName: Enum "Interface Name";
        PurchaseDocumentType: enum "Purchase Document Type";
        ErrorMessage: Text[250];
        LogEntry: Integer;
        BoolError: Boolean;
    begin
        CLEARLASTERROR();
        TempNameValueBuffer.DELETEALL();

        // Etape 0 : Vérification des paramètres
        InterfaceSetup.GET();
        CheckFields(InterfaceSetup);

        // Etape 1 : Import des fichiers
        FileManagement.GetServerDirectoryFilesList(TempNameValueBuffer, InterfaceSetup."Bank File Path");
        IF TempNameValueBuffer.FINDSET() THEN
            REPEAT
                CLEAR(BankAccReconciliation);
                CLEAR(gBankAccount);

                // Etape 2 : Génération des logs
                LogEntry := InterfaceLogMgt.CreateLogInterface(InterfaceName::ALLMYBANKS, COPYSTR((TempNameValueBuffer.Value + '.xml'), 1, 100), '', '', 4, PurchaseDocumentType::" ", '', CopyStr(CompanyName(), 1, 30));

                // Etape 3 : Intégration des fichiers
                BoolError := NOT ImportBank(TempNameValueBuffer.Name, BankAccReconciliation, ErrorMessage);

                // Etape 4 : Archivage des fichiers
                IF InterfaceSetup."Archive Bank File" THEN
                    FileManagement.CopyServerFile(TempNameValueBuffer.Name, InterfaceSetup."Archive Bank File Path" + '\' + TempNameValueBuffer.Value + '.xml', TRUE);

                //Suppression du fichier
                FileManagement.DeleteServerFile(TempNameValueBuffer.Name);

                // Etape 5 : Mise à jour des log d'intégration
                BankAccReconciliation.CALCFIELDS("Number of Lines");
                InterfaceLogMgt.ModifyLogInterface(LogEntry, COPYSTR((TempNameValueBuffer.Value + '.xml'), 1, 100), '', '', 4 /* Empty */, PurchaseDocumentType::" ", '', BankAccReconciliation."Statement Type", gBankAccount."No.", BankAccReconciliation."Statement No.", BankAccReconciliation."Number of Lines", CompanyName, BoolError, ErrorMessage);

            UNTIL TempNameValueBuffer.NEXT() = 0;
    END;

    local procedure GetBankAccountFromFile(var BankAccount: Record "Bank Account"; Name: Text[250]): Boolean;
    var
        TextRead: Text;
        vFile: File;
    begin
        vFile.Open(Name);
        vFile.CreateInStream(InStr);
        InStr.Read(TextRead);
        vFile.Close();
        EXIT(GetBankAccount(BankAccount, COPYSTR(TextRead, 1, 100)));
    end;

    local procedure GetBankAccount(var BankAccount: Record "Bank Account"; ValueText: Text): Boolean
    var
        Company: Record Company;
        BankBranchNo: Text[5];
        AgencyCode: Text[5];
        BankAccountNo: Text[11];
        Pos: Integer;
    begin
        CompanyName := '';
        gDateFile := 0D;

        Pos := 3;
        BankBranchNo := COPYSTR(ValueText, Pos, MAXSTRLEN(BankBranchNo));
        Pos += MAXSTRLEN(BankBranchNo) + 4;
        AgencyCode := COPYSTR(ValueText, Pos, MAXSTRLEN(AgencyCode));
        Pos += MAXSTRLEN(AgencyCode) + 5;
        BankAccountNo := COPYSTR(ValueText, Pos, MAXSTRLEN(BankAccountNo));

        Pos += MAXSTRLEN(BankAccountNo) + 2;
        IF NOT EVALUATE(gDateFile, COPYSTR(ValueText, Pos, 6)) THEN
            EXIT(false);

        BankAccount.RESET();
        BankAccount.SETRANGE("Bank Branch No.", BankBranchNo);
        BankAccount.SETRANGE("Agency Code", AgencyCode);
        BankAccount.SETRANGE("Bank Account No.", BankAccountNo);
        IF BankAccount.FINDSET() THEN
            EXIT(TRUE)
        ELSE BEGIN
            Company.SETFILTER(Name, '<>%1', BankAccount.CURRENTCOMPANY());
            IF Company.FINDSET() THEN
                REPEAT
                    BankAccount.CHANGECOMPANY(Company.Name);
                    BankAccount.SETRANGE("Bank Branch No.", BankBranchNo);
                    BankAccount.SETRANGE("Agency Code", AgencyCode);
                    BankAccount.SETRANGE("Bank Account No.", BankAccountNo);
                    IF BankAccount.FINDSET() THEN begin
                        CompanyName := Company.Name;
                        EXIT(TRUE);
                    END;
                UNTIL Company.NEXT() = 0;
        END;

        EXIT(FALSE);
    end;

    /// <summary>
    /// Verification setup for import
    /// </summary>
    /// <param name="pInterfaceSetup"></param>
    local procedure CheckFields(pInterfaceSetup: record "Interface Setup")
    begin
        pInterfaceSetup.TestField("Bank File Path");
        IF pInterfaceSetup."Archive Bank File" THEN
            pInterfaceSetup.TestField("Archive Bank File Path");
    end;

    local procedure ImportBank(Name: Text[250]; var BankAccReconciliation: record "Bank Acc. Reconciliation"; var ErrorMessage: text[250]): Boolean
    var
        BankAccount: Record "Bank Account";
        fileName: Text[250];

        // Label pour les erreurs
        NotBankAccountFindErr: Label 'Bank account is not found', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Compte bancaire non trouvé"}]}';
        NotDateFindErr: Label 'Date is not found in file', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date du relevé non trouvé"}]}';
        NotBARCreateErr: Label 'Bank Acc. Reconciliation not created', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rapprochement bancaire non créé"}]}';
        NotBARLineCreateErr: Label 'Bank Acc. Line Reconciliation not imported', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne de rapprochement bancaire non importé"}]}';
        DuplicateFileErr: Label 'File : %1 already imported.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fichier : %1 a déjà été intégré."}]}';
    begin
        CLEAR(ErrorMessage);

        // Etape 1 : Récupération des informations bancaire
        IF NOT GetBankAccountFromFile(BankAccount, Name) THEN BEGIN
            ErrorMessage := NotBankAccountFindErr;
            IF gDateFile = 0D then
                ErrorMessage := NotDateFindErr;

            EXIT(false);
        END;

        //On conserve que le nom du fichier
        fileName := DelStr(Name, 1, STRLEN(InterfaceSetup."Bank File Path"));

        // Etape 2 : Vérification si import d'un fichier déjà importé.
        if CheckDuplicateFileOnPayment(BankAccount, fileName) then begin
            IF gBankAccount.GET(BankAccount."No.") THEN;//utile pour avoir le numéro du compte bancaire dans le journal de log.

            ErrorMessage := STRSUBSTNO(DuplicateFileErr, fileName);
            EXIT(FALSE);
        END;

        // Etape 3 : vérification des informations bancaire
        ErrorMessage := CheckBankAccount(BankAccount);
        IF ErrorMessage <> '' THEN
            EXIT(false);

        // Etape 4 : Création de l'en-tête
        IF NOT CreateBARHeader(BankAccount, BankAccReconciliation, fileName) THEN BEGIN
            ErrorMessage := NotBARCreateErr;
            EXIT(false);
        END;

        // Etape 5 : Création des lignes
        IF NOT CreateBARLine(BankAccReconciliation, Name) THEN BEGIN
            ErrorMessage := NotBARLineCreateErr;
            EXIT(false);
        END;

        EXIT(true);
    end;

    /// <summary>
    /// Création de l'en-tête du réappro bancaire
    /// </summary>
    /// <param name="BankAccountNo">Bank Account No.</param>
    /// <param name="BankAccReconciliation">Bank Account Reconcilaion</param>
    /// <param name="piFileName">Filename</param>
    local procedure CreateBARHeader(BankAccount: Record "Bank Account"; var BankAccReconciliation: Record "Bank Acc. Reconciliation"; piFileName: Text[250]): Boolean
    var
        lBankAccount: Record "Bank Account";
    begin
        BankAccReconciliation.ChangeCompany(CompanyName);
        BankAccReconciliation.Init();
        BankAccReconciliation."Statement Type" := BankAccReconciliation."Statement Type"::"Bank Reconciliation";
        BankAccReconciliation."Bank Account No." := BankAccount."No.";

        lBankAccount.ChangeCompany(CompanyName);
        lBankAccount.GET(BankAccReconciliation."Bank Account No.");

        SetLastStatementNo(lBankAccount);
        BankAccReconciliation."Statement No." := IncStr(lBankAccount."Last Statement No.");
        BankAccReconciliation."Balance Last Statement" := lBankAccount."Balance Last Statement";

        BankAccReconciliation.Filename := piFileName;
        BankAccReconciliation."File Date" := gDateFile;
        EXIT(BankAccReconciliation.Insert(false));
    end;

    /// <summary>
    /// Importation des lignes d'import bancaire
    /// </summary>
    /// <param name="BankAccReconciliation"></param>
    /// <returns></returns>
    local procedure CreateBARLine(var BankAccReconciliation: Record "Bank Acc. Reconciliation"; FileName: Text[250]): Boolean
    begin
        EXIT(ImportBankStatement(BankAccReconciliation, FileName));
    end;

    local procedure ImportBankStatement(var BankAccReconciliation: Record "Bank Acc. Reconciliation"; FileName: Text[250]): Boolean
    var
        DataExch: Record "Data Exch.";
        BankAcc: Record "Bank Account";
        DataExchDef: Record "Data Exch. Def";
        OutStream: OutStream;
        vFile: File;
    begin
        if BankAccountCouldBeUsedForImport(BankAccReconciliation) then begin
            DataExch.Init();
            DataExch.Validate("File Name", FileName);
            DataExch."File Content".CreateOutStream(OutStream);
            vFile.Open(FileName);
            vFile.CreateInStream(InStr);
            CopyStream(OutStream, InStr);

            BankAcc.ChangeCompany(CompanyName);
            BankAcc.Get(BankAccReconciliation."Bank Account No.");
            BankAcc.GetDataExchDef(DataExchDef);
            DataExch."Related Record" := BankAcc.RecordId;
            DataExch."Data Exch. Def Code" := DataExchDef.Code;
            DataExch.Insert();

            EXIT(ImportBankStatement(BankAccReconciliation, DataExch));
        end;
    end;

    local procedure ImportBankStatement(BankAccRecon: Record "Bank Acc. Reconciliation"; DataExch: Record "Data Exch."): Boolean
    var
        BankAcc: Record "Bank Account";
        DataExchDef: Record "Data Exch. Def";
        DataExchMapping: Record "Data Exch. Mapping";
        DataExchLineDef: Record "Data Exch. Line Def";
        TempBankAccReconLine: Record "Bank Acc. Reconciliation Line" temporary;
    begin
        BankAcc.ChangeCompany(CompanyName);
        BankAcc.Get(BankAccRecon."Bank Account No.");
        BankAcc.GetDataExchDef(DataExchDef);

        DataExch."Related Record" := BankAcc.RecordId;
        DataExch."Data Exch. Def Code" := DataExchDef.Code;

        if not DataExch.ImportToDataExch(DataExchDef) then
            exit(false);

        CreateBankAccRecLineTemplate(TempBankAccReconLine, BankAccRecon, DataExch);
        DataExchLineDef.SetRange("Data Exch. Def Code", DataExchDef.Code);
        DataExchLineDef.FindFirst();

        DataExchMapping.Get(DataExchDef.Code, DataExchLineDef.Code, DATABASE::"Bank Acc. Reconciliation Line");

        if DataExchMapping."Pre-Mapping Codeunit" <> 0 then
            CODEUNIT.Run(DataExchMapping."Pre-Mapping Codeunit", TempBankAccReconLine);

        DataExchMapping.TestField("Mapping Codeunit");
        CODEUNIT.Run(DataExchMapping."Mapping Codeunit", TempBankAccReconLine);

        if DataExchMapping."Post-Mapping Codeunit" <> 0 then
            CODEUNIT.Run(DataExchMapping."Post-Mapping Codeunit", TempBankAccReconLine);

        InsertNonReconciledOrImportedLines(TempBankAccReconLine, GetLastStatementLineNo(BankAccRecon));

        exit(true);
    end;

    local procedure GetLastStatementLineNo(BankAccRecon: Record "Bank Acc. Reconciliation"): Integer
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconLine.ChangeCompany(CompanyName);
        BankAccReconLine.SetRange("Statement Type", BankAccRecon."Statement Type");
        BankAccReconLine.SetRange("Statement No.", BankAccRecon."Statement No.");
        BankAccReconLine.SetRange("Bank Account No.", BankAccRecon."Bank Account No.");
        if BankAccReconLine.FindLast() then
            exit(BankAccReconLine."Statement Line No.");
        exit(0);
    end;

    local procedure InsertNonReconciledOrImportedLines(var TempBankAccReconLine: Record "Bank Acc. Reconciliation Line" temporary; StatementLineNoOffset: Integer)
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconciliationLine.ChangeCompany(CompanyName);
        if TempBankAccReconLine.FindSet() then
            repeat
                if TempBankAccReconLine.CanImport() then begin
                    BankAccReconciliationLine := TempBankAccReconLine;
                    BankAccReconciliationLine."Statement Line No." += StatementLineNoOffset;
                    BankAccReconciliationLine.Insert();
                end;
            until TempBankAccReconLine.Next() = 0;
    end;

    local procedure CreateBankAccRecLineTemplate(var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; BankAccRecon: Record "Bank Acc. Reconciliation"; DataExch: Record "Data Exch.")
    begin
        BankAccReconLine.ChangeCompany(CompanyName);
        BankAccReconLine.Init();
        BankAccReconLine."Statement Type" := BankAccRecon."Statement Type";
        BankAccReconLine."Statement No." := BankAccRecon."Statement No.";
        BankAccReconLine."Bank Account No." := BankAccRecon."Bank Account No.";
        BankAccReconLine."Data Exch. Entry No." := DataExch."Entry No.";
    end;

    local procedure BankAccountCouldBeUsedForImport(BankAccReconciliation: Record "Bank Acc. Reconciliation"): Boolean
    var
        BankAccount: Record "Bank Account";
    begin
        BankAccount.ChangeCompany(CompanyName);
        BankAccount.Get(BankAccReconciliation."Bank Account No.");
        if BankAccount."Bank Statement Import Format" <> '' then
            exit(true);

        if BankAccount.IsLinkedToBankStatementServiceProvider() then
            exit(true);

        exit(false);
    end;

    local procedure CheckBankAccount(BankAccount: Record "Bank Account"): Text[250];
    var
        UnmanagedFileErr: Label 'Unmanaged statement file', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fichier de relevé non géré"}]}';
        BankUnkownErr: Label 'Bank No. %1 is unknow', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Banque n° %1 n''existe pas"}]}';
    begin
        gBankAccount.ChangeCompany(CompanyName);
        IF gBankAccount.GET(BankAccount."No.") THEN BEGIN
            IF gBankAccount."Bank Statement Import Format" = '' then
                EXIT(UnmanagedFileErr);
        END ELSE
            EXIT(STRSUBSTNO(BankUnkownErr, BankAccount."No."));
    end;

    //Fonction qui vérifie si le même fichier a déjà été intégré.
#pragma warning disable AA0137
    local procedure CheckDuplicateFileOnPayment(BankAccount: Record "Bank Account"; piFileName: Text[250]): Boolean
#pragma warning restore AA0137
    var
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        BankAccountStatement: Record "Bank Account Statement";
    begin
        BankAccReconciliation.CHANGECOMPANY(CompanyName);
        BankAccReconciliation.SETRANGE("Bank Account No.", BankAccount."No.");
        BankAccReconciliation.SETRANGE("File Date", gDateFile);
        //BankAccReconciliation.SETRANGE(Filename, piFileName);
        if not BankAccReconciliation.ISEMPTY() then
            EXIT(TRUE);

        BankAccountStatement.ChangeCompany(CompanyName);
        BankAccountStatement.SETRANGE("Bank Account No.", BankAccount."No.");
        BankAccountStatement.SETRANGE("File Date", gDateFile);
        //BankAccountStatement.SETRANGE(Filename, piFileName);
        if not BankAccountStatement.ISEMPTY() then
            EXIT(TRUE);
    end;

    local procedure SetLastStatementNo(var BankAccount: Record "Bank Account")
    begin
        if BankAccount."Last Statement No." = '' then begin
            BankAccount."Last Statement No." := '0';
            BankAccount.Modify();
        end;
    end;

    var
        gBankAccount: Record "Bank Account";
        InterfaceSetup: Record "Interface Setup";
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        FileManagement: Codeunit "File Management";
        CompanyName: text[30];
        gDateFile: Date;
        InStr: InStream;
}