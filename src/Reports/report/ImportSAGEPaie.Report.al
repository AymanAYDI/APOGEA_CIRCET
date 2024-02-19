report 50031 "Import SAGE Paie"
{
    Caption = 'Import payroll SAGE', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Import SAGE PAIE" } ] }';
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
        Xmlport.Run(Xmlport::"Import Sage Paie", false);
    end;
}