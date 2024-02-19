/*
Version------Trigramme-------Date------- N° REF   -    Domain : Comments
AC.FAB002       JCO       15/06/2021     Feature 10324 FAB002 : Gestion des attributs affaire
*/
table 50001 "Business Attributes"
{
    Caption = 'Business Attributes', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Attributs affaire" } ] }';
    LookupPageId = "Business Attributes List";
    DrillDownPageId = "Business Attributes List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code" } ] }';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                GeneralLedgerSetup: Record "General Ledger Setup";
                DimensionValue: Record "Dimension Value";
            begin
                GeneralLedgerSetup.GET();
                GeneralLedgerSetup.TESTFIELD("Shortcut Dimension 3 Code");
                IF NOT DimensionValue.GET(GeneralLedgerSetup."Shortcut Dimension 3 Code", Code) THEN BEGIN
                    DimensionValue.INIT();
                    DimensionValue."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 3 Code";
                    DimensionValue.Code := Code;
                    DimensionValue.INSERT(TRUE);
                END;
                "ShorCut Dimension 3 Code" := DimensionValue.Code;
            end;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Désignation" } ] }';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                GeneralLedgerSetup: Record "General Ledger Setup";
                DimensionValue: Record "Dimension Value";
                AssemblyMgt: Codeunit "Assembly Mgt.";
            begin
                GeneralLedgerSetup.GET();
                DimensionValue.GET(GeneralLedgerSetup."Shortcut Dimension 3 Code", "ShorCut Dimension 3 Code");
                DimensionValue.Name := Rec.Description;
                DimensionValue.MODIFY();

                AssemblyMgt.UpdateBusinessNameOnAssemblyHeader("ShorCut Dimension 3 Code", Description);
            end;
        }
        field(3; "Manager Code"; Code[20])
        {
            Caption = 'Manager Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code responsable" } ] }';
            DataClassification = CustomerContent;
        }
        field(4; Site; Code[1])
        {
            Caption = 'Site', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site" } ] }';
            DataClassification = CustomerContent;
        }
        field(5; "Address Site"; Text[100])
        {
            Caption = 'Address Site', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Adresse site" } ] }';
            DataClassification = CustomerContent;
        }
        field(6; "Address Site 2"; Text[50])
        {
            Caption = 'Address Site 2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Adresse site 2" } ] }';
            DataClassification = CustomerContent;
        }
        field(7; "Post Code"; Code[10])
        {
            Caption = 'Post Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code postal" } ] }';
            DataClassification = CustomerContent;
        }
        field(8; City; Text[30])
        {
            Caption = 'City', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ville" } ] }';
            DataClassification = CustomerContent;
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City;
        }
        field(9; "Site 2"; Text[50])
        {
            Caption = 'Site 2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site 2" } ] }';
            DataClassification = CustomerContent;
        }
        field(10; "Site 3"; Text[50])
        {
            Caption = 'Site 3', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site 3" } ] }';
            DataClassification = CustomerContent;
        }
        field(11; "Site 4"; Text[50])
        {
            Caption = 'Site 4', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site 4" } ] }';
            DataClassification = CustomerContent;
        }
        field(12; "ShorCut Dimension 3 Code"; Code[20])
        {
            Caption = 'ShorCut Dimension 3 Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code section axe 3" } ] }';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
            CaptionClass = '1,2,3';
        }
        field(13; "ShorCut Dimension Name"; Text[50])
        {
            Caption = 'ShorCut Dimension Name', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom axe analytique" } ] }';
            FieldClass = FlowField;
            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = CONST(3), Code = FIELD("ShorCut Dimension 3 Code")));
            Editable = false;
        }
        field(14; Latitude; Decimal)
        {
            Caption = 'Latitude', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Latitude" } ] }';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 6;
        }
        field(15; Longitude; Decimal)
        {
            Caption = 'Longitude', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Longitude" } ] }';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 6;
        }
        field(16; Height; Decimal)
        {
            Caption = 'Height', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Hauteur" } ] }';
            DataClassification = CustomerContent;
        }
        field(17; Type; Code[1])
        {
            Caption = 'Type', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site" } ] }';     // Traduction souhaité par le client
            DataClassification = CustomerContent;
        }
        field(18; Load; Decimal)
        {
            Caption = 'Load', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Charge" } ] }';
            DataClassification = CustomerContent;
        }
        field(19; Comment; Text[100])
        {
            Caption = 'Comment', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Commentaires" } ] }';
            DataClassification = CustomerContent;
        }
        field(20; "Comment 2"; Text[100])
        {
            Caption = 'Comment 2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Autres commentaires" } ] }';
            DataClassification = CustomerContent;
        }
        field(21; "Comment 3"; Text[100])
        {
            Caption = 'Comment 3', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Commentaires supplémentaires" } ] }';
            DataClassification = CustomerContent;
        }
        field(22; "Comment 4"; Text[100])
        {
            Caption = 'Comment 4', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Commentaires supplémentaires" } ] }';
            DataClassification = CustomerContent;
        }
        field(23; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code région" } ] }';
            DataClassification = CustomerContent;
        }
        field(24; Operator; Code[30])
        {
            Caption = 'Operator', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Opérateur" } ] }';
            DataClassification = CustomerContent;
        }
        field(25; "Operator 2"; Code[30])
        {
            Caption = 'Operator 2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Opérateur 2" } ] }';
            DataClassification = CustomerContent;
        }
        field(26; "Operator 3"; Code[30])
        {
            Caption = 'Operator 3', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Opérateur 3" } ] }';
            DataClassification = CustomerContent;
        }
        field(27; County; Code[10])
        {
            Caption = 'County', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Région" } ] }';
            DataClassification = CustomerContent;
        }
        field(28; "Country/Region Code 2"; Code[10])
        {
            Caption = 'Country/Region Code 2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "" } ] }';
            DataClassification = CustomerContent;
        }
        field(29; "Answer Date"; Date)
        {
            Caption = 'Answer Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date réponse" } ] }';
            DataClassification = CustomerContent;
        }
        field(30; Directory; Text[100])
        {
            Caption = 'Directory', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Suivi dossier" } ] }';
            DataClassification = CustomerContent;
        }
        field(31; Remarks; Text[100])
        {
            Caption = 'Remarks', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Observations" } ] }';
            DataClassification = CustomerContent;
        }
        field(32; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date dern. modification" } ] }';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
    end;
}