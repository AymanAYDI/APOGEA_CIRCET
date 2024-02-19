pageextension 50040 "CIRPosted Purch. Inv. Subform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addfirst(Control1)
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order No. ';
            }
        }
        addafter("Quantity")
        {
            field("Accrue"; Rec.Accrue)
            {
                ApplicationArea = ALL;
                ToolTip = 'Specifies the value of the Accrue', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"FNP"}]}';
                Editable = false;
            }
        }
    }
}