report 50035 "Lettering Employee"
{
    ApplicationArea = All;
    Caption = 'Lettering Employee', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Lettrage salarié"}]}';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Employee; Employee)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name";

            trigger OnAfterGetRecord()
            var
                EmployeeLedgerEntry: Record "Employee Ledger Entry";
                EmployeeLedgerEntry2: Record "Employee Ledger Entry";
                TempEmployeeLedgerEntry: Record "Employee Ledger Entry" temporary;
            begin
                CalcFields(Balance);
                if Balance <> 0 then
                    CurrReport.Skip();

                EmployeeLedgerEntry.SetRange("Employee No.", Employee."No.");
                EmployeeLedgerEntry.Setrange(Open, true);
                EmployeeLedgerEntry.SetFilter("Applies-to ID", '<>%1', '');
                if EmployeeLedgerEntry.Findset() then
                    repeat
                        EmployeeLedgerEntry2.SETRANGE("Entry No.", EmployeeLedgerEntry."Entry No.");
                        EmplEntrySetApplID.SetApplId(EmployeeLedgerEntry2, TempEmployeeLedgerEntry, '');
                    until EmployeeLedgerEntry.NEXT() = 0;

                EmployeeLedgerEntry.Reset();
                EmployeeLedgerEntry.SetRange("Employee No.", Employee."No.");
                EmployeeLedgerEntry.Setrange(Open, true);
                if EmployeeLedgerEntry.Findset() then begin
                    EmplEntrySetApplID.SetApplId(EmployeeLedgerEntry, TempEmployeeLedgerEntry, CopyStr(Userid(), 1, 50));
                    EmplEntryApplyPostedEntries.Apply(EmployeeLedgerEntry, EmployeeLedgerEntry."Document No.", 0D);
                end;
            end;
        }
    }

    var
        EmplEntrySetApplID: codeunit "Empl. Entry-SetAppl.ID";
        EmplEntryApplyPostedEntries: codeunit "EmplEntry-Apply Posted Entries";
}