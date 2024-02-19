codeunit 50004 "Purchase Invoice Mgmt"
{
    Permissions = TableData "G/L Entry" = rmid,
                    tabledata "Vendor Ledger Entry" = rmid,
                    tabledata "VAT Entry" = rmid,
                    tabledata "Job Ledger Entry" = rmid;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnCheckExternalDocumentNumberOnAfterSetFilters', '', false, false)]
    local procedure OnCheckExternalDocumentNumberOnAfterSetFilters(var VendLedgEntry: Record "Vendor Ledger Entry"; PurchaseHeader: Record "Purchase Header");
    begin
        FilterPeriodOnDocumentDate(VendLedgEntry, PurchaseHeader);
    end;

    internal procedure ConfirmVendorInvoiceNo_AndChangeInAssociatedGL(PurchInvHeader: Record "Purch. Inv. Header"; VendorInvoiceNo: Code[35])
    var
        GLEntry: Record "G/L Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VATEntry: Record "VAT Entry";
        JobLedgerEntry: Record "Job Ledger Entry";
        ConfirmManagement: Codeunit "Confirm Management";
        ConfirmChangeExternalDocNo_Qst: Label 'Do you confirm the change of the vendor invoice No.?', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Confirmez-vous la modification du N° de facture fournisseur ?" }, { "lang": "FRB", "txt": "Confirmez-vous la modification du N° de facture fournisseur ?" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        ExternalDocNoHasNotBeenChanged_Err: Label 'The vendor invoice No. has not been changed.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Le N° de facture fournisseur n''a pas été modifié." }, { "lang": "FRB", "txt": "Le N° de facture fournisseur n''a pas été modifié." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        IF NOT ConfirmManagement.GetResponseOrDefault(ConfirmChangeExternalDocNo_Qst, FALSE) THEN
            ERROR(ExternalDocNoHasNotBeenChanged_Err);

        // Propagation de la modification sur les écritures comptables associées
        GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
        GLEntry.RESET();
        GLEntry.SETRANGE("Document No.", PurchInvHeader."No.");
        GLEntry.SETRANGE("Posting Date", PurchInvHeader."Posting Date");
        GLEntry.MODIFYALL("External Document No.", VendorInvoiceNo, FALSE);

        // Propagation de la modification sur l'écriture fournisseur associée
        VendorLedgerEntry.SETCURRENTKEY("Source Code", "Document No.", "Posting Date");
        VendorLedgerEntry.RESET();
        VendorLedgerEntry.SETRANGE("Document No.", PurchInvHeader."No.");
        VendorLedgerEntry.SETRANGE("Posting Date", PurchInvHeader."Posting Date");
        VendorLedgerEntry.MODIFYALL("External Document No.", VendorInvoiceNo, FALSE);

        // Propagation de la modification sur les écritures TVA associées
        VATEntry.SETCURRENTKEY("Document No.", "Posting Date");
        VATEntry.RESET();
        VATEntry.SETRANGE("Document No.", PurchInvHeader."No.");
        VATEntry.SETRANGE("Posting Date", PurchInvHeader."Posting Date");
        VATEntry.MODIFYALL("External Document No.", VendorInvoiceNo, FALSE);

        // Propagation de la modification sur les écritures projets associées
        JobLedgerEntry.SETCURRENTKEY("Document No.", "Posting Date", "Entry Type");
        JobLedgerEntry.RESET();
        JobLedgerEntry.SETRANGE("Document No.", PurchInvHeader."No.");
        JobLedgerEntry.SETRANGE("Posting Date", PurchInvHeader."Posting Date");
        JobLedgerEntry.MODIFYALL("External Document No.", VendorInvoiceNo, FALSE);
    end;

    internal procedure CheckVendorInvoiceNo(PurchInvHdr: Record "Purch. Inv. Header")
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        AlreadyExist_Err: label '%1 already exists', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%1 existe déjà" }, { "lang": "FRB", "txt": "%1 existe déjà" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        PurchInvHdr.TESTFIELD("Vendor Invoice No.");
        PurchInvHeader.SETCURRENTKEY("Vendor Invoice No.", "Posting Date");
        PurchInvHeader.SETRANGE("Vendor Invoice No.", PurchInvHdr."Vendor Invoice No.");
        PurchInvHeader.SETRANGE("Buy-from Vendor No.", PurchInvHdr."Buy-from Vendor No.");
        PurchInvHeader.SETFILTER("No.", '<>%1', PurchInvHdr."No.");
        IF NOT PurchInvHeader.ISEMPTY THEN
            PurchInvHeader.FIELDERROR("Vendor Invoice No.", STRSUBSTNO(AlreadyExist_Err, PurchInvHdr."Vendor Invoice No."));
    end;

    internal procedure ConfirmVendorCrMemoNo_AndChangeInAssociatedGL(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; VendorInvoiceNo: Code[35])
    var
        GLEntry: Record "G/L Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VATEntry: Record "VAT Entry";
        JobLedgerEntry: Record "Job Ledger Entry";
        ConfirmManagement: Codeunit "Confirm Management";
        ConfirmChangeExternalDocNo_Qst: Label 'Do you confirm the change of the Vendor Cr. Memo No. ?', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Confirmez-vous la modification du N° avoir fournisseur ?" }, { "lang": "FRB", "txt": "Confirmez-vous la modification du N° avoir fournisseur ?" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        ExternalDocNoHasNotBeenChanged_Err: Label 'The Vendor Cr. Memo No. has not been changed.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Le N° avoir fournisseur n''a pas été modifié." }, { "lang": "FRB", "txt": "Le N° avoir fournisseur n''a pas été modifié." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        IF NOT ConfirmManagement.GetResponseOrDefault(ConfirmChangeExternalDocNo_Qst, FALSE) THEN
            ERROR(ExternalDocNoHasNotBeenChanged_Err);

        // Propagation de la modification sur les écritures comptables associées
        GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
        GLEntry.RESET();
        GLEntry.SETRANGE("Document No.", PurchCrMemoHdr."No.");
        GLEntry.SETRANGE("Posting Date", PurchCrMemoHdr."Posting Date");
        GLEntry.MODIFYALL("External Document No.", VendorInvoiceNo, FALSE);

        // Propagation de la modification sur l'écriture fournisseur associée
        VendorLedgerEntry.SETCURRENTKEY("Source Code", "Document No.", "Posting Date");
        VendorLedgerEntry.RESET();
        VendorLedgerEntry.SETRANGE("Document No.", PurchCrMemoHdr."No.");
        VendorLedgerEntry.SETRANGE("Posting Date", PurchCrMemoHdr."Posting Date");
        VendorLedgerEntry.MODIFYALL("External Document No.", VendorInvoiceNo, FALSE);

        // Propagation de la modification sur les écritures TVA associées
        VATEntry.SETCURRENTKEY("Document No.", "Posting Date");
        VATEntry.RESET();
        VATEntry.SETRANGE("Document No.", PurchCrMemoHdr."No.");
        VATEntry.SETRANGE("Posting Date", PurchCrMemoHdr."Posting Date");
        VATEntry.MODIFYALL("External Document No.", VendorInvoiceNo, FALSE);

        // Propagation de la modification sur les écritures projets associées
        JobLedgerEntry.SETCURRENTKEY("Document No.", "Posting Date", "Entry Type");
        JobLedgerEntry.RESET();
        JobLedgerEntry.SETRANGE("Document No.", PurchCrMemoHdr."No.");
        JobLedgerEntry.SETRANGE("Posting Date", PurchCrMemoHdr."Posting Date");
        JobLedgerEntry.MODIFYALL("External Document No.", VendorInvoiceNo, FALSE);
    end;

    internal procedure CheckVendorCrMemoNo(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        PurchCrMemoHdr2: Record "Purch. Cr. Memo Hdr.";
        AlreadyExist_Err: label '%1 already exists', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%1 existe déjà" }, { "lang": "FRB", "txt": "%1 existe déjà" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        PurchCrMemoHdr.TESTFIELD("Vendor Cr. Memo No.");
        PurchCrMemoHdr2.SETCURRENTKEY("Vendor Cr. Memo No.", "Posting Date");
        PurchCrMemoHdr2.SETRANGE("Vendor Cr. Memo No.", PurchCrMemoHdr."Vendor Cr. Memo No.");
        PurchCrMemoHdr2.SETRANGE("Buy-from Vendor No.", PurchCrMemoHdr."Buy-from Vendor No.");
        PurchCrMemoHdr2.SETFILTER("No.", '<>%1', PurchCrMemoHdr."No.");
        IF NOT PurchCrMemoHdr2.ISEMPTY THEN
            PurchCrMemoHdr2.FIELDERROR("Vendor Cr. Memo No.", STRSUBSTNO(AlreadyExist_Err, PurchCrMemoHdr."Vendor Cr. Memo No."));
    end;

    //Fonction pour filtrer sur les documents d'achat par numéro de doc externe par année.
    local procedure FilterPeriodOnDocumentDate(var VendLedgEntry: Record "Vendor Ledger Entry"; PurchaseHeader: Record "Purchase Header")
    var
        DatGBegin, DatGEnd : Date;
        TxtGDate: Text;
    begin
        TxtGDate := '0101' + FORMAT(DATE2DMY(PurchaseHeader."Document Date", 3));
        EVALUATE(DatGBegin, TxtGDate);
        TxtGDate := '3112' + FORMAT(DATE2DMY(PurchaseHeader."Document Date", 3));
        EVALUATE(DatGEnd, TxtGDate);
        VendLedgEntry.SETRANGE("Document Date", DatGBegin, DatGEnd);
    end;
}