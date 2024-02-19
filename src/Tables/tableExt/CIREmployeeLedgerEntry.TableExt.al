tableextension 50041 "CIR Employee Ledger Entry" extends "Employee Ledger Entry"
{
    procedure DrillDownOnEntries(var DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry")
    var
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
    begin
        EmployeeLedgerEntry.Reset();
        DetailedEmployeeLedgerEntry.CopyFilter("Employee No.", EmployeeLedgerEntry."Employee No.");
        DetailedEmployeeLedgerEntry.CopyFilter("Currency Code", EmployeeLedgerEntry."Currency Code");
        DetailedEmployeeLedgerEntry.CopyFilter("Initial Entry Global Dim. 1", EmployeeLedgerEntry."Global Dimension 1 Code");
        DetailedEmployeeLedgerEntry.CopyFilter("Initial Entry Global Dim. 2", EmployeeLedgerEntry."Global Dimension 2 Code");
        EmployeeLedgerEntry.SetCurrentKey("Employee No.", "Posting Date");
        EmployeeLedgerEntry.SetRange(Open, true);
        PAGE.Run(Page::"Employee Ledger Entries", EmployeeLedgerEntry);
    end;
}