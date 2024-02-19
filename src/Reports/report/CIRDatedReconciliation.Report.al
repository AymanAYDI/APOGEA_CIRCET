report 50019 "CIR Dated Reconciliation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRDatedReconciliation.rdl';
    Caption = 'Dated Reconciliation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rapprochement daté"}]}';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", Blocked, "Date Filter";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID; USERID)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(Bank_Account_Name; Name)
            {
            }
            column(Bank_Account__No__; "No.")
            {
            }
            column(Bank_Account_Last_Statement_No; "Bank Account"."Last Statement No.")
            {
            }
            column(STRSUBSTNO_Text8001600_FORMAT_DateMax_0___Day___Month_Text___Year4____; STRSUBSTNO(ReportOfReconciliationP1_Lbl, FORMAT(MaxDate, 0, '<Day> <Month Text> <Year4>')))
            {
            }
            column(CurrReport_OBJECTID_FALSE_; CurrReport.OBJECTID(FALSE))
            {
            }
            column(STRSUBSTNO__Text8001601__1___DateMax_; STRSUBSTNO(ThisReportIsTheReconciliationOfTheP1_Lbl, MaxDate))
            {
            }
            column(AvecEncours; WithOutstanding)
            {
            }
            column(STRSUBSTNO__Text8001602__DateMax_; STRSUBSTNO(ReportIsReconciliationOfP1CurrentReconciliations_Lbl, MaxDate))
            {
            }
            column(FORMAT_TODAY_0_4__Control50; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID_Control60; USERID)
            {
            }
            column(COMPANYNAME_Control76; COMPANYNAME)
            {
            }
            column(STRSUBSTNO_Text8001600_FORMAT_DateMax_0___Day___Month_Text___Year4_____Control12; STRSUBSTNO(ReportOfReconciliationP1_Lbl, FORMAT(MaxDate, 0, '<Day> <Month Text> <Year4>')))
            {
            }
            column(TABLENAME__________BqueFiltre; TABLENAME + ': ' + BankFilter)
            {
            }
            column(BqueFiltre; BankFilter)
            {
            }
            column(STRSUBSTNO_Text8001601_DateMax_; STRSUBSTNO(ThisReportIsTheReconciliationOfTheP1_Lbl, MaxDate))
            {
            }
            column(STRSUBSTNO_Text8001602_DateMax_; STRSUBSTNO(ReportIsReconciliationOfP1CurrentReconciliations_Lbl, MaxDate))
            {
            }
            column(BAR__Bank_Account__Net_Operation; "CIR Bank Account"."Net Operation")
            {
            }
            column(Bank_Account__No___Control22; "No.")
            {
            }
            column(Bank_Account_Name_Control23; Name)
            {
            }
            column(Bank_Account__Currency_Code_; "Currency Code")
            {
            }
            column(MntRapproTotDeb___MntBqueTotdeb___AfficheDebitSolde___AfficheDebit; DebitBalancedAtDate + DebitValue + CreditTotalBalanceValue + MntRapproTotDeb)
            {
            }
            column(MntRapproTotCre___MntBqueTotcre___AffichecreditSolde___Affichecredit; ABS(CreditBalancedAtDate + CreditValue + DebitTotalBalanceValue + MntRapproTotCre))
            {
            }
            column(Text8001604___Bank_Account__Name; STRSUBSTNO(TotalReconciliationOfBankP1_Lbl, "Bank Account".Name))
            {
            }
            column(Text8001605___Bank_Account__Name; STRSUBSTNO(ReconciliationVarianceOfBankP1_Lbl, "Bank Account".Name))
            {
            }
            column(AfficheDebitEcart; DebitGapValue)
            {
            }
            column(AffichecreditEcart; CreditGapValue)
            {
            }
            column(Ecart; Gap)
            {
            }
            column(CurrReport_PAGENOCaption; PageCaption_Lbl)
            {
            }
            column(LigneReleve__Transaction_Date__Control29Caption; InDateCaption_Lbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Statement_No__Caption; ReconciliedStatementNoCaption_Lbl)
            {
            }
            column(Bank_Account_Ledger_Entry_DescriptionCaption; "Bank Account Ledger Entry".FIELDCAPTION(Description))
            {
            }
            column(Bank_Account_Ledger_Entry__Document_No__Caption; "Bank Account Ledger Entry".FIELDCAPTION("Document No."))
            {
            }
            column(Bank_Account_Ledger_Entry__Posting_Date_Caption; OperationDateCaption_Lbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Reason_Code_Caption; "Bank Account Ledger Entry".FIELDCAPTION("Reason Code"))
            {
            }
            column(Bank_Account_Ledger_Entry__External_Document_No__Caption; "Bank Account Ledger Entry".FIELDCAPTION("External Document No."))
            {
            }
            column(Bank_Account_Ledger_Entry__Due_Date_Caption; ValueDateCaption_Lbl)
            {
            }
            column(EcrDebitCaption; DebitAmountCaption_Lbl)
            {
            }
            column(EcrCreditCaption; CreditAmountCaption_Lbl)
            {
            }
            column(CurrReport_PAGENO_Control57Caption; PageCaption_Lbl)
            {
            }
            column(LigneReleve__Transaction_Date__Control29Caption_Control31; InDateCaption_Lbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Statement_No__Caption_Control28; ReconciliedStatementNoCaption_Lbl)
            {
            }
            column(Bank_Account_Ledger_Entry_DescriptionCaption_Control17; "Bank Account Ledger Entry".FIELDCAPTION(Description))
            {
            }
            column(Bank_Account_Ledger_Entry__Document_No__Caption_Control15; "Bank Account Ledger Entry".FIELDCAPTION("Document No."))
            {
            }
            column(Bank_Account_Ledger_Entry__Posting_Date_Caption_Control11; OperationDateCaption_Lbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Reason_Code_Caption_Control78; "Bank Account Ledger Entry".FIELDCAPTION("Reason Code"))
            {
            }
            column(Bank_Account_Ledger_Entry__External_Document_No__Caption_Control80; "Bank Account Ledger Entry".FIELDCAPTION("External Document No."))
            {
            }
            column(Bank_Account_Ledger_Entry__Due_Date_Caption_Control82; ValueDateCaption_Lbl)
            {
            }
            column(EcrDebitCaption_Control42; DebitAmountCaption_Lbl)
            {
            }
            column(EcrCreditCaption_Control44; CreditAmountCaption_Lbl)
            {
            }
            column(Account__Caption; AccountCaption_Lbl)
            {
            }
            column(Bank_Account__Currency_Code_Caption; FIELDCAPTION("Currency Code"))
            {
            }
            column(BankLedgerEntryTotalAmount; BankLedgerEntryTotalAmount)
            {
            }
            dataitem("CIR Bank Account"; "Bank Account")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING(IBAN, "Bank Account No.");

                column(Net_Operation; "Net Operation")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    BalancedAtDate := GetTotalBankAccountStatementLine("Bank Account"."No.", "Bank Account".GETFILTER("Date Filter"));
                    BalancedAtDate += GetTotalBankAccReconciliationLine("Bank Account"."No.", "Bank Account".GETFILTER("Date Filter"));

                    IF (BalancedAtDate > 0) THEN
                        DebitBalancedAtDate := BalancedAtDate
                    else
                        CreditBalancedAtDate := BalancedAtDate;

                    BankLedgerEntryTotalAmount := GetTotalBankLedgerEnty("Bank Account"."No.", "Bank Account".GETFILTER("Date Filter"));
                end;

                trigger OnPreDataItem()
                begin
                    DebitBalancedAtDate := 0;
                    CreditBalancedAtDate := 0;
                    BalancedAtDate := 0;
                    SETFILTER("Date Filter", "Bank Account".GETFILTER("Date Filter"));
                    SETFILTER("Global Dimension 1 Code", "Bank Account".GETFILTER("Global Dimension 1 Filter"));
                    SETFILTER("Global Dimension 2 Code", "Bank Account".GETFILTER("Global Dimension 2 Filter"));
                end;
            }
            dataitem("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
            {
                DataItemLink = "Bank Account No." = field("No.");
                DataItemTableView = SORTING("Statement Type", "Bank Account No.", "Statement No.");
                dataitem("Bank Acc. Reconciliation Line"; "Bank Acc. Reconciliation Line")
                {
                    DataItemLink = "Statement Type" = field("Statement Type"), "Bank Account No." = field("Bank Account No."), "Statement No." = field("Statement No.");
                    DataItemTableView = SORTING("Statement Type", "Bank Account No.", "Statement No.");
                    column(BankAccountNo_BankAccReconciliationLine; "Bank Account No.")
                    {
                    }
                    column(StatementNo_BankAccReconciliationLine; "Statement No.")
                    {
                    }
                    column(StatementLineNo_BankAccReconciliationLine; "Statement Line No.")
                    {
                    }
                    column(DocumentNo_BankAccReconciliationLine; "Document No.")
                    {
                    }
                    column(Description_BankAccReconciliationLine; Description)
                    {
                    }
                    column(TransactionDate_BankAccReconciliationLine; "Transaction Date")
                    {
                    }
                    column(StatementAmount_BankAccReconciliationLine; "Statement Amount")
                    {
                    }
                    column(AfficheDebitSolde; CreditBalanceValue)
                    {
                    }
                    column(AffichecreditSolde; DebitBalanceValue)
                    {
                    }
                    column(Total_Bank_Account_ReconciliationLineCaption; TotalBankEntriesNotReconciliedCaption_Lbl)
                    {
                    }
                    column(AfficheTotalDebitSolde; CreditTotalBalanceValue)
                    {
                    }
                    column(AfficheTotalCreditSolde; DebitTotalBalanceValue)
                    {
                    }
                    column(PrintTotal; PrintTotal)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        CreditBalanceValue := 0;
                        DebitBalanceValue := 0;
                        if "Bank Acc. Reconciliation Line"."Statement Amount" > 0 then begin
                            DebitBalanceValue := "Bank Acc. Reconciliation Line"."Statement Amount";
                            DebitTotalBalanceValue += DebitBalanceValue;
                        end else begin
                            CreditBalanceValue := -"Bank Acc. Reconciliation Line"."Statement Amount";
                            CreditTotalBalanceValue += CreditBalanceValue;
                        end;

                        j += 1;

                        IF (i = BankAccountReconcCount) Then
                            PrintTotal := (j = TotalCount);
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Transaction Date", '..%1', MaxDate);
                        TotalCount += COUNT;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    i += 1;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Statement Date", '..%1', MaxDate);
                    BankAccountReconcCount += COUNT;
                end;
            }
            dataitem("CIR Bank Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD("No.");
                DataItemTableView = SORTING("Bank Account No.", "Posting Date", "Reason Code", Amount);
                column(STRSUBSTNO_Text8001606_; NonReconciliedBankEntry_Lbl)
                {
                }
                column(DebitBalanceLastStatement_CIRBankAccount; DebitBalancedAtDate)
                {
                }
                column(CreditBalanceLastStatement_CIRBankAccount; CreditBalancedAtDate)
                {
                }
                column(Balance_CIRBankAccount; BalancedAtDate)
                {
                }
                column(BAR__Bank_Entry__Entry_No; "CIR Bank Entry"."Entry No.")
                {
                }
                column(LigneReleve__Transaction_Date_; BankAccountStatementLine."Transaction Date")
                {
                }
                column(TexteEnCours; OutstandingsText)
                {
                }
                column(BAR___Bank_Entry__Statement_No___Treatement__; "Statement No.")
                {
                }
                column(BAR___Bank_Entry_Description; Description)
                {
                }
                column(BAR___Bank_Entry__Value_Date_; "Value Date")
                {
                }
                column(BAR___Bank_Entry__Operation_Date_; "Posting Date")
                {
                }
                column(BAR___Bank_Entry__Document_No__; "Document No.")
                {
                }
                column(BAR___Bank_Entry__Reason_Code_; "Reason Code")
                {
                }
                column(Debit; Debit)
                {
                }
                column(Credit; Credit)
                {
                }
                column(Print1; Print)
                {
                }
                column(MntBqueTotdeb; BankTotalDebit)
                {
                }
                column(MntBqueTotcre; BankTotalCredit)
                {
                }
                column(Bank_Account___No__; "Bank Account"."No.")
                {
                }
                column(Bank_BalanceCaption; BankBalanceCaption_Lbl)
                {
                }
                column(Total_Bank_Entries_Not_ReconciliedCaption; TotalBankEntriesNotReconciliedCaption_Lbl)
                {
                }
                column(BAR___Bank_Entry_Bank_Account_No_; "Bank Account No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Debit := 0;
                    Credit := 0;
                    IF Amount < 0 THEN
                        Debit := -Amount
                    ELSE
                        Credit := Amount;

                    LineCounter += 1;
                    DialogWindow.UPDATE(3, 0);
                    DialogWindow.UPDATE(4, ROUND(LineCounter / RecordNumber * 10000, 1));
                    Print := TRUE;
                    OutstandingsText := '';
                    BankAccountStatementLine.INIT();

                    IF ("Posting Date" = CLOSINGDATE("Posting Date")) AND (NORMALDATE("Posting Date") < MaxDate) THEN BEGIN
                        BankAmount := BankAmount + Amount;
                        Print := FALSE;
                    END ELSE
                        IF "Statement No." = 'MANUEL' THEN BEGIN
                            BankAmount := BankAmount + Amount;
                            Print := FALSE;
                        END ELSE
                            IF "Statement Line No." <> 0 THEN
                                IF BankAccountStatement.GET("Bank Account No.", "Statement No.") THEN BEGIN
                                    IF BankAccountStatement."Statement Date" <= MaxDate THEN BEGIN
                                        IF BankAccountStatementLine.GET("Bank Account No.", "Statement No.", "Statement Line No.") THEN BEGIN
                                            BankAccountLedgerEntry.INIT();
                                            BankAccountLedgerEntry.SETCURRENTKEY("Bank Account No.", "Statement No.", "Statement Line No.");
                                            BankAccountLedgerEntry.SETRANGE("Bank Account No.", BankAccountStatementLine."Bank Account No.");
                                            BankAccountLedgerEntry.SETRANGE("Statement No.", BankAccountStatementLine."Statement No.");
                                            BankAccountLedgerEntry.SETRANGE("Statement Line No.", BankAccountStatementLine."Statement Line No.");
                                            BankAccountLedgerEntry.SETFILTER("Posting Date", '%1..', MaxDate + 1);
                                            IF NOT BankAccountLedgerEntry.FIND() THEN BEGIN
                                                BankAmount := BankAmount + Amount;
                                                Print := FALSE;
                                            END
                                            ELSE
                                                BankAccountStatementLine."Transaction Date" := BankAccountStatement."Statement Date";
                                        END
                                        ELSE
                                            OutstandingsText := 'en cours';
                                    END
                                    ELSE
                                        IF BankAccountStatementLine.GET("Bank Account No.", "Statement No.", "Statement Line No.") THEN
                                            BankAccountStatementLine."Transaction Date" := BankAccountStatement."Statement Date"
                                        ELSE
                                            OutstandingsText := 'en cours';
                                END
                                ELSE
                                    OutstandingsText := 'en cours';

                    IF (OutstandingsText = 'en cours') THEN
                        IF BankAccReconciliationLine.GET("Bank Acc. Reconciliation Line"."Statement Type", "Bank Acc. Reconciliation Line"."Bank Account No.", "Bank Acc. Reconciliation Line"."Statement No.", "Bank Acc. Reconciliation Line"."Statement Line No.") THEN
                            IF BankAccReconciliationLine.Difference <> 0 THEN BEGIN
                                OutstandingsText := '';
                                "Statement No." := '';
                            END;
                    IF WithOutstanding AND (OutstandingsText = 'en cours') THEN
                        Print := FALSE;

                    IF Print THEN BEGIN
                        BankTotalAmount += Amount;
                        IF Amount < 0 THEN
                            BankTotalDebit += -Amount
                        ELSE
                            BankTotalCredit += Amount;
                    END;
                end;

                trigger OnPostDataItem()
                begin
                    Gap := "CIR Bank Account"."Net Operation" - BankTotalAmount - "Bank Account"."Net Change" + MntRapproTot;
                    IF Gap > 0 THEN
                        DebitGapValue := Gap
                    ELSE
                        CreditGapValue := -Gap;
                end;

                trigger OnPreDataItem()
                begin
                    SETFILTER("Posting Date", DateFilter);

                    BankTotalAmount := 0;
                    BankTotalDebit := 0;
                    BankTotalCredit := 0;
                    BankAmount := 0;
                    RecordNumber := COUNT;
                    LineCounter := 0;
                end;
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD("No.");
                DataItemTableView = SORTING("Bank Account No.", "Posting Date");
                column(STRSUBSTNO_Text8001603_; NonReconciliedEntry_Lbl)
                {
                }
                column(AfficheDebit; DebitValue)
                {
                }
                column(Affichecredit; CreditValue)
                {
                }
                column(Bank_Account_Ledger_Entry__Entry_No; "Bank Account Ledger Entry"."Entry No.")
                {
                }
                column(Bank_Account_Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Bank_Account_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Description; Description)
                {
                }
                column(Bank_Account_Ledger_Entry__Statement_No__; "Statement No.")
                {
                }
                column(LigneReleve__Transaction_Date__Control29; BankAccountStatementLine."Transaction Date")
                {
                }
                column(Bank_Account_Ledger_Entry__Reason_Code_; "Reason Code")
                {
                }
                column(Bank_Account_Ledger_Entry__External_Document_No__; "External Document No.")
                {
                }
                column(Bank_Account_Ledger_Entry__Due_Date_; '')
                {
                }
                column(TexteEnCours_Control83; OutstandingsText)
                {
                }
                column(EcrDebit; DebitLedgerEntry)
                {
                }
                column(EcrCredit; CreditLedgerEntry)
                {
                }
                column(Print2; Print)
                {
                }
                column(MntRapproTotDeb; MntRapproTotDeb)
                {
                }
                column(MntRapproTotCre; MntRapproTotCre)
                {
                }
                column(Bank_Account___No___Control51; "Bank Account"."No.")
                {
                }
                column(Account_BalanceCaption; AccountBalanceCaption_Lbl + ' ')
                {
                }
                column(Total_Account_Entries_Not_ReconciliedCaption; TotalAccountEntriesNotReconciliedCaption_Lbl)
                {
                }
                column(Bank_Account_Ledger_Entry_Bank_Account_No_; "Bank Account No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Open; "Open")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    LineCounter += 1;
                    DialogWindow.UPDATE(3, ROUND(LineCounter / RecordNumber * 10000, 1));
                    Print := TRUE;
                    OutstandingsText := '';
                    BankAccountStatementLine.INIT();

                    IF Amount > 0 THEN begin
                        DebitLedgerEntry := Amount;
                        CreditLedgerEntry := 0;
                    end ELSE begin
                        CreditLedgerEntry := -Amount;
                        DebitLedgerEntry := 0;
                    end;

                    IF NOT Open AND ("Statement No." = '') THEN
                        CurrReport.SKIP();
                    IF "Statement No." <> '' THEN
                        IF BankAccountStatement.GET("Bank Account No.", "Statement No.") THEN BEGIN
                            IF BankAccountStatement."Statement Date" <= MaxDate THEN BEGIN
                                IF BankAccountStatementLine.GET("Bank Account No.", "Statement No.", "Statement Line No.") THEN BEGIN
                                    BankAccountStatementLine."Transaction Date" := BankAccountStatement."Statement Date";
                                    IF BankAccountStatementLine."Transaction Date" <= MaxDate THEN BEGIN
                                        ReconciliationAmout := ReconciliationAmout + Amount;
                                        Print := FALSE;
                                    END;
                                END ELSE
                                    OutstandingsText := 'en cours';
                            END ELSE
                                IF BankAccountStatementLine.GET("Bank Account No.", "Statement No.", "Statement Line No.") THEN
                                    BankAccountStatementLine."Transaction Date" := BankAccountStatement."Statement Date"
                                ELSE
                                    OutstandingsText := 'en cours';
                        END
                        ELSE
                            OutstandingsText := 'en cours';

                    IF OutstandingsText = 'en cours' THEN
                        IF BankAccReconciliationLine.GET("Bank Acc. Reconciliation Line"."Statement Type", "Bank Acc. Reconciliation Line"."Bank Account No.", "Bank Acc. Reconciliation Line"."Statement No.", "Bank Acc. Reconciliation Line"."Statement Line No.") THEN
                            IF BankAccReconciliationLine.Difference <> 0 THEN BEGIN
                                OutstandingsText := '';
                                "Statement No." := '';
                            END;
                    IF WithOutstanding AND (OutstandingsText = 'en cours') THEN
                        Print := FALSE;
                    IF Print THEN BEGIN
                        MntRapproTot += Amount;
                        IF Amount > 0 THEN
                            MntRapproTotDeb += Amount
                        ELSE
                            MntRapproTotCre -= Amount;
                    END;
                end;

                trigger OnPostDataItem()
                begin
                    Gap := "CIR Bank Account"."Net Operation" - BankTotalAmount - "Bank Account"."Net Change" + MntRapproTot;
                    IF Gap > 0 THEN
                        DebitGapValue := Gap
                    ELSE
                        CreditGapValue := -Gap;
                end;

                trigger OnPreDataItem()
                begin
                    SETFILTER("Posting Date", DateFilter);
                    SETFILTER("Global Dimension 2 Code", "Bank Account".GETFILTER("Global Dimension 2 Filter"));
                    SETFILTER("Global Dimension 1 Code", "Bank Account".GETFILTER("Global Dimension 1 Filter"));
                    ReconciliationAmout := 0;
                    MntRapproTot := 0;
                    MntRapproTotDeb := 0;
                    MntRapproTotCre := 0;
                    DebitLedgerEntry := 0;
                    CreditLedgerEntry := 0;
                    RecordNumber := COUNT;
                    LineCounter := 0;
                    DebitValue := 0;
                    CreditValue := 0;
                    DebitGapValue := 0;
                    CreditGapValue := 0;

                    IF "Bank Account"."Net Change" < 0 THEN
                        DebitValue := -"Bank Account"."Net Change"
                    ELSE
                        CreditValue := "Bank Account"."Net Change";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ReconciliationAmout := 0;
                BankAmount := 0;
                MntRapproTot := 0;
                BankTotalAmount := 0;
                BankTotalDebit := 0;
                BankTotalCredit := 0;
                PrintTotal := false;
                CreditValue := 0;
                DebitValue := 0;
                CreditBalanceValue := 0;
                CreditTotalBalanceValue := 0;
                DebitTotalBalanceValue := 0;
                CreditGapValue := 0;
                SETRANGE("Date Filter", 0D, MaxDate);
                CALCFIELDS("Net Change (LCY)", "Net Change");
                DialogWindow.UPDATE(1, "No.");
                DialogWindow.UPDATE(2, Name);
                IF "Currency Code" = '' THEN
                    "Currency Code" := GeneralLedgerSetup."LCY Code";
                DebitGapValue := 0;
                CreditGapValue := 0;
                Gap := "CIR Bank Account"."Net Operation" - BankTotalAmount - "Bank Account"."Net Change" + MntRapproTot;
                IF Gap > 0 THEN
                    DebitGapValue := Gap
                ELSE
                    CreditGapValue := -Gap;
            end;
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
                    field(WithOutstanding; WithOutstanding)
                    {
                        Caption = 'Exclude Current Entries From Reconciliation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Exclure écritures en cours de rapprochement"}]}';
                        ApplicationArea = All;
                        ToolTip = 'Exclude Current Entries From Reconciliation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Exclure écritures en cours de rapprochement"}]}';
                        Visible = false;
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        DialogWindow.CLOSE();
    end;

    trigger OnPreReport()
    var
        DatedBankReconciliation_Lbl: Label 'Dated bank reconciliation\', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rapprochement bancaire daté\\"}]}';
        BankAccount12_Lbl: Label ' #1#### #2################\', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":" #1#### #2################\\"}]}';
        ReconciliationBankEntries_Lbl: Label 'Reconciliation: bank entries @4@@@@@@@@@@@@@\', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rappro : écritures banque @4@@@@@@@@@@@@@\\"}]}';
        BankAccountLedgerEntry_Lbl: Label '  @3@@@@@@@@@@@@@', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"  @3@@@@@@@@@@@@@"}]}';
        DialogWindow_Txt: Text;
    begin
        BankFilter := "Bank Account".GETFILTERS;
        MaxDate := "Bank Account".GETRANGEMAX("Date Filter");
        DateFilter := "Bank Account".GETFILTER("Date Filter");
        IF FORMAT(MaxDate) = DateFilter THEN
            ERROR(FilterDateMustBeAPeriod_Err);

        DialogWindow_Txt := DatedBankReconciliation_Lbl + "Bank account".TableCaption + BankAccount12_Lbl + ReconciliationBankEntries_Lbl + "Bank account ledger entry".TableCaption + BankAccountLedgerEntry_Lbl;
        DialogWindow.OPEN(DialogWindow_Txt);
        GeneralLedgerSetup.GET();
    end;

    local procedure GetTotalBankAccountStatementLine(BankAccountNo: Code[20]; pDateFilter: Text): Decimal
    var
        lBankAccountStatementLine: Record "Bank Account Statement Line";
    begin
        lBankAccountStatementLine.SETRANGE("Bank Account No.", BankAccountNo);
        lBankAccountStatementLine.SETFILTER("Transaction Date", pDateFilter);
        lBankAccountStatementLine.CALCSUMS("Statement Amount");
        EXIT(lBankAccountStatementLine."Statement Amount");
    end;

    local procedure GetTotalBankAccReconciliationLine(BankAccountNo: Code[20]; pDateFilter: Text): Decimal
    var
        lBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        lBankAccReconciliationLine.SETRANGE("Bank Account No.", BankAccountNo);
        lBankAccReconciliationLine.SETFILTER("Transaction Date", pDateFilter);
        lBankAccReconciliationLine.CALCSUMS("Statement Amount");
        EXIT(lBankAccReconciliationLine."Statement Amount");
    end;

    local procedure GetTotalBankLedgerEnty(BankAccountNo: Code[20]; pDateFilter: Text): Decimal
    var
        lBankAccoutnLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        lBankAccoutnLedgerEntry.SETRANGE("Bank Account No.", BankAccountNo);
        lBankAccoutnLedgerEntry.SETFILTER("Posting Date", pDateFilter);
        lBankAccoutnLedgerEntry.CALCSUMS("Amount");
        EXIT(lBankAccoutnLedgerEntry."Amount");
    end;

    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccountStatementLine: Record "Bank Account Statement Line";
        BankAccountStatement: Record "Bank Account Statement";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
        BankFilter: Text;
        OutstandingsText: Text[30];
        MaxDate: Date;
        DateFilter: Text;
        BankAmount: Decimal;
        BankTotalAmount, BankLedgerEntryTotalAmount, BankTotalDebit, BankTotalCredit : Decimal;
        ReconciliationAmout: Decimal;
        MntRapproTot: Decimal;
        MntRapproTotDeb: Decimal;
        MntRapproTotCre: Decimal;
        Print: Boolean;
        PrintTotal: Boolean;
        DialogWindow: Dialog;
        RecordNumber: Integer;
        LineCounter: Integer;
        DebitValue: Decimal;
        DebitBalanceValue: Decimal;
        DebitGapValue: Decimal;
        CreditValue: Decimal;
        CreditBalanceValue: Decimal;
        DebitTotalBalanceValue: Decimal;
        CreditTotalBalanceValue: Decimal;
        CreditGapValue: Decimal;
        Debit: Decimal;
        Credit: Decimal;
        Gap: Decimal;
        BalancedAtDate, DebitBalancedAtDate, CreditBalancedAtDate : Decimal;
#pragma warning disable AA0204
        WithOutstanding: Boolean;
#pragma warning restore AA0204
        DebitLedgerEntry: Decimal;
        CreditLedgerEntry: Decimal;
        i, j, TotalCount, BankAccountReconcCount : Integer;
        FilterDateMustBeAPeriod_Err: Label 'Filter Date must be a period.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le filtre de date doit être une période"}]}';
        ReportOfReconciliationP1_Lbl: Label 'Report of Reconciliation : %1 ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Etat de rapprochement au %1"}]}';
        ThisReportIsTheReconciliationOfTheP1_Lbl: Label 'this report is the reconciliation of the %1.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Cet état reconstitue l''état de rapprochement tel qu''il était en date du %1."}]}';
        ReportIsReconciliationOfP1CurrentReconciliations_Lbl: Label 'this report is the reconciliation of the %1 with current reconciliations', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ce rapport est le rapprochement du %1 avec les rapprochements en cours"}]}';
        NonReconciliedEntry_Lbl: Label 'Non reconcilied entry', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Écritures comptables non rapprochées"}]}';
        TotalReconciliationOfBankP1_Lbl: Label 'Total reconciliation of bank %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total des rapprochements bancaires de %1"}]}';
        ReconciliationVarianceOfBankP1_Lbl: Label 'Reconciliation variance of bank %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Écart de rapprochement bancaire de %1"}]}';
        NonReconciliedBankEntry_Lbl: Label 'Non reconcilied bank entry', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Écritures de banque non rapprochées"}]}';
        ReconciliedStatementNoCaption_Lbl: Label 'Reconcilied Statement No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rapproché sur le"}]}';
        OperationDateCaption_Lbl: Label 'Operation Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date opération"}]}';
        ValueDateCaption_Lbl: Label 'Value Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de valeur"}]}';
        DebitAmountCaption_Lbl: Label 'Debit Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant débit"}]}';
        CreditAmountCaption_Lbl: Label 'Credit Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant crédit"}]}';
        PageCaption_Lbl: Label 'Page', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Page"}]}';
        InDateCaption_Lbl: Label 'In Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"En date du"}]}';
        AccountCaption_Lbl: Label 'Account :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Compte :"}]}';
        BankBalanceCaption_Lbl: Label 'Bank Balance', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde bancaire"}]}';
        TotalBankEntriesNotReconciliedCaption_Lbl: Label 'Total Bank Entries Not Reconcilied', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total des écritures de banque non rapprochées"}]}';
        AccountBalanceCaption_Lbl: Label 'Account Balance', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde comptable"}]}';
        TotalAccountEntriesNotReconciliedCaption_Lbl: Label 'Total Account Entries Not Reconcilied', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total des écritures comptables non rapprochées"}]}';
}