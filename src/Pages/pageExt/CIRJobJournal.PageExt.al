pageextension 50072 "CIR Job Journal" extends "Job Journal"
{
    layout
    {
        addafter("No.")
        {
            field("Start Date"; Rec."Start Date")
            {
                ToolTip = 'Specifies the value of the Start Date ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date début" }, { "lang": "FRB", "txt": "Date début" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
                Width = 14;
            }
        }
    }
}