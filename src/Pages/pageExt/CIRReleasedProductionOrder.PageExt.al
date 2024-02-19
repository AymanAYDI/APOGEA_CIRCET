pageextension 50079 "CIR Released Production Order" extends "Released Production Order"
{
    layout
    {
        addLast(General)
        {
            field("No. Printed"; Rec."Print count")
            {
                ToolTip = 'Specifies the value of the Print count field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du champ Nombre impression."}]}';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(reporting)
        {
            action("ProductionfollowUp")
            {
                ApplicationArea = All;
                Caption = 'Production follow-up', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Suivi de production"}]}';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Print the production follow-up.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Imprimer le suivi de production"}]}';

                trigger OnAction()
                var
                    ProdOrderMgt: Codeunit "Prod. Order Mgt.";
                begin
                    ProdOrderMgt.ExecuteProductionFollowUP("No.", true, true);
                end;
            }
        }
    }
}