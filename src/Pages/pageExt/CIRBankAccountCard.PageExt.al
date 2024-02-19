pageextension 50002 "CIR Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        addbefore("SEPA Direct Debit Exp. Format")
        {
            field("CIR Factoring"; Rec.Factoring)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the factoring of the bank account.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie l''affacturage du compte bancaire." }, { "lang": "FRB", "txt": "Spécifie l''affacturage du compte bancaire." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
        }
        addlast(Transfer)
        {
            field("CIR Check Gen. Jnl Template"; Rec."Check Gen. Jnl Template")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the check gen. journal template for the bank account.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie le modèle feuille paiement chèque du compte bancaire." }, { "lang": "FRB", "txt": "Spécifie le modèle feuille paiement chèque du compte bancaire." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
            field("CIR Check Gen. Journal Batch"; Rec."Check Gen. Journal Batch")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the check cen. journal batch for the bank account.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la feuille paiement chèque du compte bancaire." }, { "lang": "FRB", "txt": "Spécifie la feuille paiement chèque du compte bancaire." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
        }
        addafter(Transfer)
        {
            group("Check Payment")
            {
                Caption = 'Check Payment', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Paiement par chèque"}]}';

                field("Print Check Format"; Rec."Print Check Format")
                {
                    ApplicationArea = All;
                    ToolTip = 'Print Check Format', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Format Impression Chèque"}]}';
                }
            }
        }
        addafter("Check Payment")
        {
            group("Dated Reconciliation")
            {
                Caption = 'Dated Reconciliation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rapprochement daté"}]}';

                field("Net Operation"; Rec."Net Operation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Net Operation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Net de l''opération"}]}';
                }
                field("Net Value"; Rec."Net Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Net Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valeur Nette"}]}';
                }
                field("Statement Line No. Filter"; Rec."Statement Line No. Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Statement Line No. Filter', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Filtre n° ligne relevé"}]}';
                }
                field("Reason Filter"; Rec."Reason Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Reason Filter', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Filtre motif"}]}';
                }
            }
        }
    }
}