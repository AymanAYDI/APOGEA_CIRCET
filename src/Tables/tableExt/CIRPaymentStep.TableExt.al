tableextension 50046 "CIR Payment Step" extends "Payment Step"
{
    fields
    {
        field(50000; "PDF File Name"; Text[50])
        {
            Caption = 'PDF File Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom fichier PDF"}]}';
            DataClassification = CustomerContent;
        }
        field(50010; "Sender Email Address"; Text[250])
        {
            Caption = 'Sender Email Address', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse expéditeur e-mail"}]}';
            DataClassification = CustomerContent;
        }
        field(50020; "Mail Subject Text Code"; Code[10])
        {
            Caption = 'Email Subject Text Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code texte sujet e-mail"}]}';
            DataClassification = CustomerContent;
            TableRelation = "Standard Text".Code;
        }
    }
}