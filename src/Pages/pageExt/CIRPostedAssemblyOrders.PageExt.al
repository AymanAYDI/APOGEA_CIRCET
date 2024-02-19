pageextension 50092 "CIR Posted Assembly Orders" extends "Posted Assembly Orders"
{
    layout
    {
        addlast(Control2)
        {
            field("Dimension Value"; Rec."Dimension Value")
            {
                ToolTip = 'Specifies the value of the Dimension Value ';
                ApplicationArea = All;
            }
            field("Dimension Value Name"; Rec."Dimension Value Name")
            {
                ToolTip = 'Specifies the value of the Dimension Value Name ';
                ApplicationArea = All;
            }
        }
    }
}