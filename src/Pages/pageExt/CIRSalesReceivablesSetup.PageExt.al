pageextension 50031 "CIR Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Generic Customer No."; Rec."Generic Customer No.")
            {
                ToolTip = 'Specifies the value of the Generic Customer No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° client générique" }, { "lang": "FRB", "txt": "N° client générique" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] } ';
                ApplicationArea = All;
            }
        }
    }
}