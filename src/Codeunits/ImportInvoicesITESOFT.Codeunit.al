codeunit 50023 "Import Invoices ITESOFT"
{
    trigger OnRun()
    var
        PurchaseHeader: Record "Purchase Header";
        InterfaceLogEntry: Record "Interface Log Entry";
        ImportXMLMgt: Codeunit "Import XML Mgt.";
        InterfaceLogMgt: Codeunit "Interface Log Mgt.";
        InterfaceName: Enum "Interface Name";
        PurchDocumentType: Enum "Purchase Document Type";
        LogEntry: Integer;
        BoolError: Boolean;
        InvoiceType: Integer;
    begin
        TempNameValueBuffer.DELETEALL();
        InterfaceSetup.GET();
        CheckFields(InterfaceSetup);
        FileManagement.GetServerDirectoryFilesList(TempNameValueBuffer, InterfaceSetup.Path);
        IF TempNameValueBuffer.FINDSET() THEN
            REPEAT
                // Clear Last Error
                CLEARLASTERROR();

                // Génération des logs
                LogEntry := InterfaceLogMgt.CreateLogInterface(InterfaceName::ITESOFT, '', '', '', 0, PurchDocumentType::Invoice, '', CopyStr(CompanyName(), 1, 30));

                COMMIT();
                CLEAR(ImportXMLMgt);
                ImportXMLMgt.FctSetValueBufferName(TempNameValueBuffer.Name);
                IF NOT ImportXMLMgt.RUN() THEN BEGIN
                    ImportXMLMgt.FctGetGlobalInformation(DocumentType, DocumentNo, VendorInvoiceID, VendorInvoiceNo, BuyfromVendorNo, Approved, CodGTreatment, BooGPostedDocExist, BooGDocApproved, DocumentDate);
                    IF CodGTreatment = InterfaceSetup."Gen. Posting Code" THEN BEGIN
                        IF BooGPostedDocExist OR ((NOT BooGDocApproved) AND NOT Approved) THEN
                            FctExportXMLResponse(InterfaceSetup."Error Code Inv.", GETLASTERRORTEXT(), VendorInvoiceID)
                        ELSE
                            IF (BooGPostedDocExist AND BooGDocApproved) THEN
                                FctExportXMLResponse(InterfaceSetup."On Hold Code", FctGetInvDocNo(VendorInvoiceNo), VendorInvoiceID)
                            ELSE
                                IF NOT BooGPostedDocExist THEN
                                    FctExportXMLResponse(InterfaceSetup."Error Code Inv.", GETLASTERRORTEXT(), VendorInvoiceID);
                    END ELSE
                        FctExportXMLResponse(InterfaceSetup."Error Code Invoice Status", GETLASTERRORTEXT(), VendorInvoiceID);

                    IF PurchaseHeader.GET(DocumentType, DocumentNo) THEN BEGIN
                        PurchaseHeader."Vendor Invoice No." := PurchaseHeader."No.";
                        PurchaseHeader.MODIFY();
                        PurchaseHeader.DELETE(TRUE);
                    END;
                END ELSE BEGIN
                    ImportXMLMgt.FctGetGlobalInformation(DocumentType, DocumentNo, VendorInvoiceID, VendorInvoiceNo, BuyfromVendorNo, Approved, CodGTreatment, BooGPostedDocExist, BooGDocApproved, DocumentDate);
                    IF Approved THEN
                        FctExportXMLResponse(InterfaceSetup."Success Code", FctGetInvDocNo(VendorInvoiceNo), VendorInvoiceID)
                    ELSE
                        FctExportXMLResponse(InterfaceSetup."On Hold Code", FctGetInvDocNo(VendorInvoiceNo), VendorInvoiceID);
                END;
                IF InterfaceSetup."Archive Message" THEN
                    FileManagement.CopyServerFile(TempNameValueBuffer.Name, InterfaceSetup."Archive Path" + '\' + TempNameValueBuffer.Value + '.xml', TRUE);
                FileManagement.DeleteServerFile(TempNameValueBuffer.Name);

                // Mise à jour des logs
                BoolError := (GETLASTERRORTEXT() <> '');

                IF NOT approved then
                    InvoiceType := InterfaceLogEntry."Invoice Type"::"Accrued not payable"
                ELSE
                    IF (CodGTreatment <> InterfaceSetup."Final Posting Code") THEN
                        InvoiceType := InterfaceLogEntry."Invoice Type"::"Accrued payable"
                    ELSE
                        InvoiceType := InterfaceLogEntry."Invoice Type"::"Payable";

                DocumentNo := FctGetInvDocNo(VendorInvoiceNo);
                IF BoolError then begin
                    InvoiceType := InterfaceLogEntry."Invoice Type"::" ";
                    DocumentType := DocumentType::" ";
                    DocumentNo := '';
                    DocumentDate := 0D;
                END;

                InterfaceLogMgt.ModifyLogInterface(LogEntry, COPYSTR((TempNameValueBuffer.Value + '.xml'), 1, 100), COPYSTR((VendorInvoiceID + '.ack.xml'), 1, 100), VendorInvoiceID, InvoiceType, DocumentType, DocumentNo, 3 /*Empty*/, '', '', 0, '', BoolError, '');
            UNTIL TempNameValueBuffer.NEXT() = 0;
    END;

    local procedure CheckFields(pInterfaceSetup: record "Interface Setup")
    begin
        pInterfaceSetup.TestField(Path);
        pInterfaceSetup.TestField("Response Path");
        IF pInterfaceSetup."Archive Message" THEN
            pInterfaceSetup.TestField("Archive Path");
    end;

    local procedure FctExportXMLResponse(returnCode: Text; returnMessage: Text; pVendorInvoiceID: Text[50])
    var
        TempXMLBuffer: Record "XML Buffer" temporary;
    begin
        //On ne créé pas de fichier si l'ID est non lu dans le fichier.
        IF pVendorInvoiceID = '' THEN
            EXIT;
        //Suppression du fichier ack
        IF Erase(InterfaceSetup."Response Path" + '\' + pVendorInvoiceID + '.ack.xml') THEN;

        //Création du fichier ack
        TempXMLBuffer.CreateRootElement('root');
        TempXMLBuffer.AddLastElement('id', pVendorInvoiceID);
        TempXMLBuffer.AddGroupElement('contentData');
        TempXMLBuffer.AddGroupElement('header');
        TempXMLBuffer.AddElement('returnCode', returnCode);
        TempXMLBuffer.AddLastElement('returnMessage', returnMessage);
        TempXMLBuffer.GetParent();
        TempXMLBuffer.Save(InterfaceSetup."Response Path" + '\' + pVendorInvoiceID + '.ack.xml');
    end;

    local procedure FctGetInvDocNo(VendorInvNo: Code[35]): Code[20]
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        CASE DocumentType of
            DocumentType::Invoice:
                BEGIN
                    PurchInvHeader.SETCURRENTKEY("Vendor Invoice No.", "Buy-from Vendor No.");
                    PurchInvHeader.SETRANGE("Vendor Invoice No.", VendorInvNo);
                    PurchInvHeader.SETRANGE("Buy-from Vendor No.", BuyfromVendorNo);
                    IF (DocumentDate <> 0D) THEN
                        PurchInvHeader.SETRANGE("Document Date", DocumentDate);
                    IF PurchInvHeader.FINDLAST() THEN
                        EXIT(PurchInvHeader."No.");
                END;
            DocumentType::"Credit Memo":
                BEGIN
                    PurchCrMemoHdr.SETCURRENTKEY("Vendor Cr. Memo No.", "Buy-from Vendor No.");
                    PurchCrMemoHdr.SETRANGE("Vendor Cr. Memo No.", VendorInvNo);
                    PurchCrMemoHdr.SETRANGE("Buy-from Vendor No.", BuyfromVendorNo);
                    IF (DocumentDate <> 0D) THEN
                        PurchCrMemoHdr.SETRANGE("Document Date", DocumentDate);
                    IF PurchCrMemoHdr.FINDLAST() THEN
                        EXIT(PurchCrMemoHdr."No.");
                END;
        END;

        //Si aucun document on vérifie si ce n'est pas une écriture
        VendorLedgerEntry.SETCURRENTKEY("Document Type", "Vendor No.", "External Document No.", "Document Date");
        VendorLedgerEntry.SETRANGE("Document Type", DocumentType);
        VendorLedgerEntry.SETRANGE("Vendor No.", BuyfromVendorNo);
        VendorLedgerEntry.SETRANGE("External Document No.", VendorInvoiceNo);
        IF (DocumentDate <> 0D) THEN
            PurchInvHeader.SETRANGE("Document Date", DocumentDate);
        IF VendorLedgerEntry.FINDLAST() then
            EXIT(VendorLedgerEntry."Document No.");
    end;

    var
        InterfaceSetup: Record "Interface Setup";
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        FileManagement: Codeunit "File Management";
        DocumentNo: Code[20];
        VendorInvoiceNo: Code[35];
        BuyfromVendorNo: Code[20];
        CodGTreatment: Code[10];
        VendorInvoiceID: Text[50];
        DocumentType: Enum "Purchase Document Type";
        Approved, BooGPostedDocExist, BooGDocApproved : Boolean;
        DocumentDate: Date;
}