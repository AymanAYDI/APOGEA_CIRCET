tableextension 50001 "CIR Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50001; "Bank Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Bank Account"."No.";
        }
        field(50003; Comment; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Comment Line" WHERE("Document Type" = const("Cust. ledger entry"),
                                                            "No." = FIELD("Document No."),
                                                            "Document Line No." = FIELD("Entry No.")));
            Caption = 'Comment', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaire"}]}';
            Editable = false;
        }
    }
}