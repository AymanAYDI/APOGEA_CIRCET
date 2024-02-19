codeunit 50026 "SubContracting Mgt."
{
    internal procedure SetAcceptOrRejectAction(ReqLines: Record "Requisition Line")
    var
        RequisitionLine: Record "Requisition Line";
        ChoiceOption: Integer;
        NumLigne: Integer;
        NbreLigne: Integer;
        ProgressDlg: Dialog;
        ConfirmChoiceOptionLbl: Label 'Accept all action messages, Reject all action messages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Accepter tous les messages d''actions, Refuser tous les messages d''actions"}]}';
        AcceptationChoiceLbl: Label 'Accept all action messages @1@', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Accepter tous les messages d''actions @1@"}]}';
        RejectChoiceLbl: Label 'Refus all action messages @1@', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Refuser tous les messages d''actions @1@"}]}';
    begin
        ChoiceOption := Dialog.StrMenu(ConfirmChoiceOptionLbl, 2);
        if ChoiceOption in [1, 2] then begin
            RequisitionLine.CopyFilters(ReqLines);
            if not RequisitionLine.IsEmpty() Then begin
                NbreLigne := RequisitionLine.count();
                NumLigne := 0;
                if ChoiceOption = 1 Then
                    ProgressDlg.open(AcceptationChoiceLbl)
                else
                    ProgressDlg.open(RejectChoiceLbl);

                RequisitionLine.FindSet();
                repeat
                    NumLigne += 1;
                    ProgressDlg.UPDATE(1, ROUND(10000 * NumLigne / NbreLigne, 1));
                    if RequisitionLine."Accept Action Message" <> (ChoiceOption = 1) Then begin
                        RequisitionLine.validate("Accept Action Message", (ChoiceOption = 1));
                        RequisitionLine.modify(true);
                    end;
                until RequisitionLine.next() = 0;
            end;
        end;
    end;
}