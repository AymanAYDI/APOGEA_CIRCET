codeunit 50003 "Sales Mgt."
{
    Permissions = TableData "Sales Shipment Header" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Invoice Line" = rimd,
                  TableData "Sales Cr.Memo Line" = rimd,
                  TableData "G/L entry" = rimd,
                  Tabledata "Cust. Ledger Entry" = rimd,
                  TableData "VAT Entry" = rimd,
                  TableData "Job Ledger Entry" = rimd;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        AssemblyMgt: codeunit "Assembly Mgt.";
    begin
        AssemblyMgt.UpdateAssemblyHeaderFromSalesLine(rec, xRec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesHeader', '', false, false)]
    local procedure OnAfterCopySalesHeader(var ToSalesHeader: Record "Sales Header"; OldSalesHeader: Record "Sales Header"; FromSalesHeader: Record "Sales Header");
    begin
        JobMgt.ControlStatusOnSalesDocument(FromSalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Sales Invoice", 'OnBeforeSalesHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesHeaderInsert(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; CancellingOnly: Boolean);
    begin
        JobMgt.ControlStatusOnSalesDocument(SalesHeader);
    end;

    internal procedure ConfirmExternalDoc_AndChangeInAssociatedGL(SalesInvDocNo: Code[20]; SalesInvPostingDate: Date; ExternalDocumentNo: Code[35])
    var
        GLEntry: Record "G/L Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VATEntry: Record "VAT Entry";
        JobLedgerEntry: Record "Job Ledger Entry";
        ConfirmManagement: Codeunit "Confirm Management";
        ConfirmChangeExternalDocNo_Qst: Label 'Do you confirm the modification of the elements ?', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Confirmez-vous la modification des éléments ?"}]}';
        ExternalDocNoHasNotBeenChanged_Err: Label 'The elements has not been changed.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Les éléments n''ont pas été modifiés."}]}';
    begin
        IF NOT ConfirmManagement.GetResponseOrDefault(ConfirmChangeExternalDocNo_Qst, FALSE) THEN
            ERROR(ExternalDocNoHasNotBeenChanged_Err);

        // Propagation de la modification sur les écritures comptables associées
        GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
        GLEntry.RESET();
        GLEntry.SETRANGE("Document No.", SalesInvDocNo);
        GLEntry.SETRANGE("Posting Date", SalesInvPostingDate);
        GLEntry.MODIFYALL("External Document No.", ExternalDocumentNo, FALSE);

        // Propagation de la modification sur l'écriture client associée
        CustLedgerEntry.SETCURRENTKEY("Customer No.", "Document No.", "Posting Date");
        CustLedgerEntry.RESET();
        CustLedgerEntry.SETRANGE("Document No.", SalesInvDocNo);
        CustLedgerEntry.SETRANGE("Posting Date", SalesInvPostingDate);
        CustLedgerEntry.MODIFYALL("External Document No.", ExternalDocumentNo, FALSE);

        // Propagation de la modification sur les écritures TVA associées
        VATEntry.SETCURRENTKEY("Document No.", "Posting Date");
        VATEntry.RESET();
        VATEntry.SETRANGE("Document No.", SalesInvDocNo);
        VATEntry.SETRANGE("Posting Date", SalesInvPostingDate);
        VATEntry.MODIFYALL("External Document No.", ExternalDocumentNo, FALSE);

        // Propagation de la modification sur les écritures projets associées
        JobLedgerEntry.SETCURRENTKEY("Document No.", "Posting Date", "Entry Type");
        JobLedgerEntry.RESET();
        JobLedgerEntry.SETRANGE("Document No.", SalesInvDocNo);
        JobLedgerEntry.SETRANGE("Posting Date", SalesInvPostingDate);
        JobLedgerEntry.MODIFYALL("External Document No.", ExternalDocumentNo, FALSE);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean);
    begin
        GeneralApplicationSetup.Get();
        //Si coche coché = toutes les sociétés différentes de pylones
        Handled := GeneralApplicationSetup."Control Over Company";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterDescriptionSalesLineInsert', '', false, false)]
    local procedure OnAfterDescriptionSalesLineInsert(var SalesLine: Record "Sales Line"; SalesShipmentLine: Record "Sales Shipment Line"; var NextLineNo: Integer);
    begin
        GeneralApplicationSetup.Get();
        //Si coche coché = toutes les sociétés différentes de pylones
        if not GeneralApplicationSetup."Control Over Company" then
            AddDimensionDefault3Text(SalesLine, SalesShipmentLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure OnAfterInitFromSalesLine(SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line");
    begin
        AddDimensionDefault3Text(SalesShptHeader, SalesShptLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCheckBillToCust', '', false, false)]
    local procedure OnAfterCheckBillToCust(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; Customer: Record Customer);
    var
        Job: Record Job;
    begin
        IF (Job."Bill-to Customer No." = SalesHeader."Bill-to Customer No.") AND
           (Job."Bank Account No." <> '') THEN
            SalesHeader."Bank Account No." := Job."Bank Account No."
        ELSE
            SalesHeader."Bank Account No." := Customer."Bank Account No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales line", 'OnAfterValidateEvent', 'Job No.', false, false)]
    local procedure OnAfterValidateJobNoEvent_UpdateDescription(var Rec: Record "Sales Line")
    var
        Job: Record Job;
    begin
        If GeneralApplicationSetup.Get() then
            if GeneralApplicationSetup."Use job descr. as item descr." then
                if Job.Get(Rec."Job No.") then
                    Rec.Description := Job.Description;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales line", 'OnAfterValidateEvent', 'ARBVRNVeronaJobNo', false, false)]
    local procedure OnAfterValidateVerJobNoEvent_UpdateDescription(var Rec: Record "Sales Line")
    var
        Job: Record Job;
    begin
        If GeneralApplicationSetup.Get() then
            if GeneralApplicationSetup."Use job descr. as item descr." then
                if Job.Get(Rec.ARBVRNVeronaJobNo) then
                    Rec.Description := Job.Description;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterInsertToSalesLine', '', false, false)]
    local procedure OnAfterInsertToSalesLine(var ToSalesLine: Record "Sales Line"; FromSalesLine: Record "Sales Line"; RecalculateLines: Boolean; DocLineNo: Integer; FromSalesDocType: Enum "Sales Document Type From"; FromSalesHeader: Record "Sales Header");
    begin
        ToSalesLine.Description := FromSalesLine.Description;
        ToSalesLine.modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc_AssigSalesShpFields(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean)
    var
        SalesShptLine: Record "Sales Shipment Line";
        PostedAsmtoOrderLink: Record "Posted Assemble-to-Order Link";
        AssemblyHeader: Record "Assembly Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        IsFirstloop: Boolean;
        NbrPackages: Integer;
        TotalWeight: Decimal;
    begin
        NbrPackages := 0;
        TotalWeight := 0;
        if SalesShptHdrNo <> '' then begin
            IsFirstloop := true;
            SalesShptLine.SetRange("Document No.", SalesShptHdrNo);
            if (not SalesShptLine.IsEmpty) and (SalesShipmentHeader.Get(SalesShptHdrNo)) then begin
                SalesShptLine.FindSet();
                repeat
                    if PostedAsmtoOrderLink.AsmExistsForPostedShipmentLine(SalesShptLine) then
                        if AssemblyHeader.Get(AssemblyHeader."Document Type"::Order, PostedAsmtoOrderLink."Assembly Order No.") then begin
                            if IsFirstloop then
                                IsFirstloop := Not SetSalesShpFieldsFromAsm(SalesShipmentHeader, AssemblyHeader);
                            NbrPackages += AssemblyHeader."Number of packages";
                            TotalWeight += AssemblyHeader."Total weight";
                        end;
                until SalesShptLine.Next() = 0;
                SetSalesShpTotalFields(SalesShipmentHeader, NbrPackages, TotalWeight);
                SalesShipmentHeader.Modify();
            end;
        end;
        if SalesInvHdrNo <> '' then begin
            SalesShipmentHeader.SetRange("Order No.", SalesHeader."No.");
            if (not SalesShipmentHeader.IsEmpty()) and (SalesInvoiceHeader.Get(SalesInvHdrNo)) then begin
                SalesShipmentHeader.SetLoadFields("Number of packages", "Total weight");
                SalesShipmentHeader.FindSet();
                repeat
                    NbrPackages += SalesShipmentHeader."Number of packages";
                    TotalWeight += SalesShipmentHeader."Total weight";
                until SalesShipmentHeader.Next() = 0;
                SetSalesInvoiceTotalFields(SalesInvoiceHeader, NbrPackages, TotalWeight);
                SalesInvoiceHeader.Modify();
            end;
        end;
    end;

    local procedure SetSalesShpFieldsFromAsm(var SalesShipmentHeader: Record "Sales Shipment Header"; AssemblyHeader: Record "Assembly Header"): Boolean
    begin
        SalesShipmentHeader."Ship-to Code" := AssemblyHeader."Ship-to Code";
        SalesShipmentHeader."Ship-to Name" := AssemblyHeader."Ship-to Name";
        SalesShipmentHeader."Ship-to Name 2" := AssemblyHeader."Ship-to Name 2";
        SalesShipmentHeader."Ship-to Address" := AssemblyHeader."Ship-to Address";
        SalesShipmentHeader."Ship-to Address 2" := AssemblyHeader."Ship-to Address 2";
        SalesShipmentHeader."Ship-to Post Code" := AssemblyHeader."Ship-to Post Code";
        SalesShipmentHeader."Ship-to City" := AssemblyHeader."Ship-to City";
        SalesShipmentHeader."Shipping Agent Code" := AssemblyHeader."Shipping Agent Code";
        exit(true);
    end;

    local procedure SetSalesShpTotalFields(var SalesShipmentHeader: Record "Sales Shipment Header"; NbrPackages: Integer; TotalWeight: Decimal)
    begin
        SalesShipmentHeader."Number of packages" := NbrPackages;
        SalesShipmentHeader."Total weight" := TotalWeight;
    end;

    local procedure SetSalesInvoiceTotalFields(var SalesInvoiceHeader: Record "Sales Invoice Header"; NbrPackages: Integer; TotalWeight: Decimal)
    begin
        SalesInvoiceHeader."Number of packages" := NbrPackages;
        SalesInvoiceHeader."Total weight" := TotalWeight;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPostYesNo(var SalesHeader: Record "Sales Header"; var DefaultOption: Integer; var Result: Boolean; var IsHandled: Boolean);
    begin
        ControlStationRefControl(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterManualReleaseSalesDoc', '', false, false)]
    local procedure OnAfterManualReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean);
    begin
        ControlStationRefControl(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPostPrint(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var SendReportAsEmail: Boolean; var DefaultOption: Integer);
    begin
        ControlStationRefControl(SalesHeader);
    end;

    internal procedure ControlStationRefControl(SalesHeader: Record "Sales Header")
    var
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        ControlStationRefCannotBeEmpty_Err: Label 'The control station ref. must be different from 0', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ref. poste de commande doit être différent de 0"}]}';
    begin
        if Customer.get(SalesHeader."Bill-to Customer No.") then;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        if SalesLine.FindSet() then
            repeat
                if (Customer."Paperless Type" in [Customer."Paperless Type"::"EDI Cegedim - Bouygues",
                Customer."Paperless Type"::"EDI Cegedim - Orange", Customer."Paperless Type"::"EDI Seres - SFR"])
                AND (SalesLine.Quantity <> 0) and (SalesLine."Control Station Ref." = 0) then
                    Error(ControlStationRefCannotBeEmpty_Err);
            until SalesLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterSetFieldsBilltoCustomer', '', false, false)]
    local procedure OnAfterSetFieldsBilltoCustomer(var SalesHeader: Record "Sales Header"; Customer: Record Customer; xSalesHeader: Record "Sales Header");
    begin
        GetSalesPersonFromJobAndModifySalesHeaderSalesPerson(SalesHeader);
    end;

    local procedure GetSalesPersonFromJobAndModifySalesHeaderSalesPerson(var SalesHeader: Record "Sales Header")
    var
        Job: Record Job;
    begin
        if SalesHeader.ARBVRNJobNo <> '' then
            if Job.Get(SalesHeader.ARBVRNJobNo) then
                SalesHeader."Salesperson Code" := Job.ARBCIRFRSalespersonCode;
    end;

    local procedure AddDimensionDefault3Text(RecVar: variant; SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesLine: Record "Sales Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        DimensionValue: Record "Dimension Value";
        RecRef: RecordRef;
        Site_Lbl: label 'Site : ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Site : "}]}';
    begin
        if RecVar.IsRecord then
            RecRef.GetTable(RecVar);

        case RecRef.Number of
            DATABASE::"Sales Line":
                begin
                    GetDefaultShorCutDim3(SalesShipmentLine);
                    RecRef.SetTable(SalesLine);
                    if DimensionValue.get(GeneralApplicationSetup."Business Dimension Code", DefaultShorCutDim3) then;
                    if DefaultShorCutDim3 <> '' then begin
                        SalesLine.Description := CopyStr(SalesLine.Description + ' ' + Site_Lbl + format(DefaultShorCutDim3) + ' ' + DimensionValue.Name, 1, MaxStrLen(SalesLine.Description));
                        SalesLine.Modify();
                    end;
                end;
            Database::"Sales Shipment Header":
                begin
                    GetDefaultShorCutDim3(SalesShipmentLine);
                    if DimensionValue.get(GeneralApplicationSetup."Business Dimension Code", DefaultShorCutDim3) then;
                    if DefaultShorCutDim3 <> '' then begin
                        RecRef.SetTable(SalesShipmentHeader);
                        // SalesShipmentHeader."Site Code" := CopyStr(SalesShipmentHeader."Site Code" + ' ' + format(DefaultShorCutDim3) + ' ' + DimensionValue.Name, 1, MaxStrLen(SalesLine.Description));
                        SalesShipmentHeader."Site Code" := CopyStr(SalesShipmentHeader."Site Code", 1, MaxStrLen(SalesLine.Description));
                        SalesShipmentHeader."Business Code" := CopyStr(format(DefaultShorCutDim3) + ' ' + DimensionValue.Name, 1, MaxStrLen(SalesShipmentHeader."Business Code"));
                        SalesShipmentHeader.Modify();
                    end;
                end;
        end;
    end;

    local procedure GetDefaultShorCutDim3(SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        DefaultShorCutDim3 := '';
        if SalesShipmentHeader.Get(SalesShipmentLine."Document No.") then
            if GeneralApplicationSetup.Get() then
                if DimensionSetEntry.Get(SalesShipmentHeader."Dimension Set ID", GeneralApplicationSetup."Business Dimension Code") then
                    DefaultShorCutDim3 := DimensionSetEntry."Dimension Value Code";
    end;

    internal procedure CheckBillToCustomerNoOnJobNo(SalesLine: Record "Sales Line")
    var
        Job: Record Job;
        JobCurrent: Record Job;
        SalesLineCurrent, SalesLine2 : Record "Sales Line";
        BillToIsDifferent_Err: Label 'You cannot select job with different customers', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous ne pouvez pas sélectionner des projets avec des clients différents"}]}';
    begin
        //Infos des autres lignes
        if (SalesLine."Document Type" IN [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) and (SalesLine."Job No." <> '') then begin
            SalesLine2.SetRange("Document Type", SalesLine."Document Type");
            SalesLine2.SetRange("Document No.", SalesLine."Document No.");
            if SalesLine2.Count() > 1 then begin
                //Infos de la ligne modifiée / inserée courante
                SalesLineCurrent := SalesLine;
                if JobCurrent.Get(SalesLineCurrent."Job No.") then;

                if SalesLine2.FindSet(false) then
                    repeat
                        //Comparaison du client facturé de la ligne courante et des autres lignes de projets
                        if Job.get(SalesLine2."Job No.") then
                            if Job."Bill-to Customer No." <> JobCurrent."Bill-to Customer No." then
                                Error(BillToIsDifferent_Err);
                    until SalesLine2.Next() = 0;
            end;
        end
    end;

    internal procedure ModifyShipmentInfoOnSalesInv(var rec: Record "Sales Invoice Header")
    var
        ModifyShipmentPostedSales: Page "Modify Shipment Posted Sales";
        NewNumberOfPackages: Integer;
        NewTotalWeight: Decimal;
        modifydata: Boolean;
    begin
        //Changement du ref poste de commande
        CLEAR(ModifyShipmentPostedSales);
        ModifyShipmentPostedSales.SetData(rec."Number of packages", rec."Total weight");
        ModifyShipmentPostedSales.LOOKUPMODE(TRUE);
        if ModifyShipmentPostedSales.RUNMODAL() = ACTION::LookupOK then begin
            ModifyShipmentPostedSales.GetData(NewNumberOfPackages, NewTotalWeight);
            if NewNumberOfPackages <> rec."Number of packages" then begin
                rec."Number of packages" := NewNumberOfPackages;
                modifydata := true;
            end;

            if NewTotalWeight <> rec."Total weight" then begin
                rec."Total weight" := NewTotalWeight;
                modifydata := true;
            end;

            IF modifydata THEN
                rec.Modify()
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Combine Shipments", 'OnBeforeSalesInvHeaderModify', '', false, false)]
    local procedure OnBeforeSalesInvHeaderModify(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header");
    begin
        SalesHeader."Exit Point" := SalesOrderHeader."Exit Point";
        SalesHeader."Shipment Method Code" := SalesOrderHeader."Shipment Method Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Get Shipment", 'OnCreateInvLinesOnBeforeFind', '', false, false)]
    local procedure OnCreateInvLinesOnBeforeFind(var SalesShipmentLine: Record "Sales Shipment Line"; var SalesHeader: Record "Sales Header");
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        //Réinitialisation du filtre sur la quantité <> 0 pour pouvoir extraire les lignes de commentaire
        SalesShipmentLine.SetRange("Qty. Shipped Not Invoiced");

        //Affectation du "Code Site" de l'exp vers la facture vente
        if SalesShipmentHeader.get(SalesShipmentLine."Document No.") then
            SalesHeader."Site Code" := CopyStr(SalesShipmentHeader."Site Code", 1, MaxStrLen(SalesHeader."Site Code"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Get Shipment", 'OnAfterInsertLine', '', false, false)]
    local procedure OnAfterInsertLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; SalesShptLine2: Record "Sales Shipment Line"; TransferLine: Boolean);
    begin
    end;

    var
        GeneralApplicationSetup: Record "General Application Setup";
        JobMgt: Codeunit "Job Mgt.";
        DefaultShorCutDim3: Code[20];

}