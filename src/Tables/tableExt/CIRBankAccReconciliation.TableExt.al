tableextension 50048 "CIR Bank Acc. Reconciliation" extends "Bank Acc. Reconciliation"
{
    fields
    {
        field(50000; Filename; Text[250])
        {
            Caption = 'Filename', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du fichier"}]}';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50010; "File Date"; date)
        {
            Caption = 'File Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date du fichier"}]}';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50020; "Number of Lines"; Integer)
        {
            Caption = 'Number of Bank Acc Reconciliation Line', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombres lignes relevé"}]}';
            FieldClass = FlowField;
            CalcFormula = count("Bank Acc. Reconciliation Line" where("Bank Account No." = field("Bank Account No."), "Statement No." = field("Statement No."), "Statement Type" = field("Statement Type")));
        }
        field(50030; "Last Statement No."; Code[20])
        {
            Caption = 'Last Statement No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Dernier n° relevé"}]}';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}