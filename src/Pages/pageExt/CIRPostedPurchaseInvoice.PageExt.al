pageextension 50008 "CIR Posted Purchase Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("Direct Customer Payment"; Rec."Direct Customer Payment")
            {
                ApplicationArea = ALL;
                Editable = false;
                ToolTip = 'Specifies the value of the Direct Customer Payment', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Paiement direct client"}]}';
            }
        }
        modify("Vendor Invoice No.")
        {
            Editable = IsEditable;

            trigger OnAfterValidate()
            var
                PurchaseInvoiceMgmt: Codeunit "Purchase Invoice Mgmt";
            begin
                IF Rec."Vendor Invoice No." = xRec."Vendor Invoice No." THEN
                    EXIT
                else
                    PurchaseInvoiceMgmt.CheckVendorInvoiceNo(Rec);
                CurrPage.Update();
            end;
        }
    }

    actions
    {
        addfirst("Correct")
        {
            action("Modify Purch. Inv.")
            {
                Caption = 'Modify Posted Purchase Invoice', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifer la facture achat"}]}';
                ApplicationArea = All;
                Image = ChangeTo;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Enabled = IsEditable;
                ToolTip = 'Modify Posted Purchase Invoice', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifer la facture achat"}]}';

                trigger OnAction()
                var
                    ModifyPostedDocument: Codeunit "Modify Posted Document";
                begin
                    ModifyPostedDocument.ModifyPostedPurchInvoice(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserGroup: Record "User Group";
        CIRUserManagement: Codeunit "CIR User Management";
    begin
        IsEditable := CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Invoice Purchase Rights"));
    end;

    var
        IsEditable: Boolean;
}