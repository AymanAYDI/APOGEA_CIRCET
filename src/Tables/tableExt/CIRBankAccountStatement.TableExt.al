tableextension 50002 "CIR Bank Account Statement" extends "Bank Account Statement"
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
    }
}
