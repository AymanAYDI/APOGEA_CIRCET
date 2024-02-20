report 50021 "CIR Empl. Detail Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIREmployeeDetailTrialBalance.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'CIR Employee Detail Trial Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "CIR Grand livre salariés" } ] }';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Employee; Employee)
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
            column(PageCaption; StrSubstNo(Text005Lbl, ' '))
            {
            }
            column(PrintedByCaption; StrSubstNo(Text003Lbl, ''))
            {
            }
            column(ExcludeBalanceOnly; ExcludeBalanceOnly)
            {
            }
            column(Employee_TABLECAPTION__________Filter; Employee.TableCaption + ': ' + FilterTxt)
            {
            }
            column("Filter"; FilterTxt)
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee_Name; "First Name")
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
            column(Employee_Date_Filter; "Date Filter")
            {
            }
            column(Employee_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Employee_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Employee_Detail_Trial_BalanceCaption; Employee_Detail_Trial_BalanceCaptionLbl)
            {
            }
            column(This_report_also_includes_employees_that_only_have_balances_Caption; This_report_also_includes_emplpoyees_that_only_have_balances_CaptionLbl)
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
            column(EmployeeLedgerEntryNoCaption; EmployeeLedgerEntryNoLbl)
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
                column(Date__Period_Name_; Date."Period Name")
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
                dataitem("Detailed Employee Ledger Entry"; "Detailed Employee Ledger Entry")
                {
                    DataItemLink = "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Employee;
                    DataItemTableView = SORTING("Employee No.", "Posting Date", "Entry Type", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Currency Code") WHERE("Entry Type" = FILTER(<> Application));
                    column(Detailed_Employee_Ledg__Entry__Debit_Amount__LCY__; "Debit Amount (LCY)")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry__Credit_Amount__LCY__; "Credit Amount (LCY)")
                    {
                    }
                    column(Debit_Amount__LCY______Credit_Amount__LCY__; "Debit Amount (LCY)" - "Credit Amount (LCY)")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry__Posting_Date_; Format("Posting Date"))
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry__Source_Code_; "Source Code")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry__Document_No__; "Document No.")
                    {
                    }
                    column(OriginalLedgerEntry_Description; EmployeeLedgerEntry.Description)
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry__Debit_Amount__LCY___Control1120116; "Debit Amount (LCY)")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry__Credit_Amount__LCY___Control1120119; "Credit Amount (LCY)")
                    {
                    }
                    column(BalanceLCY; BalanceLCY)
                    {
                    }
                    column(Det_Employee_L_E___Entry_No__; "Detailed Employee Ledger Entry"."Entry No.")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry__Debit_Amount__LCY___Control1120126; "Debit Amount (LCY)")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry__Credit_Amount__LCY___Control1120128; "Credit Amount (LCY)")
                    {
                    }
                    column(Debit_Amount__LCY______Credit_Amount__LCY___Control1120130; "Debit Amount (LCY)" - "Credit Amount (LCY)")
                    {
                    }
                    column(Text008_________FORMAT_Date__Period_Type___________Date__Period_Name_; Text008Lbl + ' ' + Format(Date."Period Type") + ' ' + Date."Period Name")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry__Debit_Amount__LCY___Control1120136; "Debit Amount (LCY)")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry__Credit_Amount__LCY___Control1120139; "Credit Amount (LCY)")
                    {
                    }
                    column(BalanceLCY_Control1120142; BalanceLCY)
                    {
                    }
                    column(FooterEnable; not (Date."Period Type" = Date."Period Type"::Year))
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry_Employee_No_; "Employee No.")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry_Posting_Date; "Posting Date")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry_Initial_Entry_Global_Dim__1; "Initial Entry Global Dim. 1")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry_Initial_Entry_Global_Dim__2; "Initial Entry Global Dim. 2")
                    {
                    }
                    column(Detailed_Employee_Ledg__Entry_Currency_Code; "Currency Code")
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
                    column(EmployeeLedgerEntryNo_; "Employee Ledger Entry No.")
                    {
                    }
                    column(LetteringCode_; LetteringCode)
                    {
                    }
                    column(LetteringDate; FORMAT(LetteringDate, 0))
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        EmployeeLedgerEntry: Record "Employee Ledger Entry";
                    begin
                        if ("Debit Amount (LCY)" = 0) and
                           ("Credit Amount (LCY)" = 0)
                        then
                            CurrReport.Skip();
                        BalanceLCY := BalanceLCY + "Debit Amount (LCY)" - "Credit Amount (LCY)";

                        GeneralDebitAmountLCY := GeneralDebitAmountLCY + "Debit Amount (LCY)";
                        GeneralCreditAmountLCY := GeneralCreditAmountLCY + "Credit Amount (LCY)";

                        DebitPeriodAmount := DebitPeriodAmount + "Debit Amount (LCY)";
                        CreditPeriodAmount := CreditPeriodAmount + "Credit Amount (LCY)";

                        if EmployeeLedgerEntry.Get("Employee Ledger Entry No.") then begin
