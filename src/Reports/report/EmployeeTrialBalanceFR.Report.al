report 50026 "Employee Trial Balance FR"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/EmployeeTrialBalanceFR.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Employee Trial Balance', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Balance salariés"}]}';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Search Name", "Date Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName())
            {
            }
            column(STRSUBSTNO_Text003_USERID_; StrSubstNo(PrintedBy_Lbl, UserId))
            {
            }
            column(STRSUBSTNO_Text004_PreviousStartDate_; StrSubstNo(FiscalYearStartDate_Lbl, PreviousStartDate))
            {
            }
            column(PageCaption; StrSubstNo(PageNo_Lbl, ' '))
            {
            }
            column(PrintedByCaption; StrSubstNo(PrintedBy_Lbl, ''))
            {
            }
            column(Employee_TABLECAPTION__________Filter; Employee.TableCaption + ': ' + Filter)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee_LastName; "Last Name")
            {
            }
            column(PreviousDebitAmountLCY_PreviousCreditAmountLCY; PreviousDebitAmountLCY - PreviousCreditAmountLCY)
            {
            }
            column(PreviousCreditAmountLCY_PreviousDebitAmountLCY; PreviousCreditAmountLCY - PreviousDebitAmountLCY)
            {
            }
            column(PeriodDebitAmountLCY; PeriodDebitAmountLCY)
            {
            }
            column(PeriodCreditAmountLCY; PeriodCreditAmountLCY)
            {
            }
            column(PreviousDebitAmountLCY_PeriodDebitAmountLCY___PreviousCreditAmountLCY_PeriodCreditAmountLCY_; (PreviousDebitAmountLCY + PeriodDebitAmountLCY) - (PreviousCreditAmountLCY + PeriodCreditAmountLCY))
            {
            }
            column(PreviousCreditAmountLCY_PeriodCreditAmountLCY___PreviousDebitAmountLCY_PeriodDebitAmountLCY_; (PreviousCreditAmountLCY + PeriodCreditAmountLCY) - (PreviousDebitAmountLCY + PeriodDebitAmountLCY))
            {
            }
            column(PreviousDebitAmountLCY_PreviousCreditAmountLCY_Control1120069; PreviousDebitAmountLCY - PreviousCreditAmountLCY)
            {
            }
            column(PreviousCreditAmountLCY_PreviousDebitAmountLCY_Control1120072; PreviousCreditAmountLCY - PreviousDebitAmountLCY)
            {
            }
            column(PeriodDebitAmountLCY_Control1120075; PeriodDebitAmountLCY)
            {
            }
            column(PeriodCreditAmountLCY_Control1120078; PeriodCreditAmountLCY)
            {
            }
            column(PreviousDebitAmountLCY_PeriodDebitAmountLCY___PreviousCreditAmountLCY_PeriodCreditAmountLCY__Control1120081; (PreviousDebitAmountLCY + PeriodDebitAmountLCY) - (PreviousCreditAmountLCY + PeriodCreditAmountLCY))
            {
            }
            column(PreviousCreditAmountLCY_PeriodCreditAmountLCY___PreviousDebitAmountLCY_PeriodDebitAmountLCY__Control1120084; (PreviousCreditAmountLCY + PeriodCreditAmountLCY) - (PreviousDebitAmountLCY + PeriodDebitAmountLCY))
            {
            }
            column(Employee_Trial_BalanceCaption; Employee_Trial_BalanceCaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(Balance_at_Starting_DateCaption; Balance_at_Starting_DateCaptionLbl)
            {
            }
            column(Balance_Date_RangeCaption; Balance_Date_RangeCaptionLbl)
            {
            }
            column(Balance_at_Ending_dateCaption; Balance_at_Ending_dateCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(DebitCaption_Control1120030; DebitCaption_Control1120030Lbl)
            {
            }
            column(CreditCaption_Control1120032; CreditCaption_Control1120032Lbl)
            {
            }
            column(DebitCaption_Control1120034; DebitCaption_Control1120034Lbl)
            {
            }
            column(CreditCaption_Control1120036; CreditCaption_Control1120036Lbl)
            {
            }
            column(Grand_totalCaption; Grand_totalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PreviousDebitAmountLCY := 0;
                PreviousCreditAmountLCY := 0;
                PeriodDebitAmountLCY := 0;
                PeriodCreditAmountLCY := 0;

                DetailedEmployeeLedgerEntry.SetCurrentKey("Posting Date", "Entry Type", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2",
                  "Currency Code");
                if Employee.GetFilter("Global Dimension 1 Filter") <> '' then
                    DetailedEmployeeLedgerEntry.SetRange("Initial Entry Global Dim. 1", Employee.GetFilter("Global Dimension 1 Filter"));
                if Employee.GetFilter("Global Dimension 2 Filter") <> '' then
                    DetailedEmployeeLedgerEntry.SetRange("Initial Entry Global Dim. 2", Employee.GetFilter("Global Dimension 2 Filter"));
                DetailedEmployeeLedgerEntry.SetRange("Employee No.", "No.");
                DetailedEmployeeLedgerEntry.SetRange("Posting Date", 0D, PreviousEndDate);
                DetailedEmployeeLedgerEntry.SetFilter("Entry Type", '<>%1', DetailedEmployeeLedgerEntry."Entry Type"::Application);
                if DetailedEmployeeLedgerEntry.FindSet() then
                    repeat
                        PreviousDebitAmountLCY += DetailedEmployeeLedgerEntry."Debit Amount (LCY)";
                        PreviousCreditAmountLCY += DetailedEmployeeLedgerEntry."Credit Amount (LCY)";
                    until DetailedEmployeeLedgerEntry.Next() = 0;
                DetailedEmployeeLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
                if DetailedEmployeeLedgerEntry.FindSet() then
                    repeat
                        PeriodDebitAmountLCY += DetailedEmployeeLedgerEntry."Debit Amount (LCY)";
                        PeriodCreditAmountLCY += DetailedEmployeeLedgerEntry."Credit Amount (LCY)";
                    until DetailedEmployeeLedgerEntry.Next() = 0;

                if not PrintVendWithoutBalance and (PeriodDebitAmountLCY = 0) and (PeriodCreditAmountLCY = 0) and
                   (PreviousDebitAmountLCY = 0) and (PreviousCreditAmountLCY = 0)
                then
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Date Filter") = '' then
                    Error(MustFillField_Err, FieldCaption("Date Filter"));
                if CopyStr(GetFilter("Date Filter"), 1, 1) = '.' then
                    Error(MustSpecifiedStartingDate_Err);
                StartDate := GetRangeMin("Date Filter");
                PreviousEndDate := ClosingDate(StartDate - 1);
#pragma warning disable AA0139 //TODO : Pas possible de CopyStr sinon error sur le type
                FiltreDateCalc.CreateFiscalYearFilter(TextDate, TextDate, StartDate, 0);
#pragma warning restore AA0139
                TextDate := ConvertStr(TextDate, '.', ',');
                FiltreDateCalc.VerifiyDateFilter(CopyStr(TextDate, 1, 30));
                TextDate := CopyStr(TextDate, 1, 8);
                Evaluate(PreviousStartDate, TextDate);
                if CopyStr(GetFilter("Date Filter"), StrLen(GetFilter("Date Filter")), 1) = '.' then
                    EndDate := 0D
                else
                    EndDate := GetRangeMax("Date Filter");
                Clear(PreviousDebitAmountLCY);
                Clear(PreviousCreditAmountLCY);
                Clear(PeriodDebitAmountLCY);
                Clear(PeriodCreditAmountLCY);
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
                    field(PrintVendorsWithoutBalance; PrintVendWithoutBalance)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Employee without Balance', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Imprimer salariés sans solde"}]}';
                        MultiLine = true;
                        ToolTip = 'Specifies whether to include information about employees without a balance.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie s''il faut inclure des informations sur les salariés sans solde."}]}';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        Filter := Employee.GetFilters;
    end;

    var
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
        FiltreDateCalc: Codeunit "DateFilter-Calc";
        StartDate: Date;
        EndDate: Date;
        PreviousStartDate: Date;
        PreviousEndDate: Date;
        TextDate: Text;
        PrintVendWithoutBalance: Boolean;
        "Filter": Text;
        PreviousDebitAmountLCY: Decimal;
        PreviousCreditAmountLCY: Decimal;
        PeriodDebitAmountLCY: Decimal;
        PeriodCreditAmountLCY: Decimal;
        MustFillField_Err: Label 'You must fill in the %1 field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez remplir le champ %1."}]}';
        MustSpecifiedStartingDate_Err: Label 'You must specify a Starting Date.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez spécifier une date de début."}]}';
        PrintedBy_Lbl: Label 'Printed by %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Imprimé par %1"}]}';
        FiscalYearStartDate_Lbl: Label 'Fiscal Year Start Date : %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Début exercice comptable : %1"}]}';
        PageNo_Lbl: Label 'Page %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"page %1"}]}';
        Employee_Trial_BalanceCaptionLbl: Label 'Employee Trial Balance', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Balance salariés"}]}';
        No_CaptionLbl: Label 'No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N°"}]}';
        NameCaptionLbl: Label 'Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom"}]}';
        Balance_at_Starting_DateCaptionLbl: Label 'Balance at Starting Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde en début de période"}]}';
        Balance_Date_RangeCaptionLbl: Label 'Balance Date Range', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde plage de dates"}]}';
        Balance_at_Ending_dateCaptionLbl: Label 'Balance at Ending date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde à fin de période"}]}';
        DebitCaptionLbl: Label 'Debit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Débit"}]}';
        CreditCaptionLbl: Label 'Credit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Crédit"}]}';
        DebitCaption_Control1120030Lbl: Label 'Debit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Débit"}]}';
        CreditCaption_Control1120032Lbl: Label 'Credit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Crédit"}]}';

        DebitCaption_Control1120034Lbl: Label 'Debit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Débit"}]}';
        CreditCaption_Control1120036Lbl: Label 'Credit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Crédit"}]}';

        Grand_totalCaptionLbl: Label 'Grand total', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total général"}]}';
}