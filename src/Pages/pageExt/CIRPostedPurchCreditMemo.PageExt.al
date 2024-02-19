pageextension 50033 "CIR Posted Purch. Credit Memo" extends "Posted Purchase Credit Memo"
{
    actions
    {
        addafter("&Navigate")
        {
            action("Modify Cr. Memo Inv.")
            {
                Caption = 'Modify Cr. Memo Inv.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifer l''avoir achat"}]}';
                ApplicationArea = All;
                Image = ChangeTo;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Enabled = IsEditable;
                ToolTip = 'Modify Cr. Memo Inv.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifer l''avoir achat"}]}';

                trigger OnAction()
                var
                    ModifyPostedDocument: Codeunit "Modify Posted Document";
                begin
                    ModifyPostedDocument.ModifyPostedCrMemoInvoice(Rec);
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