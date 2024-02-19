tableextension 50502 "CIR G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(50000; "Anonymized Source No."; code[20])
        {
            Caption = 'Anonymized Source No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code source anonymisé" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50001; "Anonymized Description"; code[100])
        {
            Caption = 'Anonymized Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Description anonymisée" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50500; "CIR Entry Type"; Option)
        {
            Caption = 'Entry Type', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type écriture" }, { "lang": "FRB", "txt": "Type écriture" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            OptionCaption = 'Definitive,Situation', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Définitive,Situation" }, { "lang": "FRB", "txt": "Définitive,Situation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            OptionMembers = Definitive,Situation;
            DataClassification = CustomerContent;
        }
    }

    trigger OnInsert()
    begin
        if "Source Type" = "Source Type"::"Employee" then begin
            "Anonymized Source No." := Text001Lbl;
            "Anonymized Description" := Text002Lbl;
        end else begin
            "Anonymized Source No." := "Source No.";
            "Anonymized Description" := Description;
        end;
    end;

    var
        Text001Lbl: Label 'XXXXX', locked = true;
        Text002Lbl: Label 'XXXXXXXXXX', locked = true;
}