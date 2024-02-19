table 50002 "General Application Setup"
{
    Caption = 'General Application Setup', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramètres général application" } ] }';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Integer)
        {
            Caption = 'Primary Key', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Clé primaire" } ] }';
            DataClassification = CustomerContent;
        }
        field(10; "Default ShorCut Dim. 3 Code"; Code[20])
        {
            Caption = 'Default Shortcut Dim. 3 Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code section axe 3" } ] }';
            CaptionClass = '1,2,3';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(20; "Payroll Job No."; Code[20])
        {
            Caption = 'Payroll Job No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Projet Paie"}]}';
            DataClassification = CustomerContent;
            TableRelation = Job."No.";
        }
        field(30; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code catégorie article"}]}';
            DataClassification = CustomerContent;
        }
        field(40; "Location Code"; Code[10])
        {
            Caption = 'Location Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code magasin"}]}';
            DataClassification = CustomerContent;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50; "Business Dimension Code"; Code[20])
        {
            Caption = 'Business Dimension Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code axe affaire"}]}';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(60; "Use Job Descr. as Item Descr."; Boolean)
        {
            Caption = 'Use job description as item description', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Utiliser désignation projet comme description article"}]}';
            DataClassification = CustomerContent;
        }
        field(70; "Control Over Company"; Boolean)
        {
            Caption = 'Control Over Company', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Contrôle sur la société"}]}';
            DataClassification = CustomerContent;
        }
        field(80; "Attach. Posted Sales Inv. Open"; Text[250])
        {
            Caption = 'Attachment Posted Sales Invoice Address Open', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Adresse ouverture PJ Doc Vente Enregistrés" } ] }';
            DataClassification = CustomerContent;
        }
        field(90; "Attach. Posted Sales Inv. Save"; Text[250])
        {
            Caption = 'Attachment Posted Sales Invoice Address Save', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Adresse sauvegarde PJ Doc Vente Enregistrés" } ] }';
            DataClassification = CustomerContent;
        }
        field(100; "Pre-relaunch Period"; DateFormula)
        {
            Caption = 'Pre-relaunch Period', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Delai Pre-Relance"}]}';
            DataClassification = CustomerContent;
        }
        field(110; "Mail Notice Of Transfer"; Text[80])
        {
            Caption = 'Mail Notice Of Transfer', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Mail avis de virement"}]}';
            DataClassification = CustomerContent;
        }
        field(120; "Evaluation Period Situation"; Boolean)
        {
            Caption = 'Evaluation period situation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Période évaluation situation"}]}';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                JobSituationMgt: Codeunit "Job Situation Mgt.";
            begin
                JobSituationMgt.OnClickEvaluationPeriodSituation(Rec."Evaluation Period Situation");
            end;
        }
        field(130; "Blocked Custo. Sales Order"; Boolean)
        {
            Caption = 'Blocked Sell-To Customer on Sales Order', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Bloquer client sur commande vente"}]}';
            DataClassification = CustomerContent;
        }
        field(140; "Operation code"; Text[2])
        {
            Caption = 'Operation code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code opération"}]}';
            DataClassification = CustomerContent;
        }
        field(150; "ETEBAC Internat. Directory"; Text[1000])
        {
            Caption = 'ETEBAC Directory', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Répertoire ETEBAC"}]}';
            DataClassification = CustomerContent;
        }
        field(160; "Init. Item Direct Unit Cost"; Boolean)
        {
            Caption = 'Initialized Item Direct Unit Cost', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Coût unitaire direct article initialisé"}]}';
            DataClassification = CustomerContent;
            Description = 'Purchase Doc.';
        }
        field(170; "Gen. Bus. Posting Group RC"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group For Reverse Charge Field', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Groupe compta. marché pour autoliquidation"}]}';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group".Code;
        }


    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}