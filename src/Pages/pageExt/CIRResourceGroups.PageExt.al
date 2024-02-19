pageextension 50054 "CIR Resource Groups" extends "Resource Groups"
{
    layout
    {
        addlast(Control1)
        {
            field(Blocked; Rec.Blocked)
            {
                ToolTip = 'Specifies the value of the Blocked ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Bloqué" }, { "lang": "FRB", "txt": "Bloqué" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
        }
    }
}