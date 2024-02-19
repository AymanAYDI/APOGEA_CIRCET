tableextension 50023 "CIR Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(50010; "Bank Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Bank Account"."No.";
        }
        field(50011; "Number of packages"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Number of packages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de colis"}]}';
        }
        field(50012; "Total weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids total"}]}';
        }
        field(50013; "Business Code"; Text[100])
        {
            Caption = 'Business Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code affaire"}]}';
            DataClassification = CustomerContent;
        }
        field(50020; "Site Code"; Text[100])
        {
            Caption = 'Site Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code Site"}]}';
            DataClassification = CustomerContent;
        }
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
    }
}