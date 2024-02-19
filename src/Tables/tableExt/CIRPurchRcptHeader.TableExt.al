tableextension 50051 "CIR Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50080; "Dimension Value"; Code[20])
        {
            Caption = 'Dimension Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Affaire"}]}';
            NotBlank = false;
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Dimension Set Entry"."Dimension Value Code" WHERE("Dimension Set ID" = FIELD("Dimension Set ID"), "Dimension Code" = const('AFFAIRE')));
        }
        field(50090; "Dimension Value Name"; Text[50])
        {
            Caption = 'Dimension Value Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom Affaire"}]}';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Dimension Value".Name WHERE("Dimension Code" = CONST('AFFAIRE'), Code = FIELD("Dimension Value")));
        }
        field(50100; "Description Order"; text[50])
        {
            Caption = 'Description Order', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désignation commande achat"}]}';
            DataClassification = CustomerContent;
        }
    }
}