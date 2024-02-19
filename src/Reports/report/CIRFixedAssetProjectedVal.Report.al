report 50020 "CIR Fixed Asset-Projected Val."
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRFixedAssetProjectedValue.rdl';
    ApplicationArea = FixedAssets;
    Caption = 'Fixed Asset Projected Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valeur projetée de l''immobilisation"}]}';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "FA Class Code", "FA Subclass Code", "Budgeted Asset";
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(DeprBookText; DeprBookText)
            {
            }
            column(FixedAssetTabcaptFAFilter; TableCaption + ': ' + FAFilter)
            {
            }
            column(FAFilter; FAFilter)
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }
            column(ProjectedDisposal; gProjectedDisposal)
            {
            }
            column(DeprBookUseCustom1Depr; DeprBook."Use Custom 1 Depreciation")
            {
            }
            column(DoProjectedDisposal; DoProjectedDisposal)
            {
            }
            column(GroupTotalsInt; GroupTotalsInt)
            {
            }
            column(IncludePostedFrom; Format(gIncludePostedFrom))
            {
            }
            column(GroupCodeName; GroupCodeName)
            {
            }
            column(FANo; FANo)
            {
            }
            column(FADescription; FADescription)
            {
            }
            column(GroupHeadLine; GroupHeadLine)
            {
            }
            column(FixedAssetNo; "No.")
            {
            }
            column(Description_FixedAsset; Description)
            {
            }
            column(DeprText2; DeprText2)
            {
            }
            column(Text002GroupHeadLine; GroupTotalTxt_Lbl + ': ' + GroupHeadLine)
            {
            }
            column(Custom1Text; Custom1Text)
            {
            }
            column(DeprCustom1Text; DeprCustom1Text)
            {
            }
            column(SalesPriceFieldname; SalesPriceFieldname)
            {
            }
            column(GainLossFieldname; GainLossFieldname)
            {
            }
            column(GroupAmounts3; GroupAmounts[3])
            {
                AutoFormatType = 1;
            }
            column(GroupAmounts4; GroupAmounts[4])
            {
                AutoFormatType = 1;
            }
            column(FAClassCode_FixedAsset; "FA Class Code")
            {
            }
            column(FASubclassCode_FixedAsset; "FA Subclass Code")
            {
            }
            column(GlobalDim1Code_FixedAsset; "Global Dimension 1 Code")
            {
            }
            column(GlobalDim2Code_FixedAsset; "Global Dimension 2 Code")
            {
            }
            column(GlobalDim4Code_FixedAsset; "Job No.")
            {
            }
            column(FALocationCode_FixedAsset; "FA Location Code")
            {
            }
            column(CompofMainAss_FixedAsset; "Component of Main Asset")
            {
            }
            column(FAPostingGroup_FixedAsset; "FA Posting Group")
            {
            }
            column(CurrReportPAGENOCaption; PageNoLbl)
            {
            }
            column(FixedAssetProjectedValueCaption; FAProjectedValueLbl)
            {
            }
            column(FALedgerEntryFAPostingDateCaption; FAPostingDateLbl)
            {
            }
            column(BookValueCaption; BookValueLbl)
            {
            }
            dataitem("FA Ledger Entry"; "FA Ledger Entry")
            {
                DataItemTableView = SORTING("FA No.", "Depreciation Book Code", "FA Posting Date");
                column(FAPostingDt_FALedgerEntry; Format("FA Posting Date"))
                {
                }
                column(PostingDt_FALedgerEntry; "FA Posting Type")
                {
                    IncludeCaption = true;
                }
                column(Amount_FALedgerEntry; Amount)
                {
                    IncludeCaption = true;
                }
                column(FANo_FALedgerEntry; "FA No.")
                {
                }
                column(BookValue; BookValue)
                {
                    AutoFormatType = 1;
                }
                column(NoofDeprDays_FALedgEntry; "No. of Depreciation Days")
                {
                    IncludeCaption = true;
                }
                column(FALedgerEntryEntryNo; "Entry No.")
                {
                }
                column(PostedEntryCaption; PostedEntryLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Part of Book Value" then
                        BookValue := BookValue + Amount;
                    if "FA Posting Date" < gIncludePostedFrom then
                        CurrReport.Skip();
                    EntryPrinted := true;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("FA No.", "Fixed Asset"."No.");
                    SetRange("Depreciation Book Code", DeprBookCode);
                    BookValue := 0;
                    if (gIncludePostedFrom = 0D) or not PrintDetails then
                        CurrReport.Break();
                end;
            }
            dataitem(ProjectedDepreciation; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 .. 1000000));
                column(DeprAmount; DeprAmount)
                {
                    AutoFormatType = 1;
                }
                column(EntryAmt1Custom1Amt; EntryAmounts[1] - Custom1Amount)
                {
                    AutoFormatType = 1;
                }
                column(FormatUntilDate; Format(UntilDate))
                {
                }
                column(DeprText; DeprText)
                {
                }
                column(NumberOfDays; gNumberOfDays)
                {
                }
                column(No1_FixedAsset; "Fixed Asset"."No.")
                {
                }
                column(Custom1Text_ProjectedDepr; Custom1Text)
                {
                }
                column(Custom1NumberOfDays; Custom1NumberOfDays)
                {
                }
                column(Custom1Amount; Custom1Amount)
                {
                    AutoFormatType = 1;
                }
                column(EntryAmounts1; EntryAmounts[1])
                {
                    AutoFormatType = 1;
                }
                column(AssetAmounts1; AssetAmounts[1])
                {
                    AutoFormatType = 1;
                }
                column(Description1_FixedAsset; "Fixed Asset".Description)
                {
                }
                column(AssetAmounts2; AssetAmounts[2])
                {
                    AutoFormatType = 1;
                }
                column(AssetAmt1AssetAmt2; AssetAmounts[1] + AssetAmounts[2])
                {
                    AutoFormatType = 1;
                }
                column(DeprCustom1Text_ProjectedDepr; DeprCustom1Text)
                {
                }
                column(AssetAmounts3; AssetAmounts[3])
                {
                    AutoFormatType = 1;
                }
                column(AssetAmounts4; AssetAmounts[4])
                {
                    AutoFormatType = 1;
                }
                column(SalesPriceFieldname_ProjectedDepr; SalesPriceFieldname)
                {
                }
                column(GainLossFieldname_ProjectedDepr; GainLossFieldname)
                {
                }
                column(GroupAmounts_1; GroupAmounts[1])
                {
                }
                column(GroupTotalBookValue; GroupTotalBookValue)
                {
                }
                column(TotalBookValue_1; TotalBookValue[1])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if UntilDate >= EndingDate then
                        CurrReport.Break();
                    if Number = 1 then begin
                        CalculateFirstDeprAmount(Done);
                        if FADeprBook."Book Value" <> 0 then
                            Done := Done or not EntryPrinted;
                    end else
                        CalculateSecondDeprAmount(Done);
                    if Done then
                        UpdateTotals()
                    else
                        UpdateGroupTotals();

                    if Done then
                        if DoProjectedDisposal then
                            CalculateGainLoss();
                end;

                trigger OnPostDataItem()
                begin
                    if DoProjectedDisposal then begin
                        TotalAmounts[3] += AssetAmounts[3];
                        TotalAmounts[4] += AssetAmounts[4];
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                case gGroupTotals of
                    gGroupTotals::"FA Class":
                        NewValue := "FA Class Code";
                    gGroupTotals::"FA Subclass":
                        NewValue := "FA Subclass Code";
                    gGroupTotals::"FA Location":
                        NewValue := "FA Location Code";
                    gGroupTotals::"Main Asset":
                        NewValue := "Component of Main Asset";
                    gGroupTotals::"Global Dimension 1":
                        NewValue := "Global Dimension 1 Code";
                    gGroupTotals::"Global Dimension 2":
                        NewValue := "Global Dimension 2 Code";
                    gGroupTotals::"FA Posting Group":
                        NewValue := "FA Posting Group";
                    gGroupTotals::"Global Dimension 4 (Project)":
                        NewValue := "Job No.";
                end;

                if NewValue <> OldValue then begin
                    MakeGroupHeadLine();
                    InitGroupTotals();
                    OldValue := NewValue;
                end;

                if not FADeprBook.Get("No.", DeprBookCode) then
                    CurrReport.Skip();
                if SkipRecord() then
                    CurrReport.Skip();

                if gGroupTotals = gGroupTotals::"FA Posting Group" then
                    if "FA Posting Group" <> FADeprBook."FA Posting Group" then
                        Error(HasBeenModifiedInFAErr_Lbl, FieldCaption("FA Posting Group"), "No.");

                StartingDate := StartingDate2;
                EndingDate := EndingDate2;
                DoProjectedDisposal := false;
                EntryPrinted := false;
                if gProjectedDisposal and
                   (FADeprBook."Projected Disposal Date" > 0D) and
                   (FADeprBook."Projected Disposal Date" <= EndingDate)
                then begin
                    EndingDate := FADeprBook."Projected Disposal Date";
                    if StartingDate > EndingDate then
                        StartingDate := EndingDate;
                    DoProjectedDisposal := true;
                end;

                TransferValues();
            end;

            trigger OnPreDataItem()
            begin
                case gGroupTotals of
                    gGroupTotals::"FA Class":
                        SetCurrentKey("FA Class Code");
                    gGroupTotals::"FA Subclass":
                        SetCurrentKey("FA Subclass Code");
                    gGroupTotals::"FA Location":
                        SetCurrentKey("FA Location Code");
                    gGroupTotals::"Main Asset":
                        SetCurrentKey("Component of Main Asset");
                    gGroupTotals::"Global Dimension 1":
                        SetCurrentKey("Global Dimension 1 Code");
                    gGroupTotals::"Global Dimension 2":
                        SetCurrentKey("Global Dimension 2 Code");
                    gGroupTotals::"FA Posting Group":
                        SetCurrentKey("FA Posting Group");
                    gGroupTotals::"Global Dimension 4 (Project)":
                        SetCurrentKey("Job No.");
                end;

                GroupTotalsInt := gGroupTotals;
                MakeGroupHeadLine();
                InitGroupTotals();
            end;
        }
        dataitem(ProjectionTotal; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(TotalBookValue2; TotalBookValue[2])
            {
                AutoFormatType = 1;
            }
            column(TotalAmounts1; TotalAmounts[1])
            {
                AutoFormatType = 1;
            }
            column(DeprText2_ProjectionTotal; DeprText2)
            {
            }
            column(ProjectedDisposal_ProjectionTotal; gProjectedDisposal)
            {
            }
            column(DeprBookUseCustDepr_ProjectionTotal; DeprBook."Use Custom 1 Depreciation")
            {
            }
            column(Custom1Text_ProjectionTotal; Custom1Text)
            {
            }
            column(TotalAmounts2; TotalAmounts[2])
            {
                AutoFormatType = 1;
            }
            column(DeprCustom1Text_ProjectionTotal; DeprCustom1Text)
            {
            }
            column(TotalAmt1TotalAmt2; TotalAmounts[1] + TotalAmounts[2])
            {
                AutoFormatType = 1;
            }
            column(SalesPriceFieldname_ProjectionTotal; SalesPriceFieldname)
            {
            }
            column(GainLossFieldname_ProjectionTotal; GainLossFieldname)
            {
            }
            column(TotalAmounts3; TotalAmounts[3])
            {
                AutoFormatType = 1;
            }
            column(TotalAmounts4; TotalAmounts[4])
            {
                AutoFormatType = 1;
            }
            column(TotalCaption; TotalLbl)
            {
            }
        }
        dataitem(Buffer; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(DeprBookText_Buffer; DeprBookText)
            {
            }
            column(Custom1TextText_Buffer; Custom1Text)
            {
            }
            column(GroupCodeName2; GroupCodeName2)
            {
            }
            column(FAPostingDate_FABufferProjection; Format(TempFABufferProjection."FA Posting Date"))
            {
            }
            column(Desc_FABufferProjection; TempFABufferProjection.Depreciation)
            {
            }
            column(Cust1_FABufferProjection; TempFABufferProjection."Custom 1")
            {
            }
            column(CodeName_FABufferProj; TempFABufferProjection."Code Name")
            {
            }
            column(ProjectedAmountsperDateCaption; ProjectedAmountsPerDateLbl)
            {
            }
            column(FABufferProjectionFAPostingDateCaption; FABufferProjectionFAPostingDateLbl)
            {
            }
            column(FABufferProjectionDepreciationCaption; FABufferProjectionDepreciationLbl)
            {
            }
            column(FixedAssetProjectedValueCaption_Buffer; FABufferProjectedValueLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                    if not TempFABufferProjection.FindFirst() then
                        CurrReport.Break();
                end else
                    if TempFABufferProjection.Next() = 0 then
                        CurrReport.Break();
            end;

            trigger OnPreDataItem()
            begin
                if not gPrintAmountsPerDate then
                    CurrReport.Break();
                TempFABufferProjection.Reset();
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
                    field(DepreciationBook; DeprBookCode)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Depreciation Book', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Livre d''amortissement"}]}';
                        TableRelation = "Depreciation Book";
                        ToolTip = 'Specifies the code for the depreciation book to be included in the report or batch job.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le code du livre d''amortissement à inclure dans le rapport ou le traitement par lots."}]}';

                        trigger OnValidate()
                        begin
                            UpdateReqForm();
                        end;
                    }
                    field(FirstDeprDate; StartingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'First Depreciation Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Première date d''amortissement"}]}';
                        ToolTip = 'Specifies the date to be used as the first date in the period for which you want to calculate projected depreciation.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la date à utiliser comme première date de la période pour laquelle vous souhaitez calculer l''amortissement prévisionnel."}]}';
                    }
                    field(LastDeprDate; EndingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Last Depreciation Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Dernière date d''amortissement"}]}';
                        ToolTip = 'Specifies the Fixed Asset posting date of the last posted depreciation.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Indique la date de comptabilisation des immobilisations du dernier amortissement comptabilisé."}]}';
                    }
                    field(NumberOfDays; PeriodLength)
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        Caption = 'Number of Days', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de jours"}]}';
                        Editable = NumberOfDaysCtrlEditable;
                        MinValue = 0;
                        ToolTip = 'Specifies the length of the periods between the first depreciation date and the last depreciation date. The program then calculates depreciation for each period. If you leave this field blank, the program automatically sets the contents of this field to equal the number of days in a fiscal year, normally 360.'
                                    , Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la durée des périodes entre la première date d''amortissement et la dernière date d''amortissement. Le programme calcule ensuite l''amortissement pour chaque période. Si vous laissez ce champ vide, le programme définit automatiquement le contenu de ce champ pour qu''il soit égal au nombre de jours d''une année fiscale, normalement 360."}]}';

                        trigger OnValidate()
                        begin
                            if PeriodLength > 0 then
                                gUseAccountingPeriod := false;
                        end;
                    }
                    field(DaysInFirstPeriod; gDaysInFirstPeriod)
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        Caption = 'No. of Days in First Period', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de jours dans la première période"}]}';
                        MinValue = 0;
                        ToolTip = 'Specifies the number of days that must be used for calculating the depreciation as of the first depreciation date, regardless of the actual number of days from the last depreciation entry. The number you enter in this field does not affect the total number of days from the starting date to the ending date.'
                                , Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le nombre de jours qui doivent être utilisés pour calculer l''amortissement à compter de la première date d''amortissement, quel que soit le nombre réel de jours depuis la dernière écriture d''amortissement. Le nombre que vous entrez dans ce champ n''affecte pas le nombre total de jours entre la date de début et la date de fin."}]}';
                    }
                    field(IncludePostedFrom; gIncludePostedFrom)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Posted Entries From', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Entrées publiées de"}]}';
                        ToolTip = 'Specifies the fixed asset posting date from which the report includes all types of posted entries.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la date de comptabilisation des immobilisations à partir de laquelle le rapport inclut tous les types d''écritures comptabilisées."}]}';
                    }
                    field(GroupTotals; gGroupTotals)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Group Totals', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Totaux de groupe"}]}';
                        OptionCaption = ' ,FA Class,FA Subclass,FA Location,Main Asset,Global Dimension 1,Global Dimension 2,FA Posting Group,Global Dimension 4 (Project)', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":" ,Classe immo.,Sous-classe immo.,Emplacement immo.,Immo. principale,Axe principal 1,Axe principal 2,Groupe compta. immo.,Axe projet"}]}';
                        ToolTip = 'Specifies if you want the report to group fixed assets and print totals using the category defined in this field. For example, maintenance expenses for fixed assets can be shown for each fixed asset class.'
                                , Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Indique si vous souhaitez que le rapport regroupe les immobilisations et imprime les totaux à l''aide de la catégorie définie dans ce champ. Par exemple, les dépenses d''entretien des immobilisations peuvent être affichées pour chaque classe d''immobilisations."}]}';
                    }
                    field(CopyToGLBudgetName; BudgetNameCode)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Copy to G/L Budget Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Copier dans le nom du budget général"}]}';
                        TableRelation = "G/L Budget Name";
                        ToolTip = 'Specifies the name of the budget you want to copy projected values to.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le nom du budget dans lequel vous souhaitez copier les valeurs projetées."}]}';

                        trigger OnValidate()
                        begin
                            if BudgetNameCode = '' then
                                BalAccount := false;
                        end;
                    }
                    field(InsertBalAccount; BalAccount)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Insert Bal. Account', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Insérer Bal. Compte"}]}';
                        ToolTip = 'Specifies if you want the batch job to automatically insert fixed asset entries with balancing accounts.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Indique si vous souhaitez que le travail par lots insère automatiquement des écritures d''immobilisation avec des comptes d''équilibrage."}]}';

                        trigger OnValidate()
                        begin
                            if BalAccount then
                                if BudgetNameCode = '' then
                                    Error(YouMustSpecifyErr_Lbl, GLBudgetName.TableCaption);
                        end;
                    }
                    field(PrintPerFixedAsset; PrintDetails)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Print per Fixed Asset', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Impression par immobilisation"}]}';
                        ToolTip = 'Specifies if you want the report to print information separately for each fixed asset.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Indique si vous souhaitez que le rapport imprime les informations séparément pour chaque immobilisation"}]}';
                    }
                    field(ProjectedDisposal; gProjectedDisposal)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Projected Disposal', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Élimination prévue"}]}';
                        ToolTip = 'Specifies if you want the report to include projected disposals: the contents of the Projected Proceeds on Disposal field and the Projected Disposal Date field on the FA depreciation book.'
                                , Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Indique si vous souhaitez que le rapport inclue les cessions projetées : le contenu du champ Produit projeté à la cession et le champ Date de cession projetée sur le livre d''amortissement FA."}]}';
                    }
                    field(PrintAmountsPerDate; gPrintAmountsPerDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Print Amounts per Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Imprimer les montants par date"}]}';
                        ToolTip = 'Specifies if you want the program to include on the last page of the report a summary of the calculated depreciation for all assets.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Indique si vous souhaitez que le programme inclue sur la dernière page du rapport un résumé de l''amortissement calculé pour tous les actifs."}]}';
                    }
                    field(UseAccountingPeriod; gUseAccountingPeriod)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Use Accounting Period', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Utiliser la période comptable"}]}';
                        ToolTip = 'Specifies if you want the periods between the starting date and the ending date to correspond to the accounting periods you have specified in the Accounting Period table. When you select this field, the Number of Days field is cleared.'
                                , Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Indique si vous souhaitez que les périodes entre la date de début et la date de fin correspondent aux périodes comptables que vous avez spécifiées dans la table Période comptable. Lorsque vous sélectionnez ce champ, le champ Nombre de jours est effacé."}]}';

                        trigger OnValidate()
                        begin
                            if gUseAccountingPeriod then
                                PeriodLength := 0;

                            UpdateReqForm();
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            NumberOfDaysCtrlEditable := true;
        end;

        trigger OnOpenPage()
        begin
            GetFASetup();
        end;
    }

    trigger OnPreReport()
    begin
        DeprBook.Get(DeprBookCode);
        Year365Days := DeprBook."Fiscal Year 365 Days";
        if gGroupTotals = gGroupTotals::"FA Posting Group" then
            FAGenReport.SetFAPostingGroup("Fixed Asset", DeprBook.Code);
        FAGenReport.AppendFAPostingFilter("Fixed Asset", StartingDate, EndingDate);
        FAFilter := "Fixed Asset".GetFilters;
        evaluate(DeprBookText, StrSubstNo(Format('%1%2 %3'), DeprBook.TableCaption, ':', DeprBookCode));
        MakeGroupTotalText();
        ValidateDates();
        if PrintDetails then begin
            FANo := Format("Fixed Asset".FieldCaption("No."));
            FADescription := Format("Fixed Asset".FieldCaption(Description));
        end;
        if DeprBook."No. of Days in Fiscal Year" > 0 then
            DaysInFiscalYear := DeprBook."No. of Days in Fiscal Year"
        else
            DaysInFiscalYear := 360;
        if Year365Days then
            DaysInFiscalYear := 365;
        if PeriodLength = 0 then
            PeriodLength := DaysInFiscalYear;
        if (PeriodLength <= 5) or (PeriodLength > DaysInFiscalYear) then
            Error(NumberOfDaysMustNotBeGreaterThanErr_Lbl, DaysInFiscalYear);
        FALedgEntry2."FA Posting Type" := FALedgEntry2."FA Posting Type"::Depreciation;
        evaluate(DeprText, StrSubstNo(Format('%1'), FALedgEntry2."FA Posting Type"));
        if DeprBook."Use Custom 1 Depreciation" then begin
            DeprText2 := DeprText;
            FALedgEntry2."FA Posting Type" := FALedgEntry2."FA Posting Type"::"Custom 1";
            evaluate(Custom1Text, StrSubstNo(Format('%1'), FALedgEntry2."FA Posting Type"));
            evaluate(DeprCustom1Text, StrSubstNo(Format('%1 %2 %3'), DeprText, '+', Custom1Text));
        end;
        SalesPriceFieldname := Format(FADeprBook.FieldCaption("Projected Proceeds on Disposal"));
        GainLossFieldname := ProjectedGainLossTxt_Lbl;
    end;

    var
        GLBudgetName: Record "G/L Budget Name";
        FASetup: Record "FA Setup";
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        FA: Record "Fixed Asset";
        FALedgEntry2: Record "FA Ledger Entry";
        TempFABufferProjection: Record "FA Buffer Projection" temporary;
        FAGenReport: Codeunit "FA General Report";
        CalculateDepr: Codeunit "Calculate Depreciation";
        FADateCalculation: Codeunit "FA Date Calculation";
        DepreciationCalculation: Codeunit "Depreciation Calculation";
        NumberOfDaysMustNotBeGreaterThanErr_Lbl: Label 'Number of Days must not be greater than %1 or less than 5.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le nombre de jours ne doit pas être supérieur à %1 ou inférieur à 5."}]}';
        ProjectedGainLossTxt_Lbl: Label 'Projected Gain/Loss', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Gain/Perte projeté"}]}';
        GroupTotalTxt_Lbl: Label 'Group Total', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Groupe Total"}]}';
        GroupTotalsTxt_Lbl: Label 'Group Totals', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Groupe Totals"}]}';
        HasBeenModifiedInFAErr_Lbl: Label '%1 has been modified in fixed asset %2.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1 a été modifié dans l''immobilisation %2."}]}';
        FAFilter: Text;
        DeprBookText: Text[50];
        GroupCodeName: Text[50];
        GroupCodeName2: Text[50];
        GroupHeadLine: Text[50];
        DeprText: Text[50];
        DeprText2: Text[50];
        Custom1Text: Text[50];
        DeprCustom1Text: Text[50];
        gIncludePostedFrom: Date;
        FANo: Text[50];
        FADescription: Text[100];
        gGroupTotals: Option " ","FA Class","FA Subclass","FA Location","Main Asset","Global Dimension 1","Global Dimension 2","FA Posting Group","Global Dimension 4 (Project)";
        BookValue: Decimal;
        NewFiscalYear: Date;
        EndFiscalYear: Date;
        DaysInFiscalYear: Integer;
        Custom1DeprUntil: Date;
        PeriodLength: Integer;
        gUseAccountingPeriod: Boolean;
        StartingDate2: Date;
        EndingDate2: Date;
        gPrintAmountsPerDate: Boolean;
        UntilDate: Date;
        PrintDetails: Boolean;
        EntryAmounts: array[4] of Decimal;
        AssetAmounts: array[4] of Decimal;
        GroupAmounts: array[4] of Decimal;
        TotalAmounts: array[4] of Decimal;
        TotalBookValue: array[2] of Decimal;
        GroupTotalBookValue: Decimal;
        DateFromProjection: Date;
        DeprAmount: Decimal;
        Custom1Amount: Decimal;
        gNumberOfDays: Integer;
        Custom1NumberOfDays: Integer;
        gDaysInFirstPeriod: Integer;
        Done: Boolean;
        NotFirstGroupTotal: Boolean;
        SalesPriceFieldname: Text[80];
        GainLossFieldname: Text[50];
        gProjectedDisposal: Boolean;
        DoProjectedDisposal: Boolean;
        EntryPrinted: Boolean;
        GroupCodeNameTxt: Label ' ,FA Class,FA Subclass,FA Location,Main Asset,Global Dimension 1,Global Dimension 2,FA Posting Group';
        BudgetNameCode: Code[10];
        OldValue: Code[20];
        NewValue: Code[20];
        BalAccount: Boolean;
        YouMustSpecifyErr_Lbl: Label 'You must specify %1.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez spécifier %1."}]}';
        TempDeprDate: Date;
        GroupTotalsInt: Integer;
        Year365Days: Boolean;
        YouMustCreateAccPeriodsErr_Lbl: Label 'You must create accounting periods until %1 to use 365 days depreciation and ''Use Accounting Periods''.',
                                              Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez créer des périodes comptables jusqu''au %1 pour utiliser l''amortissement de 365 jours et ''Utiliser les périodes comptables''."}]}';
        NumberOfDaysCtrlEditable: Boolean;
        PageNoLbl: Label 'Page', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Page"}]}';
        FAProjectedValueLbl: Label 'Fixed Asset - Projected Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Immobilisation - Valeur projetée"}]}';
        FAPostingDateLbl: Label 'FA Posting Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de lancement de l''AF"}]}';
        BookValueLbl: Label 'Book Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valeur comptable"}]}';
        PostedEntryLbl: Label 'Posted Entry', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Entrée publiée"}]}';
        TotalLbl: Label 'Total', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total"}]}';
        ProjectedAmountsPerDateLbl: Label 'Projected Amounts per Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montants projetés par date"}]}';
        FABufferProjectionFAPostingDateLbl: Label 'FA Posting Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de lancement de l''AF"}]}';
        FABufferProjectionDepreciationLbl: Label 'Depreciation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Dépréciation"}]}';
        FABufferProjectedValueLbl: Label 'Fixed Asset - Projected Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Immobilisation - Valeur projetée"}]}';

    protected var
        DeprBookCode: Code[10];
        StartingDate: Date;
        EndingDate: Date;

    local procedure SkipRecord(): Boolean
    begin
        exit(
          "Fixed Asset".Inactive or
          (FADeprBook."Acquisition Date" = 0D) or
          (FADeprBook."Acquisition Date" > EndingDate) or
          (FADeprBook."Last Depreciation Date" > EndingDate) or
          (FADeprBook."Disposal Date" > 0D));
    end;

    local procedure TransferValues()
    begin
        with FADeprBook do begin
            CalcFields("Book Value", Depreciation, "Custom 1");
            DateFromProjection := 0D;
            EntryAmounts[1] := "Book Value";
            EntryAmounts[2] := "Custom 1";
            EntryAmounts[3] := DepreciationCalculation.DeprInFiscalYear("Fixed Asset"."No.", DeprBookCode, StartingDate);
            TotalBookValue[1] := TotalBookValue[1] + "Book Value";
            TotalBookValue[2] := TotalBookValue[2] + "Book Value";
            GroupTotalBookValue += "Book Value";
            NewFiscalYear := FADateCalculation.GetFiscalYear(DeprBookCode, StartingDate);
            EndFiscalYear := FADateCalculation.CalculateDate(
                DepreciationCalculation.Yesterday(NewFiscalYear, Year365Days), DaysInFiscalYear, Year365Days);
            TempDeprDate := "Temp. Ending Date";

            if DeprBook."Use Custom 1 Depreciation" then
                Custom1DeprUntil := "Depr. Ending Date (Custom 1)"
            else
                Custom1DeprUntil := 0D;

            if Custom1DeprUntil > 0D then
                EntryAmounts[4] := GetDeprBasis();
        end;
        UntilDate := 0D;
        AssetAmounts[1] := 0;
        AssetAmounts[2] := 0;
        AssetAmounts[3] := 0;
        AssetAmounts[4] := 0;
    end;

    local procedure CalculateFirstDeprAmount(var pDone: Boolean)
    var
        FirstTime: Boolean;
    begin
        FirstTime := true;
        UntilDate := StartingDate;
        repeat
            if not FirstTime then
                GetNextDate();
            FirstTime := false;
            CalculateDepr.Calculate(
              DeprAmount, Custom1Amount, gNumberOfDays, Custom1NumberOfDays,
              "Fixed Asset"."No.", DeprBookCode, UntilDate, EntryAmounts, 0D, gDaysInFirstPeriod);
            pDone := (DeprAmount <> 0) or (Custom1Amount <> 0);
        until (UntilDate >= EndingDate) or pDone;
        EntryAmounts[3] :=
          DepreciationCalculation.DeprInFiscalYear("Fixed Asset"."No.", DeprBookCode, UntilDate);
    end;

    local procedure CalculateSecondDeprAmount(var pDone: Boolean)
    begin
        GetNextDate();
        CalculateDepr.Calculate(
          DeprAmount, Custom1Amount, gNumberOfDays, Custom1NumberOfDays,
          "Fixed Asset"."No.", DeprBookCode, UntilDate, EntryAmounts, DateFromProjection, 0);
        pDone := CalculationDone(
            (DeprAmount <> 0) or (Custom1Amount <> 0), DateFromProjection);
    end;

    local procedure GetNextDate()
    var
        UntilDate2: Date;
    begin
        UntilDate2 := GetPeriodEndingDate(gUseAccountingPeriod, UntilDate, PeriodLength);
        if Custom1DeprUntil > 0D then
            if (UntilDate < Custom1DeprUntil) and (UntilDate2 > Custom1DeprUntil) then
                UntilDate2 := Custom1DeprUntil;

        if TempDeprDate > 0D then
            if (UntilDate < TempDeprDate) and (UntilDate2 > TempDeprDate) then
                UntilDate2 := TempDeprDate;

        if (UntilDate < EndFiscalYear) and (UntilDate2 > EndFiscalYear) then
            UntilDate2 := EndFiscalYear;

        if UntilDate = EndFiscalYear then begin
            EntryAmounts[3] := 0;
            NewFiscalYear := DepreciationCalculation.ToMorrow(EndFiscalYear, Year365Days);
            EndFiscalYear := FADateCalculation.CalculateDate(EndFiscalYear, DaysInFiscalYear, Year365Days);
        end;

        DateFromProjection := DepreciationCalculation.ToMorrow(UntilDate, Year365Days);
        UntilDate := UntilDate2;
        if UntilDate >= EndingDate then
            UntilDate := EndingDate;
    end;

    local procedure GetPeriodEndingDate(pUseAccountingPeriod: Boolean; PeriodEndingDate: Date; var pPeriodLength: Integer): Date
    var
        AccountingPeriod: Record "Accounting Period";
        UntilDate2: Date;
    begin
        if not pUseAccountingPeriod or AccountingPeriod.IsEmpty() then
            exit(FADateCalculation.CalculateDate(PeriodEndingDate, pPeriodLength, Year365Days));
        AccountingPeriod.SetFilter(
          "Starting Date", '>=%1', DepreciationCalculation.ToMorrow(PeriodEndingDate, Year365Days) + 1);
        if AccountingPeriod.FindFirst() then begin
            if Date2DMY(AccountingPeriod."Starting Date", 1) <> 31 then
                UntilDate2 := DepreciationCalculation.Yesterday(AccountingPeriod."Starting Date", Year365Days)
            else
                UntilDate2 := AccountingPeriod."Starting Date" - 1;
            pPeriodLength :=
              DepreciationCalculation.DeprDays(
                DepreciationCalculation.ToMorrow(PeriodEndingDate, Year365Days), UntilDate2, Year365Days);
            if (pPeriodLength <= 5) or (pPeriodLength > DaysInFiscalYear) then
                pPeriodLength := DaysInFiscalYear;
            exit(UntilDate2);
        end;
        if Year365Days then
            Error(YouMustCreateAccPeriodsErr_Lbl, DepreciationCalculation.ToMorrow(EndingDate, Year365Days) + 1);
        exit(FADateCalculation.CalculateDate(PeriodEndingDate, pPeriodLength, Year365Days));
    end;

    local procedure MakeGroupTotalText()
    begin
        case gGroupTotals of
            gGroupTotals::"FA Class":
                Evaluate(GroupCodeName, "Fixed Asset".FieldCaption("FA Class Code"));
            gGroupTotals::"FA Subclass":
                Evaluate(GroupCodeName, "Fixed Asset".FieldCaption("FA Subclass Code"));
            gGroupTotals::"FA Location":
                Evaluate(GroupCodeName, "Fixed Asset".FieldCaption("FA Location Code"));
            gGroupTotals::"Main Asset":
                Evaluate(GroupCodeName, "Fixed Asset".FieldCaption("Main Asset/Component"));
            gGroupTotals::"Global Dimension 1":
                Evaluate(GroupCodeName, "Fixed Asset".FieldCaption("Global Dimension 1 Code"));
            gGroupTotals::"Global Dimension 2":
                Evaluate(GroupCodeName, "Fixed Asset".FieldCaption("Global Dimension 2 Code"));
            gGroupTotals::"FA Posting Group":
                Evaluate(GroupCodeName, "Fixed Asset".FieldCaption("FA Posting Group"));
            gGroupTotals::"Global Dimension 4 (Project)":
                Evaluate(GroupCodeName, "Fixed Asset".FieldCaption("Job No."));
        end;
        if GroupCodeName <> '' then begin
            GroupCodeName2 := GroupCodeName;
            if gGroupTotals = gGroupTotals::"Main Asset" then
                Evaluate(GroupCodeName2, StrSubstNo(Format('%1'), SelectStr(gGroupTotals + 1, GroupCodeNameTxt)));
            Evaluate(GroupCodeName, StrSubstNo(Format('%1%2 %3'), GroupTotalsTxt_Lbl, ':', GroupCodeName2));
        end;
    end;

    local procedure ValidateDates()
    begin
        FAGenReport.ValidateDeprDates(StartingDate, EndingDate);
        EndingDate2 := EndingDate;
        StartingDate2 := StartingDate;
    end;

    local procedure MakeGroupHeadLine()
    begin
        with "Fixed Asset" do
            case gGroupTotals of
                gGroupTotals::"FA Class":
                    GroupHeadLine := "FA Class Code";
                gGroupTotals::"FA Subclass":
                    GroupHeadLine := "FA Subclass Code";
                gGroupTotals::"FA Location":
                    GroupHeadLine := "FA Location Code";
                gGroupTotals::"Main Asset":
                    begin
                        FA."Main Asset/Component" := FA."Main Asset/Component"::"Main Asset";
                        Evaluate(GroupHeadLine, StrSubstNo(Format('%1 %2'), FA."Main Asset/Component", "Component of Main Asset"));
                        if "Component of Main Asset" = '' then
                            Evaluate(GroupHeadLine, StrSubstNo(Format('%1%2'), GroupHeadLine, '*****'));
                    end;
                gGroupTotals::"Global Dimension 1":
                    GroupHeadLine := "Global Dimension 1 Code";
                gGroupTotals::"Global Dimension 2":
                    GroupHeadLine := "Global Dimension 2 Code";
                gGroupTotals::"FA Posting Group":
                    GroupHeadLine := "FA Posting Group";
                gGroupTotals::"Global Dimension 4 (Project)":
                    GroupHeadLine := "Job No.";
            end;
        if GroupHeadLine = '' then
            GroupHeadLine := '*****';
    end;

    local procedure UpdateTotals()
    var
        BudgetDepreciation: Codeunit "Budget Depreciation";
        EntryNo: Integer;
        CodeName: Code[20];
    begin
        EntryAmounts[1] := EntryAmounts[1] + DeprAmount + Custom1Amount;
        if Custom1DeprUntil > 0D then
            if UntilDate <= Custom1DeprUntil then
                EntryAmounts[4] := EntryAmounts[4] + DeprAmount + Custom1Amount;
        EntryAmounts[2] := EntryAmounts[2] + Custom1Amount;
        EntryAmounts[3] := EntryAmounts[3] + DeprAmount + Custom1Amount;
        AssetAmounts[1] := AssetAmounts[1] + DeprAmount;
        AssetAmounts[2] := AssetAmounts[2] + Custom1Amount;
        GroupAmounts[1] := GroupAmounts[1] + DeprAmount;
        GroupAmounts[2] := GroupAmounts[2] + Custom1Amount;
        TotalAmounts[1] := TotalAmounts[1] + DeprAmount;
        TotalAmounts[2] := TotalAmounts[2] + Custom1Amount;
        TotalBookValue[1] := TotalBookValue[1] + DeprAmount + Custom1Amount;
        TotalBookValue[2] := TotalBookValue[2] + DeprAmount + Custom1Amount;
        GroupTotalBookValue += DeprAmount + Custom1Amount;
        if BudgetNameCode <> '' then
            BudgetDepreciation.CopyProjectedValueToBudget(
              FADeprBook, BudgetNameCode, UntilDate, DeprAmount, Custom1Amount, BalAccount);

        if (UntilDate > 0D) or gPrintAmountsPerDate then
            with TempFABufferProjection do begin
                Reset();
                if FindLast() then
                    EntryNo := "Entry No." + 1
                else
                    EntryNo := 1;
                SetRange("FA Posting Date", UntilDate);
                if gGroupTotals <> gGroupTotals::" " then begin
                    case gGroupTotals of
                        gGroupTotals::"FA Class":
                            CodeName := "Fixed Asset"."FA Class Code";
                        gGroupTotals::"FA Subclass":
                            CodeName := "Fixed Asset"."FA Subclass Code";
                        gGroupTotals::"FA Location":
                            CodeName := "Fixed Asset"."FA Location Code";
                        gGroupTotals::"Main Asset":
                            CodeName := "Fixed Asset"."Component of Main Asset";
                        gGroupTotals::"Global Dimension 1":
                            CodeName := "Fixed Asset"."Global Dimension 1 Code";
                        gGroupTotals::"Global Dimension 2":
                            CodeName := "Fixed Asset"."Global Dimension 2 Code";
                        gGroupTotals::"FA Posting Group":
                            CodeName := "Fixed Asset"."FA Posting Group";
                        gGroupTotals::"Global Dimension 4 (Project)":
                            CodeName := "Fixed Asset"."Job No.";
                    end;
                    SetRange("Code Name", CodeName);
                end;
                if not Find('=><') then begin
                    Init();
                    "Code Name" := CodeName;
                    "FA Posting Date" := UntilDate;
                    "Entry No." := EntryNo;
                    Depreciation := DeprAmount;
                    "Custom 1" := Custom1Amount;
                    Insert();
                end else begin
                    Depreciation := Depreciation + DeprAmount;
                    "Custom 1" := "Custom 1" + Custom1Amount;
                    Modify();
                end;
            end;
    end;

    local procedure InitGroupTotals()
    begin
        GroupAmounts[1] := 0;
        GroupAmounts[2] := 0;
        GroupAmounts[3] := 0;
        GroupAmounts[4] := 0;
        GroupTotalBookValue := 0;
        if NotFirstGroupTotal then
            TotalBookValue[1] := 0
        else
            TotalBookValue[1] := EntryAmounts[1];
        NotFirstGroupTotal := true;
    end;

    local procedure GetDeprBasis(): Decimal
    var
        FALedgEntry: Record "FA Ledger Entry";
    begin
        with FALedgEntry do begin
            SetCurrentKey("FA No.", "Depreciation Book Code", "Part of Book Value", "FA Posting Date");
            SetRange("FA No.", "Fixed Asset"."No.");
            SetRange("Depreciation Book Code", DeprBookCode);
            SetRange("Part of Book Value", true);
            SetRange("FA Posting Date", 0D, Custom1DeprUntil);
            CalcSums(Amount);
            exit(Amount);
        end;
    end;

    local procedure CalculateGainLoss()
    var
        CalculateDisposal: Codeunit "Calculate Disposal";
        lEntryAmounts: array[14] of Decimal;
        PrevAmount: array[2] of Decimal;
    begin
        PrevAmount[1] := AssetAmounts[3];
        PrevAmount[2] := AssetAmounts[4];

        CalculateDisposal.CalcGainLoss("Fixed Asset"."No.", DeprBookCode, lEntryAmounts);
        AssetAmounts[3] := FADeprBook."Projected Proceeds on Disposal";
        if lEntryAmounts[1] <> 0 then
            AssetAmounts[4] := lEntryAmounts[1]
        else
            AssetAmounts[4] := lEntryAmounts[2];
        AssetAmounts[4] :=
          AssetAmounts[4] + AssetAmounts[1] + AssetAmounts[2] - FADeprBook."Projected Proceeds on Disposal";

        GroupAmounts[3] += AssetAmounts[3] - PrevAmount[1];
        GroupAmounts[4] += AssetAmounts[4] - PrevAmount[2];
    end;

    local procedure CalculationDone(pDone: Boolean; pFirstDeprDate: Date): Boolean
    var
        TableDeprCalculation: Codeunit "Table Depr. Calculation";
    begin
        if pDone or
           (FADeprBook."Depreciation Method" <> FADeprBook."Depreciation Method"::"User-Defined")
        then
            exit(pDone);
        exit(
          TableDeprCalculation.GetTablePercent(
            DeprBookCode, FADeprBook."Depreciation Table Code",
            FADeprBook."First User-Defined Depr. Date", pFirstDeprDate, UntilDate) = 0);
    end;

    local procedure UpdateReqForm()
    begin
        PageUpdateReqForm();
    end;

    local procedure PageUpdateReqForm()
    var
        lDeprBook: Record "Depreciation Book";
    begin
        if DeprBookCode <> '' then
            lDeprBook.Get(DeprBookCode);

        PeriodLength := 0;
        if lDeprBook."Fiscal Year 365 Days" and not gUseAccountingPeriod then
            PeriodLength := 365;
    end;

    procedure SetMandatoryFields(DepreciationBookCodeFrom: Code[10]; StartingDateFrom: Date; EndingDateFrom: Date)
    begin
        DeprBookCode := DepreciationBookCodeFrom;
        StartingDate := StartingDateFrom;
        EndingDate := EndingDateFrom;
    end;

    procedure SetPeriodFields(PeriodLengthFrom: Integer; DaysInFirstPeriodFrom: Integer; IncludePostedFromFrom: Date; UseAccountingPeriodFrom: Boolean)
    begin
        PeriodLength := PeriodLengthFrom;
        gDaysInFirstPeriod := DaysInFirstPeriodFrom;
        gIncludePostedFrom := IncludePostedFromFrom;
        gUseAccountingPeriod := UseAccountingPeriodFrom;
    end;

    procedure SetTotalFields(GroupTotalsFrom: Option; PrintDetailsFrom: Boolean)
    begin
        gGroupTotals := GroupTotalsFrom;
        PrintDetails := PrintDetailsFrom;
    end;

    procedure SetBudgetField(BudgetNameCodeFrom: Code[10]; BalAccountFrom: Boolean; ProjectedDisposalFrom: Boolean; PrintAmountsPerDateFrom: Boolean)
    begin
        BudgetNameCode := BudgetNameCodeFrom;
        BalAccount := BalAccountFrom;
        gProjectedDisposal := ProjectedDisposalFrom;
        gPrintAmountsPerDate := PrintAmountsPerDateFrom;
    end;

    procedure GetFASetup()
    begin
        if DeprBookCode = '' then begin
            FASetup.Get();
            DeprBookCode := FASetup."Default Depr. Book";
        end;
        UpdateReqForm();
    end;

    local procedure UpdateGroupTotals()
    begin
        GroupAmounts[1] := GroupAmounts[1] + DeprAmount;
        TotalAmounts[1] := TotalAmounts[1] + DeprAmount;
    end;
}