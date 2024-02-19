pageextension 50502 "CIR Source Codes" extends "Source Codes"
{
    layout
    {
        addafter(Description)
        {
            field("CIR Situation"; Rec."CIR Situation")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the source code can support situation entries', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie si le code source peut supporter des entrées de situation" }, { "lang": "FRB", "txt": "Spécifie si le code source peut supporter des entrées de situation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
        }
    }
}