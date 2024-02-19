pageextension 50014 "CIR Sales Cr. Memo Subform" extends "Sales Cr. Memo Subform"
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
        addafter(Description)
        {
            field("Description 214105"; Rec."Description 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description 2 ';
            }
        }
        modify("Line Amount")
        {
            Editable = false;
        }
    }
}