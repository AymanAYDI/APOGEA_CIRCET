pageextension 50045 "CIR ACY_ACC Accruals Overview" extends "ACY_AAC Accruals Overview"
{
    actions
    {
        addafter(GetLines)
        {
            action(GetOrderLines)
            {
                ApplicationArea = All;
                Caption = 'Search Accrues Lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Extraire FNP sur commandes"}]}';
                Image = ViewOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Search accrues lines at situation date.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Extraire lignes FNP sur commandes d''achat à date de situation"}]}';

                trigger OnAction()
                begin
                    CurrPage.Lines.Page.GetOrderLines(Rec."Accrual Type", SituationDate, Periodicity);
                    CurrPage.Lines.Page.SetVisibility(TRUE);
                    CurrPage.Update(false);
                end;
            }
        }
        modify(GetLines)
        {
            trigger OnBeforeAction()
            begin
                CurrPage.Lines.Page.SetVisibility(FALSE);
            end;
        }
    }
}