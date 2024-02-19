/// <summary>
/// TableExtension ACY Payment Header (ID 50001) extends Record Payment Header.
/// </summary>
tableextension 50009 "CIR Payment Header" extends "Payment Header"
{
    fields
    {
        field(50000; "Issuer/Recipient"; Option)
        {
            Caption = 'Issuer/Recipient', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Emetteur/Beneficiaire"}]}';
            DataClassification = CustomerContent;
            OptionMembers = "15-Issuer","14-Both","13-Recipient";
            OptionCaption = '15-Issuer,14-Both,13-Recipient', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"15-Emetteur,14-Les deux,13-Beneficiaire"}]}';
        }
        field(50001; "Intermediary Account No."; Code[20])
        {
            Caption = 'Intermediary Account No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° compte bancaire intermédiaire"}]}';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account";
        }
        field(50010; "Print"; Boolean)
        {
            Caption = 'Print', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Imprimer"}]}';
            DataClassification = CustomerContent;
        }
    }
}