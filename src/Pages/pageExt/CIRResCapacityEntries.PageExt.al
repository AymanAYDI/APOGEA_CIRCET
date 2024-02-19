pageextension 50032 "CIR Res. Capacity Entries" extends "Res. Capacity Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ToolTip = 'Specifies the value of the Global Dimension 1 Code';
                ApplicationArea = All;
            }
        }
    }
}