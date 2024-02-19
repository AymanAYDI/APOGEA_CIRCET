/*
Version------Trigramme-------Date------- N° REF   -    Domain : Comments
AC.FAB002       JCO       15/06/2021     Feature 10324 FAB002 : Ajout de l'axe analytique 3 en affichage
*/
pageextension 50028 "CIR Assembly Orders" extends "Assembly Orders"
{
    layout
    {
        addafter("Remaining Quantity")
        {
            field("Assembly to Order No."; Rec."Assembly to Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Order No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° commande"}]}';
                Editable = false;
            }
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Job No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° projet"}]}';
                Editable = false;
            }
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code destinataire"}]}';
            }
            field("Ship-to Name"; Rec."Ship-to Name")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du destinataire"}]}';
            }
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Name 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du destinataire 2"}]}';
            }
            field("Ship-to Address"; Rec."Ship-to Address")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Address', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse destinataire"}]}';
            }
            field("Ship-to Address 2"; Rec."Ship-to Address 2")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Address 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse destinataire 2"}]}';
            }
            field("Ship-to City"; Rec."Ship-to City")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to City', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ville destinataire"}]}';
            }
            field("Number of packages"; Rec."Number of packages")
            {
                ApplicationArea = All;
                ToolTip = 'Number of packages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de colis"}]}';
            }
            field("Total weight"; Rec."Total weight")
            {
                ApplicationArea = All;
                ToolTip = 'Total weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids total"}]}';
            }
            field("Business"; Rec."Business")
            {
                ApplicationArea = All;
                ToolTip = 'Business Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code Affaire"}]}';
                Editable = false;
            }
            field("Business name"; Rec."Business name")
            {
                ApplicationArea = All;
                ToolTip = 'Business name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom Affaire"}]}';
                Editable = false;
            }
            field("Ship-to Post Code"; Rec."Ship-to Post Code")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Post Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code postal destinataire"}]}';
            }
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = All;
                ToolTip = 'Shipping Agent Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code transporteur"}]}';
            }
            field("Comment 1"; Rec."Comment 1")
            {
                ApplicationArea = All;
                ToolTip = 'Comment 1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaire 1"}]}';
            }
            field("Comment 2"; Rec."Comment 2")
            {
                ApplicationArea = All;
                ToolTip = 'Comment 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaire 2"}]}';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Status', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Statut"}]}';
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ToolTip = 'Specifies the value of the Your Reference field', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du champ Votre référence"}]}';
                ApplicationArea = All;
            }
            field("Site Code"; Rec."Site Code")
            {
                ToolTip = 'Specifies the value of the Site Code field', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du champ code site"}]}';
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("ShorCut Dimension 3 Code"; ShorCutDimension3Code)
            {
                ApplicationArea = All;
                Caption = 'ShorCut Dimension 3 Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code section axe 3" } ] }';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
                CaptionClass = '1,2,3';
                ToolTip = 'Specifies the value of the ShorCut Dimension 3 Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code section axe 3" } ] }';
                Editable = false;
            }
        }
        modify("Starting Date")
        {
            Caption = 'Starting Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de départ"}]}';
        }
    }

    trigger OnOpenPage()
    begin
        GeneralLedgerSetup.GET();
    end;

    trigger OnAfterGetRecord()
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        if DimensionSetEntry.Get(Rec."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 3 Code") then
            ShorCutDimension3Code := DimensionSetEntry."Dimension Value Code"
        else
            ShorCutDimension3Code := '';
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        ShorCutDimension3Code: Code[20];
}