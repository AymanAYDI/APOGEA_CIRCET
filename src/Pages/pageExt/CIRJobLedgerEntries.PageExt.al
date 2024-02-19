pageextension 50080 "CIR Job Ledger Entries" extends "Job Ledger Entries"
{
    layout
    {
        addafter("No.")
        {
            field("Start Date"; Rec."Start Date")
            {
                ToolTip = 'Specifies the value of the Start Date ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date début" }, { "lang": "FRB", "txt": "Date début" }]}';
                ApplicationArea = All;
                Width = 14;
            }
        }
    }
}