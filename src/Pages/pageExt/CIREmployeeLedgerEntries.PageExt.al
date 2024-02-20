pageextension 50503 "CIR Employee Ledger Entries" extends "Employee Ledger Entries"
{
    layout
    {
        addafter(Amount)
        {

            field("Debit Amount"; Rec."Debit Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the total of the ledger entries that represent debits.';
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the total of the ledger entries that represent credits.';
            }
        }
        addafter("Amount (LCY)")
        {

            field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Debit Amount (LCY) ';
            }
            field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Credit Amount (LCY) ';
            }
        }
    }

    trigger OnOpenPage()
    var
        UserGroup: Record "User Group";
        CIRUserManagement: Codeunit "CIR User Management";
    begin
        if not (CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Allow employees entries"))) then begin
            Rec.FILTERGROUP(2);
            rec.SetFilter("Entry No.", '%1', 0);
            Rec.FILTERGROUP(2);
        end;
    end;
}