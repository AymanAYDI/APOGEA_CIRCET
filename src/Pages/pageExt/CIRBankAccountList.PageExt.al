pageextension 50001 "CIR Bank Account List" extends "Bank Account List"
{
    layout
    {
        addlast(Control1)
        {
            field("CIR Factoring"; Rec.Factoring)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the factoring of the bank account.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie l''affacturage du compte bancaire." }, { "lang": "FRB", "txt": "Spécifie l''affacturage du compte bancaire." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
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
    }
}