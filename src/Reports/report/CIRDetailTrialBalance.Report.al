report 50002 "CIR Detail Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRDetailTrialBalance.rdl';
    AdditionalSearchTerms = 'payment due,order status';
    ApplicationArea = Basic, Suite;
    Caption = 'CIR Detail Trial Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "CIR Grand livre" }, { "lang": "FRB", "txt": "CIR Grand livre" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = WHERE("Account Type" = CONST(Posting));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Income/Balance", "Debit/Credit", "Date Filter";
            column(PeriodGLDtFilter; StrSubstNo(Text000Lbl, GLDateFilter))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(ExcludeBalanceOnly; ExcludeBalanceOnly)
            {
            }
            column(PrintReversedEntries; PrintReversedEntries)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(PrintClosingEntries; PrintClosingEntries)
            {
            }
            column(PrintOnlyCorrections; PrintOnlyCorrections)
            {
            }
            column(GLAccTableCaption; TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(EmptyString; '')
            {
            }
            column(No_GLAcc; "No.")
            {
            }
            column(DetailTrialBalCaption; DetailTrialBalCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(PeriodCaption; PeriodCaptionLbl)
            {
            }
            column(OnlyCorrectionsCaption; OnlyCorrectionsCaptionLbl)
            {
            }
            column(NetChangeCaption; NetChangeCaptionLbl)
            {
            }
            column(GLEntryDebitAmtCaption; GLEntryDebitAmtCaptionLbl)
            {
            }
            column(GLEntryCreditAmtCaption; GLEntryCreditAmtCaptionLbl)
            {
            }
            column(GLBalCaption; GLBalCaptionLbl)
            {
            }
            column(LetterCaption; LetterLbl)
            {
            }
            column(PrintSituationEntries; PrintSituationEntries)
            {
            }
            dataitem(PageCounter; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(Name_GLAcc; "G/L Account".Name)
                {
                }
                column(StartBalance; StartBalance)
                {
                    AutoFormatType = 1;
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "G/L Account No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Business Unit Code" = FIELD("Business Unit Filter");
                    DataItemLinkReference = "G/L Account";
                    DataItemTableView = SORTING("G/L Account No.", "Posting Date");
                    column(VATAmount_GLEntry; "VAT Amount")
                    {
                        IncludeCaption = true;
                    }
                    column(DebitAmount_GLEntry; "Debit Amount")
                    {
                    }
                    column(CreditAmount_GLEntry; "Credit Amount")
                    {
                    }
                    column(PostingDate_GLEntry; Format("Posting Date"))
                    {
                    }
                    column(DocumentNo_GLEntry; "Document No.")
                    {
                    }
                    column(ExtDocNo_GLEntry; "External Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_GLEntry; DescriptionX)
                    {
                    }
                    column(GLBalance; GLBalance)
                    {
                        AutoFormatType = 1;
                    }
                    column(EntryNo_GLEntry; "Entry No.")
                    {
                    }
                    column(ClosingEntry; ClosingEntry)
                    {
                    }
                    column(Reversed_GLEntry; Reversed)
                    {
                    }
                    column(letter; letter)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        UserGroup: Record "User Group";
                        CIRUserManagement: Codeunit "CIR User Management";
                    begin
                        if PrintOnlyCorrections then
                            if not (("Debit Amount" < 0) or ("Credit Amount" < 0)) then
                                CurrReport.Skip();
                        if not PrintReversedEntries and Reversed then
                            CurrReport.Skip();

                        GLBalance := GLBalance + Amount;
                        if ("Posting Date" = ClosingDate("Posting Date")) and
                           not PrintClosingEntries
                        then begin
                            "Debit Amount" := 0;
                            "Credit Amount" := 0;
                        end;

                        if "Posting Date" = ClosingDate("Posting Date") then
                            ClosingEntry := true
                        else
                            ClosingEntry := false;

                        if not (CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Allow employees entries"))) then
                            DescriptionX := "Anonymized Description"
                        else
                            DescriptionX := "Description";
                    end;

                    trigger OnPreDataItem()
                    begin
                        GLBalance := StartBalance;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PrintOnlyIfDetail := ExcludeBalanceOnly or (StartBalance = 0);
                end;
            }

            trigger OnAfterGetRecord()
            var
                GLEntry: Record "G/L Entry";
                Date: Record Date;
            begin
                StartBalance := 0;
                if GLDateFilter <> '' then begin
                    Date.SetRange("Period Type", Date."Period Type"::Date);
                    Date.SetFilter("Period Start", GLDateFilter);
                    if Date.FindFirst() then begin
                        SetRange("Date Filter", 0D, ClosingDate(Date."Period Start" - 1));
                        CalcFields("Net Change");
                        StartBalance := "Net Change";
                        SetFilter("Date Filter", GLDateFilter);
                    end;
                end;

                if PrintOnlyOnePerPage then begin
                    GLEntry.Reset();
                    GLEntry.SetRange("G/L Account No.", "No.");
#pragma warning disable AA0175
                    if CurrReport.PrintOnlyIfDetail and GLEntry.FindFirst() then
#pragma warning restore AA0175
                        PageGroupNo := PageGroupNo + 1;
                end;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
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
                    field(NewPageperGLAcc; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New page per G/L Acc.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nouvelle page par compte général" }, { "lang": "FRB", "txt": "Nouvelle page par compte général" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        ToolTip = 'Specifies if each G/L account information is printed on a new page if you have chosen two or more G/L accounts to be included in the report.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique si les informations de chaque compte général sont imprimées sur une nouvelle page si vous avez choisi deux comptes généraux ou plus à inclure dans le rapport." }, { "lang": "FRB", "txt": "Indique si les informations de chaque compte général sont imprimées sur une nouvelle page si vous avez choisi deux comptes généraux ou plus à inclure dans le rapport." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    }
                    field(ExcludeGLAccsHaveBalanceOnly; ExcludeBalanceOnly)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exclude G/L Accs. that have a balance only', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Exclure les comptes généraux qui ont un solde seulement" }, { "lang": "FRB", "txt": "Exclure les comptes généraux qui ont un solde seulement" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        ToolTip = 'Specifies if you do not want the report to include entries for G/L accounts that have a balance but do not have a net change during the selected time period.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique si vous ne voulez pas que le rapport inclue les entrées pour les comptes généraux qui ont un solde mais qui n''ont pas de changement net pendant la période sélectionnée." }, { "lang": "FRB", "txt": "Indique si vous ne voulez pas que le rapport inclue les entrées pour les comptes généraux qui ont un solde mais qui n''ont pas de changement net pendant la période sélectionnée." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        MultiLine = true;
                    }
                    field(InclClosingEntriesWithinPeriod; PrintClosingEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include closing entries within the period', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Inclure les écritures de clôture dans la période" }, { "lang": "FRB", "txt": "Inclure les écritures de clôture dans la période" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        ToolTip = 'Specifies if you want the report to include closing entries. This is useful if the report covers an entire fiscal year. Closing entries are listed on a fictitious date between the last day of one fiscal year and the first day of the next one. They have a C before the date, such as C123194. If you do not select this field, no closing entries are shown.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique si vous voulez que le rapport comprenne les écritures de clôture. Ceci est utile si le rapport couvre un exercice fiscal entier. Les écritures de clôture sont répertoriées à une date fictive située entre le dernier jour d''un exercice et le premier jour de l''exercice suivant. Elles comportent un C devant la date, par exemple C123194. Si vous ne sélectionnez pas ce champ, aucune entrée de clôture n''est affichée." }, { "lang": "FRB", "txt": "Indique si vous voulez que le rapport comprenne les écritures de clôture. Ceci est utile si le rapport couvre un exercice fiscal entier. Les écritures de clôture sont répertoriées à une date fictive située entre le dernier jour d''un exercice et le premier jour de l''exercice suivant. Elles comportent un C devant la date, par exemple C123194. Si vous ne sélectionnez pas ce champ, aucune entrée de clôture n''est affichée." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        MultiLine = true;
                    }
                    field(IncludeReversedEntries; PrintReversedEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Reversed Entries', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Inclure écritures contrepassées" }, { "lang": "FRB", "txt": "Inclure écritures contrepassées" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        ToolTip = 'Specifies if you want to include reversed entries in the report.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique si vous voulez inclure les écritures contrepassées dans le rapport." }, { "lang": "FRB", "txt": "Indique si vous voulez inclure les écritures contrepassées dans le rapport." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    }
                    field(PrintCorrectionsOnly; PrintOnlyCorrections)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print corrections only', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Imprimer les corrections seulement" }, { "lang": "FRB", "txt": "Imprimer les corrections seulement" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        ToolTip = 'Specifies if you want the report to show only the entries that have been reversed and their matching correcting entries.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique si vous voulez que le rapport affiche uniquement les écritures qui ont été annulées et les écritures correctrices correspondantes." }, { "lang": "FRB", "txt": "Indique si vous voulez que le rapport affiche uniquement les écritures qui ont été annulées et les écritures correctrices correspondantes." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    }
                    field(IncludePrintSituationEntries; PrintSituationEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Situation Entries', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Imprimer les écritures de situations" }, { "lang": "FRB", "txt": "Imprimer les écritures de situation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                        ToolTip = 'Specifies if you want the report to show the situations entries.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique si vous voulez que le rapport affiche les écritures de situations." }, { "lang": "FRB", "txt": "Indique si vous voulez que le rapport affiche les écritures de situations." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    }
                }
            }
        }
    }

    labels
    {
        PostingDateCaption = 'Posting Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date comptabilisation" }, { "lang": "FRB", "txt": "Date comptabilisation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        DocNoCaption = 'Document No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° document"},{"lang":"FRB","txt":"N° document"},{"lang":"DEU","txt":""},{"lang":"ESP","txt":""},{"lang":"ITA","txt":""},{"lang":"NLB","txt":""},{"lang":"NLD","txt":""},{"lang":"PTG","txt":""}]}';
        DescCaption = 'Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Description" }, { "lang": "FRB", "txt": "Description" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        VATAmtCaption = 'VAT Amount', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Montant TVA" }, { "lang": "FRB", "txt": "Montant TVA" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        EntryNoCaption = 'Entry No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° de séquence" }, { "lang": "FRB", "txt": "N° de séquence" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    }

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GetFilters;
        GLDateFilter := "G/L Account".GetFilter("Date Filter");
    end;

    var
        Text000Lbl: Label 'Period: %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Periode: %1" }, { "lang": "FRB", "txt": "Periode: %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GLDateFilter: Text;
        GLFilter: Text;
        GLBalance: Decimal;
        StartBalance: Decimal;
        DescriptionX: Text;
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        PrintClosingEntries: Boolean;
        PrintOnlyCorrections: Boolean;
        PrintReversedEntries: Boolean;
        PrintSituationEntries: Boolean;
        PageGroupNo: Integer;
        ClosingEntry: Boolean;
        DetailTrialBalCaptionLbl: Label 'Detail Trial Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Grand livre" }, { "lang": "FRB", "txt": "Grand livre" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        PageCaptionLbl: Label 'Page', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Page" }, { "lang": "FRB", "txt": "Page" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        BalanceCaptionLbl: Label 'This also includes general ledger accounts that only have a balance.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Cela inclut également les comptes du grand livre qui n''ont qu''un solde." }, { "lang": "FRB", "txt": "Cela inclut également les comptes du grand livre qui n''ont qu''un solde." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        PeriodCaptionLbl: Label 'This report also includes closing entries within the period.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ce rapport comprend également les écritures de clôture de la période." }, { "lang": "FRB", "txt": "Ce rapport comprend également les écritures de clôture de la période." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        OnlyCorrectionsCaptionLbl: Label 'Only corrections are included.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Seules les corrections sont incluses." }, { "lang": "FRB", "txt": "Seules les corrections sont incluses." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        NetChangeCaptionLbl: Label 'Net Change', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde période" }, { "lang": "FRB", "txt": "Solde période" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GLEntryDebitAmtCaptionLbl: Label 'Debit', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Débit" }, { "lang": "FRB", "txt": "Débit" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GLEntryCreditAmtCaptionLbl: Label 'Credit', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Crédit" }, { "lang": "FRB", "txt": "Crédit" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        GLBalCaptionLbl: Label 'Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Solde" }, { "lang": "FRB", "txt": "Solde" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        LetterLbl: Label 'Letter', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Lettre" }, { "lang": "FRB", "txt": "Lettre" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';

    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean; NewExcludeBalanceOnly: Boolean; NewPrintClosingEntries: Boolean; NewPrintReversedEntries: Boolean; NewPrintOnlyCorrections: Boolean; NewPrintSituationEntries: Boolean)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        ExcludeBalanceOnly := NewExcludeBalanceOnly;
        PrintClosingEntries := NewPrintClosingEntries;
        PrintReversedEntries := NewPrintReversedEntries;
        PrintOnlyCorrections := NewPrintOnlyCorrections;
        PrintSituationEntries := NewPrintSituationEntries;
    end;
}