#pragma warning disable AA0206
                            ClosedbyEntryNo := EmployeeLedgerEntry."Closed by Entry No.";
#pragma warning restore AA0206
                            LetteringCode := EmployeeLedgerEntry."ACY_AAC Letter Code";
                            LetteringDate := EmployeeLedgerEntry."ACY_AAC Letter Date";
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        ReportDebitAmountLCY := ReportDebitAmountLCY + "Debit Amount (LCY)";
                        ReportCreditAmountLCY := ReportCreditAmountLCY + "Credit Amount (LCY)";
                    end;

                    trigger OnPreDataItem()
                    begin
                        if DocNumSort then
                            SetCurrentKey("Employee No.", "Document No.", "Posting Date");
                        if StartDate > Date."Period Start" then
                            Date."Period Start" := StartDate;
                        if EndDate < Date."Period End" then
                            Date."Period End" := EndDate;
                        SetRange("Posting Date", Date."Period Start", Date."Period End");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Period Type", TotalBy);
                    SetRange("Period Start", CalcDate('<-CM>', StartDate), ClosingDate(EndDate));
                    CurrReport.PrintOnlyIfDetail := ExcludeBalanceOnly or (BalanceLCY = 0);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                DetailedEmployeeLedgerEntry.SetCurrentKey(
                  "Employee No.", "Posting Date", "Entry Type", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Currency Code");
                DetailedEmployeeLedgerEntry.SetRange("Employee No.", "No.");
                DetailedEmployeeLedgerEntry.SetRange("Posting Date", 0D, PreviousEndDate);
                DetailedEmployeeLedgerEntry.SetFilter(
                  "Entry Type", '<>%1&<>%2',
                  DetailedEmployeeLedgerEntry."Entry Type"::Application,
                  DetailedEmployeeLedgerEntry."Entry Type"::"Initial Entry");

                DetailedEmployeeLedgerEntry.CalcSums("Debit Amount (LCY)", "Credit Amount (LCY)");
                PreviousDebitAmountLCY := DetailedEmployeeLedgerEntry."Debit Amount (LCY)";
                PreviousCreditAmountLCY := DetailedEmployeeLedgerEntry."Credit Amount (LCY)";

                DetailedEmployeeLedgerEntry2.CopyFilters(DetailedEmployeeLedgerEntry);
                DetailedEmployeeLedgerEntry2.SetRange("Posting Date", StartDate, EndDate);
                if not (ExcludeBalanceOnly and DetailedEmployeeLedgerEntry2.IsEmpty) then begin
                    GeneralDebitAmountLCY := GeneralDebitAmountLCY + PreviousDebitAmountLCY;
                    GeneralCreditAmountLCY := GeneralCreditAmountLCY + PreviousCreditAmountLCY;
                end;
                BalanceLCY := PreviousDebitAmountLCY - PreviousCreditAmountLCY;

                DebitPeriodAmount := 0;
                CreditPeriodAmount := 0;
                CurrReport.PrintOnlyIfDetail := ExcludeBalanceOnly or (BalanceLCY = 0);
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
                    Caption = 'Options', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Options" } ] }';
                    field(DocNumSort; DocNumSort)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sorted by Document No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Trié par n° document" } ] }';
                        ToolTip = 'Specifies criteria for arranging information in the report.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie les critères d''organisation des informations dans le rapport." } ] }';
                    }
                    field(ExcludeBalanceOnly; ExcludeBalanceOnly)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exclude employees that have a balance only', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Exclure les vendeurs qui ont un solde uniquement" } ] }';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want the report to exclude entries for employees that have a balance but do not have a net change during the selected time period.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique si vous voulez que le rapport exclue les entrées pour les salariés qui ont un solde mais qui n''ont pas de changement net pendant la période sélectionnée." } ] }';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        TotalBy := TotalBy::Month;
    end;

    trigger OnPreReport()
    begin
        FilterTxt := Employee.GetFilters;
    end;

    var
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        DetailedEmployeeLedgerEntry2: Record "Detailed Employee Ledger Entry";
        DateFilterCalc: Codeunit "DateFilter-Calc";
        Text001Lbl: Label 'You must fill in the %1 field.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous devez remplir le champ %1." } ] }';
        Text002Lbl: Label 'You must specify a Starting Date.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous devez spécifier une date de début." } ] }';
        Text003Lbl: Label 'Printed by %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Imprimé par %1" } ] }';
        Text004Lbl: Label 'Fiscal Year Start Date : %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date de début de l''année fiscale : %1" } ] }';
        Text005Lbl: Label 'Page %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Page %1" } ] }';
        Text006Lbl: Label 'Balance at %1 ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde au %1" } ] }';
        Text007Lbl: Label 'Balance at %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde au %1" } ] }';
        Text008Lbl: Label 'Total', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Total" } ] }';
        StartDate: Date;
        EndDate: Date;
        PreviousStartDate: Date;
        PreviousEndDate: Date;
        TextDate: Text[30];
        BalanceLCY: Decimal;
        TotalBy: Option Date,Week,Month,Quarter,Year;
