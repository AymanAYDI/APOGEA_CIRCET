codeunit 50001 "Payment Slip Subform Mgt"
{
    procedure AppliesToVendorLedgerEntries(PaymentLine: Record "Payment Line"; BooPDrillDown: Boolean): Integer
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendorLedgerEntries: Page "Vendor Ledger Entries";
    begin
        If PaymentLine."Applies-to ID" = '' then
            exit;
        VendorLedgerEntry.SetCurrentKey("Applies-to ID");
        VendorLedgerEntry.SetRange("Applies-to ID", PaymentLine."Applies-to ID");
        If VendorLedgerEntry.IsEmpty() then
            exit;
        If BooPDrillDown then begin
            VendorLedgerEntries.SetTableView(VendorLedgerEntry);
            VendorLedgerEntries.Run();
        end;
        exit(VendorLedgerEntry.Count)
    end;
}