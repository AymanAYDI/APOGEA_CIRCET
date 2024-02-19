table 50000 "Vendor Subclass"
{
    Caption = 'Vendor Subclass', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Sous-classe Fournisseur" }, { "lang": "FRB", "txt": "Sous-classe Fournisseur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    LookupPageId = "Vendor Subclass";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[30])
        {
            Caption = 'Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code" }, { "lang": "FRB", "txt": "Code" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[60])
        {
            Caption = 'Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Désignation" }, { "lang": "FRB", "txt": "Désignation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}