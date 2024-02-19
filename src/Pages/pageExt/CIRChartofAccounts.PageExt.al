pageextension 50041 "CIR Chart of Accounts" extends "Chart of Accounts"
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