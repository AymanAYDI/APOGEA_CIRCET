pageextension 50039 "CIRUserGroups" extends "User Groups"
{
    layout
    {
        addafter("Code")
        {
            field("Accounts receivable"; Rec."Accounts receivable")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Accounts receivable', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Service comptabilité client"}]}';
            }
            field(InvoicePurchaseRights; Rec."Invoice Purchase Rights")
            {
                ToolTip = 'Specifies the value of the Invoice Purchase Rights', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie si l''utilisateur à les droits achat lié à la facturation" } ] }';
                ApplicationArea = All;
            }
            field("Leader Sales Invoice"; Rec."Leader Sales Invoice")
            {
                ToolTip = 'Specifies the value of the Leader Sales Invoice', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Leader facturation vente" } ] } ';
                ApplicationArea = All;
            }
            field("Invoice Sale Rights"; Rec."Invoice Sales Rights")
            {
                ToolTip = 'Specifies the value of the Invoice Sales Rights', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Droits facturation achat" } ] } ';
                ApplicationArea = All;
            }
            field("Deletion Vendor RIB"; Rec."Deletion Vendor RIB")
            {
                ToolTip = 'Specifies the value of the Deletion Vendor RIB ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie si l''utilisateur peut supprimer un compte bancaire fournisseur"}]}';
                ApplicationArea = All;
            }
            field("Financial Controller"; Rec."Financial Controller")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Financial Controller', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Contrôleur de gestion"}]}';
            }
            field("Allow employees entries"; Rec."Allow employees entries")
            {
                ApplicationArea = All;
                ToolTip = 'Show employees entries', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Affiche les écritures salariés"}]}';
            }
        }
    }
}