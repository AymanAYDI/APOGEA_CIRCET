report 50033 "CIR Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRTrialBalance.rdl';
    AdditionalSearchTerms = 'year closing,close accounting period,close fiscal year';
    Caption = 'Trial Balance', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Balance"}]}';
    PreviewMode = PrintLayout;
    UsageCategory = None;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter", "CIR G/L Entry Type Filter";
            column(STRSUBSTNO_Text000_PeriodText_; StrSubstNo(Period_Lbl, PeriodText))
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName())
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(G_L_Account_No_; "No.")
            {
            }
            column(Trial_BalanceCaption; Trial_BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption; FieldCaption("No."))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
            {
            }
            column(G_L_Account___Net_Change_Caption; G_L_Account___Net_Change_CaptionLbl)
            {
            }
            column(G_L_Account___Net_Change__Control22Caption; G_L_Account___Net_Change__Control22CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date_Caption; G_L_Account___Balance_at_Date_CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date__Control24Caption; G_L_Account___Balance_at_Date__Control24CaptionLbl)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(G_L_Account___No__; "G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name; PadStr('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(G_L_Account___Net_Change_; NetChange)
                {
                }
                column(G_L_Account___Net_Change__Control22; -NetChange)
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Balance_at_Date_; BalanceAtDate)
                {
                }
                column(G_L_Account___Balance_at_Date__Control24; -BalanceAtDate)
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Account_Type_; Format("G/L Account"."Account Type", 0, 2))
                {
                }
                column(No__of_Blank_Lines; "G/L Account"."No. of Blank Lines")
                {
                }
                dataitem(BlankLineRepeater; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(BlankLineNo; BlankLineNo)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if BlankLineNo = 0 then
                            CurrReport.Break();

                        BlankLineNo -= 1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    BlankLineNo := "G/L Account"."No. of Blank Lines" + 1;
                    NetChange := 0;
                    BalanceAtDate := 0;
                    if GLEntryTypeFilter = GLEntryTypeFilter::Definitive then begin
                        "G/L Account".CalcFields("CIR Definitive Net Change", "CIR Balance Definitive at Date");
                        NetChange := "G/L Account"."CIR Definitive Net Change";
                        BalanceAtDate := "G/L Account"."CIR Balance Definitive at Date";
                    end else begin
                        "G/L Account".CalcFields("CIR Situation Net Change", "CIR Balance Situation at Date");
                        NetChange := "G/L Account"."CIR Situation Net Change";
                        BalanceAtDate := "G/L Account"."CIR Balance Situation at Date";
                    end;
                    if (NetChange = 0) and (BalanceAtDate = 0) then
                        CurrReport.Skip();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Net Change", "Balance at Date");

                if ChangeGroupNo then begin
                    PageGroupNo += 1;
                    ChangeGroupNo := false;
                end;

                ChangeGroupNo := "New Page";
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
                ChangeGroupNo := false;
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
                    Caption = 'Option', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Option"}]}';
                    Field("G/L Entry Type Filter"; GLEntryTypeFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'G/L Entry Type Filter', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Filtre type écriture"}]}';
                        OptionCaption = 'Definitive,Situation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Définitive,Situation"}]}';
                        ToolTip = 'G/L Entry Type Filter', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Filtre type écriture"}]}';
                    }
                }
            }
        }
    }


    trigger OnPreReport()
    begin
        "G/L Account".SecurityFiltering(SecurityFilter::Filtered);
        GLFilter := "G/L Account".GetFilters;
        PeriodText := "G/L Account".GetFilter("Date Filter");
    end;

    var
        Period_Lbl: Label 'Period: %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Période: %1"}]}';
        GLFilter: Text;
        PeriodText: Text;
        Trial_BalanceCaptionLbl: Label 'Trial Balance', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Balance"}]}';
        CurrReport_PAGENOCaptionLbl: Label 'Page', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Page"}]}';
        Net_ChangeCaptionLbl: Label 'Net Change', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde période"}]}';
        BalanceCaptionLbl: Label 'Balance', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde"}]}';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: Label 'Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom"}]}';
        G_L_Account___Net_Change_CaptionLbl: Label 'Debit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Débit"}]}';
        G_L_Account___Net_Change__Control22CaptionLbl: Label 'Credit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Crédit"}]}';
        G_L_Account___Balance_at_Date_CaptionLbl: Label 'Debit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Débit"}]}';
        G_L_Account___Balance_at_Date__Control24CaptionLbl: Label 'Credit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Crédit"}]}';
        PageGroupNo: Integer;
        ChangeGroupNo: Boolean;
        BlankLineNo: Integer;
        NetChange: decimal;
        BalanceAtDate: decimal;
        GLEntryTypeFilter: option Definitive,Situation;
}

