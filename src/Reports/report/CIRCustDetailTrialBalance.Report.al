report 50000 "CIR Cust. Detail Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRCustomerDetailTrialBalance.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'CIR Customer Detail Trial Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "CIR Grand livre clients" }, { "lang": "FRB", "txt": "CIR Grand livre clients" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName())
            {
            }
            column(STRSUBSTNO_Text003_USERID_; StrSubstNo(Text003Lbl, UserId))
            {
            }
            column(STRSUBSTNO_Text004_PreviousStartDate_; StrSubstNo(Text004Lbl, PreviousStartDate))
            {
            }
            column(PageCaption; StrSubstNo(Text005Lbl, ''))
            {
            }
            column(PrintedByCaption; StrSubstNo(Text003Lbl, ''))
            {
            }
            column(ExcludeBalanceOnly; bExcludeBalanceOnly)
            {
            }
            column(Customer_TABLECAPTION__________Filter; Customer.TableCaption + ': ' + Filter)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(ReportDebitAmountLCY; ReportDebitAmountLCY)
            {
            }
            column(ReportCreditAmountLCY; ReportCreditAmountLCY)
            {
            }
            column(ReportDebitAmountLCY_ReportCreditAmountLCY; ReportDebitAmountLCY - ReportCreditAmountLCY)
            {
            }
            column(STRSUBSTNO_Text006_PreviousEndDate_; StrSubstNo(Text006Lbl, PreviousEndDate))
            {
            }
            column(PreviousDebitAmountLCY; PreviousDebitAmountLCY)
            {
            }
            column(PreviousCreditAmountLCY; PreviousCreditAmountLCY)
            {
            }
            column(PreviousDebitAmountLCY_PreviousCreditAmountLCY; PreviousDebitAmountLCY - PreviousCreditAmountLCY)
            {
            }
            column(ReportDebitAmountLCY_Control1120062; ReportDebitAmountLCY)
            {
            }
            column(ReportCreditAmountLCY_Control1120064; ReportCreditAmountLCY)
            {
            }
            column(ReportDebitAmountLCY_ReportCreditAmountLCY_Control1120066; ReportDebitAmountLCY - ReportCreditAmountLCY)
            {
            }
            column(GeneralDebitAmountLCY; GeneralDebitAmountLCY)
            {
            }
            column(GeneralCreditAmountLCY; GeneralCreditAmountLCY)
            {
            }
            column(GeneralDebitAmountLCY_GeneralCreditAmountLCY; GeneralDebitAmountLCY - GeneralCreditAmountLCY)
            {
            }
            column(Customer_Date_Filter; "Date Filter")
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Customer_Currency_Filter; "Currency Filter")
            {
            }
            column(Customer_Detail_Trial_BalanceCaption; Customer_Detail_Trial_BalanceCaptionLbl)
            {
            }
            column(This_report_also_includes_customers_that_only_have_balances_Caption; This_report_also_includes_customers_that_only_have_balances_CaptionLbl)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(Source_CodeCaption; Source_CodeCaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(External_Document_No_Caption; External_Document_No_CaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(ContinuedCaption; ContinuedCaptionLbl)
            {
            }
            column(To_be_continuedCaption; To_be_continuedCaptionLbl)
            {
            }
            column(Grand_TotalCaption; Grand_TotalCaptionLbl)
            {
            }
            column(ClosedbyEntryNoCaption; ClosedbyEntryNoLbl)
            {
            }
            column(CustLedgerEntryNoCaption; CustLedgerEntryNoLbl)
            {
            }
            column(LetteringCodeCaption; LetteringCodeLbl)
            {
            }
            column(LetteringDateCaption; LetteringDateLbl)
            {
            }
            dataitem(Date; Date)
            {
                DataItemTableView = SORTING("Period Type");
                column(DebitPeriodAmount_PreviousDebitAmountLCY___CreditPeriodAmount_PreviousCreditAmountLCY_; (DebitPeriodAmount + PreviousDebitAmountLCY) - (CreditPeriodAmount + PreviousCreditAmountLCY))
                {
                }
                column(CreditPeriodAmount_PreviousCreditAmountLCY; CreditPeriodAmount + PreviousCreditAmountLCY)
                {
                }
                column(DebitPeriodAmount_PreviousDebitAmountLCY; DebitPeriodAmount + PreviousDebitAmountLCY)
                {
                }
                column(STRSUBSTNO_Text006_EndDate_; StrSubstNo(Text006Lbl, EndDate))
                {
                }
                column(STRSUBSTNO_Text007_EndDate_; StrSubstNo(Text007Lbl, EndDate))
                {
                }
                column(DebitPeriodAmount; DebitPeriodAmount)
                {
                }
                column(DebitPeriodAmount_PreviousDebitAmountLCY_Control1120082; DebitPeriodAmount + PreviousDebitAmountLCY)
                {
                }
                column(CreditPeriodAmount; CreditPeriodAmount)
                {
                }
                column(CreditPeriodAmount_PreviousCreditAmountLCY_Control1120086; CreditPeriodAmount + PreviousCreditAmountLCY)
                {
                }
                column(DebitPeriodAmount_CreditPeriodAmount; DebitPeriodAmount - CreditPeriodAmount)
                {
                }
                column(DebitPeriodAmount_PreviousDebitAmountLCY___CreditPeriodAmount_PreviousCreditAmountLCY__Control1120090; (DebitPeriodAmount + PreviousDebitAmountLCY) - (CreditPeriodAmount + PreviousCreditAmountLCY))
                {
                }
                column(Date_Period_Type; "Period Type")
                {
                }
                column(Date_Period_Start; "Period Start")
                {
                }
                column(Total_Date_RangeCaption; Total_Date_RangeCaptionLbl)
                {
                }
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"), "Currency Code" = FIELD("Currency Filter");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Currency Code") WHERE("Entry Type" = FILTER(<> Application));
                    column(Detailed_Cust__Ledg__Entry__Debit_Amount__LCY__; "Debit Amount (LCY)")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Credit_Amount__LCY__; "Credit Amount (LCY)")
                    {
                    }
                    column(Debit_Amount__LCY______Credit_Amount__LCY__; "Debit Amount (LCY)" - "Credit Amount (LCY)")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Posting_Date_; Format("Posting Date"))
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Source_Code_; "Source Code")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Document_No__; "Document No.")
                    {
                    }
                    column(OriginalLedgerEntry__External_Document_No__; CustLedgerEntry."External Document No.")
                    {
                    }
                    column(OriginalLedgerEntry_Description; CustLedgerEntry.Description)
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Debit_Amount__LCY___Control1120116; "Debit Amount (LCY)")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Credit_Amount__LCY___Control1120119; "Credit Amount (LCY)")
                    {
                    }
                    column(BalanceLCY; BalanceLCY)
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Debit_Amount__LCY___Control1120126; "Debit Amount (LCY)")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Credit_Amount__LCY___Control1120128; "Credit Amount (LCY)")
                    {
                    }
                    column(Debit_Amount__LCY______Credit_Amount__LCY___Control1120130; "Debit Amount (LCY)" - "Credit Amount (LCY)")
                    {
                    }
                    column(Text008_________FORMAT_Date__Period_Type___________Date__Period_Name_; Text008Lbl + ' ' + Format(Date."Period Type") + ' ' + Date."Period Name")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Debit_Amount__LCY___Control1120136; "Debit Amount (LCY)")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Credit_Amount__LCY___Control1120139; "Credit Amount (LCY)")
                    {
                    }
                    column(BalanceLCY_Control1120142; BalanceLCY)
                    {
                    }
                    column(DatePeriodTypeInt; DatePeriodTypeInt)
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry_Customer_No_; "Customer No.")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry_Posting_Date; "Posting Date")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry_Initial_Entry_Global_Dim__1; "Initial Entry Global Dim. 1")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry_Initial_Entry_Global_Dim__2; "Initial Entry Global Dim. 2")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry_Currency_Code; "Currency Code")
                    {
                    }
                    column(Previous_pageCaption; Previous_pageCaptionLbl)
                    {
                    }
                    column(Current_pageCaption; Current_pageCaptionLbl)
                    {
                    }
                    column(PostingYearValue; Format(Date2DMY("Posting Date", 3)))
                    {
                    }
                    column(ClosedbyEntryNo_; ClosedbyEntryNo)
                    {
                    }
                    column(CustLedgerEntryNo_; "Cust. Ledger Entry No.")
                    {
                    }
                    column(LetteringCode_; LetteringCode)
                    {
                    }
                    column(LetteringDate; FORMAT(LetteringDate, 0))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ("Debit Amount (LCY)" = 0) and
                           ("Credit Amount (LCY)" = 0)
                        then
                            CurrReport.Skip();
                        BalanceLCY := BalanceLCY + "Debit Amount (LCY)" - "Credit Amount (LCY)";

                        CustLedgerEntry.Get("Cust. Ledger Entry No.");

                        GeneralDebitAmountLCY := GeneralDebitAmountLCY + "Debit Amount (LCY)";
                        GeneralCreditAmountLCY := GeneralCreditAmountLCY + "Credit Amount (LCY)";

                        DebitPeriodAmount := DebitPeriodAmount + "Debit Amount (LCY)";
                        CreditPeriodAmount := CreditPeriodAmount + "Credit Amount (LCY)";

                        if CustLedgerEntry.Get("Cust. Ledger Entry No.") then begin
                            ClosedbyEntryNo := CustLedgerEntry."Closed by Entry No.";
                            LetteringCode := CustLedgerEntry."ACY_AAC Letter Code";
                            LetteringDate := CustLedgerEntry."ACY_AAC Letter Date";
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        ReportDebitAmountLCY := ReportDebitAmountLCY + "Debit Amount (LCY)";
                        ReportCreditAmountLCY := ReportCreditAmountLCY + "Credit Amount (LCY)";
                    end;

                    trigger OnPreDataItem()
                    begin
                        if bDocNumSort then
                            SetCurrentKey("Customer No.", "Document No.", "Posting Date");
                        if StartDate > Date."Period Start" then
                            Date."Period Start" := StartDate;
                        if EndDate < Date."Period End" then
                            Date."Period End" := EndDate;
                        SetRange("Posting Date", Date."Period Start", Date."Period End");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    DatePeriodTypeInt := Date."Period Type";
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Period Type", TotalBy);
                    SetRange("Period Start", CalcDate('<-CM>', StartDate), ClosingDate(EndDate));
                    CurrReport.PrintOnlyIfDetail := bExcludeBalanceOnly or (BalanceLCY = 0);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                DetailedCustLedgEntry.SetCurrentKey(
                  "Customer No.", "Posting Date", "Entry Type", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Currency Code");
                DetailedCustLedgEntry.SetRange("Customer No.", "No.");
                DetailedCustLedgEntry.SetRange("Posting Date", 0D, PreviousEndDate);
                DetailedCustLedgEntry.SetFilter(
                  "Entry Type",
                  '<>%1&<>%2',
                  DetailedCustLedgEntry."Entry Type"::Application,
                  DetailedCustLedgEntry."Entry Type"::"Appln. Rounding");

                DetailedCustLedgEntry.CalcSums("Debit Amount (LCY)", "Credit Amount (LCY)");
                PreviousDebitAmountLCY := DetailedCustLedgEntry."Debit Amount (LCY)";
                PreviousCreditAmountLCY := DetailedCustLedgEntry."Credit Amount (LCY)";

                DetailedCustLedgEntry2.CopyFilters(DetailedCustLedgEntry);
                DetailedCustLedgEntry2.SetRange("Posting Date", StartDate, EndDate);
                if not (bExcludeBalanceOnly and DetailedCustLedgEntry2.IsEmpty) then begin
                    GeneralDebitAmountLCY := GeneralDebitAmountLCY + PreviousDebitAmountLCY;
                    GeneralCreditAmountLCY := GeneralCreditAmountLCY + PreviousCreditAmountLCY;
                end;
                BalanceLCY := PreviousDebitAmountLCY - PreviousCreditAmountLCY;

                DebitPeriodAmount := 0;
                CreditPeriodAmount := 0;
                CurrReport.PrintOnlyIfDetail := bExcludeBalanceOnly or (BalanceLCY = 0);
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Date Filter") = '' then
                    Error(Text001Lbl, FieldCaption("Date Filter"));
                if CopyStr(GetFilter("Date Filter"), 1, 1) = '.' then
                    Error(Text002Lbl);
                StartDate := GetRangeMin("Date Filter");
                PreviousEndDate := ClosingDate(StartDate - 1);
                DateFilterCalc.CreateFiscalYearFilter(TextDate, TextDate, StartDate, 0);
                TextDate := ConvertStr(TextDate, '.', ',');
                TextDate := CopyStr(TextDate, 1, 8);
                Evaluate(PreviousStartDate, TextDate);
                if CopyStr(GetFilter("Date Filter"), StrLen(GetFilter("Date Filter")), 1) = '.' then
                    EndDate := 0D
                else
                    EndDate := GetRangeMax("Date Filter");
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
                    Caption = 'Options', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Options" }, { "lang": "FRB", "txt": "Options" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    field(DocNumSort; bDocNumSort)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sorted by Document No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Trié par n° de document" }, { "lang": "FRB", "txt": "Trié par n° de document" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        ToolTip = 'Specifies criteria for arranging information in the report.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie les critères d''organisation des informations dans le rapport." }, { "lang": "FRB", "txt": "Spécifie les critères d''organisation des informations dans le rapport." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    }
                    field(ExcludeBalanceOnly; bExcludeBalanceOnly)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exclude customers that have a balance only', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Exclure les clients qui ont un solde uniquement" }, { "lang": "FRB", "txt": "Exclure les clients qui ont un solde uniquement" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        ToolTip = 'Specifies if you do not want to display entries for customers who have a balance but do not have a net change during the selected time period.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique si vous ne voulez pas afficher les entrées pour les clients qui ont un solde mais qui n''ont pas de changement net pendant la période sélectionnée." }, { "lang": "FRB", "txt": "Indique si vous ne voulez pas afficher les entrées pour les clients qui ont un solde mais qui n''ont pas de changement net pendant la période sélectionnée." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        MultiLine = true;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        TotalBy := TotalBy::Month;
    end;

    trigger OnPreReport()
    begin
        Filter := Customer.GetFilters;
    end;

    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DateFilterCalc: Codeunit "DateFilter-Calc";
        Text001Lbl: Label 'You must fill in the %1 field.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous devez remplir le champ %1." }, { "lang": "FRB", "txt": "Vous devez remplir le champ %1." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text002Lbl: Label 'You must specify a Starting Date.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous devez spécifier une date de début." }, { "lang": "FRB", "txt": "Vous devez spécifier une date de début." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text003Lbl: Label 'Printed by %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Imprimé par %1" }, { "lang": "FRB", "txt": "Imprimé par %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text004Lbl: Label 'Fiscal Year Start Date : %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date de début de l''année fiscale : %1" }, { "lang": "FRB", "txt": "Date de début de l''année fiscale : %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text005Lbl: Label 'Page %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Page %1" }, { "lang": "FRB", "txt": "Page %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text006Lbl: Label 'Balance at %1 ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde au %1" }, { "lang": "FRB", "txt": "Solde au %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text007Lbl: Label 'Balance at %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde au %1" }, { "lang": "FRB", "txt": "Solde au %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text008Lbl: Label 'Total', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Total" }, { "lang": "FRB", "txt": "Total" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';

        StartDate: Date;
        EndDate: Date;
        PreviousStartDate: Date;
        PreviousEndDate: Date;
        TextDate: Text[30];
        BalanceLCY: Decimal;
        TotalBy: Option Date,Week,Month,Quarter,Year;
        bDocNumSort: Boolean;
        "Filter": Text;
        PreviousDebitAmountLCY: Decimal;
        PreviousCreditAmountLCY: Decimal;
        GeneralDebitAmountLCY: Decimal;
        GeneralCreditAmountLCY: Decimal;
        ReportDebitAmountLCY: Decimal;
        ReportCreditAmountLCY: Decimal;
        DebitPeriodAmount: Decimal;
        CreditPeriodAmount: Decimal;
        bExcludeBalanceOnly: Boolean;
        DatePeriodTypeInt: Integer;
        ClosedbyEntryNo: Integer;
        LetteringCode: Text[10];
        LetteringDate: Date;
        Customer_Detail_Trial_BalanceCaptionLbl: Label 'Customer Detail Trial Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Grand livre clients" }, { "lang": "FRB", "txt": "Grand livre clients" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        This_report_also_includes_customers_that_only_have_balances_CaptionLbl: Label 'This report also includes customers that only have balances.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ce rapport inclut également les clients qui n''ont que des soldes."}]}';
        Posting_DateCaptionLbl: Label 'Posting Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date comptabilisation" }, { "lang": "FRB", "txt": "Date comptabilisation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Source_CodeCaptionLbl: Label 'Source Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code journal" }, { "lang": "FRB", "txt": "Code journal" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Document_No_CaptionLbl: Label 'Document No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° document" }, { "lang": "FRB", "txt": "N° document" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        External_Document_No_CaptionLbl: Label 'External Document No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° doc. externe" }, { "lang": "FRB", "txt": "N° doc. externe" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        DescriptionCaptionLbl: Label 'Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Description" }, { "lang": "FRB", "txt": "Description" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        DebitCaptionLbl: Label 'Debit', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Débit" }, { "lang": "FRB", "txt": "Débit" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        CreditCaptionLbl: Label 'Credit', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Crédit" }, { "lang": "FRB", "txt": "Crédit" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        BalanceCaptionLbl: Label 'Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde" }, { "lang": "FRB", "txt": "Solde" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        ContinuedCaptionLbl: Label 'Continued', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Suite" }, { "lang": "FRB", "txt": "Suite" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        To_be_continuedCaptionLbl: Label 'To be continued', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "A reporter" }, { "lang": "FRB", "txt": "A reporter" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Grand_TotalCaptionLbl: Label 'Grand Total', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Total général" }, { "lang": "FRB", "txt": "Total général" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Total_Date_RangeCaptionLbl: Label 'Total Date Range', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Total de la période" }, { "lang": "FRB", "txt": "Total de la période" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Previous_pageCaptionLbl: Label 'Previous page', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Page précédente" }, { "lang": "FRB", "txt": "Page précédente" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Current_pageCaptionLbl: Label 'Current page', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Page courante" }, { "lang": "FRB", "txt": "Page courante" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        ClosedbyEntryNoLbl: Label 'Closed by Entry No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° de sequence lettrage final" }, { "lang": "FRB", "txt": "N° de sequence lettrage final" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        CustLedgerEntryNoLbl: Label 'Entry No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° de séquence" }, { "lang": "FRB", "txt": "N° de séquence" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        LetteringCodeLbl: Label 'Application code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Lettrage" }, { "lang": "FRB", "txt": "Lettrage" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        LetteringDateLbl: Label 'Application Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date Lettrage" }, { "lang": "FRB", "txt": "Date Lettrage" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
}