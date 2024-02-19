tableextension 50017 "CIR Sales Line Archive" extends "Sales Line Archive"
{
    fields
    {
        field(50000; "Control Station Ref."; Integer)
        {
            Caption = 'Control Station Ref.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Réf. poste de commande" }, { "lang": "FRB", "txt": "Réf. poste de commande" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}