report 50500 "CIR G/L Detail Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Src/001_Situation/CIRGLDetailTrialBalance.report.rdl';
    Caption = 'G/L Detail Trial Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Grand livre comptes généraux" }, { "lang": "FRB", "txt": "Grand livre comptes généraux" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    UsageCategory = None;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Date Filter", "CIR G/L Entry Type Filter";
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName())
            {
            }
            column(STRSUBSTNO_Text004_PreviousStartDate_; StrSubstNo(Text004Lbl, PreviousStartDate))
            {
            }
            column(PageCaption; StrSubstNo(Text005Lbl, ' '))
            {
            }
            column(UserCaption; StrSubstNo(Text003Lbl, ''))
            {
            }
            column(GLAccountTABLECAPTIONAndFilter; "G/L Account".TableCaption() + ': ' + Filter)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(FiscalYearStatusText; FiscalYearStatusText)
            {
            }
            column(No_GLAccount; "No.")
            {
            }
            column(Name_GLAccount; Name)
            {
            }
            column(DebitAmount_GLAccount; "G/L Account"."CIR Debit Amount")
            {
            }
            column(CreditAmount_GLAccount; "G/L Account"."CIR Credit Amount")
            {
            }
            column(STRSUBSTNO_Text006_PreviousEndDate_; StrSubstNo(Text006Lbl, PreviousEndDate))
            {
            }
            column(DebitAmount_GLAccount2; GLAccount2."CIR Debit Amount")
            {
            }
            column(CreditAmount_GLAccount2; GLAccount2."CIR Credit Amount")
            {
            }
            column(STRSUBSTNO_Text006_EndDate_; StrSubstNo(Text006Lbl, EndDate))
            {
            }
            column(ShowBodyGLAccount; ShowBodyGLAccount)
            {
            }
            column(G_L_Account_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(G_L_Account_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(G_L_Detail_Trial_BalanceCaption; G_L_Detail_Trial_BalanceCaptionLbl)
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
            column(Grand_TotalCaption; Grand_TotalCaptionLbl)
            {
            }
            column(OrderNoLbl; OrderNoLbl) { }
            dataitem(Date; Date)
            {
                DataItemTableView = SORTING("Period Type");
                PrintOnlyIfDetail = true;
                column(STRSUBSTNO_Text007_EndDate_; StrSubstNo(Text007Lbl, EndDate))
                {
                }
                column(Date_PeriodNo; PeriodDate."Period No.")
                {
                }
                column(PostingYear; Date2DMY("G/L Entry"."Posting Date", 3))
                {
                }
                column(Date_Period_Type; "Period Type")
                {
                }
                column(Total_Date_RangeCaption; Total_Date_RangeCaptionLbl)
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "G/L Account No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "CIR Entry Type" = field("CIR G/L Entry Type Filter");
                    DataItemLinkReference = "G/L Account";
                    DataItemTableView = SORTING("G/L Account No.");
                    column(DebitAmount_GLEntry; "G/L Entry"."Debit Amount")
                    {
                    }
                    column(CreditAmount_GLEntry; "G/L Entry"."Credit Amount")
                    {
                    }
                    column(PostingDate_GLEntry; Format("Posting Date"))
                    {
                    }
                    column(SourceCode_GLEntry; "Source Code")
                    {
                    }
                    column(DocumentNo_GLEntry; "Document No.")
                    {
                    }
                    column(ExternalDocumentNo_GLEntry; "External Document No.")
                    {
                    }
                    column(Description_GLEntry; Description)
                    {
                    }
                    column(Balance; Balance)
                    {
                    }
                    column(EntryNo_GLEntry; "G/L Entry"."Entry No.")
                    {
                    }
                    column(Date_PeriodType_PeriodName; Text008Lbl + ' ' + Format(PeriodDate."Period Type") + ' ' + PeriodDate."Period Name")
                    {
                    }
                    column(TotalByInt; TotalByInt)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ("Debit Amount" = 0) and
                           ("Credit Amount" = 0)
                        then
                            CurrReport.Skip();
                        Balance := Balance + "Debit Amount" - "Credit Amount";
                    end;

                    trigger OnPreDataItem()
                    begin
                        if DocNumSort then
                            SetCurrentKey("G/L Account No.", "Document No.", "Posting Date");
                        SetRange("Posting Date", PeriodDate."Period Start", PeriodDate."Period End");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Period Type", TotalBy);
                    SetRange("Period Start", StartDate, ClosingDate(EndDate));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GLAccount2.Copy("G/L Account");
                if GLAccount2."Income/Balance" = 0 then
                    GLAccount2.SetRange("Date Filter", PreviousStartDate, PreviousEndDate)
                else
                    GLAccount2.SetRange("Date Filter", 0D, PreviousEndDate);
                GLAccount2.CalcFields("CIR Debit Amount", "CIR Credit Amount");
                GLAccount2.Balance := GLAccount2."CIR Debit Amount" - GLAccount2."CIR Credit Amount";
                if "Income/Balance" = 0 then
                    SetRange("Date Filter", StartDate, EndDate)
                else
                    SetRange("Date Filter", 0D, EndDate);
                CalcFields("CIR Debit Amount", "CIR Credit Amount");
                if ("CIR Debit Amount" = 0) and ("CIR Credit Amount" = 0) then
                    CurrReport.Skip();

                ShowBodyGLAccount :=
                  ((GLAccount2."CIR Debit Amount" = "CIR Debit Amount") and (GLAccount2."CIR Credit Amount" = "CIR Credit Amount")) or ("Account Type" <> 0);
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Date Filter") = '' then
                    Error(Text001Lbl, FieldCaption("Date Filter"));
                if CopyStr(GetFilter("Date Filter"), 1, 1) = '.' then
                    Error(Text002Lbl);
                StartDate := GetRangeMin("Date Filter");
                PeriodDate.SetRange("Period Start", StartDate);
                case TotalBy of
                    TotalBy::" ":
                        PeriodDate.SetRange("Period Type", PeriodDate."Period Type"::Date);
                    TotalBy::Week:
                        PeriodDate.SetRange("Period Type", PeriodDate."Period Type"::Week);
                    TotalBy::Month:
                        PeriodDate.SetRange("Period Type", PeriodDate."Period Type"::Month);
                    TotalBy::Quarter:
                        PeriodDate.SetRange("Period Type", PeriodDate."Period Type"::Quarter);
                    TotalBy::Year:
                        PeriodDate.SetRange("Period Type", PeriodDate."Period Type"::Year);
                end;
                if not PeriodDate.FindFirst() then
                    Error(Text010Lbl, StartDate, PeriodDate.GetFilter("Period Type"));
                PreviousEndDate := ClosingDate(StartDate - 1);
                DateFilterCalc.CreateFiscalYearFilter(TextDate, TextDate, StartDate, 0);
                TextDate := ConvertStr(TextDate, '.', ',');
                VerifiyDateFilter(TextDate);
                TextDate := CopyStr(TextDate, 1, 8);
                Evaluate(PreviousStartDate, TextDate);
                if CopyStr(GetFilter("Date Filter"), StrLen(GetFilter("Date Filter")), 1) = '.' then
                    EndDate := 0D
                else
                    EndDate := GetRangeMax("Date Filter");
                Clear(PeriodDate);
                PeriodDate.SetRange("Period End", ClosingDate(EndDate));
                case TotalBy of
                    TotalBy::" ":
                        PeriodDate.SetRange("Period Type", PeriodDate."Period Type"::Date);
                    TotalBy::Week:
                        PeriodDate.SetRange("Period Type", PeriodDate."Period Type"::Week);
                    TotalBy::Month:
                        PeriodDate.SetRange("Period Type", PeriodDate."Period Type"::Month);
                    TotalBy::Quarter:
                        PeriodDate.SetRange("Period Type", PeriodDate."Period Type"::Quarter);
                    TotalBy::Year:
                        PeriodDate.SetRange("Period Type", PeriodDate."Period Type"::Year);
                end;
                if not PeriodDate.FindFirst() then
                    Error(Text011Lbl, EndDate, PeriodDate.GetFilter("Period Type"));
                FiscalYearStatusText := StrSubstNo(Text012Lbl, CheckFiscalYearStatus(CopyStr(GetFilter("Date Filter"), 1, 30)));

                TotalByInt := TotalBy;
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
                    field(SummarizeBy; TotalBy)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Summarize by', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Résumez en" }, { "lang": "FRB", "txt": "Résumez en" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        OptionCaption = ' ,Week,Month,Quarter,Year', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": " ,Semaine,Mois,Trimestre,Année" }, { "lang": "FRB", "txt": " ,Semaine,Mois,Trimestre,Année" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        ToolTip = 'Specifies the period for which you ant subtotals on the report.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la période pour laquelle vous souhaitez des sous-totaux sur le rapport." }, { "lang": "FRB", "txt": "Spécifie la période pour laquelle vous souhaitez des sous-totaux sur le rapport." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    }
                    field(SortedByDocumentNo; DocNumSort)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sorted by Document No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Trié par n° document" }, { "lang": "FRB", "txt": "Trié par n° document" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        ToolTip = 'Specifies criteria for arranging information in the report.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie les critères d''organisation des informations dans le rapport." }, { "lang": "FRB", "txt": "Spécifie les critères d''organisation des informations dans le rapport." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
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
        TotalBy := TotalBy::Month
    end;

    trigger OnPreReport()
    begin
        Filter := "G/L Account".GetFilters();
    end;

    local procedure CheckFiscalYearStatus(PeriodRange: Text[30]): Text[30]
    var
        AccountingPeriod: Record "Accounting Period";
        Date: Record Date;
        PeriodOpenTxt: Label 'Fiscally Open', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ouvert fiscalement" }, { "lang": "FRB", "txt": "Ouvert fiscalement" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        PeriodClosedTxt: Label 'Fiscally Closed', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Clôturé fiscalement" }, { "lang": "FRB", "txt": "Clôturé fiscalement" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
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
        MessageErr: Label 'The selected date is not a starting period.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "La date choisie n''est pas un début de période." }, { "lang": "FRB", "txt": "La date choisie n''est pas un début de période." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        if pFilter = ',,,' then
            Error(MessageErr);
    end;

    var
        GLAccount2: Record "G/L Account";
        PeriodDate: Record Date;
        // FiscalYearFiscalClose: Codeunit "Fiscal Year-FiscalClose";
        DateFilterCalc: Codeunit "DateFilter-Calc";
        StartDate: Date;
        EndDate: Date;
        PreviousStartDate: Date;
        PreviousEndDate: Date;
        TextDate: Text[30];
        Balance: Decimal;
        TotalBy: Option " ",Week,Month,Quarter,Year;
        DocNumSort: Boolean;
        ShowBodyGLAccount: Boolean;
        "Filter": Text;
        FiscalYearStatusText: Text;
        TotalByInt: Integer;
        Text010Lbl: Label 'The selected starting date %1 is not the start of a %2.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "La date de début sélectionnée %1 ne correspond pas au début de %2." }, { "lang": "FRB", "txt": "La date de début sélectionnée %1 ne correspond pas au début de %2." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text011Lbl: Label 'The selected ending date %1 is not the end of a %2.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "La date de fin sélectionnée %1 ne correspond pas à la fin de %2." }, { "lang": "FRB", "txt": "La date de fin sélectionnée %1 ne correspond pas à la fin de %2." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text012Lbl: Label 'Fiscal-Year Status: %1', Comment = '{ "instructions": "%1 = date", "translations": [ { "lang": "FRA", "txt": "État de l''année fiscale : %." }, { "lang": "FRB", "txt": "État de l''année fiscale : %." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        G_L_Detail_Trial_BalanceCaptionLbl: Label 'G/L Detail Trial Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Grand livre comptes généraux" }, { "lang": "FRB", "txt": "Grand livre comptes généraux" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Posting_DateCaptionLbl: Label 'Posting Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date comptabilisation" }, { "lang": "FRB", "txt": "Date comptabilisation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Source_CodeCaptionLbl: Label 'Source Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code journal" }, { "lang": "FRB", "txt": "Code journal" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Document_No_CaptionLbl: Label 'Document No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° document" }, { "lang": "FRB", "txt": "N° document" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        External_Document_No_CaptionLbl: Label 'External Document No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° doc. externe" }, { "lang": "FRB", "txt": "N° doc. externe" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        DescriptionCaptionLbl: Label 'Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Description" }, { "lang": "FRB", "txt": "Description" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        DebitCaptionLbl: Label 'Debit', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Débit" }, { "lang": "FRB", "txt": "Débit" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        CreditCaptionLbl: Label 'Credit', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Crédit" }, { "lang": "FRB", "txt": "Crédit" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        BalanceCaptionLbl: Label 'Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde" }, { "lang": "FRB", "txt": "Solde" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Grand_TotalCaptionLbl: Label 'Grand Total', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Total général" }, { "lang": "FRB", "txt": "Total général" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Total_Date_RangeCaptionLbl: Label 'Total Date Range', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Total de la période" }, { "lang": "FRB", "txt": "Total de la période" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text001Lbl: Label 'You must fill in the %1 field.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous devez remplir le champ %1." }, { "lang": "FRB", "txt": "Vous devez remplir le champ %1." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text002Lbl: Label 'You must specify a Starting Date.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous devez spécifier une date de début." }, { "lang": "FRB", "txt": "Vous devez spécifier une date de début." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text003Lbl: Label 'Printed by %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Imprimé par %1" }, { "lang": "FRB", "txt": "Imprimé par %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text004Lbl: Label 'Fiscal Year Start Date : %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date de début de l''année fiscale : %1" }, { "lang": "FRB", "txt": "Date de début de l''année fiscale : %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text005Lbl: Label 'Page %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Page %1" }, { "lang": "FRB", "txt": "Page %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text006Lbl: Label 'Balance at %1 ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde au %1" }, { "lang": "FRB", "txt": "Solde au %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text007Lbl: Label 'Balance at %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde au %1" }, { "lang": "FRB", "txt": "Solde au %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text008Lbl: Label 'Total', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Total" }, { "lang": "FRB", "txt": "Total" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        OrderNoLbl: Label 'Order No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° commande" }, { "lang": "FRB", "txt": "N° commande" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
}
