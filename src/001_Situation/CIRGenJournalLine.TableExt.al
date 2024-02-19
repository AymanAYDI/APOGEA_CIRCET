tableextension 50500 "CIR Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(50001; "Bank Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Bank Account"."No.";
        }
        field(50500; "CIR Entry Type"; Option)
        {
            Caption = 'Entry Type', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type écriture" }, { "lang": "FRB", "txt": "Type écriture" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            OptionCaption = 'Definitive,Situation', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Définitive,Situation" }, { "lang": "FRB", "txt": "Définitive,Situation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            OptionMembers = Definitive,Situation;
            DataClassification = CustomerContent;
        }
        modify("Document No.")
        {
            trigger OnBeforeValidate()
            var
                GenJournalBatch: Record "Gen. Journal Batch";
            begin
                if GenJournalBatch.get(Rec."Journal Template Name", Rec."Journal Batch Name") then
                    Rec."External Document No." := Rec."Document No.";
            end;
        }
    }
}