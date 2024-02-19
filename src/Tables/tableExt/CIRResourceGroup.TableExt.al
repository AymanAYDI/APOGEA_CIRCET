tableextension 50025 "CIR Resource Group" extends "Resource Group"
{
    fields
    {
        field(50000; "Resource type"; Enum "Resource type")
        {
            Caption = 'Resource type', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type Ressource" }, { "lang": "FRB", "txt": "Type Ressource" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50010; Blocked; Boolean)
        {
            Caption = 'Blocked', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Bloqué" }, { "lang": "FRB", "txt": "Bloqué" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
    }
}