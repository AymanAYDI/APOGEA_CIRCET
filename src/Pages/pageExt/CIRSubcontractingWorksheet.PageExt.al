pageextension 50068 "CIR Subcontracting Worksheet" extends "Subcontracting Worksheet"
{
    actions
    {
        addafter("Calculate Subcontracts")
        {
            action("AcceptRejectMessg.")
            {
                ApplicationArea = All;
                Caption = 'Accept/Reject all action messages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Accepter/Refuser tous les messages d''actions"}]}';
                Image = Refresh;
                Promoted = true;
                ToolTip = 'The action accept/refuse will apply on all lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"L''action accepter/refuser s''appliquera sur l''ensemble des lignes"}]}';
                trigger OnAction()
                var
                    SubContractingMgt: Codeunit "SubContracting Mgt.";
                begin
                    SubContractingMgt.SetAcceptOrRejectAction(Rec);
                end;
            }
        }
    }
}