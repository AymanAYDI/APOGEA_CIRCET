pageextension 50064 "CIR Posted Sales Inv. Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addbefore("Type")
        {
            field("Control Station Ref."; Rec."Control Station Ref.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Control Station Ref.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Réf. poste de commande" }, { "lang": "FRB", "txt": "Réf. poste de commande" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                Style = Favorable;
                StyleExpr = true;
            }
        }
        addafter(Quantity)
        {
            field("Description 2"; Rec."Description 2")
            {
                Caption = 'Description 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désignation 2"}]}';
                ToolTip = 'Specifies a second descriptive text.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie un second texte descriptif."}]}';
                ApplicationArea = All;
            }
        }
    }
}