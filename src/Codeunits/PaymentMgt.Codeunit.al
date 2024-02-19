codeunit 50027 "Payment Mgt."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment Management", 'OnProcessPaymentStepOnCaseElse', '', false, false)]
    local procedure OnProcessPaymentStepOnCaseElse(var Step: Record "Payment Step"; var PaymentLine: Record "Payment Line"; var ActionValidated: Boolean);
    begin
        ExecuteStepSendMailOnPayment(Step, PaymentLine, ActionValidated);
    end;

    local procedure ExecuteStepSendMailOnPayment(var Step: Record "Payment Step"; var PaymentLine: Record "Payment Line"; var ActionValidated: Boolean)
    var
        PDFSendReportMgt: codeunit "PDF Send Report Mgt";
    begin
        case Step."Action Type" of
            Step."Action Type"::"Send By Mail":
                begin
                    CLEAR(PDFSendReportMgt);
                    PDFSendReportMgt.SendPaymentDocPDF(Step, PaymentLine);
                    ActionValidated := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Line", 'OnAfterSetUpNewLine', '', false, false)]
    local procedure OnAfterSetUpNewLine(var PaymentLine: Record "Payment Line");
    var
        vPaymentLine: Record "Payment Line";
    begin
        if PaymentLine."No." <> '' then begin
            vPaymentLine.SetRange("No.", PaymentLine."No.");
            if vPaymentLine.FindLast() then
                PaymentLine."Document No." := CopyStr(PaymentLine."No." + '/' + Format((vPaymentLine."Line No." + 10000)), 1, MaxStrLen(PaymentLine."Document No."))
            else
                PaymentLine."Document No." := CopyStr(PaymentLine."No." + '/' + Format(10000), 1, MaxStrLen(PaymentLine."Document No."));
        end;
    end;
}