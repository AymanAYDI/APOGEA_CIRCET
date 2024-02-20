pageextension 50013 "CIR Sales Order Subform" extends "Sales Order Subform"
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
        addafter("Location Code")
        {
            field("CIR Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Width = 18;
                ToolTip = 'Specifies the value of the Description 2';
            }
        }
        addafter("Qty. to Assemble to Order")
        {
            field("NAV Assembly Order No."; Rec."NAV Assembly Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'NAV Assembly Order No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Ordre Assemblage NAV"}]}';
                Visible = false;
            }
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                Caption = 'No Used Field Job No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ne pas utiliser - N° Projet"}]}';
                Editable = false;
                Enabled = false;
                Visible = false;
                ToolTip = 'Specifies the number of the related job.';
            }
        }

        moveafter("Qty. Assigned"; "Reserved Quantity")
        moveafter("Line Amount"; ARBVRNVeronaJobNo)
        moveafter(ARBVRNVeronaJobNo; ShortcutDimCode4)
        moveafter(ShortcutDimCode4; "Shortcut Dimension 1 Code")

        modify(ARBVRNVeronaJobTaskNo)
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Line Amount")
        {
            Editable = false;
        }
    }
}