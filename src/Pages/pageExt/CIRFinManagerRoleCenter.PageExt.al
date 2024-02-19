pageextension 50084 "CIR Fin. Manager Role Center" extends "Finance Manager Role Center"
{
    actions
    {
        addlast(Group18)
        {
            action("Dated Reconciliation")
            {
                Caption = 'Dated Reconciliation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rapprochement daté"}]}';
                ApplicationArea = all;
                RunObject = report "CIR Dated Reconciliation";
                ToolTip = 'Executes the Dated Reconciliation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rapprochement daté"}]}';
            }
        }
    }
}