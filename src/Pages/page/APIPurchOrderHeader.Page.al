page 50097 "API Purch Order Header"
{
    PageType = API;
    Caption = 'API Purchase Order Header';
    APIPublisher = 'circet';
    APIGroup = 'purchases';
    APIVersion = 'v1.0';
    EntityName = 'purchaseOrderHeader';
    EntitySetName = 'purchaseOrderHeaders';
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = filter(Order));
    DelayedInsert = true;

    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                    Editable = false;
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                    Editable = false;
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                    Editable = false;
                }
                field(buyFromVendorNo; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Buy-from Vendor No.';
                }
                field(payToVendorNo; Rec."Pay-to Vendor No.")
                {
                    Caption = 'Pay-to Vendor No.';
                }
                field(purchaserCode; Rec."Purchaser Code")
                {
                    Caption = 'Purchaser Code';
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'Ship-to Name';
                    Editable = false;
                }
                field(shipToAddress; Rec."Ship-to Address")
                {
                    Caption = 'Ship-to Address';
                    Editable = false;
                }
                field(shipToAddress2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address 2';
                    Editable = false;
                }
                field(shipToPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code';
                    Editable = false;
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City';
                    Editable = false;
                }
                field(shipToCountryRegionCode; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'Ship-to Country/Region Code';
                    Editable = false;
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    Caption = 'Ship-to Contact';
                    Editable = false;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(directCustomerPayment; Rec."Direct Customer Payment")
                {
                    Caption = 'Direct Customer Payment';
                }
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                }
                field(vATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    Caption = 'VAT Bus. Posting Group';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(orderDate; Rec."Order Date")
                {
                    Caption = 'Order Date';
                    Editable = false;
                }
            }
            part(PurchOrderLines; "API Purch Order Line")
            {
                Caption = 'Purchase Order Lines';
                EntityName = 'purchaseOrderLine';
                EntitySetName = 'purchaseOrderLines';
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

    [ServiceEnabled]
    procedure UpdateHeader(RequeteJson: Text): Text
    var
        PurchaseHeader: Record "Purchase Header";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        WebServActionContext: WebServiceActionContext;
        JsonObj: JsonObject;
        JsonTkn: JsonToken;
        ReturnValue: Text;
        valCode: Code[2048];
        valText: Text;
        valDate: Date;
        valBool: boolean;

    begin
        WebServActionContext.SetObjectType(ObjectType::Page);
        WebServActionContext.SetObjectId(Page::"API Purch Order Header");
        WebServActionContext.AddEntityKey(Rec.FieldNo("Document Type"), Rec."Document Type");
        WebServActionContext.AddEntityKey(Rec.FieldNo("No."), Rec."No.");
        WebServActionContext.SetResultCode(WebServiceActionResultCode::Updated);

        // Reopen purchase order
        PurchaseHeader.Get(Rec."Document Type", Rec."No.");
        if (PurchaseHeader.Status <> PurchaseHeader.Status::Open) then
            ReleasePurchDoc.PerformManualReopen(Rec);

        // Parse the json parameter and update the order header
        JsonObj.ReadFrom(RequeteJson);
        if JsonObj.Contains('buyFromVendorNo') then begin
            JsonObj.Get('buyFromVendorNo', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseHeader."Buy-from Vendor No."));
            if valCode <> PurchaseHeader."Buy-from Vendor No." then begin
                PurchaseHeader.Validate("Buy-from Vendor No.", valCode);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('payToVendorNo') then begin
            JsonObj.Get('payToVendorNo', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrlen(PurchaseHeader."Pay-to Vendor No."));
            if valCode <> PurchaseHeader."Pay-to Vendor No." then begin
                PurchaseHeader.Validate("Pay-to Vendor No.", valCode);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('purchaserCode') then begin
            JsonObj.Get('purchaserCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseHeader."Purchaser Code"));
            if valCode <> PurchaseHeader."Purchaser Code" then begin
                PurchaseHeader.Validate("Purchaser Code", valCode);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToName') then begin
            JsonObj.Get('shipToName', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(PurchaseHeader."Ship-to Name"));
            if valText <> PurchaseHeader."Ship-to Name" then begin
                PurchaseHeader.Validate("Ship-to Name", valText);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToAddress') then begin
            JsonObj.Get('shipToAddress', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(PurchaseHeader."Ship-to Address"));
            if valText <> PurchaseHeader."Ship-to Address" then begin
                PurchaseHeader.Validate("Ship-to Address", valText);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToAddress2') then begin
            JsonObj.Get('shipToAddress2', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(PurchaseHeader."Ship-to Address 2"));
            if valText <> PurchaseHeader."Ship-to Address 2" then begin
                PurchaseHeader.Validate("Ship-to Address 2", valText);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToPostCode') then begin
            JsonObj.Get('shipToPostCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseHeader."Ship-to Post Code"));
            if valCode <> PurchaseHeader."Ship-to Post Code" then begin
                PurchaseHeader.Validate("Ship-to Post Code", valCode);
                PurchaseHeader.Modify(true);
            end
        end;
        if JsonObj.Contains('shipToCity') then begin
            JsonObj.Get('shipToCity', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(PurchaseHeader."Ship-to City"));
            if valText <> PurchaseHeader."Ship-to City" then begin
                PurchaseHeader.Validate("Ship-to City", valText);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToCountryRegionCode') then begin
            JsonObj.Get('shipToCountryRegionCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseHeader."Ship-to Country/Region Code"));
            if valCode <> PurchaseHeader."Ship-to Country/Region Code" then begin
                PurchaseHeader.Validate("Ship-to Country/Region Code", valCode);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToContact') then begin
            JsonObj.Get('shipToContact', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(PurchaseHeader."Ship-to Contact"));
            if valText <> PurchaseHeader."Ship-to Contact" then begin
                PurchaseHeader.Validate("Ship-to Contact", valText);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('description') then begin
            JsonObj.Get('description', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(PurchaseHeader.Description));
            if valText <> PurchaseHeader.Description then begin
                ;
                PurchaseHeader.Validate(Description, valText);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('directCustomerPayment') then begin
            JsonObj.Get('directCustomerPayment', JsonTkn);
            valBool := JsonTkn.AsValue().AsBoolean();
            if valBool <> PurchaseHeader."Direct Customer Payment" then begin
                PurchaseHeader.Validate("Direct Customer Payment", valBool);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('genBusPostingGroup') then begin
            JsonObj.Get('genBusPostingGroup', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseHeader."Gen. Bus. Posting Group"));
            if valCode <> PurchaseHeader."Gen. Bus. Posting Group" then begin
                PurchaseHeader.Validate("Gen. Bus. Posting Group", valCode);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('vATBusPostingGroup') then begin
            JsonObj.Get('vATBusPostingGroup', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrlen(PurchaseHeader."VAT Bus. Posting Group"));
            if valCode <> PurchaseHeader."VAT Bus. Posting Group" then begin
                PurchaseHeader.Validate("VAT Bus. Posting Group", valCode);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('currencyCode') then begin
            JsonObj.Get('currencyCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseHeader."Currency Code"));
            if valCode <> PurchaseHeader."Currency Code" then begin
                PurchaseHeader.Validate("Currency Code", valCode);
                PurchaseHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('orderDate') then begin
            JsonObj.Get('orderDate', JsonTkn);
            valDate := JsonTkn.AsValue().AsDate();
            if valDate <> PurchaseHeader."Order Date" then begin
                PurchaseHeader.Validate("Order Date", valDate);
                PurchaseHeader.Validate("Document Date", PurchaseHeader."Order Date");
                PurchaseHeader.Validate("Posting Date", PurchaseHeader."Order Date");
                PurchaseHeader.Modify(true);
            end;
        end;

        // Build json return value
        Clear(JsonObj);
        JsonObj.Add('documentType', Format(PurchaseHeader."Document Type"));
        JsonObj.Add('no', PurchaseHeader."No.");
        JsonObj.Add('status', Format(PurchaseHeader.Status));
        JsonObj.Add('buyFromVendorNo', PurchaseHeader."Buy-from Vendor No.");
        JsonObj.Add('payToVendorNo', PurchaseHeader."Pay-to Vendor No.");
        JsonObj.Add('purchaserCode', PurchaseHeader."Purchaser Code");
        JsonObj.Add('shipToName', PurchaseHeader."Ship-to Name");
        JsonObj.Add('shipToAddress', PurchaseHeader."Ship-to Address");
        JsonObj.Add('shipToAddress2', PurchaseHeader."Ship-to Address 2");
        JsonObj.Add('shipToPostCode', PurchaseHeader."Ship-to Post Code");
        JsonObj.Add('shipToCity', PurchaseHeader."Ship-to City");
        JsonObj.Add('shipToCountryRegionCode', PurchaseHeader."Ship-to Country/Region Code");
        JsonObj.Add('shipToContact', PurchaseHeader."Ship-to Contact");
        JsonObj.Add('description', PurchaseHeader.Description);
        JsonObj.Add('directCustomerPayment', PurchaseHeader."Direct Customer Payment");
        JsonObj.Add('genBusPostingGroup', PurchaseHeader."Gen. Bus. Posting Group");
        JsonObj.Add('vATBusPostingGroup', PurchaseHeader."VAT Bus. Posting Group");
        JsonObj.Add('currencyCode', PurchaseHeader."Currency Code");
        JsonObj.Add('orderDate', PurchaseHeader."Order Date");
        JsonObj.WriteTo(ReturnValue);

        Rec := PurchaseHeader;
        CurrPage.Update(false);

        exit(ReturnValue);
    end;

    [ServiceEnabled]
    procedure PostReceive(RequeteJson: Text): Text
    var
        PurchaseLine: Record "Purchase Line";
        ReservationEntry: Record "Reservation Entry";
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TempItemLegderEntry: Record "Item Ledger Entry" temporary;
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        CreateReservationEntry: Codeunit "Create Reserv. Entry";
        ReservationManagement: Codeunit "Reservation Management";
        PurchPost: Codeunit "Purch.-Post";
        ItemTrackingDocMngt: Codeunit "Item Tracking Doc. Management";
        WebServActionContext: WebServiceActionContext;
        PostingDate: Date;
        LineNo: Integer;
        QtyToReceive: Decimal;
        TrackNo: Code[50];
        TrackQty: Decimal;
        ReservStatus: Enum "Reservation Status";
        JsonObj: JsonObject;
        JsonTokenPostDate: JsonToken;
        JsonTokenLines: JsonToken;
        JsonTokenLine: JsonToken;
        JsonObjLine: JsonObject;
        JsonTokenLineNo: JsonToken;
        JsonTokenQtyToReceive: JsonToken;
        JsonTokenTrackColl: JsonToken;
        JsonTokenTrack: JsonToken;
        JsonObjTrack: JsonObject;
        TrackingType: Option " ","Serial","Lot";
        JsonTokenTrackNo: JsonToken;
        JsonTokenTrackQty: JsonToken;
        JsonArrayLine: JsonArray;
        JsonArraySerialNo: JsonArray;
        JsonArrayLotNo: JsonArray;
        JsonObjSerialLot: JsonObject;
        ReturnValue: Text;
    begin
        WebServActionContext.SetObjectType(ObjectType::Page);
        WebServActionContext.SetObjectId(Page::"API Purch Order Header");
        WebServActionContext.AddEntityKey(Rec.FieldNo("Document Type"), Rec."Document Type");
        WebServActionContext.AddEntityKey(Rec.FieldNo("No."), Rec."No.");
        WebServActionContext.SetResultCode(WebServiceActionResultCode::Updated);

        // Reopen purchase order
        if (Rec.Status <> Rec.Status::Open) then
            ReleasePurchDoc.PerformManualReopen(Rec);

        // Reset all recept awaiting for posting
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."No.");
        if PurchaseLine.FindSet() then
            repeat
                ReservationEntry.Reset();
                ReservationEntry.SetSourceFilter(DATABASE::"Purchase Line", PurchaseLine."Document Type".AsInteger(), PurchaseLine."Document No.", PurchaseLine."Line No.", true);
                if ReservationEntry.FindSet() then begin
                    Clear(ReservationManagement);
                    ReservationManagement.SetItemTrackingHandling(1);
                    ReservationManagement.DeleteReservEntries(true, 0, ReservationEntry);
                end;
                PurchaseLine.Validate("Qty. to Receive", 0);
                PurchaseLine.Modify(true);
            until PurchaseLine.Next() = 0;

        // Parse the json parameter 
        JsonObj.ReadFrom(RequeteJson);
        if JsonObj.Contains('postingDate') then begin
            JsonObj.Get('postingDate', JsonTokenPostDate);
            PostingDate := JsonTokenPostDate.AsValue().AsDate();
        end else
            PostingDate := WorkDate();
        if JsonObj.Contains('linesToReceive') then begin
            JsonObj.Get('linesToReceive', JsonTokenLines);
            foreach JsonTokenLine in JsonTokenLines.AsArray() do begin
                JsonObjLine := JsonTokenLine.AsObject();
                JsonObjLine.Get('lineNo', JsonTokenLineNo);
                LineNo := JsonTokenLineNo.AsValue().AsInteger();
                PurchaseLine.Get(Rec."Document Type", Rec."No.", LineNo);
                JsonObjLine.Get('qtyToReceive', JsonTokenQtyToReceive);
                QtyToReceive := JsonTokenQtyToReceive.AsValue().AsDecimal();
                TrackingType := TrackingType::" ";
                if JsonObjLine.Contains('serialNo') then begin
                    TrackingType := TrackingType::Serial;
                    JsonObjLine.Get('serialNo', JsonTokenTrackColl);
                end else
                    if JsonObjLine.Contains('lotNo') then begin
                        TrackingType := TrackingType::Lot;
                        JsonObjLine.Get('lotNo', JsonTokenTrackColl);
                    end;
                if TrackingType <> TrackingType::" " then begin
                    PurchaseLine.TestField("Type", PurchaseLine."Type"::Item);
                    Item.Get(PurchaseLine."No.");
                    Item.TestField("Item Tracking Code");
                    ItemTrackingCode.Get(Item."Item Tracking Code");
                    foreach JsonTokenTrack in JsonTokenTrackColl.AsArray() do begin
                        JsonObjTrack := JsonTokenTrack.AsObject();
                        JsonObjTrack.Get('no', JsonTokenTrackNo);
                        TrackNo := CopyStr(JsonTokenTrackNo.AsValue().AsCode(), 1, MaxStrLen(TrackNo));
                        TrackQty := 1;
                        if JsonObjTrack.Contains('qty') then begin
                            JsonObjTrack.Get('qty', JsonTokenTrackQty);
                            TrackQty := JsonTokenTrackQty.AsValue().AsDecimal();
                        end;
                        ReservationEntry.Init();
                        if TrackingType = TrackingType::Serial then
                            ReservationEntry."Serial No." := TrackNo
                        else
                            ReservationEntry."Lot No." := TrackNo;
                        CreateReservationEntry.SetDates(0D, 0D);  // Warranty Date, Expiration date
                        CreateReservationEntry.CreateReservEntryFor(DATABASE::"Purchase Line", PurchaseLine."Document Type".AsInteger(), PurchaseLine."Document No.", '', 0, PurchaseLine."Line No.", PurchaseLine."Qty. per Unit of Measure", TrackQty, TrackQty * PurchaseLine."Qty. per Unit of Measure", ReservationEntry);
                        CreateReservationEntry.CreateEntry(PurchaseLine."No.", PurchaseLine."Variant Code", PurchaseLine."Location Code", '', PurchaseLine."Expected Receipt Date", 0D, 0, ReservStatus::Surplus);
                    end;
                end;
                PurchaseLine.Validate("Qty. to Receive", QtyToReceive);
                PurchaseLine.Modify(true);
            end;
        end;

        // Post receipt
        Rec.Receive := true;
        Rec.Invoice := false;
        Rec."Posting Date" := PostingDate;
        PurchPost.Run(Rec);

        // Build json return value
        Clear(JsonObj);
        PurchRcptHeader.Get(Rec."Last Receiving No.");
        JsonObj.Add('receiptNo', Rec."Last Receiving No.");
        JsonObj.Add('orderNo', PurchRcptHeader."Order No.");
        JsonObj.Add('postingDate', PurchRcptHeader."Posting Date");
        PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
        PurchRcptLine.SetFilter(Quantity, '<>0');
        Clear(JsonArrayLine);
        if PurchRcptLine.FindSet() then
            repeat
                Clear(JsonObjLine);
                JsonObjLine.Add('lineNo', PurchRcptLine."Line No.");
                JsonObjLine.Add('quantity', PurchRcptLine.Quantity);
                TempItemLegderEntry.Reset();
                TempItemLegderEntry.DeleteAll(false);
                ItemTrackingDocMngt.RetrieveEntriesFromShptRcpt(TempItemLegderEntry, Database::"Purch. Rcpt. Line", 0, PurchRcptLine."Document No.", '', 0, PurchRcptLine."Line No.");
                if TempItemLegderEntry.FindSet() then begin
                    Clear(JsonArraySerialNo);
                    Clear(JsonArrayLotNo);
                    repeat
                        if TempItemLegderEntry."Serial No." <> '' then begin
                            Clear(JsonObjSerialLot);
                            JsonObjSerialLot.Add('no', TempItemLegderEntry."Serial No.");
                            JsonObjSerialLot.Add('qty', TempItemLegderEntry.Quantity);
                            JsonArraySerialNo.Add(JsonObjSerialLot);
                        end;
                        if TempItemLegderEntry."Lot No." <> '' then begin
                            Clear(JsonObjSerialLot);
                            JsonObjSerialLot.Add('no', TempItemLegderEntry."Lot No.");
                            JsonObjSerialLot.Add('qty', TempItemLegderEntry.Quantity);
                            JsonArrayLotNo.Add(JsonObjSerialLot);
                        end;
                    until TempItemLegderEntry.Next() = 0;
                end;
                if JsonArraySerialNo.Count <> 0 then
                    JsonObjLine.Add('serialNo', JsonArraySerialNo);
                if JsonArrayLotNo.Count <> 0 then
                    JsonObjLine.Add('lotNo', JsonArrayLotNo);
                JsonArrayLine.Add(JsonObjLine);
            until PurchRcptLine.Next() = 0;
        if JsonArrayLine.Count <> 0 then
            JsonObj.Add('receiptLines', JsonArrayLine);
        JsonObj.WriteTo(ReturnValue);
        exit(ReturnValue);
    end;
}