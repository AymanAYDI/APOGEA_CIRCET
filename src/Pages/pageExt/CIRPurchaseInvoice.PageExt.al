pageextension 50049 "CIR Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        addbefore("VAT Bus. Posting Group")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Groupe compta. marché"}]}';
            }
        }

        modify("Posting Description")
        {
            ApplicationArea = All;
            Visible = true;
            Editable = true;
        }
    }
}