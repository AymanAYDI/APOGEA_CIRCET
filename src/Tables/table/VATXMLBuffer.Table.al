table 50008 "VAT XML Buffer"
{
    Caption = 'VAT XML Buffer', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"XML Buffer TVA"}]}';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(3; "Line Number"; Integer)
        {
            Caption = 'Line Number', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° ligne"}]}';
            DataClassification = CustomerContent;
        }
        field(5; "VAT Label"; Code[50])
        {
            Caption = 'VAT Label', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Libellé TVA"}]}';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "VAT Bus. Posting Group")
        {
            Clustered = true;
        }
    }
}