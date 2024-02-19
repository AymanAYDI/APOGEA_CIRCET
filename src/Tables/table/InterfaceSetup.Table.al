table 50004 "Interface Setup"
{
    Caption = 'Interface Setup', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Paramètres interface"},{"lang":"FRB","txt":"Paramètres interface"},{"lang":"DEU","txt":"<ToComplete>"},{"lang":"ESP","txt":"<ToComplete>"},{"lang":"ITA","txt":"<ToComplete>"},{"lang":"NLB","txt":"<ToComplete>"},{"lang":"NLD","txt":"<ToComplete>"},{"lang":"PTG","txt":"<ToComplete>"}]}';
    DataClassification = CustomerContent;

    fields
    {
        #region SAP CONCUR
        field(1; "Primary Key"; Integer)
        {
            Caption = 'Primary Key', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Clé primaire" } ] }';
            DataClassification = CustomerContent;
        }
        field(2; "Expense Job Journal Template"; Code[10])
        {
            Caption = 'Expense Job Journal Template', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Modèle feuille projet frais" }, { "lang": "FRB", "txt": "Modèle Feuille Prj Frais" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Job Journal Template";
            DataClassification = CustomerContent;
            Description = 'SAP CONCUR';
        }
        field(3; "Work Type Expense"; Code[10])
        {
            Caption = 'Work Type Expense', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type travail frais" }, { "lang": "FRB", "txt": "Type travail frais" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Work Type";
            DataClassification = CustomerContent;
            Description = 'SAP CONCUR';
        }
        field(4; "Expense Journal Template"; Code[10])
        {
            Caption = 'Expense Journal Template', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Modèle feuille comptable frais" }, { "lang": "FRB", "txt": "Modèle feuille de frais" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Gen. Journal Template".Name;
            DataClassification = CustomerContent;
            Description = 'SAP CONCUR';
        }
        #endregion SAP CONCUR

        #region QUARKSUP
        field(50; "Employee Posting Group"; Code[10])
        {
            Caption = 'Employee Posting Group', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Groupe compta. salarié"}]}';
            DataClassification = CustomerContent;
            TableRelation = "Employee Posting Group".Code;
            Description = 'Quarksup';
        }
        field(60; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group Resource', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Groupe compta. produit ressource"}]}';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Product Posting Group";
            Description = 'Quarksup';
        }
        field(90; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Unité de base"}]}';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
            Description = 'Quarksup';
        }
        #endregion QUARKSUP

        #region Horoquartz
        field(100; "HQ Job Journal Template"; Code[10])
        {
            Caption = 'Job Journal Template', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modèle feuille Horoquartz"}]}';
            TableRelation = "Job Journal Template".Name;
            DataClassification = CustomerContent;
            Description = 'HOROQUARTZ';
        }

        field(110; "HQ Root Name Journal Batch"; Code[2])
        {
            Caption = 'Root Name Journal Batch', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Racine nom feuille Horoquartz"}]}';
            DataClassification = CustomerContent;
            Description = 'HOROQUARTZ';
        }
        #endregion Horoquartz

        #region SAGE PAIE
        field(160; "SAGE PAIE Gen. Jnl. Template"; Code[10])
        {
            Caption = 'Gen. Journal Template', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom modèle feuille"}]}';
            TableRelation = "Gen. Journal Template" WHERE(Type = CONST(General));
            NotBlank = true;
            DataClassification = CustomerContent;
            Description = 'SAGE PAIE';
        }
        field(170; "SAGE PAIE Gen. Journal Batch"; Code[10])
        {
            Caption = 'Gen. Journal Batch', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom feuille"}]}';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("SAGE PAIE Gen. Jnl. Template"));
            NotBlank = true;
            DataClassification = CustomerContent;
            Description = 'SAGE PAIE';
        }
        #endregion SAGE PAIE

        #region ITESOFT

        field(300; Path; Text[250])
        {
            Caption = 'Path', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Chemin"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }

        field(310; "Archive Message"; Boolean)
        {
            Caption = 'Archive the file', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Archiver le fichier"}]}';
            InitValue = true;
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(320; "Archive Path"; Text[250])
        {
            Caption = 'Archive Path', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Répertoire d''archive"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(330; "Response Path"; Text[250])
        {
            Caption = 'Response Path', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Répertoire de réponse"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(340; "Error Code Invoice Status"; Text[10])
        {
            Caption = 'Error Code Invoice Status', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code d''erreur BAP"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(350; "Success Code"; Text[10])
        {
            Caption = 'Success Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code de succès"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(360; "On Hold Code"; Text[10])
        {
            Caption = 'On Hold Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code en attente"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(370; "Gen. Posting Code"; Text[10])
        {
            Caption = 'Gen. Posting Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code validation comptable"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(380; "Final Posting Code"; Text[10])
        {
            Caption = 'Final Posting Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code validation finale"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(390; "Error Code Inv."; Text[10])
        {
            Caption = 'Error Code Inv.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code d''erreur Facture/Avoir"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        #endregion ITESOFT

        #region ALLMYBANKS

        field(400; "Bank File Path"; Text[250])
        {
            Caption = 'Path', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Chemin fichier bancaire"}]}';
            DataClassification = CustomerContent;
            Description = 'ALLMYBANKS';
        }

        field(410; "Archive Bank File"; Boolean)
        {
            Caption = 'Archive Bank File', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Archiver fichier bancaire"}]}';
            InitValue = true;
            DataClassification = CustomerContent;
            Description = 'ALLMYBANKS';
        }
        field(420; "Archive Bank File Path"; Text[250])
        {
            Caption = 'Archive Bank File Path', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Répertoire d''archive fichier bancaire"}]}';
            DataClassification = CustomerContent;
            Description = 'ALLMYBANKS';
        }
        #endregion ALLMYBANKS
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}