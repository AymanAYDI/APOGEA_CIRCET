codeunit 50000 "Report Mgt."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', true, true)]
    local procedure OnAfterSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        OnAfterSubstituteReport_DetailTrialBalance(ReportId, NewReportId);
        OnAfterSubstituteReport_ExportGLEntriesTaxAudit(ReportId, NewReportId);
        OnAfterSubstituteReport_Order(ReportId, NewReportId);
        OnAfterSubstituteReport_Reminder(ReportId, NewReportId);
        OnAfterSubstituteReport_FixedAsset(ReportId, NewReportId);
        OnAfterSubstituteReport_SEPAISO20022(ReportId, NewReportId);
        if ReportId = Report::"Posted Assembly Order" then
            NewReportId := Report::"CIR Posted Assembly Order";
    end;

    local procedure OnAfterSubstituteReport_DetailTrialBalance(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = report::"Customer Detail Trial Balance" then
            NewReportId := Report::"CIR Cust. Detail Trial Balance";
        if ReportId = report::"Vendor Detail Trial Balance FR" then
            NewReportId := Report::"CIR Vend. Detail Trial Balance";
        if ReportId = report::"Detail Trial Balance" then
            NewReportId := Report::"CIR Detail Trial Balance";
        if ReportId = Report::"Customer - Detail Trial Bal." then
            NewReportId := Report::"CIR Cust. Detail Trial Balance";
        if ReportId = report::"Vendor - Detail Trial Balance" then
            NewReportId := Report::"CIR Vend. Detail Trial Balance";
        if ReportId = report::"Trial Balance" then
            NewReportId := Report::"CIR Trial Balance";
    end;

    local procedure OnAfterSubstituteReport_FixedAsset(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::"Fixed Asset - Projected Value" then
            NewReportId := Report::"CIR Fixed Asset-Projected Val.";
    end;

    local procedure OnAfterSubstituteReport_Reminder(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::Reminder then
            NewReportId := Report::"Reminder Circet";
    end;

    local procedure OnAfterSubstituteReport_ExportGLEntriesTaxAudit(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = report::"Export G/L Entries - Tax Audit" then
            NewReportId := Report::"CIR Export GL Entries TaxAudit";
    end;

    local procedure OnAfterSubstituteReport_Order(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = report::"Standard Purchase - Order" then
            NewReportId := Report::"CIR Standard Purchase - Order"
    end;

    local procedure OnAfterSubstituteReport_SEPAISO20022(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::"CIR SEPA ISO20022" then
            NewReportId := Report::"CIR SEPA ISO20022";
    end;

    internal procedure BlankZero(Number: Decimal): Text
    begin
        if Number <> 0 then
            exit(Format(Number, 0, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
        else
            exit('');
    end;

    internal procedure BlankZeroFormatted(NumberFormatted: Text): Text
    var
        Number: Integer;
    begin
        if Evaluate(Number, NumberFormatted) and (Number = 0) then
            exit('')
        else
            exit(NumberFormatted)
    end;
}