table 50039 "Activity Agency Region"
{
    LookupPageID = "Activity Agency Region List";
    Caption = 'Activity Agency Region', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Activité Agence Région"}]}';

    fields
    {
        field(10; Type; Enum "Activity Agency Region Type")
        {
            Caption = 'Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type"}]}';
            DataClassification = CustomerContent;
        }
        field(20; Name; Code[20])
        {
            Caption = 'Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom"}]}';
            DataClassification = CustomerContent;
        }
        field(30; Responsible; Code[20])
        {
            Caption = 'Responsible', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Responsable"}]}';
            TableRelation = Resource."No." WHERE(Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(40; "Responsible Name"; Text[100])
        {
            Caption = 'Responsible Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom responsable"}]}';
            CalcFormula = Lookup(Resource.Name WHERE("No." = FIELD(Responsible)));
            FieldClass = FlowField;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; Type, Name)
        {
            Clustered = true;
        }
    }
}