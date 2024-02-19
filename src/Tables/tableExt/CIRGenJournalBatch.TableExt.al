tableextension 50034 "CIR Gen. Journal Batch" extends "Gen. Journal Batch"
{
    fields
    {
        field(50000; "Check"; Boolean)
        {
            Caption = 'Check', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Chèque"}]}';
            DataClassification = CustomerContent;
            Description = 'Identification d''une feuille de paiement par chèque';
        }
    }
}