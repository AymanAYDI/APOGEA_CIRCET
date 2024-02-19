pageextension 50017 "CIR Sales Invoice Subform" extends "Sales Invoice Subform"
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
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description 2 ';
            }
        }

        moveafter("Allow Item Charge Assignment"; ARBVRNJobNo)
        moveafter(ARBVRNJobNo; ARBVRNJobTaskNo)
        moveafter(ShortcutDimCode4; "Qty. to Assign")

        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Line Discount %")
        {
            Visible = false;
        }
        modify(ARBVRNJobTaskNo)
        {
            Visible = false;
        }
        modify("Line Amount")
        {
            Editable = false;
        }
    }
}