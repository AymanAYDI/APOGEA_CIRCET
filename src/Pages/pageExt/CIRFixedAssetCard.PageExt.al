pageextension 50057 "CIR Fixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        addlast(General)
        {
            field("Job No."; Rec."Job No.")
            {
                ToolTip = 'Specifies the value of the Job No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° projet"}]}';
                ApplicationArea = All;
            }
        }
    }
}