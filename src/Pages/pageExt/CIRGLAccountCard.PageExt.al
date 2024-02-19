pageextension 50042 "CIR G/L Account Card" extends "G/L Account Card"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ToolTip = 'Specifies the value of the No. 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur de N° 2"}]}';
                ApplicationArea = All;
            }
        }
    }
}