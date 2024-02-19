report 50009 "Import Job Allocation FA"
{
    Caption = 'Import Job Allocation FA', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import projet attribution immo"}]}';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnPreReport()
    begin
        OnRun();
    end;

    internal procedure OnRun()
    begin
        Xmlport.Run(Xmlport::"Import Job Allocation FA", false);
    end;
}