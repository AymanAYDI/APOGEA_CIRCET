tableextension 50014 "CIR Sales Header Archive" extends "Sales Header Archive"
{
    fields
    {
        field(50000; "Breakdown Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Breakdown Invoice No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° facture ventilée" }, { "lang": "FRB", "txt": "N° facture ventilée" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Sales Invoice Header";
            Editable = false;
        }

        field(50010; "Bank Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Bank Account"."No.";
            Editable = false;
        }
    }
}