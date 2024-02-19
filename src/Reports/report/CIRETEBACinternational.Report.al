/// <summary>
/// Report CIR ETEBAC international (ID 50000).
/// </summary>
report 50034 "CIR ETEBAC International"
{
    ApplicationArea = ALL;
    Caption = 'ETEBAC international', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ETEBAC international"}]}';
    Permissions = TableData "Payment Header" = rimd, TableData "Payment Line" = rimd;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(PaymentHeader; "Payment Header")
        {
            dataitem(PaymentLine; "Payment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("No.", "Line No.");

                trigger OnAfterGetRecord();
                var
                    DecimalNumber: Integer;
                    Lg: Integer;
                    Err_MissingAccountNo_Lbl: Label 'The vendor code %1 does not exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"le code fournisseur %1 n''existe pas"}]}';
                    Err_MissingCountryRegionCode_Lbl: Label 'The country code of the supplier bank account %1 is not filled in. You must verify this before continuing.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le code pays du compte bancaire fournisseur %1 n''est pas renseigné. Vous devez le vérifier avant de continuer."}]}';
                    Err_MissingCurrencyCode_Lbl: Label 'All transfers must refer to the same currency.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tous les virements doivent faire référence à la même devise."}]}';
                    Err_MissingDocumentNo_Lbl: Label 'All transfers must have a document number.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tous les virements doivent avoir un numéro de document."}]}';
                    Err_MissingIBAN_Lbl: Label 'The IBAN code of bank account n °: %1 must be entered', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le code IBAN du compte bancaire n°: %1 doit être renseigné"}]}';
                    Err_MissingName_Lbl: Label 'The name of vendor bank account %1 is missing. You must check it before continuing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le nom du compte bancaire fournisseur %1 n''est pas renseigné. Vous devez le vérifier avant de continuer."}]}';
                    Err_MissingSWIFTCode_Lbl: Label 'The BIC or SWIFT code of the supplier bank account %1 is not filled in. You must verify this before continuing.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le code BIC ou SWIFT du compte bancaire fournisseur %1 n''est pas renseigné. Vous devez le vérifier avant de continuer."}]}';
                    Err_MissingVendorBankAccount_Lbl: Label 'Vendor bank account %1 does not exist. You must create it before continuing.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le compte bancaire fournisseur %1 n''existe pas. Vous devez le créer avant de continuer."}]}';
                    Err_SWIFT_Inter_Lbl: Label 'Swift code must be filled on line %1 of payment header %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez renseigner le code swift sur la ligne %1 du bordereau n° %2"}]}';
                    AccountTypeRecipient: Text[1];
                    IntermediaryBankCountryName: Text[2];
                    OperationCode: Text[2];
                    RegistrationCodeB: Text[2];
                    RegistrationCodeD: Text[2];
                    RegistrationCodeI: Text[2];
                    RegistrationCodeR: Text[2];
                    VendorBankCountrysName: Text[2];
                    VendorCountryName: Text[2];
                    CodeMotifEconomique: Text[3];
                    SequentialNumber: Text[6];
                    ExecutionDate: Text[8];
                    BICCode: Text[11];
                    Compl: Text[11];
                    IntermediaryBankBICCode: Text[11];
                    Void: Text[11];
                    RefOperation: Text[18];
                    AccountCodeDebit: Text[34];
                    BeneficiaryAccountCode: Text[34];
                    IntermediaryBankName: Text[35];
                    VendorBankName: Text[35];
                    VendorName: Text[35];
                    PrintAmount: Text[50];
                    IntermediaryBankAddress: Text[105];
                    Vendoraddress: Text[105];
                    VendorBankAddressName: Text[105];
                    Designation: Text[140];
                begin
                    TESTFIELD("Bank Account Code");
                    TESTFIELD("Account Type", PaymentLine."Account Type"::Vendor);

                    VendorBankAccount.SETRANGE("Vendor No.", "Account No.");
                    VendorBankAccount.SETRANGE(Code, "Bank Account Code");

                    IF NOT VendorBankAccount.FIND('-') THEN
                        ERROR(Err_MissingVendorBankAccount_Lbl, "Bank Account Code");
                    IF (STRLEN(VendorBankAccount."SWIFT Code") = 0) THEN
                        ERROR(Err_MissingSWIFTCode_Lbl, "Bank Account Code");

                    IF (STRLEN(VendorBankAccount."Country/Region Code") = 0) THEN
                        ERROR(Err_MissingCountryRegionCode_Lbl, "Bank Account Code");
                    IF (STRLEN(VendorBankAccount.Name) = 0) THEN
                        ERROR(Err_MissingName_Lbl, "Bank Account Code");

                    IF (STRLEN(BankAccount.IBAN) = 0) THEN
                        ERROR(Err_MissingIBAN_Lbl, BankAccount."No.");

                    IF NOT Vendor.GET("Account No.") THEN
                        ERROR(Err_MissingAccountNo_Lbl, "Account No.");

                    IF (CurrencyUsed <> "Currency Code") THEN
                        ERROR(Err_MissingCurrencyCode_Lbl);

                    "Issuer/Recipient" := PaymentHeader."Issuer/Recipient";
                    "Intermediary Account No." := PaymentHeader."Intermediary Account No.";
                    RegistrationCodeD := '04';
                    OperationCode := GeneralApplicationSetup."Operation code";
                    SequentialInt := SequentialInt + 1;
                    SequentialNumber := Format(CONVERTSTR(FORMAT(SequentialInt, 6), ' ', '0'));

                    AccountTypeRecipient := '2';
                    BeneficiaryAccountCode := PADSTR(VendorBankAccount."Bank Account No.", 34);

                    VendorName := PADSTR(Vendor.Name + ' ' + Vendor."Name 2", 35);
                    Vendoraddress := PADSTR(Vendor.Address, 35) + PADSTR(Vendor."Address 2", 35) + PADSTR(Vendor."Post Code" + Vendor.City, 35);

                    VendorCountryName := PADSTR(Vendor."Country/Region Code", 2);
                    IF Currency.GET("Currency Code") THEN CodeCurrencyDetail := PADSTR(Currency.Code, 3);
                    IF "Currency Code" = '' THEN CodeCurrencyDetail := 'EUR';

                    RefOperation := PADSTR(TransferNumber, 16);
                    PrintAmount := FormatMnt(Amount, 14);

                    CodeMotifEconomique := '359';

                    DecimalNumber := 2;
                    ExecutionDate := FORMAT(PaymentHeader."Document Date", 0, '<Year4><Month,2><Day,2>');
                    CLEAR(TexteSorti);
                    ChargesChargingCode := '15';
                    CASE PaymentLine."Issuer/Recipient" OF
                        PaymentLine."Issuer/Recipient"::"15-Issuer": //Iban cpte entête Bordereau
                            ChargesChargingCode := '15';
                        PaymentLine."Issuer/Recipient"::"14-Both":
                            ChargesChargingCode := '14';
                        PaymentLine."Issuer/Recipient"::"13-Recipient": //Iban du fns
                            ChargesChargingCode := '13';
                    END;

                    TexteSorti := Format(RegistrationCodeD + OperationCode + SequentialNumber + AccountTypeRecipient + COPYSTR(BeneficiaryAccountCode, 1, 34) +
                      VendorName + Vendoraddress + PADSTR('', 17) + VendorCountryName + RefOperation + 'T' + PADSTR('', 4) + PrintAmount + FORMAT(DecimalNumber) +
                      PADSTR('', 1) + PADSTR(CodeMotifEconomique, 3) + VendorCountryName + '0' + ChargesChargingCode);

                    TypeIdentifCpteFrais := '1';
                    IF (ChargesChargingCode = '15') OR (ChargesChargingCode = '14') THEN
                        IF BankAccount.IBAN <> '' THEN BEGIN
                            TypeIdentifCpteFrais := '1';
                            AccountCodeDebit := PADSTR(BankAccount.IBAN, 34);
                        END
                        ELSE BEGIN
                            TypeIdentifCpteFrais := '0';
                            AccountCodeDebit := PADSTR(BankAccount."Bank Account No.", 34)
                        END;

                    IF ChargesChargingCode = '13' THEN BEGIN
                        TypeIdentifCpteFrais := ' ';
                        AccountCodeDebit := PADSTR(' ', 34);
                    END;
                    TexteSorti2 := TypeIdentifCpteFrais + PADSTR(AccountCodeDebit, 34) + PADSTR(DebiterAccountCurrencyCode, 3) + PADSTR('', 22) + ExecutionDate + PADSTR(CodeCurrencyDetail, 3);
                    OutStr.WriteText(PADSTR(TexteSorti + TexteSorti2, 320));
                    OutStr.WriteText();
                    //ENREGISTREMENT BANQUE BENEFICIAIRE
                    RegistrationCodeB := '05';
                    SequentialInt := SequentialInt + 1;
                    SequentialNumber := Format(CONVERTSTR(FORMAT(SequentialInt, 6), ' ', '0'));
                    VendorBankName := PADSTR(VendorBankAccount.Name + ' ' + VendorBankAccount."Name 2", 35);
                    VendorBankAddressName := PADSTR(VendorBankAccount.Address, 35) + PADSTR(VendorBankAccount."Address 2", 35) + PADSTR(VendorBankAccount."Post Code" + ' ' + VendorBankAccount.City, 35);
                    Evaluate(BICCode, VendorBankAccount."SWIFT Code");
                    Lg := STRLEN(BICCode);
                    IF Lg < 12 THEN BEGIN
                        Void := '           ';
                        Compl := BICCode;
                        CLEAR(BICCode);
                        BICCode := Compl + COPYSTR(Void, 1, 11 - Lg);
                    END;
                    VendorBankCountrysName := PADSTR(VendorBankAccount."Country/Region Code", 2);
                    CLEAR(TexteSorti);
                    TexteSorti := RegistrationCodeB + OperationCode + SequentialNumber + VendorBankName + VendorBankAddressName;
                    TexteSorti2 := BICCode + VendorBankCountrysName + PADSTR('', 157);
                    OutStr.WriteText(PADSTR(TexteSorti + TexteSorti2, 320));
                    OutStr.WriteText();

                    //ENREGISTREMENT BANQUE INTERMEDIAIRE
                    IF "Intermediary Account No." <> '' THEN BEGIN
                        RegistrationCodeI := '06';
                        SequentialInt := SequentialInt + 1;
                        SequentialNumber := Format(CONVERTSTR(FORMAT(SequentialInt, 6), ' ', '0'));
                        CLEAR(IntermediaryBankName);
                        IF BqeInter.GET("Intermediary Account No.") THEN
                            IF BqeInter."SWIFT Code" = '' THEN ERROR(Err_SWIFT_Inter_Lbl, "Line No.", "No.");
                        IntermediaryBankName := PADSTR(BqeInter.Name + ' ' + BqeInter."Name 2", 35);
                        IntermediaryBankAddress := PADSTR(BqeInter.Address, 35) + PADSTR(BqeInter.City + BqeInter."Country/Region Code", 35)
                        + PADSTR(BqeInter."Post Code" + BqeInter."Address 2", 35);
                        IntermediaryBankBICCode := PADSTR('', 11 - STRLEN(BqeInter."SWIFT Code"), '0') + BqeInter."SWIFT Code";
                        IntermediaryBankCountryName := PADSTR(BqeInter."Country/Region Code", 2);
                        CLEAR(TexteSorti);
                        TexteSorti := RegistrationCodeI + OperationCode + SequentialNumber + IntermediaryBankName + IntermediaryBankAddress;
                        TexteSorti2 := IntermediaryBankBICCode + IntermediaryBankCountryName + PADSTR('', 157);
                        OutStr.WriteText(PADSTR(TexteSorti + TexteSorti2, 320));
                        OutStr.WriteText();
                    END;

                    //ENREGISTREMENT RENSEIGNEMENTS COMPLEMENTAIRES
                    RegistrationCodeR := '07';
                    SequentialInt := SequentialInt + 1;
                    SequentialNumber := Format(CONVERTSTR(FORMAT(SequentialInt, 6), ' ', '0'));
                    Designation := PADSTR(Vendor.Name, 140);
                    CLEAR(TexteSorti);
                    TexteSorti := RegistrationCodeR + OperationCode + SequentialNumber + Designation + 'N' + PADSTR('', 16) + PADSTR('', 8) + '0' + PADSTR('', 11);
                    TexteSorti2 := PADSTR('', 105) + PADSTR('', 28);
                    OutStr.WriteText(PADSTR(TexteSorti + TexteSorti2, 320));
                    OutStr.WriteText();
                    IF "Document No." = '' THEN ERROR(Err_MissingDocumentNo_Lbl);

                    TotalMontant += Amount;

                end;

                trigger OnPostDataItem();
                var
                    TypeAccountDebit: Text[1];
                    OperationCode: Text[2];
                    RegistrationCode: Text[2];
                    RIBNumber: Text[2];
                    CodeCurrencyAccountDebit: Text[3];
                    CounterCodeNumber: Text[5];
                    EstablishmentNumber: Text[5];
                    SequentialNumber: Text[6];
                    ExecutionDate: Text[8];
                    CpteBqe: Text[11];
                    SiretNo: Text[14];
                    PaymentNo: Text[16];
                    AccountCodeDebit: Text[34];
                    PrintAmount: Text[50];
                begin
                    //ENREGISTREMENT TOTAL
                    RegistrationCode := '08';
                    OperationCode := GeneralApplicationSetup."Operation code";
                    SequentialInt := SequentialInt + 1;
                    SequentialNumber := Format(CONVERTSTR(FORMAT(SequentialInt, 6), ' ', '0'));
                    ExecutionDate := FORMAT(PaymentHeader."Document Date", 0, '<Year4><Month,2><Day,2>');

                    SiretNo := PADSTR(CompanyInformation."Registration No.", 14);

                    PaymentNo := PADSTR(TransferNumber, 16);
                    TypeAccountDebit := '1';

                    EstablishmentNumber := PADSTR('', 5 - STRLEN(BankAccount."Bank Branch No."), '0') + BankAccount."Bank Branch No.";
                    CounterCodeNumber := PADSTR('', 5 - STRLEN(BankAccount."Agency Code"), '0') + BankAccount."Agency Code";
                    CpteBqe := PADSTR('', 11 - STRLEN(BankAccount."Bank Account No."), '0') + BankAccount."Bank Account No.";
                    Evaluate(RIBNumber, PADSTR('', 2 - STRLEN(FORMAT(BankAccount."RIB Key")), '0') + FORMAT(BankAccount."RIB Key"));

                    AccountCodeDebit := PADSTR(BankAccount.IBAN, 34);
                    IF Currency.GET(BankAccount."Currency Code") THEN
                        Evaluate(CodeCurrencyAccountDebit, Currency.Code)
                    ELSE
                        Evaluate(CodeCurrencyAccountDebit, GeneralLedgerSetup."LCY Code");

                    PrintAmount := FormatMnt(TotalMontant, 18);
                    IF CodeCurrencyAccountDebit = '' THEN CodeCurrencyAccountDebit := 'EUR';

                    CLEAR(TexteSorti);
                    TexteSorti := RegistrationCode + OperationCode + SequentialNumber + ExecutionDate + PADSTR('', 140) + SiretNo +
                      PaymentNo + PADSTR('', 11) + TypeAccountDebit + AccountCodeDebit + CodeCurrencyAccountDebit;
                    TexteSorti2 := PADSTR('', 16) + PrintAmount + PADSTR('', 49);
                    OutStr.WriteText(PADSTR(TexteSorti + TexteSorti2, 320));
                    OutStr.WriteText();
                end;

                trigger OnPreDataItem();
                var
                    IndexTypeDebit: Text[1];
                    PaymentType: Text[1];
                    TypeAccountDebit: Text[1];
                    OperationCode: Text[2];
                    RegistrationCode: Text[2];
                    RIBCode: Text[2];
                    CounterCodeNumber: Text[5];
                    EstablishmentNumber: Text[5];
                    SequentialNumber: Text[6];
                    CreationDate: Text[8];
                    DateExecution: Text[8];
                    CpteBqe: Text[11];
                    SiretNo: Text[14];
                    PaymentNo: Text[16];
                    CodeAccountDebit: Text[34];
                    CompanyName: Text[35];
                    CompanyAddress: Text[105];
                begin
                    TransferNumber := PaymentHeader."No.";
                    CurrencyUsed := PaymentHeader."Currency Code";


                    //ENREGISTREMENT EMETTEUR
                    CLEAR(TexteSorti);
                    CLEAR(TexteSorti2);

                    RegistrationCode := '03';
                    OperationCode := GeneralApplicationSetup."Operation code";
                    SequentialInt := 0;
                    SequentialInt := SequentialInt + 1;
                    SequentialNumber := Format(CONVERTSTR(FORMAT(SequentialInt, 6), ' ', '0'));
                    CreationDate := FORMAT(TODAY, 0, '<Year4><Month,2><Day,2>');
                    CompanyName := PADSTR(CompanyInformation.Name, 35);

                    CompanyAddress := PADSTR(CompanyInformation.Address, 35) + PADSTR(CompanyInformation.City, 35);
                    CompanyAddress := Format(CompanyAddress + PADSTR((CompanyInformation."Post Code" + CompanyInformation."Address 2"), 35));
                    SiretNo := PADSTR(CompanyInformation."Registration No.", 14);
                    PaymentNo := PADSTR(PaymentHeader."No.", 16);

                    TypeAccountDebit := '1';
                    EstablishmentNumber := PADSTR('', 5 - STRLEN(BankAccount."Bank Branch No."), '0') + BankAccount."Bank Branch No.";
                    CounterCodeNumber := PADSTR('', 5 - STRLEN(BankAccount."Agency Code"), '0') + BankAccount."Agency Code";
                    CpteBqe := PADSTR('', 11 - STRLEN(BankAccount."Bank Account No."), '0') + BankAccount."Bank Account No.";
                    Evaluate(RIBCode, PADSTR('', 2 - STRLEN(FORMAT(BankAccount."RIB Key")), '0') + FORMAT(BankAccount."RIB Key"));

                    CodeAccountDebit := PADSTR(BankAccount.IBAN, 34);
                    PaymentType := '';

                    IF Currency.GET(PaymentHeader."Currency Code") THEN IssuerCurrencyCode := Currency.Code;
                    IF PaymentHeader."Currency Code" = '' THEN IssuerCurrencyCode := 'EUR';

                    IF Currency.GET(BankAccount."Currency Code") THEN
                        Evaluate(DebiterAccountCurrencyCode, Currency.Code)
                    ELSE
                        Evaluate(DebiterAccountCurrencyCode, GeneralLedgerSetup."LCY Code");

                    IF DebiterAccountCurrencyCode = '' THEN DebiterAccountCurrencyCode := 'EUR';

                    IndexTypeDebit := '2';
                    DateExecution := FORMAT(PaymentHeader."Document Date", 0, '<Year4><Month,2><Day,2>');
                    PaymentTypeIndex := '1';
                    wSWIFT := BankAccount."SWIFT Code";
                    CLEAR(TexteSorti);

                    TexteSorti := RegistrationCode + OperationCode + SequentialNumber + CreationDate + CompanyName + CompanyAddress +
                      SiretNo + PaymentNo + PADSTR(wSWIFT, 11) + TypeAccountDebit + CodeAccountDebit + DebiterAccountCurrencyCode;
                    TexteSorti2 := PADSTR('', 16) + PADSTR('', 1) + PADSTR('', 34) + PADSTR('', 3) + PADSTR('', 16)
                      + PaymentType + IndexTypeDebit + PaymentTypeIndex + DateExecution + PADSTR(IssuerCurrencyCode, 3);
                    OutStr.WriteText(PADSTR(TexteSorti + TexteSorti2, 320));
                    OutStr.WriteText();
                end;
            }

            trigger OnAfterGetRecord();
            begin
                codeDevise := "Currency Code";
                IF codeDevise = '' THEN codeDevise := 'EUR';

                gRec_Head.TRANSFERFIELDS(PaymentHeader);

                IF PaymentHeader."Account No." = '' THEN ERROR(ERR_BNQ_Lbl);
                IF NOT BankAccount.GET(PaymentHeader."Account No.") THEN ERROR(BNQ_Entete_Lbl);
                IF PaymentHeader."Document Date" = 0D THEN ERROR(ERR_Date_Lbl);
            end;

            trigger OnPreDataItem();
            begin
                LOCKTABLE();
                GeneralApplicationSetup.TESTFIELD("Operation code");
                CreateOutPutFile();
                IF FileName = '' THEN ERROR(InputFileName_Lbl);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("FileName_"; FileName)
                {
                    ApplicationArea = All;
                    Caption = 'File Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom fichier"}]}';
                    ToolTip = 'File Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom fichier"}]}';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        FileNameRTC := Format(FileName);
                        OriginFile := Format(FileName);
                    end;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            FileNameRTC := Format(FileName);
            OriginFile := Format(FileName);
        end;
    }

    labels
    {
    }

    trigger OnPostReport();
    begin
        PaymentHeader."File Export Completed" := TRUE;
        PaymentHeader.MODIFY();
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        DownloadFromStream(InStr, '', '', '', FileName);
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.GET();
        GeneralApplicationSetup.GET();
        GeneralLedgerSetup.GET();
        SetFileName();
    end;

    var
        BankAccount: Record "Bank Account";
        BqeInter: Record "Bank Account";
        CompanyInformation: Record "Company Information";
        Currency: Record "Currency";
        GeneralApplicationSetup: Record "General Application Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        gRec_Head: Record "Payment Header";
        Vendor: Record "Vendor";
        VendorBankAccount: Record "Vendor Bank Account";
        TempBlob: Codeunit "Temp Blob";
        PaymentTypeIndex: Code[1];
        ChargesChargingCode: Code[2];
        CodeCurrencyDetail: Code[3];
        CurrencyUsed: Code[10];
        IssuerCurrencyCode: Code[10];
        TransferNumber: Code[20];
        TotalMontant: Decimal;
        OutPutFile: File;
        InStr: InStream;
        SequentialInt: Integer;
        BNQ_Entete_Lbl: Label 'It is not a bank which is defined in the header', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ce n''est pas une banque qui est définie dans l''entête"}]}';
        ERR_BNQ_Lbl: Label 'You must define the remittance bank in the header', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez définir la banque de remise dans l''entête"}]}';
        ERR_Date_Lbl: Label 'You must fill in the transfer date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez remplir la date de virement"}]}';
        InputFileName_Lbl: Label 'Input File Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Veuillez renseigner le nom du fichier"}]}';
        OutStr: OutStream;
        FileName: Text;
        TypeIdentifCpteFrais: Text[1];
        DebiterAccountCurrencyCode: Text[3];
        codeDevise: Text[30];
        wSWIFT: Text[30];
        TexteSorti: Text[250];
        TexteSorti2: Text[250];
        FileNameRTC: Text[1024];
        OriginFile: Text[1024];

    /// <summary>
    /// CreateOutPutFile.
    /// </summary>
    procedure CreateOutPutFile();
    begin
        CLEAR(OutPutFile);
        TempBlob.CreateOutStream(OutStr, TextEncoding::Windows);
    end;

    /// <summary>
    /// SetFileName.
    /// </summary>
    procedure SetFileName();
    var
        TextNorme_Lbl: Label 'A320';
        l_Annee: Text[30];
        l_Heure: Text[30];
        l_Jour: Text[30];
        l_Mois: Text[30];
    begin
        l_Annee := FORMAT(DATE2DMY(TODAY, 3));
        l_Mois := FORMAT(DATE2DMY(TODAY, 2));
        l_Jour := FORMAT(DATE2DMY(TODAY, 1));
        l_Heure := FORMAT(TIME, 2, '<Hours24,2>');
        l_Heure += FORMAT(TIME, 2, '<Minutes,2>');
        l_Heure += FORMAT(TIME, 2, '<Seconds,2>');
        FileName := Format(GeneralApplicationSetup."ETEBAC Internat. Directory" + TextNorme_Lbl + l_Annee + l_Mois + l_Jour + l_Heure + '.txt');
    end;

    local procedure FormatMnt(Montant: Decimal; Longueur: Integer): Text[50];
    var
        MntFormate: Text[50];
    begin
        MntFormate := Format(CONVERTSTR(FORMAT(Montant, Longueur, '<Precision,2:2><Integer><Decimal><Comma,,>'), ' ', '0'));
        MntFormate := '0' + COPYSTR(MntFormate, 1, Longueur - 3) + COPYSTR(MntFormate, Longueur - 1, 2);
        EXIT(MntFormate);
    end;
}