tableextension 50043 "CIR Job ledger Entry" extends "Job Ledger Entry"
{
    fields
    {
        field(50000; "Start Date"; Date)
        {
            Caption = 'Start Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date début" }, { "lang": "FRB", "txt": "Date début" }] }';
            DataClassification = CustomerContent;
        }
    }
}