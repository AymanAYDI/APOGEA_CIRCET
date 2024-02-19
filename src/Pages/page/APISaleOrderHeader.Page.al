page 50110 "API Sale Order Header"
{
    PageType = API;
    Caption = 'API Sale Order Header';
    APIPublisher = 'circet';
    APIGroup = 'sales';
    APIVersion = 'v1.0';
    EntityName = 'saleOrderHeader';
    EntitySetName = 'saleOrderHeaders';
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = filter(Order));
    DelayedInsert = true;

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
                field(jobNo; JobNo)
                {
                    Caption = 'Job No.';

                    trigger OnValidate()
                    var
                        Job: Record "Job";
                    begin
                        if Job.Get(JobNo) then
                            rec.Validate("Sell-to Customer No.", Job."Bill-to Customer No.");
                    end;
                }
                field(affaireCode; AffaireCode)
                {
                    Caption = 'Affaire Code';
                }
                field(sellToCustomerNo; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.';
                }
                field(billToCustomerNo; Rec."Bill-to Customer No.")
                {
                    Caption = 'Bill-to Customer No.';
                }
                field(salespersonCode; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson Code';
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'Ship-to Name';
                }
                field(shipToAddress; Rec."Ship-to Address")
                {
                    Caption = 'Ship-to Address';
                }
                field(shipToAddress2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address 2';
                }
                field(shipToPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code';
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City';
                }
                field(shipToCountryRegionCode; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'Ship-to Country/Region Code';
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    Caption = 'Ship-to Contact';
                }
                field(yourReference; Rec."Your Reference")
                {
                    Caption = 'Your Reference';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(siteCode; Rec."Site Code")
                {
                    Caption = 'Site Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code site"}]}';
                }
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                }
                field(vatBusPostingGroup; Rec."VAT Bus. Posting Group")
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

                    trigger OnValidate()
                    begin
                        Rec.Validate("Posting Date", Rec."Order Date");
                        Rec.Validate("Document Date", Rec."Document Date");
                    end;
                }
                field(bankAccountNo; Rec."Bank Account No.")
                {
                    Caption = 'Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                }
            }
            part(SaleOrderLines; "API Sale Order Line")
            {
                Caption = 'Sale Order Lines';
                EntityName = 'saleOrderLine';
                EntitySetName = 'saleOrderLines';
                SubPageLink = "Document No." = field("No.");
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
        JobNo := '';
        Rec.Insert(true);
    end;

    trigger OnModifyRecord(): Boolean
    var
        Job: Record "Job";
    begin
        if JobNo = '' then begin
            Job."No." := '';
            Job."Global Dimension 1 Code" := '';
        end else
            Job.Get(JobNo);
        Rec.ARBVRNJobNo := Job."No.";
        Rec.ValidateShortcutDimCode(4, Job."No.");
        Rec.Validate("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
        Rec.ValidateShortcutDimCode(3, AffaireCode);
    end;

    trigger OnAfterGetRecord()
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        if DimensionSetEntry.Get(Rec."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 3 Code") then
            AffaireCode := DimensionSetEntry."Dimension Value Code"
        else
            AffaireCode := '';
        JobNo := Rec.ARBVRNJobNo;
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        AffaireCode: Code[20];
        JobNo: Code[20];

    [ServiceEnabled]
    procedure UpdateHeader(RequeteJson: Text): Text
    var
        SalesHeader: Record "Sales Header";
        Job: Record Job;
        DimensionSetEntry: Record "Dimension Set Entry";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        WebServActionContext: WebServiceActionContext;
        JsonObj: JsonObject;
        JsonTkn: JsonToken;
        ReturnValue: Text;
        valCode: Code[2048];
        valText: Text;
        valDate: Date;
    begin
        WebServActionContext.SetObjectType(ObjectType::Page);
        WebServActionContext.SetObjectId(Page::"API Sale Order Header");
        WebServActionContext.AddEntityKey(Rec.FieldNo("Document Type"), Rec."Document Type");
        WebServActionContext.AddEntityKey(Rec.FieldNo("No."), Rec."No.");
        WebServActionContext.SetResultCode(WebServiceActionResultCode::Updated);

        // Reopen sale order
        SalesHeader.Get(Rec."Document Type", Rec."No.");
        if (SalesHeader.Status <> SalesHeader.Status::Open) then
            ReleaseSalesDoc.PerformManualReopen(Rec);

        // Parse the json parameter and update the order header
        JsonObj.ReadFrom(RequeteJson);
        if JsonObj.Contains('jobNo') then begin
            JsonObj.Get('jobNo', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(Job."No."));
            if valCode <> SalesHeader.ARBVRNJobNo then begin
                if valCode = '' then begin
                    Job."No." := '';
                    Job."Global Dimension 1 Code" := '';
                end else
                    Job.Get(valCode);
                JobNo := Job."No.";
                SalesHeader.ARBVRNJobNo := Job."No.";
                SalesHeader.ValidateShortcutDimCode(4, Job."No.");
                SalesHeader.Validate("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('sellToCustomerNo') then begin
            JsonObj.Get('sellToCustomerNo', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesHeader."Sell-to Customer No."));
            if valCode <> SalesHeader."Sell-to Customer No." then begin
                SalesHeader.Validate("Sell-to Customer No.", valCode);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('billToCustomerNo') then begin
            JsonObj.Get('billToCustomerNo', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesHeader."Bill-to Customer No."));
            if valCode <> SalesHeader."Bill-to Customer No." then begin
                SalesHeader.Validate("Bill-to Customer No.", valCode);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('salespersonCode') then begin
            JsonObj.Get('salespersonCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesHeader."Salesperson Code"));
            if valCode <> SalesHeader."Salesperson Code" then begin
                SalesHeader.Validate(SalesHeader."Salesperson Code", valCode);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToName') then begin
            JsonObj.Get('shipToName', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(SalesHeader."Ship-to Name"));
            if valText <> SalesHeader."Ship-to Name" then begin
                SalesHeader.Validate("Ship-to Name", valText);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToAddress') then begin
            JsonObj.Get('shipToAddress', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(SalesHeader."Ship-to Address"));
            if valText <> SalesHeader."Ship-to Address" then begin
                SalesHeader.Validate("Ship-to Address", valText);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToAddress2') then begin
            JsonObj.Get('shipToAddress2', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(SalesHeader."Ship-to Address 2"));
            if valText <> SalesHeader."Ship-to Address 2" then begin
                SalesHeader.Validate("Ship-to Address 2", valText);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToPostCode') then begin
            JsonObj.Get('shipToPostCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesHeader."Ship-to Post Code"));
            if valCode <> SalesHeader."Ship-to Post Code" then begin
                SalesHeader.Validate("Ship-to Post Code", valCode);
                SalesHeader.Modify(true);
            end
        end;
        if JsonObj.Contains('shipToCity') then begin
            JsonObj.Get('shipToCity', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(SalesHeader."Ship-to City"));
            if valText <> SalesHeader."Ship-to City" then begin
                SalesHeader.Validate("Ship-to City", valText);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToCountryRegionCode') then begin
            JsonObj.Get('shipToCountryRegionCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesHeader."Ship-to Country/Region Code"));
            if valCode <> SalesHeader."Ship-to Country/Region Code" then begin
                SalesHeader.Validate("Ship-to Country/Region Code", valCode);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('shipToContact') then begin
            JsonObj.Get('shipToContact', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(SalesHeader."Ship-to Contact"));
            if valText <> SalesHeader."Ship-to Contact" then begin
                SalesHeader.Validate("Ship-to Contact", valText);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('yourReference') then begin
            JsonObj.Get('yourReference', JsonTkn);
            valText := CopyStr(JsonTkn.AsValue().AsText(), 1, MaxStrLen(SalesHeader."Your Reference"));
            if valText <> SalesHeader."Your Reference" then begin
                SalesHeader.Validate("Your Reference", valText);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('externalDocumentNo') then begin
            JsonObj.Get('externalDocumentNo', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesHeader."External Document No."));
            if valCode <> SalesHeader."External Document No." then begin
                SalesHeader.Validate("External Document No.", valCode);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('siteCode') then begin
            JsonObj.Get('siteCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesHeader."Site Code"));
            if valCode <> SalesHeader."Site Code" then begin
                SalesHeader.Validate("Site Code", valCode);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('genBusPostingGroup') then begin
            JsonObj.Get('genBusPostingGroup', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesHeader."Gen. Bus. Posting Group"));
            if valCode <> SalesHeader."Gen. Bus. Posting Group" then begin
                SalesHeader.Validate("Gen. Bus. Posting Group", valCode);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('vATBusPostingGroup') then begin
            JsonObj.Get('vATBusPostingGroup', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrlen(SalesHeader."VAT Bus. Posting Group"));
            if valCode <> SalesHeader."VAT Bus. Posting Group" then begin
                SalesHeader.Validate("VAT Bus. Posting Group", valCode);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('currencyCode') then begin
            JsonObj.Get('currencyCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesHeader."Currency Code"));
            if valCode <> SalesHeader."Currency Code" then begin
                SalesHeader.Validate("Currency Code", valCode);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('orderDate') then begin
            JsonObj.Get('orderDate', JsonTkn);
            valDate := JsonTkn.AsValue().AsDate();
            if valDate <> SalesHeader."Order Date" then begin
                SalesHeader.Validate("Order Date", valDate);
                SalesHeader.Validate("Posting Date", SalesHeader."Order Date");
                SalesHeader.Validate("Document Date", SalesHeader."Order Date");
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('bankAccountNo') then begin
            JsonObj.Get('bankAccountNo', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(SalesHeader."Bank Account No."));
            if valCode <> SalesHeader."Bank Account No." then begin
                SalesHeader.Validate("Bank Account No.", valCode);
                SalesHeader.Modify(true);
            end;
        end;
        if JsonObj.Contains('affaireCode') then begin
            JsonObj.Get('affaireCode', JsonTkn);
            valCode := CopyStr(JsonTkn.AsValue().AsCode(), 1, MaxStrLen(AffaireCode));
            DimensionSetEntry.Init();
            if DimensionSetEntry.Get(SalesHeader."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 3 Code") then;
            if valCode <> DimensionSetEntry."Dimension Value Code" then begin
                AffaireCode := CopyStr(valCode, 1, MaxStrLen(AffaireCode));
                SalesHeader.ValidateShortcutDimCode(3, AffaireCode);
                SalesHeader.Modify(true);
            end;
        end;

        // Build json return value
        Clear(JsonObj);
        JsonObj.Add('documentType', Format(SalesHeader."Document Type"));
        JsonObj.Add('no', SalesHeader."No.");
        JsonObj.Add('status', Format(SalesHeader.Status));
        JsonObj.Add('jobNo', SalesHeader.ARBVRNJobNo);
        if DimensionSetEntry.Get(SalesHeader."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 3 Code") then
            AffaireCode := DimensionSetEntry."Dimension Value Code"
        else
            AffaireCode := '';
        JsonObj.Add('affaireCode', AffaireCode);
        JsonObj.Add('sellToCustomerNo', SalesHeader."Sell-to Customer No.");
        JsonObj.Add('billToCustomerNo', SalesHeader."Bill-to Customer No.");
        JsonObj.Add('salespersonCode', SalesHeader."Salesperson Code");
        JsonObj.Add('shipToName', SalesHeader."Ship-to Name");
        JsonObj.Add('shipToAddress', SalesHeader."Ship-to Address");
        JsonObj.Add('shipToAddress2', SalesHeader."Ship-to Address 2");
        JsonObj.Add('shipToPostCode', SalesHeader."Ship-to Post Code");
        JsonObj.Add('shipToCity', SalesHeader."Ship-to City");
        JsonObj.Add('shipToCountryRegionCode', SalesHeader."Ship-to Country/Region Code");
        JsonObj.Add('shipToContact', SalesHeader."Ship-to Contact");
        JsonObj.Add('yourReference', SalesHeader."Your Reference");
        JsonObj.Add('externalDocumentNo', SalesHeader."External Document No.");
        JsonObj.Add('siteCode', SalesHeader."Site Code");
        JsonObj.Add('genBusPostingGroup', SalesHeader."Gen. Bus. Posting Group");
        JsonObj.Add('vATBusPostingGroup', SalesHeader."VAT Bus. Posting Group");
        JsonObj.Add('currencyCode', SalesHeader."Currency Code");
        JsonObj.Add('orderDate', SalesHeader."Order Date");
        JsonObj.Add('bankAccountNo', SalesHeader."Bank Account No.");
        JsonObj.WriteTo(ReturnValue);

        Rec := SalesHeader;
        CurrPage.Update(false);

        exit(ReturnValue);
    end;
}
