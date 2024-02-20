/*
Version------Trigramme-------Date------- N° REF   -    Domain : Comments
AC.FAB002       JCO       15/06/2021     Feature 10324 FAB002 : Ajout de l'axe analytique 3 en affichage
*/
pageextension 50029 "CIR Sales Order List" extends "Sales Order List"
{
    layout
    {
        addafter("External Document No.")
        {
            field(ARBVRNJobNo; Rec.ARBVRNJobNo)
            {
                ToolTip = 'Specifies the value of the Job No. ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° de projet"}]}';
                ApplicationArea = All;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Dimension Value"; Rec."Dimension Value")
            {
                ToolTip = 'Specifies the value of the Dimension Value ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Affaire"}]}';
                ApplicationArea = All;
            }
            field("Dimension Value Name"; Rec."Dimension Value Name")
            {
                ToolTip = 'Specifies the value of the Dimension Value Name ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom Affaire"}]}';
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field("CIR Your Reference"; Rec."Your Reference")
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
    }
    actions
    {
        addlast("O&rder")
        {
            action("Import Sales Line")
            {
                Caption = 'Import Sales Order Line', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import des lignes de cmd ventes"}]}';
                ToolTip = 'Allows you to launch the import of sales order lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Permet de lancer l''import des lignes de commande ventes"}]}';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = xmlport "Import Sales Line";
                Image = Import;
            }
        }
    }
}