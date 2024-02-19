page 50000 "Vendor Subclass"
{
    Caption = 'Vendor Subclass', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Sous-classe fournisseur" }, { "lang": "FRB", "txt": "Sous-classe fournisseur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    PageType = List;
    UsageCategory = None;
    SourceTable = "Vendor Subclass";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifie the code value', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie le code" }, { "lang": "FRB", "txt": "Spécifie le code" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifie the value for description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur pour la désignation" }, { "lang": "FRB", "txt": "Spécifie la valeur pour la désignation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                }
            }
        }
    }
}