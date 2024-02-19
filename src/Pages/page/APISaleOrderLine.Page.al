page 50111 "API Sale Order Line"
{
    PageType = API;
    Caption = 'API Sale Order Line';
    APIPublisher = 'circet';
    APIGroup = 'sales';
    APIVersion = 'v1.0';
    EntityName = 'saleOrderLine';
    EntitySetName = 'saleOrderLines';
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter(Order));
    DelayedInsert = true;
    AutoSplitKey = true;

    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(jobNo; Rec.ARBVRNVeronaJobNo)
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
                field(quantityShipped; Rec."Quantity Shipped")
                {
                    Caption = 'Quantity Shipped';
                }
                field(quantityInvoiced; Rec."Quantity Invoiced")
                {
                    Caption = 'Quantity Invoiced';
                }
                field(vatProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    Caption = 'VAT Prod. Posting Group';
                }
                field(affaireCode; AffaireCode)
                {
                    Caption = 'Affaire Code';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, AffaireCode);
                    end;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(orderLineRef; Rec."Control Station Ref.")
                {
                    Caption = 'Control Station Ref.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Réf. poste de commande" }, { "lang": "FRB", "txt": "Réf. poste de commande" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
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
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        DimensionSetEntry: Record "Dimension Set Entry";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        WebServActionContext: WebServiceActionContext;
        JsonObj: JsonObject;
        JsonTkn: JsonToken;
        ReturnValue: Text;
        valCode: Code[2048];
        valType: Enum "Sales Line Type";
        valText: Text;
        valInt: Integer;
        valDecimal: Decimal;
    begin
        WebServActionContext.SetObjectType(ObjectType::Page);
        WebServActionContext.SetObjectId(Page::"API Sale Order Line");
        WebServActionContext.AddEntityKey(Rec.FieldNo("Document Type"), Rec."Document Type");
        WebServActionContext.AddEntityKey(Rec.FieldNo("Document No."), Rec."Document No.");
        WebServActionContext.AddEntityKey(Rec.FieldNo("Line No."), Rec."Line No.");
        WebServActionContext.SetResultCode(WebServiceActionResultCode::Updated);

        // Reopen sale order
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        if (SalesHeader.Status <> SalesHeader.Status::Open) then
            ReleaseSalesDoc.PerformManualReopen(SalesHeader);

        // Parse the json parameter and update the order line
        SalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
        JsonObj.ReadFrom(RequeteJson);
        if JsonObj.Contains('type') then begin
            JsonObj.Get('type', JsonTkn);
            valType := Enum::"Sales Line Type".FromInteger(valType.Ordinals.Get(valType.Names.IndexOf(JsonTkn.AsValue().AsText())));
            if valType <> SalesLine."Type" then begin
                SalesLine.Validate("Type", valType);
                SalesLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('no') then begin
            JsonObj.Get('no', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesLine."No."));
            if valCode <> SalesLine."No." then begin
                SalesLine.Validate("No.", valCode);
                SalesLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('jobNo') then begin
            JsonObj.Get('jobNo', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesLine.ARBVRNVeronaJobNo));
            if valCode <> SalesLine.ARBVRNVeronaJobNo then begin
                SalesLine.Validate(ARBVRNVeronaJobNo, valCode);
                SalesLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('unitOfMeasureCode') then begin
            JsonObj.Get('unitOfMeasureCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesLine."Unit of Measure Code"));
            if valCode <> SalesLine."Unit of Measure Code" then begin
                SalesLine.Validate("Unit of Measure Code", valCode);
                SalesLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('quantity') then begin
            JsonObj.Get('quantity', JsonTkn);
            valDecimal := JsonTkn.AsValue().AsDecimal();
            if valDecimal <> SalesLine.Quantity then begin
                SalesLine.Validate(Quantity, valDecimal);
                SalesLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('vatProdPostingGroup') then begin
            JsonObj.Get('vatProdPostingGroup', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesLine."VAT Prod. Posting Group"));
            if valCode <> SalesLine."VAT Prod. Posting Group" then begin
                SalesLine.Validate("VAT Prod. Posting Group", valCode);
                SalesLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('affaireCode') then begin
            JsonObj.Get('affaireCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(AffaireCode));
            DimensionSetEntry.Init();
            if DimensionSetEntry.Get(SalesLine."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 3 Code") then;
            if valCode <> DimensionSetEntry."Dimension Value Code" then begin
                AffaireCode := CopyStr(valCode, 1, MaxStrLen(AffaireCode));
                SalesLine.ValidateShortcutDimCode(3, AffaireCode);
                SalesLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('description') then begin
            JsonObj.Get('description', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(SalesLine.Description));
            if valText <> SalesLine.Description then begin
                SalesLine.Validate(Description, valText);
                SalesLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('description2') then begin
            JsonObj.Get('description2', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(SalesLine."Description 2"));
            if valText <> SalesLine."Description 2" then begin
                SalesLine.Validate("Description 2", valText);
                SalesLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('unitPrice') then begin
            JsonObj.Get('unitPrice', JsonTkn);
            valDecimal := JsonTkn.AsValue().AsDecimal();
            if valDecimal <> SalesLine."Unit Price" then begin
                SalesLine.Validate("Unit Price", valDecimal);
                SalesLine.Modify(true);
            end;
        end;
        if JsonObj.Contains('orderLineRef') then begin
            JsonObj.Get('orderLineRef', JsonTkn);
            valInt := JsonTkn.AsValue().AsInteger();
            if valInt <> SalesLine."Control Station Ref." then begin
                SalesLine.Validate("Control Station Ref.", valInt);
                SalesLine.Modify(true);
            end;
        end;

        // Build json return value
        Clear(JsonObj);
        JsonObj.Add('documentType', Format(SalesLine."Document Type"));
        JsonObj.Add('documentNo', SalesLine."Document No.");
        JsonObj.Add('lineNo', SalesLine."Line No.");
        JsonObj.Add('type', Format(SalesLine.Type));
        JsonObj.Add('no', SalesLine."No.");
        JsonObj.Add('jobNo', SalesLine.ARBVRNVeronaJobNo);
        JsonObj.Add('unitOfMeasureCode', SalesLine."Unit of Measure Code");
        JsonObj.Add('quantity', SalesLine.Quantity);
        JsonObj.Add('quantityShipped', SalesLine."Quantity Shipped");
        JsonObj.Add('quantityInvoiced', SalesLine."Quantity Invoiced");
        JsonObj.Add('vATProdPostingGroup', SalesLine."VAT Prod. Posting Group");
        if DimensionSetEntry.Get(SalesLine."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 3 Code") then
            AffaireCode := DimensionSetEntry."Dimension Value Code"
        else
            AffaireCode := '';
        JsonObj.Add('affaireCode', AffaireCode);
        JsonObj.Add('description', SalesLine.Description);
        JsonObj.Add('description2', SalesLine."Description 2");
        JsonObj.Add('unitPrice', SalesLine."Unit Price");
        JsonObj.Add('orderLineRef', SalesLine."Control Station Ref.");
        JsonObj.WriteTo(ReturnValue);

        Rec := SalesLine;
        CurrPage.Update(false);

        exit(ReturnValue);
    end;
}
