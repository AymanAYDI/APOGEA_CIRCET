pageextension 50060 "CIR Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addlast(General)
        {
            field("Site Code"; Rec."Site Code")
            {
                ToolTip = 'Specifies the value of the Site Code ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code Site :"}]}';
                ApplicationArea = All;
            }
            field("Business Code"; Rec."Business Code")
            {
                ToolTip = 'Specifies the value of the Business Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code affaire"}]}';
                ApplicationArea = All;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Number of packages"; Rec."Number of packages")
            {
                ApplicationArea = All;
                ToolTip = 'Number of packages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de colis"}]}';
                Editable = false;
            }
            field("Total weight"; Rec."Total weight")
            {
                ApplicationArea = All;
                ToolTip = 'Total weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids total"}]}';
                Editable = false;
            }
        }
        addafter("Sell-to Customer Name")
        {
            field("Your Reference29873"; Rec."Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Your Reference ';
            }
        }
    }
}