pageextension 50093 "CIR Posted Assembly Order" extends "Posted Assembly Order"
{
    layout
    {
        addlast(General)
        {
            field("Dimension Value"; Rec."Dimension Value")
            {
                ToolTip = 'Specifies the value of the Dimension Value ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Affaire"}]}';
                ApplicationArea = All;
            }
            field("Dimension Value Name"; Rec."Dimension Value Name")
            {
                ToolTip = 'Specifies the value of the Dimension Value Name ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom Affaire"}]}';
                ApplicationArea = All;
            }
        }
    }
}