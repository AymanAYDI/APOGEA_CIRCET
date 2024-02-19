pageextension 50078 "CIR Employee List" extends "Employee List"
{
    layout
    {
        addlast(Control1)
        {
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

    trigger OnOpenPage()
    var
        UserGroup: Record "User Group";
        CIRUserManagement: Codeunit "CIR User Management";
    begin
        if not (CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Allow employees entries"))) then begin
            FILTERGROUP(2);
            SetFilter(rec."Date Filter", '010101..010101');
            FILTERGROUP(2);
        end;
    end;
}