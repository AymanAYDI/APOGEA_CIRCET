page 50098 "API Purch Order Line"
{
    PageType = API;
    Caption = 'API Purchase Order Line';
    APIPublisher = 'circet';
    APIGroup = 'purchases';
    APIVersion = 'v1.0';
    EntityName = 'purchaseOrderLine';
    EntitySetName = 'purchaseOrderLines';
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type" = filter(Order));
    DelayedInsert = true;
    AutoSplitKey = true;

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
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                    Editable = false;
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                    Editable = false;
                }
                field(type; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(site; Rec.Site)
                {
                    Caption = 'Site';
                }
                field(jobNo; Rec."Job No.")
                {
                    Caption = 'Job No.';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(quantityReceived; Rec."Quantity Received")
                {
                    Caption = 'Quantity Received';
                    Editable = false;
                }
                field(quantityInvoiced; Rec."Quantity Invoiced")
                {
                    Caption = 'Quantity Invoiced';
                    Editable = false;
                }
                field(vATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    Caption = 'VAT Prod. Posting Group';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(binCode; Rec."Bin Code")
                {
                    Caption = 'Bin Code';
                }
                field(affaireCode; AffaireCode)
                {
                    Caption = 'Affaire Code';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, AffaireCode);
                    end;
                }
                field(vendorItemNo; Rec."Vendor Item No.")
                {
                    Caption = 'Vendor Item No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(directUnitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';
                }
                field(qtyToReceive; Rec."Qty. to Receive")
                {
                    Caption = 'Qty. to Receive';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        GeneralLedgerSetup.Get();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        AffaireCode := '';
    end;

    trigger OnAfterGetRecord()
    var
        DimensionSetEntry: Record "Dimension Set Entry";

    begin
        if DimensionSetEntry.Get(Rec."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 3 Code") then
            AffaireCode := DimensionSetEntry."Dimension Value Code"
        else
            AffaireCode := '';
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        AffaireCode: Code[20];

    [ServiceEnabled]
    procedure UpdateLine(RequeteJson: Text): Text
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        DimensionSetEntry: Record "Dimension Set Entry";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        WebServActionContext: WebServiceActionContext;
        JsonObj: JsonObject;
        JsonTkn: JsonToken;
        ReturnValue: Text;
        valCode: Code[2048];
        valType: Enum "Purchase Line Type";
        valText: Text;
        valDecimal: Decimal;
    begin
        WebServActionContext.SetObjectType(ObjectType::Page);
        WebServActionContext.SetObjectId(Page::"API Purch Order Header");
        WebServActionContext.AddEntityKey(Rec.FieldNo("Document Type"), Rec."Document Type");
        WebServActionContext.AddEntityKey(Rec.FieldNo("No."), Rec."No.");
        WebServActionContext.SetResultCode(WebServiceActionResultCode::Updated);

        // Reopen purchase order
        PurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
        if (PurchaseHeader.Status <> PurchaseHeader.Status::Open) then
            ReleasePurchDoc.PerformManualReopen(PurchaseHeader);

        // Parse the json parameter and update the order line
        PurchaseLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
        JsonObj.ReadFrom(RequeteJson);
        if JsonObj.Contains('type') then begin
            JsonObj.Get('type', JsonTkn);
            valType := Enum::"Purchase Line Type".FromInteger(valType.Ordinals.Get(valType.Names.IndexOf(JsonTkn.AsValue().AsText())));
            if valType <> PurchaseLine."Type" then begin
                PurchaseLine.Validate("Type", valType);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('no') then begin
            JsonObj.Get('no', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseLine."No."));
            if valCode <> PurchaseLine."No." then begin
                if PurchaseLine.Quantity <> 0 then
                    PurchaseLine.Validate(Quantity, 0);
                PurchaseLine.Validate("No.", valCode);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('site') then begin
            JsonObj.Get('site', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(PurchaseLine.Site));
            if valText <> PurchaseLine.Site then begin
                PurchaseLine.Validate(Site, valText);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('jobNo') then begin
            JsonObj.Get('jobNo', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseLine."Job No."));
            if valCode <> PurchaseLine."Job No." then begin
                PurchaseLine.Validate("Job No.", valCode);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('unitOfMeasureCode') then begin
            JsonObj.Get('unitOfMeasureCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseLine."Unit of Measure Code"));
            if valCode <> PurchaseLine."Unit of Measure Code" then begin
                PurchaseLine.Validate("Unit of Measure Code", valCode);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('quantity') then begin
            JsonObj.Get('quantity', JsonTkn);
            valDecimal := JsonTkn.AsValue().AsDecimal();
            if valDecimal <> PurchaseLine.Quantity then begin
                PurchaseLine.Validate(Quantity, valDecimal);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('vATProdPostingGroup') then begin
            JsonObj.Get('vATProdPostingGroup', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseLine."VAT Prod. Posting Group"));
            if valCode <> PurchaseLine."VAT Prod. Posting Group" then begin
                PurchaseLine.Validate("VAT Prod. Posting Group", valCode);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('locationCode') then begin
            JsonObj.Get('locationCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseLine."Location Code"));
            if valCode <> PurchaseLine."Location Code" then begin
                PurchaseLine.Validate("Location Code", valCode);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('binCode') then begin
            JsonObj.Get('binCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(PurchaseLine."Bin Code"));
            if valCode <> PurchaseLine."Bin Code" then begin
                PurchaseLine.Validate("Bin Code", valCode);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('affaireCode') then begin
            JsonObj.Get('affaireCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(AffaireCode));
            DimensionSetEntry.Init();
            if DimensionSetEntry.Get(PurchaseLine."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 3 Code") then;
            if valCode <> DimensionSetEntry."Dimension Value Code" then begin
                AffaireCode := CopyStr(valCode, 1, MaxStrLen(AffaireCode));
                PurchaseLine.ValidateShortcutDimCode(3, AffaireCode);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('vendorItemNo') then begin
            JsonObj.Get('vendorItemNo', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(PurchaseLine."Vendor Item No."));
            if valText <> PurchaseLine."Vendor Item No." then begin
                PurchaseLine.Validate("Vendor Item No.", valText);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('description') then begin
            JsonObj.Get('description', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(PurchaseLine.Description));
            if valText <> PurchaseLine.Description then begin
                PurchaseLine.Validate(Description, valText);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('description2') then begin
            JsonObj.Get('description2', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(PurchaseLine."Description 2"));
            if valText <> PurchaseLine."Description 2" then begin
                PurchaseLine.Validate("Description 2", valText);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('directUnitCost') then begin
            JsonObj.Get('directUnitCost', JsonTkn);
            valDecimal := JsonTkn.AsValue().AsDecimal();
            if valDecimal <> PurchaseLine."Direct Unit Cost" then begin
                PurchaseLine.Validate("Direct Unit Cost", valDecimal);
                PurchaseLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('qtyToReceive') then begin
            JsonObj.Get('qtyToReceive', JsonTkn);
            valDecimal := JsonTkn.AsValue().AsDecimal();
            if valDecimal <> PurchaseLine."Qty. to Receive" then begin
                PurchaseLine.Validate("Qty. to Receive", valDecimal);
                PurchaseLine.Modify(true);
            end;
        end;

        // Build json return value
        Clear(JsonObj);
        JsonObj.Add('documentType', Format(PurchaseLine."Document Type"));
        JsonObj.Add('documentNo', PurchaseLine."Document No.");
        JsonObj.Add('lineNo', PurchaseLine."Line No.");
        JsonObj.Add('type', Format(PurchaseLine.Type));
        JsonObj.Add('no', PurchaseLine."No.");
        JsonObj.Add('site', PurchaseLine.Site);
        JsonObj.Add('jobNo', PurchaseLine."Job No.");
        JsonObj.Add('quantity', PurchaseLine.Quantity);
        JsonObj.Add('qtyToReceive', PurchaseLine."Qty. to Receive");
        JsonObj.Add('quantityReceived', PurchaseLine."Quantity Received");
        JsonObj.Add('quantityInvoiced', PurchaseLine."Quantity Invoiced");
        JsonObj.Add('unitOfMeasureCode', PurchaseLine."Unit of Measure Code");
        JsonObj.Add('vATProdPostingGroup', PurchaseLine."VAT Prod. Posting Group");
        JsonObj.Add('locationCode', PurchaseLine."Location Code");
        JsonObj.Add('binCode', PurchaseLine."Bin Code");
        JsonObj.Add('affaireCode', AffaireCode);
        JsonObj.Add('vendorItemNo', PurchaseLine."Vendor Item No.");
        JsonObj.Add('description', PurchaseLine.Description);
        JsonObj.Add('description2', PurchaseLine."Description 2");
        JsonObj.Add('directUnitCost', PurchaseLine."Direct Unit Cost");
        JsonObj.WriteTo(ReturnValue);

        Rec := PurchaseLine;
        CurrPage.Update(false);

        exit(ReturnValue);
    end;
}