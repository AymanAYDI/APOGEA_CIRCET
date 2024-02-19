page 50009 "Employee Statistics FactBox"
{
    Caption = 'Employee Statistics', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Statistiques salarié"}]}';
    PageType = CardPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
                Caption = 'Employee No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Salarié"}]}';
                ToolTip = 'Specifies the value of the Employee No. ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Salarié"}]}';

                trigger OnDrillDown()
                begin
                    ShowDetails();
                end;
            }

            field("Balance"; Rec."Balance")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Balance ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du solde"}]}';

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
    }

    trigger OnOpenPage()
    begin
        Rec.SetAutoCalcFields("Balance");
    end;

    local procedure ShowDetails()
    begin
        PAGE.Run(PAGE::"Employee Card", Rec);
    end;
}