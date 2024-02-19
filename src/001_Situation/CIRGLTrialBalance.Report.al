report 50501 "CIR G/L Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Src/001_Situation/CIRGLTrialBalance.report.rdl';
    Caption = 'G/L Trial Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Balance comptes généraux"}]}';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Date Filter", "CIR G/L Entry Type Filter";
            column(TodayFormatted; Format(Today(), 0, 4))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(PreviousStartDateText; StrSubstNo(Text004Lbl, PreviousStartDate))
            {
            }
            column(PageCaption; StrSubstNo(Text005Lbl, ''))
            {
            }
            column(UserCaption; Text003Lbl)
            {
            }
            column(GLAccTableCaptionFilter; "G/L Account".TableCaption() + ': ' + Filter)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(FiscalYearStatusText; FiscalYearStatusText)
            {
            }
            column(No_GLAcc; "No.")
            {
            }
            column(Name_GLAcc; Name)
            {
            }
            column(GLAcc2DebitAmtCreditAmt; GLAccount2."CIR Debit Amount" - GLAccount2."CIR Credit Amount")
            {
            }
            column(GLAcc2CreditAmtDebitAmt; GLAccount2."CIR Credit Amount" - GLAccount2."CIR Debit Amount")
            {
            }
            column(DebitAmt_GLAcc; "CIR Debit Amount")
            {
            }
            column(CreditAmt_GLAcc; "CIR Credit Amount")
            {
            }
            column(BalAtEndingDateDebitCaption; GLAccount2."CIR Debit Amount" + "CIR Debit Amount" - GLAccount2."CIR Credit Amount" - "CIR Credit Amount")
            {
            }
            column(BalAtEndingDateCreditCaption; GLAccount2."CIR Credit Amount" + "CIR Credit Amount" - GLAccount2."CIR Debit Amount" - "CIR Debit Amount")
            {
            }
            column(TLAccType; TLAccountType)
            {
            }
            column(GLTrialBalCaption; GLTrialBalCaptionLbl)
            {
            }
            column(NoCaption; NoCaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(BalAtStartingDateCaption; BalAtStartingDateCaptionLbl)
            {
            }
            column(BalDateRangeCaption; BalDateRangeCaptionLbl)
            {
            }
            column(BalAtEndingdateCaption; BalAtEndingdateCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(gDecDebitBegin; gDecDebitBegin)
            {
            }
            column(gDecDebitPeriod; gDecDebitPeriod)
            {
            }
            column(gDecDebitEnd; gDecDebitEnd)
            {
            }
            column(gDecCreditBegin; gDecCreditBegin)
            {
            }
            column(gDecCreditPeriod; gDecCreditPeriod)
            {
            }
            column(gDecCreditEnd; gDecCreditEnd)
            {
            }
            column(gBooTotal; gBooTotal)
            {
            }

            trigger OnAfterGetRecord()
            begin
                GLAccount2.Copy("G/L Account");
                if GLAccount2."Income/Balance" = 0 then begin
                    GLAccount2.SetRange("Date Filter", PreviousStartDate, PreviousEndDate);
                    GLAccount2.CalcFields("CIR Debit Amount", "CIR Credit Amount");
                end else begin
                    GLAccount2.SetRange("Date Filter", 0D, PreviousEndDate);
                    GLAccount2.CalcFields("CIR Debit Amount", "CIR Credit Amount");
                end;
                if not ImprNonMvt and
                   (GLAccount2."CIR Debit Amount" = 0) and
                   ("CIR Debit Amount" = 0) and
                   (GLAccount2."CIR Credit Amount" = 0) and
                   ("CIR Credit Amount" = 0)
                then
                    CurrReport.Skip();

                if "CIR Debit Amount" < 0 then begin
                    "CIR Credit Amount" += -"CIR Debit Amount";
                    "CIR Debit Amount" := 0;
                end;
                if "CIR Credit Amount" < 0 then begin
                    "CIR Debit Amount" += -"CIR Credit Amount";
                    "CIR Credit Amount" := 0;
                end;

                TLAccountType := "G/L Account"."Account Type";

                IF "G/L Account"."Account Type" = "Account Type"::Posting THEN BEGIN
                    gDecDebitBegin += fDecPos(GLAccount2."CIR Debit Amount" - GLAccount2."CIR Credit Amount");
                    gDecCreditBegin += fDecPos(GLAccount2."CIR Credit Amount" - GLAccount2."CIR Debit Amount");
                    gDecDebitPeriod += fDecPos("CIR Debit Amount");
                    gDecCreditPeriod += fDecPos("CIR Credit Amount");
                    gDecDebitEnd += fDecPos(GLAccount2."CIR Debit Amount" + "CIR Debit Amount" - GLAccount2."CIR Credit Amount" - "CIR Credit Amount");
                    gDecCreditEnd += fDecPos(GLAccount2."CIR Credit Amount" + "CIR Credit Amount" - GLAccount2."CIR Debit Amount" - "CIR Debit Amount");
                END;
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
                VerifiyDateFilter(TextDate);
                TextDate := CopyStr(TextDate, 1, 8);
                Evaluate(PreviousStartDate, TextDate);
                FiscalYearStatusText := StrSubstNo(Text007Lbl, CheckFiscalYearStatus(CopyStr(GetFilter("Date Filter"), 1, 30)));
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
                    Caption = 'Options', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Options"}]}';
                    field(PrintGLAccsWithoutBalance; ImprNonMvt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print G/L Accs. without balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Impr. cptes non mouvementés"}]}';
                        ToolTip = 'Specifies the value of the Print G/L Accs. without balance ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Impr. cptes non mouvementés"}]}';
                    }
                    field(Totalisation; gBooTotal)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Totalisation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Totalisation"}]}';
                        ToolTip = 'Specifies whether the total should be displayed', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie si le total doit s''afficher"}]}';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        Filter := "G/L Account".GetFilters();
    end;

    local procedure CheckFiscalYearStatus(PeriodRange: Text[30]): Text[30]
    var
        AccountingPeriod: Record "Accounting Period";
        Date: Record Date;
        PeriodClosedTxt: Label 'Fiscally Closed', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Clôturé fiscalement"}]}';
        PeriodOpenTxt: Label 'Fiscally Open', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ouvert fiscalement"}]}';
    begin
        Date.SetRange("Period Type", Date."Period Type"::Date);
        Date.SetFilter("Period Start", PeriodRange);
        Date.FindLast();
        AccountingPeriod.SetFilter("Starting Date", '<=%1', Date."Period Start");
        AccountingPeriod.SetRange("New Fiscal Year", true);
        AccountingPeriod.FindLast();
        if AccountingPeriod."Fiscally Closed" then
            exit(PeriodClosedTxt);
        exit(PeriodOpenTxt);
    end;

    local procedure VerifiyDateFilter(pFilter: Text[30])
    var
        MessageErr: Label 'The selected date is not a starting period.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "La date choisie n''est pas un début de période."}]}';
    begin
        if pFilter = ',,,' then
            Error(MessageErr);
    end;

    var
        GLAccount2: Record "G/L Account";
        DateFilterCalc: Codeunit "DateFilter-Calc";
        StartDate: Date;
        PreviousStartDate: Date;
        PreviousEndDate: Date;
        TextDate: Text[30];
        ImprNonMvt: Boolean;
        "Filter": Text;
        FiscalYearStatusText: Text;
        TLAccountType: Integer;
        gDecDebitBegin: Decimal;
        gDecDebitPeriod: Decimal;
        gDecDebitEnd: Decimal;
        gDecCreditBegin: Decimal;
        gDecCreditPeriod: Decimal;
        gDecCreditEnd: Decimal;
        gBooTotal: Boolean;
        GLTrialBalCaptionLbl: Label 'G/L Trial Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Balance comptes généraux"}]}';
        NoCaptionLbl: Label 'No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N°"}]}';
        NameCaptionLbl: Label 'Name', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom"}]}';
        BalAtStartingDateCaptionLbl: Label 'Balance at Starting Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde en début de période"}]}';
        BalDateRangeCaptionLbl: Label 'Balance Date Range', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde plage de dates"}]}';
        BalAtEndingdateCaptionLbl: Label 'Balance at Ending date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde à fin de période"}]}';
        DebitCaptionLbl: Label 'Debit', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Débit"}]}';
        CreditCaptionLbl: Label 'Credit', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Crédit"}]}';
        Text001Lbl: Label 'You must fill in the %1 field.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous devez remplir le champ %1."}]}';
        Text002Lbl: Label 'You must specify a Starting Date.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous devez spécifier une date de début."}]}';
        Text003Lbl: Label 'Printed by ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Imprimé par "}]}';
        Text004Lbl: Label 'Fiscal Year Start Date : %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date de début de l''année fiscale : %1"}]}';
        Text005Lbl: Label 'Page %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Page %1"}]}';
        Text007Lbl: Label 'Fiscal-Year Status: %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "État de l''exercice : %1"}]}';

    local procedure fDecPos(pDec: Decimal): Decimal
    begin
        IF pDec > 0 THEN
            EXIT(pDec);
    end;
}