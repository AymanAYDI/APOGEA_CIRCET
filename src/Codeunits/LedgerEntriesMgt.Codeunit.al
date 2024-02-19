codeunit 50021 "Ledger Entries Mgt."
{
    Permissions = TableData "Vendor Ledger Entry" = rimd,
                  TableData "Cust. Ledger Entry" = rimd,
                  TableData "Employee Ledger Entry" = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustEntry-Apply Posted Entries", 'OnAfterPostUnapplyCustLedgEntry', '', false, false)]
    local procedure OnAfterPostUnapplyCustLedgEntry(GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry"; DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitChanges: Boolean);
    var
        CustomerLedgerEntry2: Record "Cust. Ledger Entry";
    begin
        CustomerLedgerEntry2.SetRange("ACY_AAC Letter Code", CustLedgerEntry."ACY_AAC Letter Code");
        CustomerLedgerEntry2.SetRange("Customer No.", CustLedgerEntry."Customer No.");
        IF CustomerLedgerEntry2.FindSet() then
            REPEAT
                CustomerLedgerEntry2.VALIDATE("ACY_AAC Letter Code", '');
                CustomerLedgerEntry2.MODIFY();
            UNTIL CustomerLedgerEntry2.NEXT() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VendEntry-Apply Posted Entries", 'OnAfterPostUnapplyVendLedgEntry', '', false, false)]
    local procedure OnAfterPostUnapplyVendLedgEntry_ClearValues(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry"; DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry2.SetRange("ACY_AAC Letter Code", VendorLedgerEntry."ACY_AAC Letter Code");
        VendorLedgerEntry2.SetRange("Vendor No.", VendorLedgerEntry."Vendor No.");
        IF VendorLedgerEntry2.FindSet() then
            REPEAT
                VendorLedgerEntry2.VALIDATE("ACY_AAC Letter Code", '');
                VendorLedgerEntry2.MODIFY();
            UNTIL VendorLedgerEntry2.NEXT() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"EmplEntry-Apply Posted Entries", 'OnPostUnApplyEmployeeOnBeforeGenJnlPostLineUnapplyEmplLedgEntry', '', false, false)]
    local procedure OnPostUnApplyEmployeeOnBeforeGenJnlPostLineUnapplyEmplLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; EmplLedgerEntry: Record "Employee Ledger Entry"; DetailedEmplLedgEntry: Record "Detailed Employee Ledger Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line");
    var
        EmplLedgerEntry2: Record "Employee Ledger Entry";
    begin
        EmplLedgerEntry2.SetRange("ACY_AAC Letter Code", EmplLedgerEntry."ACY_AAC Letter Code");
        EmplLedgerEntry2.SetRange("Employee No.", EmplLedgerEntry."Employee No.");
        IF EmplLedgerEntry2.FindSet() then
            REPEAT
                EmplLedgerEntry2.VALIDATE("ACY_AAC Letter Code", '');
                EmplLedgerEntry2.MODIFY();
            UNTIL EmplLedgerEntry2.NEXT() = 0;
    end;
}