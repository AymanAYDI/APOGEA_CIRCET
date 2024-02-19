table 50005 "Anomaly"
{
    Caption = 'Anomaly', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Anomalie"}]}';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code"}]}';
            DataClassification = CustomerContent;
        }
        field(2; Designation; Text[70])
        {
            Caption = 'Designation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désignation"}]}';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
}