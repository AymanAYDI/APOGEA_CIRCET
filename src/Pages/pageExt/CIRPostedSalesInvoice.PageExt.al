pageextension 50009 "CIR Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addafter(Closed)
        {
            field("Reminder Level Max"; Rec."Reminder Level Max")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the max reminder level if the Type field contains Reminder', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie le max niveau relance si le champ Type contient Relance." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
        }
        addafter("External Document No.")
        {
            field("Breakdown Invoice No."; Rec."Breakdown Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Breakdown Invoice No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° facture ventilée" }, { "lang": "FRB", "txt": "N° facture ventilée" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }

            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
        }
        addlast("Shipping and Billing")
        {
            field("Number of packages"; Rec."Number of packages")
            {
                ApplicationArea = All;
                ToolTip = 'Number of packages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de colis"}]}';
                Editable = false;
            }
            field("Total weight"; Rec."Total weight")
            {
                ApplicationArea = All;
                ToolTip = 'Total weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids total"}]}';
                Editable = false;
            }
        }
        addafter("Foreign Trade")
        {
            part(Documents; "Attachm. Posted Sales Invoice")
            {
                ApplicationArea = all;
                Caption = 'Documents', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Documents" } ] }';
                SubPageView = sorting("Sales Document Type", "Sales Document No.", "File No.") order(ascending) where("Sales Document Type" = const(Invoice));
                SubPageLink = "Sales Document No." = field("No.");
            }
        }
        addafter("Sell-to Customer Name")
        {
            field("Your Reference53001"; Rec."Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s reference. The contents will be printed on sales documents.';
            }
        }
        modify("Exit Point")
        {
            Caption = 'Exit Point', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Pays origine"}]}';
        }
    }

    actions
    {
        addfirst("Correct")
        {
            action("Modify Posted Sales Invoice")
            {
                Caption = 'Modify Posted Sales Invoice', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifer la facture de vente"}]}';
                ApplicationArea = All;
                Image = ChangeTo;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Modify Posted Sales Invoice', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifer la facture de vente"}]}';

                trigger OnAction()
                var
                    ModifyPostedDocument: codeunit "Modify Posted Document";
                begin
                    if (IsEditable or IsEditableBillto) then
                        ModifyPostedDocument.ModifyPostedSalesInvoice(rec."No.")
                    else
                        Message(NoRigthoModifyInvoiceLbl);
                end;
            }

            action("Modify Header Information")
            {
                Caption = 'Modify Shipment Information', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifier information expédition"}]}';
                ApplicationArea = All;
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Modify Shipment Information', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifier information expédition"}]}';

                trigger OnAction()
                begin
                    //Changement du poids et nombre de colis
                    SalesMgt.ModifyShipmentInfoOnSalesInv(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserGroup: Record "User Group";
        CIRUserManagement: Codeunit "CIR User Management";
    begin
        IsEditable := CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Invoice Sales Rights"));
        IsEditableBillto := CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Leader Sales Invoice"));
    end;

    var
        SalesMgt: Codeunit "Sales Mgt.";
        IsEditable, IsEditableBillto : Boolean;
        NoRigthoModifyInvoiceLbl: Label 'You don''t have right to modify this sales invoice', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''avez pas les droits pour modifier cette facture de vente"}]}';
}