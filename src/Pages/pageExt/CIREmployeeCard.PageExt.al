pageextension 50067 "CIR Employee Card" extends "Employee Card"
{
    layout
    {
        addlast(General)
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ToolTip = 'Specifies the value of the Global Dimension 1 Code';
                ApplicationArea = All;
            }
            field(Balance; Rec.Balance)
            {
                ToolTip = 'Specifies the value of the Balance ';
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    EmployeeLedgerEntry: Record "Employee Ledger Entry";
                    DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
                begin
                    DetailedEmployeeLedgerEntry.SetRange("Employee No.", Rec."No.");
                    Rec.CopyFilter("Global Dimension 1 Filter", DetailedEmployeeLedgerEntry."Initial Entry Global Dim. 1");
                    Rec.CopyFilter("Global Dimension 2 Filter", DetailedEmployeeLedgerEntry."Initial Entry Global Dim. 2");
                    Rec.CopyFilter("Date Filter", DetailedEmployeeLedgerEntry."Posting Date");
                    EmployeeLedgerEntry.DrillDownOnEntries(DetailedEmployeeLedgerEntry);
                end;
            }
        }
        addlast(factboxes)
        {
            part(EmployeeStatisticsFactBox; "Employee Statistics FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
        }
    }
}