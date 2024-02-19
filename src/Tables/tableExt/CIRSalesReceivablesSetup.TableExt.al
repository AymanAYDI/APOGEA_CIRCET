tableextension 50021 "CIR Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50001; "Generic Customer No."; Code[20])
        {
            Caption = 'Generic Customer No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° client générique" }, { "lang": "FRB", "txt": "N° client générique" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
    }
}