table 50007 "Interface Log Entry"
{
    Caption = 'Interface Log Entry', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Écritures journal interface"}]}';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° écriture"}]}';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Date and Time"; DateTime)
        {
            Caption = 'Date and Time', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date & heure"}]}';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; "User Name"; Text[100])
        {
            Caption = 'User ID', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code utilisateur"}]}';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Interface Name"; Enum "Interface Name")
        {
            Caption = 'Interface Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom de l''interface"}]}';
            DataClassification = CustomerContent;
        }
        field(20; "Purch. Document Type"; Enum "Purchase Document Type")
        {
            Caption = 'Purch. Document Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type de document achat"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(25; "Purch. Document No."; Code[20])
        {
            Caption = 'Purch. Document No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° document achat"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(30; "Invoice ID"; Text[100])
        {
            Caption = 'Invoice ID', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ID facture"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(40; "Invoice Type"; Option)
        {
            Caption = 'Invoice Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type facture"}]}';
            DataClassification = CustomerContent;
            OptionMembers = "Accrued payable","Accrued not payable","Payable"," ";
            OptionCaption = 'Comptabilisée payable,Accrued not payable,Payable, ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Comptabilisée payable,Comptabilisée non payable,Payable, "}]}';
            Description = 'ITESOFT';
        }
        field(50; "Filename"; Text[100])
        {
            Caption = 'Filename', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du fichier"}]}';
            DataClassification = CustomerContent;
        }
        field(60; "Error"; Boolean)
        {
            Caption = 'Error', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Erreur"}]}';
            DataClassification = CustomerContent;
        }
        field(70; "Error Message"; Text[2048])
        {
            Caption = 'Error Message', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Message d''erreur"}]}';
            DataClassification = CustomerContent;
        }
        field(100; "Statement Type"; Option)
        {
            Caption = 'Statement Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type de déclaration"}]}';
            OptionCaption = 'Bank Reconciliation,Payment Application, ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rapprochement bancaire,Réglement applicatif, "}]}';
            OptionMembers = "Bank Reconciliation","Payment Application"," ";
            Description = 'ALLMYBANKS';
        }
        field(110; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° compte bancaire"}]}';
            DataClassification = CustomerContent;
            Description = 'ALLMYBANKS';
        }
        field(120; "Statement No."; Code[20])
        {
            Caption = 'Statement No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° de déclaration"}]}';
            DataClassification = CustomerContent;
            Description = 'ALLMYBANKS';
        }
        field(130; "Company Name"; Text[30])
        {
            Caption = 'Company Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom de société"}]}';
            DataClassification = CustomerContent;
            Description = 'ALLMYBANKS';
        }
        field(140; "Ack Filename"; Text[100])
        {
            Caption = 'Ack Filename', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du fichier d''acquittement"}]}';
            DataClassification = CustomerContent;
        }
        field(150; "Number of Lines Recon."; Integer)
        {
            Caption = 'Number of Bank Acc Reconciliation Line', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombres lignes relevé"}]}';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}