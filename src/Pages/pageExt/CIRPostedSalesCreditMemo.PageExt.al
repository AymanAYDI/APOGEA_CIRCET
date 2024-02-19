pageextension 50012 "CIR Posted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    layout
    {
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
    }

    actions
    {
        addlast(processing)
        {
            action("Modify Posted Sales Cr. Memo")
            {
                Caption = 'Modify Posted Sales Credit Memo', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifer l''avoir de vente"}]}';
                ApplicationArea = All;
                Image = ChangeTo;
                ToolTip = 'Modify Posted Sales Credit Memo', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifer l''avoir de vente"}]}';

                trigger OnAction()
                var
                    ModifyPostedDocument: codeunit "Modify Posted Document";
                begin
                    if (IsEditable or IsEditableBillto) then
                        ModifyPostedDocument.ModifyPostedSalesCreditMemo(Rec."No.")
                    else
                        Message(NoRigthoModifyCrMemoLbl);
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
        IsEditable, IsEditableBillto : Boolean;
        NoRigthoModifyCrMemoLbl: Label 'You don''t have right to modify this sales credit memo', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''avez pas les droits pour modifier cet avoir de vente"}]}';
}