report 50005 "CIR Export GL Entries TaxAudit"
{
    Caption = 'Export G/L Entries - Tax Audit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Exporter écritures comptables - Audit fiscal"}]}';
    ProcessingOnly = true;
    UsageCategory = None;

    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            DataItemTableView = SORTING("No.") WHERE("Account Type" = CONST(Posting));
            RequestFilterFields = "No.";
            dataitem(Customer; Customer)
            {
                DataItemTableView = SORTING("No.");

                trigger OnAfterGetRecord()
                begin
                    DetailedBalance +=
                      WriteDetailedGLAccountBySource(GLAccount."No.", GLEntry."Source Type"::Customer, "No.");
                end;

                trigger OnPreDataItem()
                begin
                    if not GLAccount."Detailed Balance" then
                        CurrReport.Break();
                end;
            }
            dataitem(Vendor; Vendor)
            {
                DataItemTableView = SORTING("No.");

                trigger OnAfterGetRecord()
                begin
                    DetailedBalance +=
                      WriteDetailedGLAccountBySource(GLAccount."No.", GLEntry."Source Type"::Vendor, "No.");
                end;

                trigger OnPreDataItem()
                begin
                    if not GLAccount."Detailed Balance" then
                        CurrReport.Break();
                end;
            }
            dataitem("Bank Account"; "Bank Account")
            {
                DataItemTableView = SORTING("No.");

                trigger OnAfterGetRecord()
                begin
                    DetailedBalance +=
                      WriteDetailedGLAccountBySource(GLAccount."No.", GLEntry."Source Type"::"Bank Account", "No.");
                end;

                trigger OnPreDataItem()
                begin
                    if not GLAccount."Detailed Balance" then
                        CurrReport.Break();
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                trigger OnAfterGetRecord()
                begin
                    if OpeningBalance - DetailedBalance <> 0 then
                        WriteGLAccountToFile(GLAccount, OpeningBalance - DetailedBalance);
                end;

                trigger OnPreDataItem()
                begin
                    if not GLAccount."Detailed Balance" then
                        CurrReport.Break();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                OpeningBalance := GetOpeningBalance();
                DetailedBalance := 0;
                if OpeningBalance = 0 then
                    exit;

                if not "Detailed Balance" then
                    WriteGLAccountToFile(GLAccount, OpeningBalance);
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("No.", GLAccNoFilter);
                if not IncludeOpeningBalances then
                    CurrReport.Break();
            end;
        }
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = SORTING("Entry No.");

            trigger OnAfterGetRecord()
            begin
                if "Posting Date" <> ClosingDate("Posting Date") then
                    ProcessGLEntry();
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Posting Date", gStartingDate, gEndingDate);
                SetFilter("G/L Account No.", GLAccount.GetFilter("No."));
                SetFilter(Amount, '<>%1', 0);
                SetFilter("Entry No.", '>=%1', 1);
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
                group(Options)
                {
                    Caption = 'Options', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Options"}]}';
                    field(StartingDate; gStartingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date début"}]}';
                        ClosingDates = true;
                        ToolTip = 'Specifies the first date for the time period covered in this audit.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la première date de la période couverte par cet audit."}]}';
                    }
                    field(EndingDate; gEndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date fin"}]}';
                        ClosingDates = true;
                        ToolTip = 'Specifies the last date to include in the time interval that you export entries for.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la dernière date à inclure dans l’intervalle de temps pour lequel vous exportez des écritures."}]}';
                    }
                    field("Include Opening Balances"; IncludeOpeningBalances)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Opening Balances', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Inclure soldes d''ouverture"}]}';
                        ToolTip = 'Specifies if you want to include opening balances in the audit report file. The balances are calculated as of the date before the first date of the period covered by the report.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie si vous souhaitez inclure des soldes d’ouverture dans le fichier de rapport d’audit. Les soldes sont calculés à la date précédant la première date de la période couverte par l’état."}]}';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        ToFileName := GetFileName();
        Writer.Close();
        if (ToFileFullName = '') then
            FileManagement.DownloadHandler(OutputFileName, '', '', '', ToFileName)
        else
            FileManagement.DownloadHandler(OutputFileName, '', '', '', ToFileFullName);
        Clear(oStream);
        Erase(OutputFileName);
    end;

    trigger OnPreReport()
    begin
        if gStartingDate = 0D then
            Error(MissingStartingDateErr);
        if gEndingDate = 0D then
            Error(MissingEndingDateErr);
        if GLAccount.GetFilter("No.") <> '' then
            GLAccNoFilter := CopyStr(GLAccount.GetFilter("No."), 1, MaxStrLen(GLAccNoFilter));
        GLEntry.SetRange("Posting Date", gStartingDate, gEndingDate);
        GLEntry.SetFilter("G/L Account No.", GLAccNoFilter);
        GLEntry.SetFilter(Amount, '<>%1', 0);
        if GLEntry.IsEmpty() then
            Error(NoEntriestoExportErr);

        CreateServerFile();
        WriteHeaderToFile();
    end;

    var
        FileManagement: Codeunit "File Management";
        OutputFile: File;
        oStream: OutStream;
        Writer: DotNet StreamWriter;
        encoding: DotNet Encoding;
        OutputFileName: Text[250];
        gStartingDate: Date;
        gEndingDate: Date;
        GLAccNoFilter: Code[250];
        ToFileName: Text[250];
        ToFileFullName: Text[250];
        MissingStartingDateErr: Label 'You must enter a Starting Date.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez entrer une date de début."}]}';
        MissingEndingDateErr: Label 'You must enter an Ending Date.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez entrer une date de fin."}]}';
        NoEntriestoExportErr: Label 'There are no entries to export within the defined filter. The file was not created.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Il n''y a pas d''écriture à exporter dans le filtre défini. Le fichier n''a pas été créé."}]}';
        InvalidWindowsChrStringTxt: Label '""#%&*:<>?\/{|}~', Locked = true;
        ServerFileExtensionTxt: Label 'TXT', Locked = true;
        IncludeOpeningBalances: Boolean;
        CurrentTransactionNo: Integer;
        CurrentSourceType: Enum "Gen. Journal Source Type";
        CustVendLedgEntryPartyNo: Code[20];
        CustVendLedgEntryPartyName: Text[100];
        CustVendLedgEntryFCYAmount: Text[250];
        CustVendLedgEntryCurrencyCode: Code[10];
        CustVendDocNoSet: Text;
        CustVendDateApplied: Date;
        PayRecAccount: Code[20];
        OpeningBalance: Decimal;
        DetailedBalance: Decimal;


    procedure Init(StartingDateValue: Date; EndingDateValue: Date; IncludeOpeningBalancesValue: Boolean; AccNoFilter: Code[250]; ReportFileNameValue: Text[250])
    begin
        gStartingDate := StartingDateValue;
        gEndingDate := EndingDateValue;
        IncludeOpeningBalances := IncludeOpeningBalancesValue;
        GLAccNoFilter := AccNoFilter;
        ToFileFullName := ReportFileNameValue;
    end;

    local procedure CreateServerFile()
    begin
        OutputFileName := CopyStr(FileManagement.ServerTempFileName(ServerFileExtensionTxt), 1, MaxStrLen(OutputFileName));
        if Exists(OutputFileName) then
            Erase(OutputFileName);

        OutputFile.TextMode(true);
        OutputFile.WriteMode(true);
        OutputFile.CreateOutStream(oStream);

        Writer := Writer.StreamWriter(OutputFileName, false, encoding.Default); // append = FALSE
    end;

    local procedure FindGLRegister(var GLRegister: Record "G/L Register"; EntryNo: Integer)
    begin
        GLRegister.SetFilter("From Entry No.", '<=%1', EntryNo);
        GLRegister.SetFilter("To Entry No.", '>=%1', EntryNo);
        GLRegister.FindFirst();
    end;

    local procedure FormatAmount(Amount: Decimal): Text[250]
    begin
        exit(Format(Amount, 0, '<Precision,2:2><Sign><Integer><Decimals><comma,,>'));
    end;

    local procedure GetAppliedBankLedgEntry(BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var DocNo: Text; var AppliedDate: Date)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        if CustLedgerEntry.Get(BankAccountLedgerEntry."Entry No.") then
            GetAppliedCustLedgEntry(CustLedgerEntry, DocNo, AppliedDate)
        else
            if VendorLedgerEntry.Get(BankAccountLedgerEntry.Get()) then
                GetAppliedVendorLedgEntry(VendorLedgerEntry, DocNo, AppliedDate);
    end;

    local procedure GetAppliedCustLedgEntry(CustLedgerEntryOriginal: Record "Cust. Ledger Entry"; var DocNo: Text; var AppliedDate: Date)
    var
        DetailedCustLedgEntryOriginal: Record "Detailed Cust. Ledg. Entry";
        DetailedCustLedgEntryApplied: Record "Detailed Cust. Ledg. Entry";
        CustLedgEntryApplied: Record "Cust. Ledger Entry";
    begin
        AppliedDate := 0D;
        DetailedCustLedgEntryOriginal.SetCurrentKey("Cust. Ledger Entry No.");
        DetailedCustLedgEntryOriginal.SetRange("Cust. Ledger Entry No.", CustLedgerEntryOriginal."Entry No.");
        DetailedCustLedgEntryOriginal.SetRange(Unapplied, false);
        if DetailedCustLedgEntryOriginal.FindSet() then
            repeat
                if DetailedCustLedgEntryOriginal."Cust. Ledger Entry No." =
                   DetailedCustLedgEntryOriginal."Applied Cust. Ledger Entry No."
                then begin
                    DetailedCustLedgEntryApplied.Init();
                    DetailedCustLedgEntryApplied.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                    DetailedCustLedgEntryApplied.SetRange("Applied Cust. Ledger Entry No.", DetailedCustLedgEntryOriginal."Applied Cust. Ledger Entry No.");
                    DetailedCustLedgEntryApplied.SetRange("Entry Type", DetailedCustLedgEntryApplied."Entry Type"::Application);
                    DetailedCustLedgEntryApplied.SetRange(Unapplied, false);
                    if DetailedCustLedgEntryApplied.FindSet() then
                        repeat
                            if DetailedCustLedgEntryApplied."Cust. Ledger Entry No." <> DetailedCustLedgEntryApplied."Applied Cust. Ledger Entry No." then
                                if CustLedgEntryApplied.Get(DetailedCustLedgEntryApplied."Cust. Ledger Entry No.") and
                                   (DetailedCustLedgEntryApplied."Posting Date" < gEndingDate)
                                then begin
                                    AddAppliedDocNo(DocNo, CustLedgEntryApplied."Document No.");
                                    GetCustAppliedDate(CustLedgEntryApplied, AppliedDate);
                                end;
                        until DetailedCustLedgEntryApplied.Next() = 0;
                end
                else
                    if CustLedgEntryApplied.Get(DetailedCustLedgEntryOriginal."Applied Cust. Ledger Entry No.") then
                        if CustLedgEntryApplied."Posting Date" < gEndingDate then begin
                            AddAppliedDocNo(DocNo, CustLedgEntryApplied."Document No.");
                            GetCustAppliedDate(CustLedgEntryApplied, AppliedDate);
                        end;
            until DetailedCustLedgEntryOriginal.Next() = 0;
    end;

    local procedure GetAppliedVendorLedgEntry(VendorLedgerEntryOriginal: Record "Vendor Ledger Entry"; var DocNo: Text; var AppliedDate: Date)
    var
        DetailedVendorLedgEntryOriginal: Record "Detailed Vendor Ledg. Entry";
        DetailedVendorLedgEntryApplied: Record "Detailed Vendor Ledg. Entry";
        VendorLedgEntryApplied: Record "Vendor Ledger Entry";
    begin
        AppliedDate := 0D;
        DetailedVendorLedgEntryOriginal.SetCurrentKey("Vendor Ledger Entry No.");
        DetailedVendorLedgEntryOriginal.SetRange("Vendor Ledger Entry No.", VendorLedgerEntryOriginal."Entry No.");
        DetailedVendorLedgEntryOriginal.SetRange(Unapplied, false);
        if DetailedVendorLedgEntryOriginal.FindSet() then
            repeat
                if DetailedVendorLedgEntryOriginal."Vendor Ledger Entry No." =
                   DetailedVendorLedgEntryOriginal."Applied Vend. Ledger Entry No."
                then begin
                    DetailedVendorLedgEntryApplied.Init();
                    DetailedVendorLedgEntryApplied.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    DetailedVendorLedgEntryApplied.SetRange(
                      "Applied Vend. Ledger Entry No.", DetailedVendorLedgEntryOriginal."Applied Vend. Ledger Entry No.");
                    DetailedVendorLedgEntryApplied.SetRange("Entry Type", DetailedVendorLedgEntryApplied."Entry Type"::Application);
                    DetailedVendorLedgEntryApplied.SetRange(Unapplied, false);
                    if DetailedVendorLedgEntryApplied.FindSet() then
                        repeat
                            if DetailedVendorLedgEntryApplied."Vendor Ledger Entry No." <> DetailedVendorLedgEntryApplied."Applied Vend. Ledger Entry No." then
                                if VendorLedgEntryApplied.Get(DetailedVendorLedgEntryApplied."Vendor Ledger Entry No.") and
                                   (DetailedVendorLedgEntryApplied."Posting Date" < gEndingDate)
                                then begin
                                    AddAppliedDocNo(DocNo, VendorLedgEntryApplied."Document No.");
                                    GetVendorAppliedDate(VendorLedgEntryApplied, AppliedDate);
                                end;
                        until DetailedVendorLedgEntryApplied.Next() = 0;
                end
                else
                    if VendorLedgEntryApplied.Get(DetailedVendorLedgEntryOriginal."Applied Vend. Ledger Entry No.") then
                        if VendorLedgEntryApplied."Posting Date" < gEndingDate then begin
                            AddAppliedDocNo(DocNo, VendorLedgEntryApplied."Document No.");
                            GetVendorAppliedDate(VendorLedgEntryApplied, AppliedDate);
                        end;
            until DetailedVendorLedgEntryOriginal.Next() = 0;
    end;

    local procedure GetBankLedgerEntryData(BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GLAccountNo: Code[20]; var PartyNo: Code[20]; var PartyName: Text[100]; var Amount: Text[250]; var CurrencyCode: Code[10]; DocNoApplied: Text; DateApplied: Date)
    begin
        if GetBankPostingGLAccount(BankAccountLedgerEntry."Bank Acc. Posting Group") = GLAccountNo then
            GetBankAccountData(BankAccountLedgerEntry."Bank Account No.", PartyNo, PartyName);

        if BankAccountLedgerEntry."Currency Code" <> '' then begin
            Amount := FormatAmount(Abs(BankAccountLedgerEntry.Amount));
            CurrencyCode := BankAccountLedgerEntry."Currency Code";
        end;
        GetAppliedBankLedgEntry(BankAccountLedgerEntry, DocNoApplied, DateApplied);
    end;

    local procedure GetBankAccountData(BankAccountNo: Code[20]; var PartyNo: Code[20]; var PartyName: Text[100])
    var
        BankAccount: Record "Bank Account";
    begin
        if BankAccount.Get(BankAccountNo) then begin
            PartyNo := BankAccount."No.";
            PartyName := BankAccount.Name;
        end;
    end;

    local procedure AddAppliedDocNo(var AppliedDocNo: Text; DocNo: Code[20])
    begin
        if StrPos(';' + AppliedDocNo, ';' + DocNo + ';') = 0 then
            AppliedDocNo += DocNo + ';';
    end;

    local procedure GetCustAppliedDate(CustLedgEntryApplied: Record "Cust. Ledger Entry"; var AppliedDate: Date)
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        if GetDetailedCustLedgEntry(DetailedCustLedgEntry, CustLedgEntryApplied."Entry No.") then begin
            if DetailedCustLedgEntry."Posting Date" > AppliedDate then
                AppliedDate := DetailedCustLedgEntry."Posting Date";
        end else
            AppliedDate := CustLedgEntryApplied."Posting Date";
    end;

    local procedure GetCustomerData(CustomerNo: Code[20]; var PartyNo: Code[20]; var PartyName: Text[100])
    var
        Customer: Record Customer;
    begin
        if Customer.Get(CustomerNo) then begin
            PartyNo := Customer."No.";
            PartyName := Customer.Name;
        end;
    end;

    local procedure GetDetailedCustLedgEntry(var DetailedCustLedgEntryApplied: Record "Detailed Cust. Ledg. Entry"; AppliedCustLedgerEntryNo: Integer): Boolean
    begin
        DetailedCustLedgEntryApplied.SetRange("Applied Cust. Ledger Entry No.", AppliedCustLedgerEntryNo);
        DetailedCustLedgEntryApplied.SetRange("Entry Type", DetailedCustLedgEntryApplied."Entry Type"::Application);
        DetailedCustLedgEntryApplied.SetRange(Unapplied, false);
        exit(DetailedCustLedgEntryApplied.FindFirst());
    end;

    local procedure GetDetailedVendorLedgEntry(var DetailedVendorLedgEntryApplied: Record "Detailed Vendor Ledg. Entry"; AppliedVendorLedgerEntryNo: Integer): Boolean
    begin
        DetailedVendorLedgEntryApplied.SetRange("Applied Vend. Ledger Entry No.", AppliedVendorLedgerEntryNo);
        DetailedVendorLedgEntryApplied.SetRange("Entry Type", DetailedVendorLedgEntryApplied."Entry Type"::Application);
        DetailedVendorLedgEntryApplied.SetRange(Unapplied, false);
        exit(DetailedVendorLedgEntryApplied.FindFirst());
    end;

    local procedure GetVendorAppliedDate(VendorLedgEntryApplied: Record "Vendor Ledger Entry"; var AppliedDate: Date)
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        if GetDetailedVendorLedgEntry(DetailedVendorLedgEntry, VendorLedgEntryApplied."Entry No.") then begin
            if DetailedVendorLedgEntry."Posting Date" > AppliedDate then
                AppliedDate := DetailedVendorLedgEntry."Posting Date";
        end else
            AppliedDate := VendorLedgEntryApplied."Posting Date";
    end;

    local procedure GetFileName(): Text[250]
    var
        CompanyInformation: Record "Company Information";
        FileName: Text[250];
    begin
        CompanyInformation.Get();
        CompanyInformation.TestField("Registration No.");
        FileName := Format(CompanyInformation.GetSIREN()) +
          'FEC' +
          GetFormattedDate(gEndingDate) +
          '.txt';
        exit(DelChr(FileName, '=', InvalidWindowsChrStringTxt));
    end;

    local procedure GetFormattedDate(GLEntryDate: Date): Text[8]
    begin
        if GLEntryDate <> 0D then
            exit(Format(GLEntryDate, 8, '<Year4><Month,2><Day,2>'));
        exit('')
    end;

    local procedure GetOpeningBalance(): Decimal
    begin
#pragma warning disable AA0217
        GLAccount.SetFilter("Date Filter", StrSubstNo('..%1', ClosingDate(CalcDate('<-1D>', gStartingDate))));
#pragma warning restore AA0217
        GLAccount.CalcFields("Balance at Date");
        exit(GLAccount."Balance at Date")
    end;

    local procedure GetCustomerPostingGroup(CustomerNo: Code[20]): Code[20]
    var
        Customer: Record Customer;
    begin
        Customer.Get(CustomerNo);
        exit(Customer."Customer Posting Group");
    end;

    local procedure GetVendorPostingGroup(VendorNo: Code[20]): Code[20]
    begin
        Vendor.Get(VendorNo);
        exit(Vendor."Vendor Posting Group");
    end;

    local procedure GetPayablesAccount(VendorPostingGroupCode: Code[20]): Code[20]
    var
        VendorPostingGroup: Record "Vendor Posting Group";
    begin
        VendorPostingGroup.Get(VendorPostingGroupCode);
        exit(VendorPostingGroup."Payables Account")
    end;

    local procedure GetReceivablesAccount(CustomerPostingGroupCode: Code[20]): Code[20]
    var
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        CustomerPostingGroup.Get(CustomerPostingGroupCode);
        exit(CustomerPostingGroup."Receivables Account")
    end;

    local procedure GetBankPostingGLAccount(BankAccPostingGroup: Code[20]): Code[20]
    var
        BankAccountPostingGroup: Record "Bank Account Posting Group";
    begin
        BankAccountPostingGroup.Get(BankAccPostingGroup);
        exit(BankAccountPostingGroup."G/L Account No.")
    end;

    local procedure GetSourceCodeDesc("Code": Code[10]): Text[100]
    var
        SourceCode: Record "Source Code";
    begin
        if SourceCode.Get(Code) then
            exit(SourceCode.Description);
    end;

    local procedure GetVendorData(VendorNo: Code[20]; var PartyNo: Code[20]; var PartyName: Text[100])
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(VendorNo) then begin
            PartyNo := Vendor."No.";
            PartyName := Vendor.Name;
        end;
    end;


    procedure GetLedgerEntryDataForCustVend(TransactionNo: Integer; SourceType: Option; var PartyNo: Code[20]; var PartyName: Text[100]; var FCYAmount: Text[250]; var CurrencyCode: Code[10]; var DocNoSet: Text; var DateApplied: Date)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        GLEntry: Record "G/L Entry";
        CountOfGLEntriesInTransaction: Integer;
        LedgerAmount: Decimal;
    begin
        DocNoSet := '';
        DateApplied := 0D;
        case SourceType of
            GLEntry."Source Type"::Customer.AsInteger():
                begin
                    CustLedgerEntry.SetRange("Transaction No.", TransactionNo);
                    if CustLedgerEntry.FindFirst() then begin
                        CustLedgerEntry.SetFilter("Customer No.", '<>%1', CustLedgerEntry."Customer No.");
                        if CustLedgerEntry.FindFirst() then begin
                            PartyName := 'multi-clients';
                            PartyNo := '*';
                            FCYAmount := '';
                            exit;
                        end;

                        CustLedgerEntry.SetRange("Customer No.");
                        GetCustomerData(CustLedgerEntry."Customer No.", PartyNo, PartyName);
                        PayRecAccount := GetReceivablesAccount(CustLedgerEntry."Customer Posting Group");
                        CountOfGLEntriesInTransaction := GetTransPayRecEntriesCount(CustLedgerEntry."Transaction No.", PayRecAccount);
                        if CustLedgerEntry.FindSet() then
                            repeat
                                GetAppliedCustLedgEntry(CustLedgerEntry, DocNoSet, DateApplied);
                                if (CustLedgerEntry."Currency Code" <> '') and (CountOfGLEntriesInTransaction = 1) then begin
                                    CustLedgerEntry.CalcFields("Original Amount");
                                    LedgerAmount += CustLedgerEntry."Original Amount";
                                    CurrencyCode := CustLedgerEntry."Currency Code";
                                    FCYAmount := FormatAmount(Abs(LedgerAmount));
                                end;
                            until CustLedgerEntry.Next() = 0;
                        DocNoSet := DelChr(DocNoSet, '>', ';');
                    end;
                end;
            GLEntry."Source Type"::Vendor.AsInteger():
                begin
                    VendorLedgerEntry.SetRange("Transaction No.", TransactionNo);
                    if VendorLedgerEntry.FindFirst() then begin
                        VendorLedgerEntry.SetFilter("Vendor No.", '<>%1', VendorLedgerEntry."Vendor No.");
                        if VendorLedgerEntry.FindFirst() then begin
                            PartyName := 'multi-fournisseurs';
                            PartyNo := '*';
                            FCYAmount := '';
                            exit;
                        end;

                        VendorLedgerEntry.SetRange("Vendor No.");
                        GetVendorData(VendorLedgerEntry."Vendor No.", PartyNo, PartyName);
                        PayRecAccount := GetPayablesAccount(VendorLedgerEntry."Vendor Posting Group");
                        CountOfGLEntriesInTransaction := GetTransPayRecEntriesCount(VendorLedgerEntry."Transaction No.", PayRecAccount);
                        if VendorLedgerEntry.FindSet() then
                            repeat
                                GetAppliedVendorLedgEntry(VendorLedgerEntry, DocNoSet, DateApplied);
                                if (VendorLedgerEntry."Currency Code" <> '') and (CountOfGLEntriesInTransaction = 1) then begin
                                    VendorLedgerEntry.CalcFields("Original Amount");
                                    LedgerAmount += VendorLedgerEntry."Original Amount";
                                    CurrencyCode := VendorLedgerEntry."Currency Code";
                                    FCYAmount := FormatAmount(Abs(LedgerAmount));
                                end;
                            until VendorLedgerEntry.Next() = 0;
                        DocNoSet := DelChr(DocNoSet, '>', ';');
                    end;
                end;
        end;
    end;

    local procedure GetTransPayRecEntriesCount(TransactionNo: Integer; pPayRecAccount: Code[20]): Integer
    var
        GLEntryCount: Integer;
        gGLAccNoFilter: Code[250];
    begin
        gGLAccNoFilter := CopyStr(GLEntry.GetFilter("G/L Account No."), 1, MaxStrLen(gGLAccNoFilter));
        GLEntry.SetRange("G/L Account No.", pPayRecAccount);
        GLEntry.SetRange("Transaction No.", TransactionNo);
        GLEntryCount := GLEntry.Count();
        GLEntry.SetRange("Transaction No.");
        GLEntry.SetFilter("G/L Account No.", gGLAccNoFilter);
        exit(GLEntryCount)
    end;

    local procedure GetCustomerUnrealizedAmount(GLAccountNo: Code[20]; CustomerNo: Code[20]): Decimal
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DetailedCustLedgEntry.SetRange("Customer No.", CustomerNo);
        DetailedCustLedgEntry.SetFilter("Entry Type", '%1|%2', DetailedCustLedgEntry."Entry Type"::"Unrealized Gain", DetailedCustLedgEntry."Entry Type"::"Unrealized Loss");
        DetailedCustLedgEntry.SetFilter("Posting Date", '..%1', gStartingDate - 1);
        DetailedCustLedgEntry.SetRange(Unapplied, false);
        DetailedCustLedgEntry.SetRange("Curr. Adjmt. G/L Account No.", GLAccountNo);
        DetailedCustLedgEntry.CalcSums("Amount (LCY)");
        exit(DetailedCustLedgEntry."Amount (LCY)");
    end;

    local procedure GetVendorUnrealizedAmount(GLAccountNo: Code[20]; VendorNo: Code[20]): Decimal
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DetailedVendorLedgEntry.SetRange("Vendor No.", VendorNo);
        DetailedVendorLedgEntry.SetFilter("Entry Type", '%1|%2', DetailedVendorLedgEntry."Entry Type"::"Unrealized Gain", DetailedVendorLedgEntry."Entry Type"::"Unrealized Loss");
        DetailedVendorLedgEntry.SetFilter("Posting Date", '..%1', gStartingDate - 1);
        DetailedVendorLedgEntry.SetRange(Unapplied, false);
        DetailedVendorLedgEntry.SetRange("Curr. Adjmt. G/L Account No.", GLAccountNo);
        DetailedVendorLedgEntry.CalcSums("Amount (LCY)");
        exit(DetailedVendorLedgEntry."Amount (LCY)");
    end;

    local procedure ProcessGLEntry()
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        GLRegister: Record "G/L Register";
        PartyNo: Code[20];
        PartyName: Text[100];
        FCYAmount: Text[250];
        CurrencyCode: Code[10];
        DocNoApplied: Text;
        DateApplied: Date;
    begin
        PartyNo := '';
        PartyName := '';
        if (GLEntry."Transaction No." <> CurrentTransactionNo) or (GLEntry."Source Type" <> CurrentSourceType) then begin
            ResetTransactionData();
            GetLedgerEntryDataForCustVend(
              GLEntry."Transaction No.", GLEntry."Source Type".AsInteger(),
              CustVendLedgEntryPartyNo,
              CustVendLedgEntryPartyName,
              CustVendLedgEntryFCYAmount,
              CustVendLedgEntryCurrencyCode,
              CustVendDocNoSet,
              CustVendDateApplied);

            CurrentTransactionNo := GLEntry."Transaction No.";
            CurrentSourceType := GLEntry."Source Type";
        end;

        if BankAccountLedgerEntry.Get(GLEntry."Entry No.") then
            GetBankLedgerEntryData(
#pragma warning disable AA0205
              BankAccountLedgerEntry, GLEntry."G/L Account No.", PartyNo, PartyName, FCYAmount, CurrencyCode, DocNoApplied, DateApplied);
#pragma warning restore AA0205

        if GLEntry."G/L Account No." = PayRecAccount then begin
            PartyNo := CustVendLedgEntryPartyNo;
            PartyName := CustVendLedgEntryPartyName;
            FCYAmount := CustVendLedgEntryFCYAmount;
            CurrencyCode := CustVendLedgEntryCurrencyCode;
            DocNoApplied := CustVendDocNoSet;
            DateApplied := CustVendDateApplied;
        end;
        if CustVendLedgEntryPartyNo = '*' then
            case GLEntry."Source Type" of
                GLEntry."Source Type"::Customer:
                    if GetReceivablesAccount(GetCustomerPostingGroup(GLEntry."Source No.")) = GLEntry."G/L Account No." then
                        GetCustomerData(GLEntry."Source No.", PartyNo, PartyName);
                GLEntry."Source Type"::Vendor:
                    if GetPayablesAccount(GetVendorPostingGroup(GLEntry."Source No.")) = GLEntry."G/L Account No." then
                        GetVendorData(GLEntry."Source No.", PartyNo, PartyName);
            end;

        FindGLRegister(GLRegister, GLEntry."Entry No.");

        WriteGLEntryToFile(
          GLRegister."No.",
          GLRegister."Creation Date",
          PartyNo,
          PartyName,
          FCYAmount,
          CurrencyCode,
          DocNoApplied,
          DateApplied);
    end;

    local procedure ResetTransactionData()
    begin
        CustVendLedgEntryPartyNo := '';
        CustVendLedgEntryPartyName := '';
        CustVendLedgEntryFCYAmount := '';
        CustVendLedgEntryCurrencyCode := '';
        PayRecAccount := '';
    end;

    local procedure WriteHeaderToFile()
    begin
        Writer.WriteLine('JournalCode|JournalLib|EcritureNum|EcritureDate|CompteNum|CompteLib|CompAuxNum|CompAuxLib|PieceRef|' +
          'PieceDate|EcritureLib|Debit|Credit|EcritureLet|DateLet|ValidDate|Montantdevise|Idevise');
    end;

    local procedure WriteGLAccountToFile(GLAccount: Record "G/L Account"; pOpeningBalance: Decimal)
    var
        CreditAmount: Decimal;
        DebitAmount: Decimal;
    begin
        if pOpeningBalance > 0 then
            DebitAmount := pOpeningBalance
        else
            CreditAmount := Abs(pOpeningBalance);

        Writer.WriteLine('00000|' +
          'BALANCE OUVERTURE|' +
          '0|' +
          GetFormattedDate(gStartingDate) + '|' +
          GLAccount."No." + '|' +
          GLAccount.Name + '|' +
          '||' +
          '00000|' +
          GetFormattedDate(gStartingDate) + '|' +
          'BAL OUV ' + GLAccount.Name + '|' +
          FormatAmount(DebitAmount) + '|' +
          FormatAmount(CreditAmount) + '|' +
          '||' +
          GetFormattedDate(gStartingDate) +
          '||');
    end;

    local procedure WriteGLEntryToFile(GLRegisterNo: Integer; GLRegisterCreationDate: Date; PartyNo: Code[20]; PartyName: Text[100]; FCYAmount: Text[250]; CurrencyCode: Code[10]; DocNoSet: Text; DateApplied: Date)
    begin
        GLEntry.CalcFields("G/L Account Name");
        Writer.WriteLine(
          GLEntry."Source Code" + '|' +
          GetSourceCodeDesc(GLEntry."Source Code") + '|' +
          Format(GLRegisterNo) + '|' +
          GetFormattedDate(GLEntry."Posting Date") + '|' +
          GLEntry."G/L Account No." + '|' +
          GLEntry."G/L Account Name" + '|' +
          Format(PartyNo) + '|' +
          PartyName + '|' +
          GLEntry."Document No." + '|' +
          GetFormattedDate(GLEntry."Document Date") + '|' +
          GLEntry.Description + '|' +
          FormatAmount(GLEntry."Debit Amount") + '|' +
          FormatAmount(GLEntry."Credit Amount") + '|' +
          DocNoSet + '|' +
          GetFormattedDate(DateApplied) + '|' +
          GetFormattedDate(GLRegisterCreationDate) + '|' +
          FCYAmount + '|' +
          CurrencyCode);
    end;

    local procedure WriteDetailedGLAccountBySource(GLAccountNo: Code[20]; SourceType: Enum "Gen. Journal Source Type"; SourceNo: Code[20]) TotalAmt: Decimal
    var
        GLEntry: Record "G/L Entry";
        PartyNo: Code[20];
        PartyName: Text[100];
        DebitAmt: Decimal;
        CreditAmt: Decimal;
        UnrealizedAmt: Decimal;
    begin
        GLEntry.SetFilter("Posting Date", '..%1', gStartingDate - 1);
        GLEntry.SetFilter("G/L Account No.", GLAccountNo);
        GLEntry.SetRange("Source Type", SourceType);
        GLEntry.SetRange("Source No.", SourceNo);
        case SourceType of
            GLEntry."Source Type"::Customer:
                GLEntry.SetFilter("Bal. Account Type", '<>%1', GLEntry."Bal. Account Type"::Customer);
            GLEntry."Source Type"::Vendor:
                GLEntry.SetFilter("Bal. Account Type", '<>%1', GLEntry."Bal. Account Type"::Vendor);
            GLEntry."Source Type"::"Bank Account":
                GLEntry.SetFilter("Bal. Account Type", '<>%1', GLEntry."Bal. Account Type"::"Bank Account");
        end;
        GLEntry.CalcSums(Amount);

        case SourceType of
            GLEntry."Source Type"::Customer:
                UnrealizedAmt := GetCustomerUnrealizedAmount(GLAccountNo, SourceNo);
            GLEntry."Source Type"::Vendor:
                UnrealizedAmt := GetVendorUnrealizedAmount(GLAccountNo, SourceNo);
        end;

        TotalAmt := GLEntry.Amount + UnrealizedAmt;
        if TotalAmt = 0 then
            exit;

        if TotalAmt > 0 then
            DebitAmt := TotalAmt
        else
            CreditAmt := -TotalAmt;

        case SourceType of
            GLEntry."Source Type"::Customer:
                GetCustomerData(SourceNo, PartyNo, PartyName);
            GLEntry."Source Type"::Vendor:
                GetVendorData(SourceNo, PartyNo, PartyName);
            GLEntry."Source Type"::"Bank Account":
                GetBankAccountData(SourceNo, PartyNo, PartyName);
        end;

        Writer.WriteLine('00000|' +
          'BALANCE OUVERTURE|' +
          '0|' +
          GetFormattedDate(gStartingDate) + '|' +
          GLAccount."No." + '|' +
          GLAccount.Name + '|' +
          PartyNo + '|' +
          PartyName + '|' +
          '00000|' +
          GetFormattedDate(gStartingDate) + '|' +
          'BAL OUV ' + PartyName + '|' +
          FormatAmount(DebitAmt) + '|' +
          FormatAmount(CreditAmt) + '|' +
          '||' +
          GetFormattedDate(gStartingDate) +
          '||');
    end;
}