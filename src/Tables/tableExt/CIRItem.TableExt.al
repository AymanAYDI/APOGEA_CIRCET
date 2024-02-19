tableextension 50008 "CIR Item" extends Item
{
    fields
    {
        field(50000; "Do Not Display"; Boolean)
        {
            Caption = 'Do not display', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ne pas afficher" }, { "lang": "FRB", "txt": "Ne pas afficher" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50002; "Business Code by Default"; Boolean)
        {
            Caption = 'Business Code by Default', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code affaire Stock par défaut" } ] }';
            DataClassification = CustomerContent;
        }
    }
}