#pragma warning disable AA0204
        DocNumSort: Boolean;
#pragma warning restore AA0204
        FilterTxt: Text;
        PreviousDebitAmountLCY: Decimal;
        PreviousCreditAmountLCY: Decimal;
        GeneralDebitAmountLCY: Decimal;
        GeneralCreditAmountLCY: Decimal;
        ReportDebitAmountLCY: Decimal;
        ReportCreditAmountLCY: Decimal;
        DebitPeriodAmount: Decimal;
        CreditPeriodAmount: Decimal;
#pragma warning disable AA0204
        ExcludeBalanceOnly: Boolean;
#pragma warning restore AA0204
        ClosedbyEntryNo: Integer;
        LetteringCode: Text[10];
        LetteringDate: Date;
        Employee_Detail_Trial_BalanceCaptionLbl: Label 'Employee Detail Trial Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Grand livre salariés" } ] }';
        This_report_also_includes_emplpoyees_that_only_have_balances_CaptionLbl: Label 'This report also includes employee that only have balances.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ce rapport inclut également les salariés qui n''ont que des soldes."}]}';
        Posting_DateCaptionLbl: Label 'Posting Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date comptabilisation" } ] }';
        Source_CodeCaptionLbl: Label 'Source Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code journal" } ] }';
        Document_No_CaptionLbl: Label 'Document No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° document" } ] }';
        External_Document_No_CaptionLbl: Label 'External Document No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° doc. externe" } ] }';
        DescriptionCaptionLbl: Label 'Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Description" } ] }';
        DebitCaptionLbl: Label 'Debit', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Débit" } ] }';
        CreditCaptionLbl: Label 'Credit', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Crédit" } ] }';
        BalanceCaptionLbl: Label 'Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde" } ] }';
        ContinuedCaptionLbl: Label 'Continued', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Suite" } ] }';
        To_be_continuedCaptionLbl: Label 'To be continued', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "A reporter" } ] }';
        Grand_TotalCaptionLbl: Label 'Grand Total', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Total général" } ] }';
        Total_Date_RangeCaptionLbl: Label 'Total Date Range', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Total de la période" } ] }';
        Previous_pageCaptionLbl: Label 'Previous page', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Page précédente" } ] }';
        Current_pageCaptionLbl: Label 'Current page', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Page courante" } ] }';
        ClosedbyEntryNoLbl: Label 'Closed by Entry No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° de sequence lettrage final" } ] }';
        EmployeeLedgerEntryNoLbl: Label 'Entry No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° de séquence" } ] }';

        LetteringCodeLbl: Label 'Application code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Lettrage" } ] }';
        LetteringDateLbl: Label 'Application Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date Lettrage" } ] }';
}

