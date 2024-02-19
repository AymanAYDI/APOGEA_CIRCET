/*
Version------Trigramme-------Date------- N° REF   -    Domain : Comments
AC.FAB002       JCO       15/06/2021     Feature 10324 FAB002 : Ajout de l'axe analytique 3 en affichage
*/
pageextension 50006 "CIR Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field("Shortcut Dimension 1 Code52493"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
                Width = 10;
                ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code ';
            }
            field("Shortcut Dimension 2 Code96419"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = All;
                Width = 7;
                ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code ';
            }
            field("Purchaser Code21570"; Rec."Purchaser Code")
            {
                ApplicationArea = All;
                Width = 8;
                ToolTip = 'Specifies the value of the Purchaser Code ';
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
        addafter("Document Date")
        {
            field("Requested Receipt Date07633"; Rec."Requested Receipt Date")
            {
                ApplicationArea = All;
                Width = 11;
                ToolTip = 'Specifies the value of the Requested Receipt Date ';
            }
        }
        moveafter(ARBVRNPostedPrepayment; "Vendor Authorization No.")
        moveafter("Buy-from Vendor Name"; "Document Date")
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Width = 5;
        }
    }
    actions
    {
        addlast("O&rder")
        {
            action(ImportPurchaseOrderLine)
            {
                Caption = 'Import Purchase Order Line', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Import des lignes de cmd achat" }, { "lang": "FRB", "txt": "Import des lignes de cmd achat" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ToolTip = 'Allows you to launch the import of purchase order lines', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Permet de lancer l''import des lignes de commande d''achat" }, { "lang": "FRB", "txt": "Permet de lancer l''import des lignes de commande d''achat" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category6;
                RunObject = xmlport "Import Purchase Line";
                Image = Import;
            }
        }

        modify("Post")
        {
            Enabled = EnabledPost;
        }
        modify(PostAndPrint)
        {
            Enabled = EnabledPost;
        }
        modify(PostBatch)
        {
            Enabled = EnabledPost;
        }
    }
    trigger OnOpenPage()
    begin
        EnabledPost := CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Invoice Purchase Rights"))
    end;

    var
        UserGroup: Record "User Group";
        CIRUserManagement: Codeunit "CIR User Management";
        EnabledPost: Boolean;
}