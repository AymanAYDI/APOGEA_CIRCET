report 50006 "Import general ledger entry"
{
    Caption = 'Import general ledger entry', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Import écriture comptable" } ] }';
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
        Xmlport.Run(Xmlport::"Import general ledger entry", false);
    end;
}