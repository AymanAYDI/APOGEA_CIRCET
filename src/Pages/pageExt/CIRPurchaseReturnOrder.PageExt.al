pageextension 50050 "CIR Purchase Return Order" extends "Purchase Return Order"
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
    }
}