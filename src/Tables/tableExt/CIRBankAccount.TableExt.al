tableextension 50000 "CIR Bank Account" extends "Bank Account"
{
    fields
    {
        field(50000; Factoring; Boolean)
        {
            Caption = 'Factoring', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Affacturage" }, { "lang": "FRB", "txt": "Affacturage" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50001; "Check Gen. Jnl Template"; Code[10])
        {
            Caption = 'Check Gen. Journal Template', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Modèle Feuille Paiement Chèque" }, { "lang": "FRB", "txt": "Modèle Feuille Paiement Chèque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments), "Bal. Account Type" = CONST("Bank Account"), "Bal. Account No." = FIELD("No."));
        }
        field(50002; "Check Gen. Journal Batch"; Code[10])
        {
            Caption = 'Check Gen. Journal Batch', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Feuille Paiement Chèque" }, { "lang": "FRB", "txt": "Feuille Paiement Chèque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name WHERE("No. Series" = FILTER(''), "Journal Template Name" = FIELD("Check Gen. Jnl Template"));
        }
        field(50003; "Print Check Format"; enum "Print Check Format Type")
        {
            Caption = 'Print Check Format', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Format Impression Chèque"}]}';
            DataClassification = CustomerContent;
        }
#pragma warning disable AA0232
        field(50004; "Net Operation"; Decimal)
#pragma warning restore AA0232
        {
            Caption = 'Net Operation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Net de l''opération"}]}';
            FieldClass = FlowField;
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE("Posting Date" = FIELD("Date Filter"),
                                                                 "Bank Account No." = FIELD("No."),
                                                                 "Reason Code" = FIELD("Reason Filter"),
                                                                 "Statement Line No." = FIELD(FILTER("Statement Line No. Filter"))));
            Editable = false;
        }
        field(50005; "Net Value"; Decimal)
        {
            Caption = 'Net Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valeur nette"}]}';
            FieldClass = FlowField;
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE("Value Date" = FIELD("Date Filter"),
                                                               "Bank Account No." = FIELD("No."),
                                                               "Reason Code" = FIELD("Reason Filter"),
                                                               "Statement Line No." = FIELD(FILTER("Statement Line No. Filter"))));
            Editable = false;
        }

        field(50006; "Statement Line No. Filter"; Integer)
        {
            Caption = 'Statement Line No. Filter', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Filtre n° ligne relevé"}]}';
            FieldClass = FlowFilter;
        }
        field(50007; "Reason Filter"; Code[10])
        {
            Caption = 'Reason Filter', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Filtre motif"}]}';
            FieldClass = FlowFilter;
            TableRelation = "Reason Code";
        }
    }
    keys
    {
        key(CIRKey1; IBAN)
        {
        }
        key(CIRKey2; "Bank Account No.")
        {
        }
    }
}