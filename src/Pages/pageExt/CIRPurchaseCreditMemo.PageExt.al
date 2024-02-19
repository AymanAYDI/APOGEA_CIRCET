pageextension 50047 "CIR Purchase Credit Memo" extends "Purchase Credit Memo"
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