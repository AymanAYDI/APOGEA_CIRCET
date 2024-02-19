pageextension 50030 "CIR Item Card" extends "Item Card"
{
    layout
    {
        addafter("Purchasing Code")
        {
            field("Business Code by Default"; Rec."Business Code by Default")
            {
                ToolTip = 'Specifies the value of the Business Code by Default', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code affaire Stock par défaut" } ] }';
                ApplicationArea = All;
                Visible = true;
            }
        }
    }
}