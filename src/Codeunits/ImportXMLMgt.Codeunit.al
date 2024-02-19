codeunit 50049 "Import XML Mgt."
{
    Permissions = TableData "Purch. Cr. Memo Hdr." = rimd, TableData "Purch. Inv. Header" = rimd, TableData "Vendor Ledger Entry" = rimd;

    trigger OnRun()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
    begin
        IF FctImportPurchFromXml() THEN
            IF (NOT Approved) OR (Approved AND NOT PostedDocExist) THEN BEGIN
                PurchaseHeader.GET(DocumentType, DocumentNo);
                PurchaseHeader.Receive := FALSE;
                PurchaseHeader.Invoice := TRUE;
                COMMIT();
                PurchaseHeader.CALCFIELDS("Amount Including VAT");
                IF (PurchaseHeader."Amount Including VAT" <> 0) THEN
                    PurchPost.RUN(PurchaseHeader)
                ELSE
                    PurchaseHeader.FIELDERROR("Amount Including VAT");
            END;
    end;

    var
        TempXMLVATBuffer: Record "VAT XML Buffer" temporary;
        TempXMLBuffer: Record "XML Buffer" temporary;
        Approved, BooGDocApproved, PostedDocExist, WIPO : Boolean;
        CodGTreatment: Code[10];
        BuyfromVendorNo, DocumentNo, JobNo : Code[20];
        CodGVATBusPstGrp: Code[20];
        DocsReference, VendorInvoiceNo : Code[35];
        CodGVATLabelMax: Code[50];
        DatGBegin, DatGDocumentDate, DatGEnd, DocumentDate : Date;
        DocumentType: Enum "Purchase Document Type";
        IntGLineCounter, IntGLineMax : Integer;
        InvoiceIDMissingLbl: Label 'Itesoft ID on invoice is missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Identificateur Itesoft de la facture absent"}]}';
        InvoiceNotFoundErr: Label 'Invoice Not Found', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Facture non trouvée"}]}';
        InvoiceNulmberLbl: Label 'This invoice number %1 already exist for this year.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ce numéro de facture %1 existe déjà pour cette année."}]}';
        ReceiptLineNotFoundErr: Label 'Receipt Line Not Found', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne de réception non trouvée"}]}';
        TaxLineLbl: Label 'Tax line incompatible with the rest of the document, %1.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne de taxe incompatible avec le reste du document, %1."}]}';
        UserAutomaticTxt: Label 'Automatique', Locked = true;
        WaitingLbl: Label 'ATT', Locked = true;
        TxtGDate: Text;
        TxtGValueBufferName: Text;
        codingUser: Text[50];
        VendorInvoiceID: Text[50];
        Description2: Text[100];

    Internal procedure FctGetGlobalInformation(var pDocumentType: ENUM "Purchase Document Type"; var CodPDocumentNo: Code[20]; var TxtPVendorInvoiceID: Text[50]; var CodPVendorInvoiceNo: Code[35]; var CodPBuyfromVendorNo: Code[20]; var BooPApproved: Boolean; var CodPTreatment: Code[10]; var BooPPostedDocExist: Boolean; var BooPDocApproved: Boolean; var DatePDocumentDate: Date)
    begin
        pDocumentType := DocumentType;
        CodPDocumentNo := DocumentNo;
        TxtPVendorInvoiceID := VendorInvoiceID;
        CodPVendorInvoiceNo := VendorInvoiceNo;
        CodPBuyfromVendorNo := BuyfromVendorNo;
        BooPApproved := Approved;
        CodPTreatment := CodGTreatment;
        BooPPostedDocExist := PostedDocExist;
        BooPDocApproved := BooGDocApproved;
        DatePDocumentDate := DocumentDate;
    end;

    Internal procedure FctSetValueBufferName(TxtPValueBufferName: Text)
    begin
        TxtGValueBufferName := TxtPValueBufferName;
    end;

    local procedure CheckVATBusPostGrp(EntryNo: Integer)
    var
        TempXMLBufferl: Record "XML Buffer" temporary;
        CodLVATLabel: Code[50];
    begin
        //Manage VAT Business Posting Group
        TempXMLBufferl.COPY(TempXMLBuffer, TRUE);
        TempXMLBufferl.RESET();
        TempXMLBufferl.SETRANGE("Parent Entry No.", EntryNo);
        IF TempXMLBufferl.FINDSET() THEN
            REPEAT
                CASE TempXMLBufferl.Name OF
                    'code':
                        CodLVATLabel := COPYSTR(TempXMLBufferl.Value, 1, MAXSTRLEN(CodLVATLabel));
                END;
            UNTIL TempXMLBufferl.NEXT() = 0;

        IntGLineCounter += 1;
        InsertVATBuffer(CodLVATLabel);
    end;

    local procedure FctChangeStatus()
    var
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchInvHeader: Record "Purch. Inv. Header";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.SETCURRENTKEY("Document Type", "Vendor No.", "External Document No.", "Document Date");
        VendorLedgerEntry.SETRANGE("Document Type", DocumentType);
        VendorLedgerEntry.SETRANGE("Vendor No.", BuyfromVendorNo);
        VendorLedgerEntry.SETRANGE("External Document No.", VendorInvoiceNo);
        VendorLedgerEntry.SETRANGE("Document Date", DatGBegin, DatGEnd);
        IF VendorLedgerEntry.FINDFIRST() THEN BEGIN
            FctChangeStatusOnLedgerEntry(VendorLedgerEntry."Document No.");

            IF VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice THEN BEGIN
                PurchInvHeader.SETCURRENTKEY("Vendor Invoice No.", "Buy-from Vendor No.");
                PurchInvHeader.SETRANGE("Vendor Invoice No.", VendorInvoiceNo);
                PurchInvHeader.SETRANGE("Buy-from Vendor No.", BuyfromVendorNo);
                PurchInvHeader.SETRANGE("Document Date", DatGBegin, DatGEnd);
                IF PurchInvHeader.FINDFIRST() THEN BEGIN
                    PurchInvHeader.Approved := TRUE;
                    PurchInvHeader.MODIFY();
                END;
            END ELSE
                IF VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" THEN BEGIN
                    PurchCrMemoHdr.SETCURRENTKEY("Vendor Cr. Memo No.", "Buy-from Vendor No.");
                    PurchCrMemoHdr.SETRANGE("Vendor Cr. Memo No.", VendorInvoiceNo);
                    PurchCrMemoHdr.SETRANGE("Buy-from Vendor No.", BuyfromVendorNo);
                    PurchCrMemoHdr.SETRANGE("Document Date", DatGBegin, DatGEnd);
                    IF PurchCrMemoHdr.FINDFIRST() THEN BEGIN
                        PurchCrMemoHdr.Approved := TRUE;
                        PurchCrMemoHdr.MODIFY();
                    END;
                END;
        END;
    end;

    local procedure FctChangeStatusOnLedgerEntry(PostedDocNo: Code[20])
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.SETCURRENTKEY("Document No.");
        VendorLedgerEntry.SETRANGE("Document No.", PostedDocNo);
        IF VendorLedgerEntry.FINDFIRST() THEN BEGIN
            IF NOT Approved THEN
                VendorLedgerEntry."On Hold" := WaitingLbl
            ELSE
                VendorLedgerEntry."On Hold" := '';
            VendorLedgerEntry.MODIFY();
        END;
    end;

    local procedure FctCheckVendLedgerEntry()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        PostedDocExist := FALSE;
        BooGDocApproved := FALSE;

        VendorLedgerEntry.SETCURRENTKEY("Document Type", "Vendor No.", "External Document No.", "Document Date");
        VendorLedgerEntry.SETRANGE("Document Type", DocumentType);
        VendorLedgerEntry.SETRANGE("Vendor No.", BuyfromVendorNo);
        VendorLedgerEntry.SETRANGE("External Document No.", VendorInvoiceNo);
        VendorLedgerEntry.SETRANGE("Document Date", DatGBegin, DatGEnd);
        PostedDocExist := NOT VendorLedgerEntry.ISEMPTY();

        VendorLedgerEntry.SETRANGE("On Hold", '');
        BooGDocApproved := NOT VendorLedgerEntry.ISEMPTY();
    end;

    local procedure FctCopyPurchDoc(DocNo: Code[20]; var pPurchHeader: Record "Purchase Header")
    var
        PurchSetup: Record "Purchases & Payables Setup";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        DocType: Enum "Purchase Document Type From";
    begin
        PurchSetup.GET();
        CopyDocMgt.SetProperties(FALSE, FALSE, FALSE, FALSE, FALSE, PurchSetup."Exact Cost Reversing Mandatory", FALSE);
        CopyDocMgt.CopyPurchDoc(DocType::"Posted Invoice", DocNo, pPurchHeader)
    end;

    local procedure FctCreateInvLine(CodPReceiptNo: Code[20]; IntPReceiptLineNo: Integer; DecPQty: Decimal; DecPUnitCost: Decimal; var RecPPurchLine: Record "Purchase Line"; ProdPostingGroup: Code[20]; BusPostingGroup: Code[20])
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.RESET();
        PurchRcptLine.SETRANGE("Document No.", CodPReceiptNo);
        PurchRcptLine.SETRANGE("Line No.", IntPReceiptLineNo);
        PurchRcptLine.SETFILTER("Qty. Rcd. Not Invoiced", '<>0');
        IF PurchRcptLine.FINDFIRST() THEN BEGIN
            RecPPurchLine.LOCKTABLE();
            RecPPurchLine.SETRANGE("Document Type", DocumentType);
            RecPPurchLine.SETRANGE("Document No.", DocumentNo);
            RecPPurchLine."Document Type" := DocumentType;
            RecPPurchLine."Document No." := DocumentNo;
            PurchRcptLine.InsertInvLineFromRcptLine(RecPPurchLine);
            IF RecPPurchLine."VAT Prod. Posting Group" <> ProdPostingGroup THEN
                RecPPurchLine."VAT Prod. Posting Group" := ProdPostingGroup;
            RecPPurchLine.VALIDATE("VAT Bus. Posting Group", BusPostingGroup);
            RecPPurchLine.VALIDATE("VAT Prod. Posting Group", ProdPostingGroup);
            UpdateReservationEntry(RecPPurchLine, DecPQty);
            RecPPurchLine.VALIDATE(Quantity, DecPQty);
            RecPPurchLine.VALIDATE("Direct Unit Cost", DecPUnitCost);
            RecPPurchLine.MODIFY();
        END ELSE
            ERROR(ReceiptLineNotFoundErr);
    end;

    local procedure FctCreatePurchLine(var pPurchLine: Record "Purchase Line"; quantity: Decimal; unitCost: Decimal; netAmount: Decimal; account: Code[20]; AmountIncVAT: Decimal; ProdPostingGroup: Code[20]; BusPostingGroup: Code[20]; pJobNo: Code[20])
    begin
        pPurchLine."Document Type" := DocumentType;
        pPurchLine."Document No." := DocumentNo;
        pPurchLine."Line No." := FctGetLineNo();
        pPurchLine.INSERT();
        pPurchLine.VALIDATE(Type, pPurchLine.Type::"G/L Account");
        pPurchLine.VALIDATE("No.", account);
        pPurchLine.VALIDATE("Buy-from Vendor No.", BuyfromVendorNo);
        pPurchLine.VALIDATE("VAT Bus. Posting Group", BusPostingGroup);
        pPurchLine.VALIDATE("VAT Prod. Posting Group", ProdPostingGroup);
        pPurchLine.VALIDATE(Quantity, quantity);
        pPurchLine.VALIDATE("Direct Unit Cost", unitCost);
        pPurchLine.VALIDATE("Line Amount", netAmount);
        pPurchLine.VALIDATE("Amount Including VAT", AmountIncVAT);
        pPurchLine.TESTFIELD("Amount Including VAT");
        pPurchLine.VALIDATE("Job No.", pJobNo);
        pPurchLine.MODIFY();
    end;

    local procedure FctGetCodingUser(EntryNo: Integer): Text[50]
    begin
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE("Parent Entry No.", EntryNo);
        TempXMLBuffer.SETRANGE(Name, 'Value');
        IF TempXMLBuffer.FINDFIRST() THEN
            EXIT(COPYSTR(TempXMLBuffer.Value, 1, 50));
    end;

    local procedure FctGetDescription2(EntryNo: Integer): Text[100]
    begin
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE("Parent Entry No.", EntryNo);
        TempXMLBuffer.SETRANGE(Name, 'Value');
        IF TempXMLBuffer.FINDFIRST() THEN
            EXIT(COPYSTR(TempXMLBuffer.Value, 1, 100));
    end;

    local procedure FctGetDocNumber(EntryNo: Integer): Code[20]
    begin
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE("Parent Entry No.", EntryNo);
        TempXMLBuffer.SETRANGE(Name, 'docNumber');
        IF TempXMLBuffer.FINDFIRST() THEN
            VendorInvoiceNo := COPYSTR(TempXMLBuffer.Value, 1, MAXSTRLEN(VendorInvoiceNo));
    end;

    local procedure FctGetDocsReference(EntryNo: Integer): Code[35]
    begin
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE("Parent Entry No.", EntryNo);
        TempXMLBuffer.SETRANGE(Name, 'code');
        IF TempXMLBuffer.FINDFIRST() THEN
            EXIT(COPYSTR(TempXMLBuffer.Value, 1, 35));
    end;

    local procedure FctGetDocType(EntryNo: Integer): Code[20]
    begin
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE("Parent Entry No.", EntryNo);
        TempXMLBuffer.SETRANGE(Name, 'documentType');
        IF TempXMLBuffer.FINDFIRST() THEN
            IF TempXMLBuffer.Value = 'INV' THEN
                DocumentType := DocumentType::Invoice
            ELSE
                IF TempXMLBuffer.Value = 'CRME' THEN
                    DocumentType := DocumentType::"Credit Memo";
    end;

    local procedure FctGetJob(EntryNo: Integer): Code[20]
    begin
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE("Parent Entry No.", EntryNo);
        TempXMLBuffer.SETRANGE(Name, 'value');
        IF TempXMLBuffer.FINDFIRST() THEN
            EXIT(COPYSTR(TempXMLBuffer.Value, 1, 20));
    end;

    local procedure FctGetJob2(EntryNo: Integer): Code[20]
    var
        TempXMLBufferl: Record "XML Buffer" temporary;
        BooLJobNo: Boolean;
    begin
        BooLJobNo := FALSE;
        TempXMLBufferl.COPY(TempXMLBuffer, TRUE);
        TempXMLBufferl.RESET();
        TempXMLBufferl.SETRANGE("Parent Entry No.", EntryNo);
        IF TempXMLBufferl.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF (TempXMLBufferl.Name = 'key') AND (TempXMLBufferl.Value = 'cusProject') THEN
                    BooLJobNo := TRUE
                ELSE
                    IF (BooLJobNo) AND (TempXMLBufferl.Name = 'value') THEN
                        EXIT(COPYSTR(TempXMLBufferl.Value, 1, 20));
            UNTIL (TempXMLBufferl.NEXT() = 0);
        EXIT('');
    end;

    local procedure FctGetLineNo(): Integer
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.RESET();
        PurchaseLine.SETRANGE("Document Type", DocumentType);
        PurchaseLine.SETRANGE("Document No.", DocumentNo);
        IF PurchaseLine.FINDLAST() THEN
            EXIT(PurchaseLine."Line No." + 10000)
        ELSE
            EXIT(10000);
    end;

    local procedure FctGetPostingGroups(VATLabel: Text; var ProdPostingGroup: Code[20]; var BusPostingGroup: Code[20]; CodPAccountNo: Code[20])
    var
        GLAccount: Record "G/L Account";
        VATPostingSetup: Record "VAT Posting Setup";
        VatProdPGrp: Code[20];
    begin
        VatProdPGrp := '';
        IF GLAccount.GET(CodPAccountNo) THEN
            VatProdPGrp := GLAccount."VAT Prod. Posting Group";

        VATPostingSetup.RESET();
        VATPostingSetup.SETRANGE("VAT Bus. Posting Group", CodGVATBusPstGrp);
        VATPostingSetup.SETRANGE("VAT Label", VATLabel);
        VATPostingSetup.SETRANGE("VAT Prod. Posting Group", VatProdPGrp);
        IF VATPostingSetup.FINDFIRST() THEN BEGIN
            ProdPostingGroup := VATPostingSetup."VAT Prod. Posting Group";
            BusPostingGroup := VATPostingSetup."VAT Bus. Posting Group";
        END ELSE BEGIN
            VATPostingSetup.SETRANGE("VAT Prod. Posting Group");
            IF VATPostingSetup.FINDFIRST() THEN BEGIN
                ProdPostingGroup := VATPostingSetup."VAT Prod. Posting Group";
                BusPostingGroup := VATPostingSetup."VAT Bus. Posting Group";
            END;
        END;
    end;

    local procedure FctGetStatus(EntryNo: Integer): Boolean
    var
        InterfaceSetup: Record "Interface Setup";
    begin
        InterfaceSetup.GET();
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE("Parent Entry No.", EntryNo);
        TempXMLBuffer.SETRANGE(Name, 'code');
        IF TempXMLBuffer.FINDFIRST() THEN
            IF TempXMLBuffer.Value = InterfaceSetup."Gen. Posting Code" THEN
                Approved := FALSE
            ELSE
                IF TempXMLBuffer.Value = InterfaceSetup."Final Posting Code" THEN
                    Approved := TRUE;
    end;

    local procedure FctGetStatus2(EntryNo: Integer): Code[10]
    var
        InterfaceSetup: Record "Interface Setup";
    begin
        //To Manage Error Code
        InterfaceSetup.GET();
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE("Parent Entry No.", EntryNo);
        TempXMLBuffer.SETRANGE(Name, 'code');
        IF TempXMLBuffer.FINDFIRST() THEN
            IF TempXMLBuffer.Value = InterfaceSetup."Gen. Posting Code" THEN
                CodGTreatment := InterfaceSetup."Gen. Posting Code"
            ELSE
                IF TempXMLBuffer.Value = InterfaceSetup."Final Posting Code" THEN
                    CodGTreatment := InterfaceSetup."Final Posting Code";
    end;

    local procedure FctGetSupplier(EntryNo: Integer): Code[20]
    begin
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE("Parent Entry No.", EntryNo);
        TempXMLBuffer.SETRANGE(Name, 'code');
        IF TempXMLBuffer.FINDFIRST() THEN
            EXIT(COPYSTR(TempXMLBuffer.Value, 1, 20));
    end;

    local procedure FctImportPurchFromXml() Check: boolean
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchaseHeader: Record "Purchase Header";
        HeaderEntryNo: Integer;
        Pos: Integer;
    begin
        ClearLastError();
        Check := FALSE;
        Pos := 0;
        TempXMLBuffer.RESET();
        TempXMLBuffer.DELETEALL();
        FctInitialize();
        TempXMLBuffer.Load(TxtGValueBufferName);

        //GET STATUS
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
        TempXMLBuffer.SETRANGE(Name, 'status');
        IF TempXMLBuffer.FINDFIRST() THEN
            FctGetStatus(TempXMLBuffer."Entry No.");

        //Manage Error Code
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
        TempXMLBuffer.SETRANGE(Name, 'status');
        IF TempXMLBuffer.FINDFIRST() THEN
            FctGetStatus2(TempXMLBuffer."Entry No.");

        //GET SUPPLIER
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
        TempXMLBuffer.SETRANGE(Name, 'supplier');
        IF TempXMLBuffer.FINDFIRST() THEN
            BuyfromVendorNo := FctGetSupplier(TempXMLBuffer."Entry No.");

        //GET DocsReference
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
        TempXMLBuffer.SETRANGE(Name, 'DocsReference');
        IF TempXMLBuffer.FINDFIRST() THEN
            DocsReference := FctGetDocsReference(TempXMLBuffer."Entry No.");

        //CHECK WIPO
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
        TempXMLBuffer.SETRANGE(Name, 'detectedDocumentCategory');
        IF TempXMLBuffer.FINDFIRST() THEN
            IF TempXMLBuffer.Value = 'WIPO' THEN
                WIPO := TRUE
            ELSE
                WIPO := FALSE;

        //A PARTIR DE LA PREMIERE LIGNE
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
        TempXMLBuffer.SETRANGE(Value, 'cusProject');
        IF TempXMLBuffer.FINDFIRST() THEN BEGIN
            JobNo := FctGetJob(TempXMLBuffer."Parent Entry No.");
            Pos := STRPOS(JobNo, '_') - 1;
            IF (Pos > 0) THEN
                JobNo := COPYSTR(COPYSTR(JobNo, 1, Pos), 1, MaxStrLen(JobNo));
        END;

        //GET ID
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
        TempXMLBuffer.SETRANGE(Name, 'id');
        TempXMLBuffer.SETRANGE(path, '/root/id');
        IF TempXMLBuffer.FINDFIRST() THEN
            VendorInvoiceID := COPYSTR(TempXMLBuffer.Value, 1, MaxStrLen(VendorInvoiceID))
        ELSE
            ERROR(InvoiceIDMissingLbl);

        //GET codingUser
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
        TempXMLBuffer.SETRANGE(Name, 'key');
        TempXMLBuffer.SETRANGE(Value, 'codingUser');
        IF TempXMLBuffer.FINDFIRST() THEN
            codingUser := FctGetCodingUser(TempXMLBuffer."Parent Entry No.");

        //GET description2
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
        TempXMLBuffer.SETRANGE(Name, 'key');
        TempXMLBuffer.SETRANGE(Value, 'description2');
        IF TempXMLBuffer.FINDFIRST() THEN
            description2 := FctGetDescription2(TempXMLBuffer."Parent Entry No.");

        //Check Document Date
        TxtGDate := '';
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
        TempXMLBuffer.SETRANGE(Name, 'documentDate');
        IF TempXMLBuffer.FINDFIRST() THEN BEGIN
            EVALUATE(DatGDocumentDate, COPYSTR(TempXMLBuffer.Value, 9, 2) + COPYSTR(TempXMLBuffer.Value, 6, 2) + COPYSTR(TempXMLBuffer.Value, 1, 4));
            TxtGDate := '0101' + FORMAT(DATE2DMY(DatGDocumentDate, 3));
            EVALUATE(DatGBegin, TxtGDate);
            TxtGDate := '3112' + FORMAT(DATE2DMY(DatGDocumentDate, 3));
            EVALUATE(DatGEnd, TxtGDate)
        END;

        //INSERT PUCHASE HEADER
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
        TempXMLBuffer.SETRANGE(Name, 'header');
        IF TempXMLBuffer.FINDFIRST() THEN BEGIN
            HeaderEntryNo := TempXMLBuffer."Entry No.";
            FctGetDocType(HeaderEntryNo);
            FctGetDocNumber(HeaderEntryNo);
            FctCheckVendLedgerEntry();

            IF PostedDocExist then
                IF (BooGDocApproved) OR ((NOT BooGDocApproved) AND NOT Approved) then
                    ERROR(InvoiceNulmberLbl, VendorInvoiceNo);

            IF (NOT PostedDocExist) THEN BEGIN
                //Manage VAT Lines
                IntGLineMax := 0;
                CodGVATLabelMax := '';
                CodGVATBusPstGrp := '';
                PurgeXMLVATBuffer();
                TempXMLBuffer.RESET();
                TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
                TempXMLBuffer.SETRANGE(Name, 'tax');
                IF TempXMLBuffer.FINDSET() THEN
                    REPEAT
                        CheckVATBusPostGrp(TempXMLBuffer."Entry No.");
                    UNTIL TempXMLBuffer.NEXT() = 0;
                GetVATBusPstGrp();

                FctInsertPurchHeader(HeaderEntryNo);
                IF (DocumentType = DocumentType::"Credit Memo") AND (DocsReference <> '') THEN BEGIN
                    PurchaseHeader.GET(DocumentType, DocumentNo);
                    PurchInvHeader.RESET();
                    PurchInvHeader.SETRANGE("Buy-from Vendor No.", BuyfromVendorNo);
                    PurchInvHeader.SETRANGE("Vendor Invoice No.", DocsReference);
                    IF PurchInvHeader.FINDFIRST() THEN
                        FctCopyPurchDoc(PurchInvHeader."No.", PurchaseHeader)
                    ELSE
                        ERROR(InvoiceNotFoundErr);
                END ELSE BEGIN
                    //INSERT PUCHASE LINES
                    TempXMLBuffer.RESET();
                    TempXMLBuffer.SETRANGE(Type, TempXMLBuffer.Type::Element);
                    TempXMLBuffer.SETRANGE(Name, 'invoiceLine');
                    IF TempXMLBuffer.FINDSET() THEN
                        REPEAT
                            FctInsertPurchLine(TempXMLBuffer."Entry No.");
                        UNTIL TempXMLBuffer.NEXT() = 0;
                END;
            END ELSE
                IF Approved THEN
                    FctChangeStatus();
        END;
        Check := (GetLastErrorCode = '');
    end;

    local procedure FctInitialize()
    begin
        DocumentType := DocumentType::Invoice;
        DocumentNo := '';
        DocumentDate := 0D;
        BuyfromVendorNo := '';
        JobNo := '';
        WIPO := FALSE;
        VendorInvoiceNo := '';
        VendorInvoiceID := '';
        BuyfromVendorNo := '';
        DocsReference := '';
    end;

    local procedure FctInsertPurchHeader(EntryNo: Integer)
    var
        Currency: Record "Currency";
        PurchaseHeader: Record "Purchase Header";
        lDocumentDate: Date;
    begin
        DocumentNo := '';
        PurchaseHeader.INIT();
        TempXMLBuffer.RESET();
        TempXMLBuffer.SETRANGE("Parent Entry No.", EntryNo);
        IF TempXMLBuffer.FINDSET() THEN
            REPEAT
                CASE TempXMLBuffer.Name OF
                    'documentType':
                        BEGIN
                            IF DocumentType = DocumentType::Invoice THEN
                                PurchaseHeader."Vendor Cr. Memo No." := ''
                            ELSE
                                IF DocumentType = DocumentType::"Credit Memo" THEN
                                    PurchaseHeader."Vendor Invoice No." := '';
                            PurchaseHeader."Document Type" := DocumentType;
                            IF PurchaseHeader.INSERT(TRUE) THEN BEGIN
                                DocumentNo := PurchaseHeader."No.";
                                PurchaseHeader.VALIDATE("Buy-from Vendor No.", BuyfromVendorNo);
                                IF PurchaseHeader."VAT Bus. Posting Group" <> CodGVATBusPstGrp THEN
                                    PurchaseHeader.VALIDATE("VAT Bus. Posting Group", CodGVATBusPstGrp);
                            END;
                        END;
                    'docNumber':
                        BEGIN
                            PurchaseHeader."Vendor Invoice No." := VendorInvoiceNo;
                            PurchaseHeader."Vendor Cr. Memo No." := VendorInvoiceNo;
                        END;
                    'currency':
                        IF Currency.GET(TempXMLBuffer.Value) THEN
                            PurchaseHeader.VALIDATE("Currency Code", TempXMLBuffer.Value);
                    'invoiceReference':
                        PurchaseHeader.VALIDATE("Vendor Invoice No.", TempXMLBuffer.Value);
                    'documentDate':
                        BEGIN
                            EVALUATE(lDocumentDate, COPYSTR(TempXMLBuffer.Value, 9, 2) + COPYSTR(TempXMLBuffer.Value, 6, 2) + COPYSTR(TempXMLBuffer.Value, 1, 4));
                            PurchaseHeader.VALIDATE("Document Date", lDocumentDate);
                            DocumentDate := PurchaseHeader."Document Date";
                        END;
                    'orderCode':
                        PurchaseHeader.VALIDATE("Vendor Order No.", TempXMLBuffer.Value);
                    'description':
                        IF NOT WIPO THEN
                            PurchaseHeader.VALIDATE("Posting Description", CopyStr((PurchaseHeader."Pay-to Name" + '/ ' + description2), 1, MaxStrLen(PurchaseHeader."Posting Description")));
                    'expectedAccountingDate':
                        BEGIN
                            PurchaseHeader.VALIDATE("Posting Date", WORKDATE());
                            PurchaseHeader.VALIDATE("Document Date", lDocumentDate);
                            PurchaseHeader.VALIDATE(ARBVRNJobNo, JobNo);
                            PurchaseHeader.Approved := Approved;
                            IF NOT Approved THEN
                                PurchaseHeader."On Hold" := WaitingLbl;
                            IF codingUser <> '' THEN
                                PurchaseHeader."ITESOFT User ID" := codingUser
                            ELSE
                                PurchaseHeader."ITESOFT User ID" := UserAutomaticTxt;
                            PurchaseHeader.MODIFY();
                        END;
                END;
            UNTIL TempXMLBuffer.NEXT() = 0;
    end;

    local procedure FctInsertPurchLine(EntryNo: Integer)
    var
        PurchaseLine: Record "Purchase Line";
        TempXMLBuffer2: Record "XML Buffer" temporary;
        TempXMLBuffer3: Record "XML Buffer" temporary;
        TempXMLBuffer4: Record "XML Buffer" temporary;
        account: Code[20];
        BusPostingGroup: Code[20];
        CodLJobNo: Code[20];
        ProdPostingGroup: Code[20];
        receiptNo: Code[20];
        AmountIncVAT: Decimal;
        netAmount: Decimal;
        quantity: Decimal;
        unitCost: Decimal;
        Pos: Integer;
        receiptLineNo: Integer;
        receiptLineCode: Text;
    begin
        PurchaseLine.INIT();
        CodLJobNo := '';
        TempXMLBuffer2.COPY(TempXMLBuffer, TRUE);
        TempXMLBuffer2.RESET();
        TempXMLBuffer2.SETRANGE("Parent Entry No.", EntryNo);
        IF TempXMLBuffer2.FINDSET() THEN
            REPEAT
                CASE TempXMLBuffer2.Name OF
                    'quantity':
                        EVALUATE(quantity, CONVERTSTR(TempXMLBuffer2.Value, '.', ','));
                    'unitPrice':
                        EVALUATE(unitCost, CONVERTSTR(TempXMLBuffer2.Value, '.', ','));
                    'receiptLineCode':
                        IF WIPO THEN
                            IF TempXMLBuffer2.Value <> '' THEN BEGIN
                                receiptLineCode := CONVERTSTR(TempXMLBuffer2.Value, '-', ',');
                                receiptLineCode := CONVERTSTR(receiptLineCode, '_', ',');
                                receiptNo := COPYSTR(SELECTSTR(1, receiptLineCode), 1, MAXSTRLEN(receiptNo));
                                EVALUATE(receiptLineNo, SELECTSTR(2, receiptLineCode));
                            END ELSE
                                receiptLineCode := '';
                    'netAmount':
                        IF TempXMLBuffer2.Value <> '' THEN
                            EVALUATE(netAmount, CONVERTSTR(TempXMLBuffer2.Value, '.', ','));
                    'estimatedTotalAmount':
                        IF TempXMLBuffer2.Value <> '' THEN
                            EVALUATE(AmountIncVAT, CONVERTSTR(TempXMLBuffer2.Value, '.', ','));
                    'account':
                        begin
                            account := COPYSTR(TempXMLBuffer2.Value, 1, MAXSTRLEN(account));
                            Pos := STRPOS(account, '_') - 1;
                            IF (Pos > 0) THEN
                                account := COPYSTR(COPYSTR(account, 1, Pos), 1, MaxStrLen(account));
                        end;
                    'tax':
                        BEGIN
                            TempXMLBuffer3.COPY(TempXMLBuffer, TRUE);
                            TempXMLBuffer3.RESET();
                            TempXMLBuffer3.SETRANGE("Parent Entry No.", TempXMLBuffer2."Entry No.");
                            TempXMLBuffer3.SETRANGE(Name, 'code');
                            IF TempXMLBuffer3.FINDFIRST() THEN
                                FctGetPostingGroups(TempXMLBuffer3.Value, ProdPostingGroup, BusPostingGroup, account);
                        END;
                    'fields':
                        BEGIN
                            TempXMLBuffer4.COPY(TempXMLBuffer, TRUE);
                            TempXMLBuffer4.RESET();
                            TempXMLBuffer4.SETRANGE("Parent Entry No.", TempXMLBuffer2."Entry No.");
                            IF TempXMLBuffer4.FINDSET(FALSE, FALSE) THEN
                                REPEAT
                                    CodLJobNo := FctGetJob2(TempXMLBuffer4."Entry No.");
                                    Pos := STRPOS(CodLJobNo, '_') - 1;
                                    IF (Pos > 0) THEN
                                        CodLJobNo := COPYSTR(COPYSTR(CodLJobNo, 1, Pos), 1, MaxStrLen(CodLJobNo));
                                UNTIL (TempXMLBuffer4.NEXT() = 0) OR (CodLJobNo <> '')
                        END;
                END;
            UNTIL TempXMLBuffer2.NEXT() = 0;
        IF DocumentType = DocumentType::"Credit Memo" THEN
            FctCreatePurchLine(PurchaseLine, quantity, unitCost, netAmount, account, AmountIncVAT, ProdPostingGroup, BusPostingGroup, CodLJobNo)
        ELSE
            IF WIPO THEN
                IF receiptLineCode <> '' THEN
                    FctCreateInvLine(receiptNo, receiptLineNo, quantity, unitCost, PurchaseLine, ProdPostingGroup, BusPostingGroup)
                ELSE
                    FctCreatePurchLine(PurchaseLine, quantity, unitCost, netAmount, account, AmountIncVAT, ProdPostingGroup, BusPostingGroup, CodLJobNo)
            ELSE
                FctCreatePurchLine(PurchaseLine, quantity, unitCost, netAmount, account, AmountIncVAT, ProdPostingGroup, BusPostingGroup, CodLJobNo);
    end;

    local procedure GetVATBusPstGrp()
    var
        Vendor: Record "Vendor";
    begin
        Vendor.GET(BuyfromVendorNo);
        TempXMLVATBuffer.RESET();
        TempXMLVATBuffer.SETRANGE("Line Number", IntGLineCounter);
        TempXMLVATBuffer.SETRANGE("VAT Bus. Posting Group", Vendor."VAT Bus. Posting Group");
        IF TempXMLVATBuffer.FINDFIRST() THEN
            CodGVATBusPstGrp := Vendor."VAT Bus. Posting Group";
        IF CodGVATBusPstGrp = '' THEN BEGIN
            TempXMLVATBuffer.SETRANGE("VAT Bus. Posting Group");
            IF TempXMLVATBuffer.FINDFIRST() THEN
                CodGVATBusPstGrp := TempXMLVATBuffer."VAT Bus. Posting Group"
            ELSE
                ERROR(TaxLineLbl, CodGVATLabelMax);
        END;
    end;

    local procedure InsertVATBuffer(pVATLabel: Code[50])
    var
        VATPostSetup: Record "VAT Posting Setup";
        VatBusPstGrp: Code[20];
    begin
        VatBusPstGrp := '';
        VATPostSetup.RESET();
        VATPostSetup.SETCURRENTKEY("VAT Bus. Posting Group");
        VATPostSetup.SETRANGE("VAT Label", pVATLabel);
        IF VATPostSetup.FINDSET() THEN
            REPEAT
                IF TempXMLVATBuffer.GET(VATPostSetup."VAT Bus. Posting Group") THEN BEGIN
                    IF VatBusPstGrp <> VATPostSetup."VAT Bus. Posting Group" THEN BEGIN
                        TempXMLVATBuffer."Line Number" += 1;
                        TempXMLVATBuffer.MODIFY(FALSE);
                        VatBusPstGrp := VATPostSetup."VAT Bus. Posting Group";
                    END;
                END ELSE BEGIN
                    TempXMLVATBuffer.INIT();
                    TempXMLVATBuffer.VALIDATE("VAT Bus. Posting Group", VATPostSetup."VAT Bus. Posting Group");
                    TempXMLVATBuffer.VALIDATE("Line Number", 1);
                    TempXMLVATBuffer.INSERT(FALSE);
                    VatBusPstGrp := VATPostSetup."VAT Bus. Posting Group";
                END;
            UNTIL VATPostSetup.NEXT() = 0;
    end;

    local procedure PurgeXMLVATBuffer()
    begin
        IntGLineCounter := 0;
        TempXMLVATBuffer.RESET();
        TempXMLVATBuffer.DELETEALL();
    end;

    local procedure UpdateReservationEntry(var RecPPurchLine: Record "Purchase Line"; DecPQty: Decimal)
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.SetRange("Source Type", DATABASE::"Purchase Line");
        ReservationEntry.SetRange("Source Subtype", RecPPurchLine."Document Type");
        ReservationEntry.SetRange("Source ID", RecPPurchLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", RecPPurchLine."Line No.");
        if ReservationEntry.IsEmpty() then
            exit
        else
            if ReservationEntry.FindFirst() then begin
                ReservationEntry.Validate("Quantity (Base)", DecPQty);
                ReservationEntry.Modify();
            end;
    end;
}