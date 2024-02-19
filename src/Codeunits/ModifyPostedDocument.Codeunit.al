codeunit 50034 "Modify Posted Document"
{
    Permissions = TableData "Sales Cr.Memo Header" = rm,
                  TableData "Sales Cr.Memo Line" = rmid,
                  tabledata "Sales Invoice Header" = rmid,
                  tabledata "Sales Invoice Line" = rmid,
                  tabledata "Purch. Inv. Header" = rmid,
                  tabledata "Purch. Inv. Line" = rmid;

    internal procedure ModifyPostedSalesCreditMemo(No: code[20])
    var
        Rec: Record "Sales Cr.Memo Header";
        TempSalesCrMemoHeader: Record "Sales Cr.Memo Header" temporary;
        TempSalesCrMemoLine: record "Sales Cr.Memo Line" temporary;
        ModPostedSalesCrMem: page "Mod Posted SalesCrMem";
    begin
        Rec.Get(No);
        SaveSalesCrMemo(Rec, TempSalesCrMemoHeader, TempSalesCrMemoLine);
        ModPostedSalesCrMem.SetRecord(Rec);
        ModPostedSalesCrMem.RunModal();
        if not ModPostedSalesCrMem.GetSaved() then
            RestoreSalesCrMemo(TempSalesCrMemoHeader, TempSalesCrMemoLine);
    end;

    local procedure SaveSalesCrMemo(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SavedSalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SavedSalesCrMemoLine: record "Sales Cr.Memo Line")
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SavedSalesCrMemoHeader.Init();
        SavedSalesCrMemoHeader.TransferFields(SalesCrMemoHeader);
        SavedSalesCrMemoHeader.Insert();

        SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
        TransferSalesCrMemoLine(SalesCrMemoLine, SavedSalesCrMemoLine);
    end;

    local procedure RestoreSalesCrMemo(var SavedSalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SavedSalesCrMemoLine: record "Sales Cr.Memo Line")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SalesCrMemoHeader.Get(SavedSalesCrMemoHeader."No.");
        SalesCrMemoHeader.TransferFields(SavedSalesCrMemoHeader);
        SalesCrMemoHeader.Modify();

        SalesCrMemoLine.SetRange("Document No.", SavedSalesCrMemoHeader."No.");
        SalesCrMemoLine.DeleteAll();
        SalesCrMemoLine.Reset();
        TransferSalesCrMemoLine(SavedSalesCrMemoLine, SalesCrMemoLine);
    end;

    local procedure TransferSalesCrMemoLine(var SalesCrMemoLineFrom: record "Sales Cr.Memo Line"; var SalesCrMemoLineTo: record "Sales Cr.Memo Line")
    begin
        if SalesCrMemoLineFrom.FindSet() then
            repeat
                SalesCrMemoLineTo.Init();
                SalesCrMemoLineTo.TransferFields(SalesCrMemoLineFrom);
                SalesCrMemoLineTo.Insert();
            until SalesCrMemoLineFrom.Next() = 0;
    end;

    internal procedure ModifyPostedSalesInvoice(No: code[20])
    var
        Rec: Record "Sales Invoice Header";
        TempSalesInvoiceHeader: Record "Sales Invoice Header" temporary;
        TempSalesInvoiceLine: record "Sales Invoice Line" temporary;
        ModPostedSalesInv: page "Mod Posted Sales Inv.";
    begin
        Rec.Get(No);
        SaveSalesInvoice(Rec, TempSalesInvoiceHeader, TempSalesInvoiceLine);
        ModPostedSalesInv.SetRecord(Rec);
        ModPostedSalesInv.RunModal();
        if not ModPostedSalesInv.GetSaved() then
            RestoreSalesInvoice(TempSalesInvoiceHeader, TempSalesInvoiceLine);
    end;

    internal procedure ModifyPostedPurchInvoice(rec: Record "Purch. Inv. Header")
    var
        PurchaseInvoiceMgmt: Codeunit "Purchase Invoice Mgmt";
        ModPostedPurchInv: page "Modify Purch. Document Inv.";
        NewVendorInvoiceNo: Code[35];
    begin
        CLEAR(ModPostedPurchInv);
        ModPostedPurchInv.SetData(rec."Vendor Invoice No.");
        ModPostedPurchInv.LOOKUPMODE(TRUE);
        if ModPostedPurchInv.RUNMODAL() = ACTION::LookupOK then begin
            NewVendorInvoiceNo := ModPostedPurchInv.GetData();
            if NewVendorInvoiceNo <> rec."Vendor Invoice No." then
                PurchaseInvoiceMgmt.ConfirmVendorInvoiceNo_AndChangeInAssociatedGL(Rec, NewVendorInvoiceNo);

            rec.VALIDATE("Vendor Invoice No.", NewVendorInvoiceNo);
            rec.MODIFY();
        end;
    end;

    internal procedure ModifyPostedCrMemoInvoice(rec: Record "Purch. Cr. Memo Hdr.")
    var
        PurchaseInvoiceMgmt: Codeunit "Purchase Invoice Mgmt";
        ModPostedPurchInv: page "Modify Purch. Document Inv.";
        NewVendorCrMemoNo: Code[35];
    begin
        CLEAR(ModPostedPurchInv);
        ModPostedPurchInv.SetData(rec."Vendor Cr. Memo No.");
        ModPostedPurchInv.LOOKUPMODE(TRUE);
        if ModPostedPurchInv.RUNMODAL() = ACTION::LookupOK then begin
            NewVendorCrMemoNo := ModPostedPurchInv.GetData();
            if NewVendorCrMemoNo <> rec."Vendor Cr. Memo No." then
                PurchaseInvoiceMgmt.ConfirmVendorCrMemoNo_AndChangeInAssociatedGL(Rec, NewVendorCrMemoNo);

            rec.VALIDATE("Vendor Cr. Memo No.", NewVendorCrMemoNo);
            rec.MODIFY();
        end;
    end;

    local procedure SaveSalesInvoice(var SalesInvoiceHeader: Record "Sales Invoice Header"; var SavedSalesInvoiceHeader: Record "Sales Invoice Header"; var SavedSalesInvoiceLine: record "Sales Invoice Line")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SavedSalesInvoiceHeader.Init();
        SavedSalesInvoiceHeader.TransferFields(SalesInvoiceHeader);
        SavedSalesInvoiceHeader.Insert();

        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        TransferSalesInvoiceLine(SalesInvoiceLine, SavedSalesInvoiceLine);
    end;

    local procedure RestoreSalesInvoice(var SavedSalesInvoiceHeader: Record "Sales Invoice Header"; var SavedSalesInvoiceLine: record "Sales Invoice Line")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceHeader.Get(SavedSalesInvoiceHeader."No.");
        SalesInvoiceHeader.TransferFields(SavedSalesInvoiceHeader);
        SalesInvoiceHeader.Modify();

        SalesInvoiceLine.SetRange("Document No.", SavedSalesInvoiceHeader."No.");
        SalesInvoiceLine.DeleteAll();
        SalesInvoiceLine.Reset();
        TransferSalesInvoiceLine(SavedSalesInvoiceLine, SalesInvoiceLine);
    end;

    local procedure TransferSalesInvoiceLine(var SalesInvoiceLineFrom: record "Sales Invoice Line"; var SalesInvoiceLineTo: record "Sales Invoice Line")
    begin
        if SalesInvoiceLineFrom.FindSet() then
            repeat
                SalesInvoiceLineTo.Init();
                SalesInvoiceLineTo.TransferFields(SalesInvoiceLineFrom);
                SalesInvoiceLineTo.Insert();
            until SalesInvoiceLineFrom.Next() = 0;
    end;
}