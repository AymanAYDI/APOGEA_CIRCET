pageextension 50086 "CIR Get Receipt Lines" extends "Get Receipt Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("Order No.97810"; Rec."Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the line number of the order that created the entry.';
            }
        }
    }
}