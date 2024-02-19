tableextension 50039 "CIR VAT Posting Setup" extends "VAT Posting Setup"
{
    fields
    {
        field(50000; "VAT Label"; Code[50])
        {
            Caption = 'VAT Label', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Libellé TVA"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
    }
}