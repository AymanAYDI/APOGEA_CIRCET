report 50014 "CIR Standard Purchase - Order"
{
    Caption = 'Purchase - Order', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Achat - Commande"}]}';
    DefaultLayout = Word;
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    WordMergeDataItem = "Purchase Header";

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Standard Purchase - Order', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Achat - Commande"}]}';
            column(CompanyAddress1; CompanyAddr[1])
            {
            }
            column(CompanyAddress2; CompanyAddr[2])
            {
            }
            column(CompanyAddress3; CompanyAddr[3])
            {
            }
            column(CompanyAddress4; CompanyAddr[4])
            {
            }
            column(CompanyAddress5; CompanyAddr[5])
            {
            }
            column(CompanyAddress6; CompanyAddr[6])
            {
            }
            column(CompanyHomePage_Lbl; HomePageCaptionLbl)
            {
            }
            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyEmail_Lbl; EmailIDCaptionLbl)
            {
            }
            column(CompanyEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyPhoneNo_Lbl; CompanyInfoPhoneNoCaptionLbl)
            {
            }
            column(CompanyGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyGiroNo_Lbl; CompanyInfoGiroNoCaptionLbl)
            {
            }
            column(CompanyBankName; CompanyInfo."Bank Name")
            {
            }
            column(CompanyBankName_Lbl; CompanyInfoBankNameCaptionLbl)
            {
            }
            column(CompanyBankBranchNo; CompanyInfo."Bank Branch No.")
            {
            }
            column(CompanyBankBranchNo_Lbl; CompanyInfo.FieldCaption("Bank Branch No."))
            {
            }
            column(CompanyBankAccountNo; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyBankAccountNo_Lbl; CompanyInfoBankAccNoCaptionLbl)
            {
            }
            column(CompanyIBAN; CompanyInfo.IBAN)
            {
            }
            column(CompanyIBAN_Lbl; CompanyInfo.FieldCaption(IBAN))
            {
            }
            column(CompanySWIFT; CompanyInfo."SWIFT Code")
            {
            }
            column(CompanySWIFT_Lbl; CompanyInfo.FieldCaption("SWIFT Code"))
            {
            }
            column(CompanyLogoPosition; CompanyLogoPosition)
            {
            }
            column(CompanyRegistrationNumber; CompanyInfo.GetRegistrationNumber())
            {
            }
            column(CompanyRegistrationNumber_Lbl; CompanyInfo.GetRegistrationNumberLbl())
            {
            }
            column(CompanyVATRegNo; CompanyInfo.GetVATRegistrationNumber())
            {
            }
            column(CompanyVATRegNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl())
            {
            }
            column(CompanyVATRegistrationNo; CompanyInfo.GetVATRegistrationNumber())
            {
            }
            column(CompanyVATRegistrationNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl())
            {
            }
            column(CompanyLegalOffice; '')
            {
            }
            column(CompanyLegalOffice_Lbl; '')
            {
            }
            column(CompanyCustomGiro; '')
            {
            }
            column(CompanyCustomGiro_Lbl; '')
            {
            }
            column(CompanyAPECode_Lbl; CompanyAPECodeLbl) { }
            column(CompanyAPECode; CompanyInfo."APE Code") { }
            column(CompanyCapital_Lbl; CompanyCapitalLbl) { }
            column(CompanyCapital; CompanyInfo."Stock Capital") { }
            column(CompanyTradeRegister_Lbl; CompanyTradeRegisterLbl) { }
            column(CompanyTradeRegister; CompanyInfo."Trade Register") { }
            column(CompanyLegalForm; CompanyInfo."Legal Form") { }
            column(CompanyLegalForm_Lbl; CompanyLegalFormLbl) { }
            column(Fax_Buyer; "Fax Buyer") { }
            column(E_mailBuyer_Lbl; "EmailBuyerLbl") { }
            column(E_mail_Buyer; "E-mail Buyer") { }
            column(Tel_Buyer_Lbl; TelBuyerLbl) { }
            column(Tel_Buyer; "Tel. Buyer") { }
            column(Vendor_Phone_No_Lbl; VendorPhoneNoLbl) { }
            column(Vendor_Phone_No; VendorPhoneNo) { }
            column(Vendor_Fax_No_Lbl; VendorFaxNoLbl) { }
            column(Vendor_Fax_No; VendorFaxNo) { }
            column(DocType_PurchHeader; "Document Type")
            {
            }
            column(No_PurchHeader; "No.")
            {
            }
            column(Description_PurchHeader; "Description")
            {
            }
            column(DocumentTitle_Lbl; DocumentTitleLbl)
            {
            }
            column(Amount_Lbl; AmountCaptionLbl)
            {
            }
            column(PurchLineInvDiscAmt_Lbl; PurchLineInvDiscAmtCaptionLbl)
            {
            }
            column(Subtotal_Lbl; SubtotalCaptionLbl)
            {
            }
            column(VATAmtLineVAT_Lbl; VATAmtLineVATCaptionLbl)
            {
            }
            column(VATAmtLineVATAmt_Lbl; VATAmtLineVATAmtCaptionLbl)
            {
            }
            column(VATAmtSpec_Lbl; VATAmtSpecCaptionLbl)
            {
            }
            column(VATIdentifier_Lbl; VATIdentifierCaptionLbl)
            {
            }
            column(VATAmtLineInvDiscBaseAmt_Lbl; VATAmtLineInvDiscBaseAmtCaptionLbl)
            {
            }
            column(VATAmtLineLineAmt_Lbl; VATAmtLineLineAmtCaptionLbl)
            {
            }
            column(VALVATBaseLCY_Lbl; VALVATBaseLCYCaptionLbl)
            {
            }
            column(Total_Lbl; TotalCaptionLbl)
            {
            }
            column(PaymentTermsDesc_Lbl; PaymentTermsDescCaptionLbl)
            {
            }
            column(ShipmentMethodDesc_Lbl; ShipmentMethodDescCaptionLbl)
            {
            }
            column(PrepymtTermsDesc_Lbl; PrepymtTermsDescCaptionLbl)
            {
            }
            column(HomePage_Lbl; HomePageCaptionLbl)
            {
            }
            column(EmailID_Lbl; EmailIDCaptionLbl)
            {
            }
            column(AllowInvoiceDisc_Lbl; AllowInvoiceDiscCaptionLbl)
            {
            }
            column(DocumentDate; Format("Document Date", 0, 4))
            {
            }
            column(DueDate; Format("Due Date", 0, 4))
            {
            }
            column(ExptRecptDt_PurchaseHeader; Format("Expected Receipt Date", 0, 4))
            {
            }
            column(OrderDate_PurchaseHeader; Format("Order Date", 0, 4))
            {
            }
            column(VATNoText; VATNoText)
            {
            }
            column(VATRegNo_PurchHeader; "VAT Registration No.")
            {
            }
            column(PurchaserText; PurchaserText)
            {
            }
            column(SalesPurchPersonName; SalespersonPurchaser.Name)
            {
            }
            column(ReferenceText; ReferenceText)
            {
            }
            column(YourRef_PurchHeader; "Your Reference")
            {
            }
            column(BuyFrmVendNo_PurchHeader; "Buy-from Vendor No.")
            {
            }
            column(BuyFromAddr1; BuyFromAddr[1])
            {
            }
            column(BuyFromAddr2; BuyFromAddr[2])
            {
            }
            column(BuyFromAddr3; BuyFromAddr[3])
            {
            }
            column(BuyFromAddr4; BuyFromAddr[4])
            {
            }
            column(BuyFromAddr5; BuyFromAddr[5])
            {
            }
            column(BuyFromAddr6; BuyFromAddr[6])
            {
            }
            column(BuyFromAddr7; BuyFromAddr[7])
            {
            }
            column(BuyFromAddr8; BuyFromAddr[8])
            {
            }
            column(BuyFromContactPhoneNoLbl; BuyFromContactPhoneNoLbl)
            {
            }
            column(BuyFromContactMobilePhoneNoLbl; BuyFromContactMobilePhoneNoLbl)
            {
            }
            column(BuyFromContactEmailLbl; BuyFromContactEmailLbl)
            {
            }
            column(PayToContactPhoneNoLbl; PayToContactPhoneNoLbl)
            {
            }
            column(PayToContactMobilePhoneNoLbl; PayToContactMobilePhoneNoLbl)
            {
            }
            column(PayToContactEmailLbl; PayToContactEmailLbl)
            {
            }
            column(BuyFromContactPhoneNo; BuyFromContact."Phone No.")
            {
            }
            column(BuyFromContactMobilePhoneNo; BuyFromContact."Mobile Phone No.")
            {
            }
            column(BuyFromContactEmail; BuyFromContact."E-Mail")
            {
            }
            column(PayToContactPhoneNo; PayToContact."Phone No.")
            {
            }
            column(PayToContactMobilePhoneNo; PayToContact."Mobile Phone No.")
            {
            }
            column(PayToContactEmail; PayToContact."E-Mail")
            {
            }
            column(PricesIncludingVAT_Lbl; PricesIncludingVATCaptionLbl)
            {
            }
            column(PricesInclVAT_PurchHeader; "Prices Including VAT")
            {
            }
            column(OutputNo; OutputNo)
            {
            }
            column(VATBaseDisc_PurchHeader; "VAT Base Discount %")
            {
            }
            column(PricesInclVATtxt; PricesInclVATtxtLbl)
            {
            }
            column(PaymentTermsDesc; PaymentTerms.Description)
            {
            }
            column(ShipmentMethodDesc; ShipmentMethod.Description)
            {
            }
            column(PrepmtPaymentTermsDesc; PrepmtPaymentTerms.Description)
            {
            }
            column(DimText; DimText)
            {
            }
            column(OrderNo_Lbl; OrderNoCaptionLbl)
            {
            }
            column(Page_Lbl; PageCaptionLbl)
            {
            }
            column(DocumentDate_Lbl; DocumentDateCaptionLbl)
            {
            }
            column(BuyFrmVendNo_PurchHeader_Lbl; FieldCaption("Buy-from Vendor No."))
            {
            }
            column(PricesInclVAT_PurchHeader_Lbl; FieldCaption("Prices Including VAT"))
            {
            }
            column(Receiveby_Lbl; ReceivebyCaptionLbl)
            {
            }
            column(Buyer_Lbl; BuyerCaptionLbl)
            {
            }
            column(PayToVendNo_PurchHeader; "Pay-to Vendor No.")
            {
            }
            column(VendAddr8; VendAddr[8])
            {
            }
            column(VendAddr7; VendAddr[7])
            {
            }
            column(VendAddr6; VendAddr[6])
            {
            }
            column(VendAddr5; VendAddr[5])
            {
            }
            column(VendAddr4; VendAddr[4])
            {
            }
            column(VendAddr3; VendAddr[3])
            {
            }
            column(VendAddr2; VendAddr[2])
            {
            }
            column(VendAddr1; VendAddr[1])
            {
            }
            column(PaymentDetails_Lbl; PaymentDetailsCaptionLbl)
            {
            }
            column(VendNo_Lbl; VendNoCaptionLbl)
            {
            }
            column(SellToCustNo_PurchHeader; "Sell-to Customer No.")
            {
            }
            column(ShipToAddr1; ShipToAddr[1])
            {
            }
            column(ShipToAddr2; ShipToAddr[2])
            {
            }
            column(ShipToAddr3; ShipToAddr[3])
            {
            }
            column(ShipToAddr4; ShipToAddr[4])
            {
            }
            column(ShipToAddr5; ShipToAddr[5])
            {
            }
            column(ShipToAddr6; ShipToAddr[6])
            {
            }
            column(ShipToAddr7; ShipToAddr[7])
            {
            }
            column(ShipToAddr8; ShipToAddr[8])
            {
            }
            column(ShiptoAddress_Lbl; ShiptoAddressCaptionLbl)
            {
            }
            column(SellToCustNo_PurchHeader_Lbl; FieldCaption("Sell-to Customer No."))
            {
            }
            column(ItemNumber_Lbl; ItemNumberCaptionLbl)
            {
            }
            column(ItemDescription_Lbl; ItemDescriptionCaptionLbl)
            {
            }
            column(ItemQuantity_Lbl; ItemQuantityCaptionLbl)
            {
            }
            column(ItemUnit_Lbl; ItemUnitCaptionLbl)
            {
            }
            column(ItemUnitPrice_Lbl; ItemUnitPriceCaptionLbl)
            {
            }
            column(ItemLineAmount_Lbl; ItemLineAmountCaptionLbl)
            {
            }
            column(ToCaption_Lbl; ToCaptionLbl)
            {
            }
            column(VendorIDCaption_Lbl; VendorIDCaptionLbl)
            {
            }
            column(ConfirmToCaption_Lbl; ConfirmToCaptionLbl)
            {
            }
            column(PurchOrderCaption_Lbl; PurchOrderCaptionLbl)
            {
            }
            column(PurchOrderNumCaption_Lbl; PurchOrderNumCaptionLbl)
            {
            }
            column(PurchOrderDateCaption_Lbl; PurchOrderDateCaptionLbl)
            {
            }
            column(TaxIdentTypeCaption_Lbl; TaxIdentTypeCaptionLbl)
            {
            }
            column(OrderDate_Lbl; OrderDateLbl)
            {
            }
            column(VendorInvoiceNo_Lbl; VendorInvoiceNoLbl)
            {
            }
            column(VendorInvoiceNo; "Vendor Invoice No.")
            {
            }
            column(VendorOrderNo_Lbl; VendorOrderNoLbl)
            {
            }
            column(VendorOrderNo; "Vendor Order No.")
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(LineNo_PurchLine; "Line No.")
                {
                }
                column(AllowInvDisctxt; AllowInvDisctxt)
                {
                }
                column(Type_PurchLine; Format(Type, 0, 2))
                {
                }
                column(No_PurchLine; ItemNo)
                {
                }
                column(ItemNo_PurchLine; "No.")
                {
                }
                column(VendorItemNo_PurchLine; "Vendor Item No.")
                {
                }
                column(ItemReferenceNo_PurchLine; "Item Reference No.")
                {
                }
                column(Desc_PurchLine; Description)
                {
                }
                column(Desc_PurchLine2; "Description 2")
                {
                }
                column(Qty_PurchLine; FormattedQuanitity)
                {
                }
                column(UOM_PurchLine; "Unit of Measure")
                {
                }
                column(DirUnitCost_PurchLine; FormattedDirectUnitCost)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 2;
                }
                column(LineDisc_PurchLine; "Line Discount %")
                {
                }
                column(LineAmt_PurchLine; FormattedLineAmount)
                {
                }
                column(AllowInvDisc_PurchLine; "Allow Invoice Disc.")
                {
                }
                column(VATIdentifier_PurchLine; "VAT Identifier")
                {
                }
                column(InvDiscAmt_PurchLine; -"Inv. Discount Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(TotalInclVAT; "Line Amount" - "Inv. Discount Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(DirectUniCost_Lbl; DirectUniCostCaptionLbl)
                {
                }
                column(PurchLineLineDisc_Lbl; PurchLineLineDiscCaptionLbl)
                {
                }
                column(VATDiscountAmount_Lbl; VATDiscountAmountCaptionLbl)
                {
                }
                column(No_PurchLine_Lbl; FieldCaption("No."))
                {
                }
                column(Desc_PurchLine_Lbl; FieldCaption(Description))
                {
                }
                column(Desc_PurchLine2_Lbl; FieldCaption("Description 2"))
                {
                }
                column(Qty_PurchLine_Lbl; FieldCaption(Quantity))
                {
                }
                column(UOM_PurchLine_Lbl; ItemUnitOfMeasureCaptionLbl)
                {
                }
                column(VATIdentifier_PurchLine_Lbl; FieldCaption("VAT Identifier"))
                {
                }
                column(AmountIncludingVAT; "Amount Including VAT")
                {
                }
                column(TotalPriceCaption_Lbl; TotalPriceCaptionLbl)
                {
                }
                column(InvDiscCaption_Lbl; InvDiscCaptionLbl)
                {
                }
                column(UnitPrice_PurchLine; "Unit Price (LCY)")
                {
                }
                column(UnitPrice_PurchLine_Lbl; UnitPriceLbl)
                {
                }
                column(JobNo_PurchLine; "Job No.")
                {
                }
                column(JobNo_PurchLine_Lbl; JobNoLbl)
                {
                }
                column(JobTaskNo_PurchLine; "Job Task No.")
                {
                }
                column(JobTaskNo_PurchLine_Lbl; JobTaskNoLbl)
                {
                }
                column(PlannedReceiptDateLbl; PlannedReceiptDateLbl)
                {
                }
                column(PlannedReceiptDate; Format("Planned Receipt Date", 0, 1))
                {
                }
                column(ExpectedReceiptDateLbl; ExpectedReceiptDateLbl)
                {
                }
                column(ExpectedReceiptDate; Format("Expected Receipt Date", 0, 1))
                {
                }
                column(PromisedReceiptDateLbl; PromisedReceiptDateLbl)
                {
                }
                column(PromisedReceiptDate; Format("Promised Receipt Date", 0, 4))
                {
                }
                column(RequestedReceiptDateLbl; RequestedReceiptDateLbl)
                {
                }
                column(RequestedReceiptDate; Format("Requested Receipt Date", 0, 4))
                {
                }
                column(SalesLine_Site; Site) { }
                column(RefSupplier_PurchLine_Lbl; RefSupplierLbl) { }
                column(Ref_PurchLine_Lbl; RefLbl) { }
                column(DefaultShorCutDim3Lbl; DefaultShorCutDim3Lbl) { }
                column(DefaultShorCutDim3; DefaultShorCutDim3) { }

                trigger OnAfterGetRecord()
                var
                    ItemReferenceMgt: Codeunit "Item Reference Management";
                begin
                    AllowInvDisctxt := Format("Allow Invoice Disc.");
                    TotalSubTotal += "Line Amount";
                    TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                    TotalAmount += Amount;
                    GetDefaultShorCutDim3("Purchase Line");

                    ItemNo := "No.";

                    if "Vendor Item No." <> '' then
                        ItemNo := "Vendor Item No.";

                    if "Item Reference No." <> '' then
                        ItemNo := "Item Reference No.";
                    FormatDocument.SetPurchaseLine("Purchase Line", FormattedQuanitity, FormattedDirectUnitCost, FormattedVATPct, FormattedLineAmount);
                end;
            }
            dataitem(Totals; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(VATAmountText; TempVATAmountLine.VATAmountText())
                {
                }
                column(TotalVATAmount; VATAmount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(TotalVATDiscountAmount; -VATDiscountAmount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(TotalVATBaseAmount; VATBaseAmount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(TotalAmountInclVAT; TotalAmountInclVAT)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(TotalInclVATText; TotalInclVATText)
                {
                }
                column(TotalExclVATText; TotalExclVATText)
                {
                }
                column(TotalSubTotal; TotalSubTotal)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(TotalInvoiceDiscountAmount; TotalInvoiceDiscountAmount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(TotalAmount; TotalAmount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(TotalText; TotalText)
                {
                }

                trigger OnAfterGetRecord()
                var
                    TempPrepmtPurchLine: Record "Purchase Line" temporary;
                begin
                    Clear(TempPurchLine);
                    Clear(PurchPost);
                    TempPurchLine.DeleteAll();
                    TempVATAmountLine.DeleteAll();
                    PurchPost.GetPurchLines("Purchase Header", TempPurchLine, 0);
                    TempPurchLine.CalcVATAmountLines(0, "Purchase Header", TempPurchLine, TempVATAmountLine);
                    TempPurchLine.UpdateVATOnLines(0, "Purchase Header", TempPurchLine, TempVATAmountLine);
                    VATAmount := TempVATAmountLine.GetTotalVATAmount();
                    VATBaseAmount := TempVATAmountLine.GetTotalVATBase();
                    VATDiscountAmount :=
                      TempVATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code", "Purchase Header"."Prices Including VAT");
                    TotalAmountInclVAT := TempVATAmountLine.GetTotalAmountInclVAT();

                    TempPrepaymentInvLineBuffer.DeleteAll();
                    PurchasePostPrepayments.GetPurchLines("Purchase Header", 0, TempPrepmtPurchLine);
                    if not TempPrepmtPurchLine.IsEmpty() then begin
                        PurchasePostPrepayments.GetPurchLinesToDeduct("Purchase Header", TempPurchLine);
                        if not TempPurchLine.IsEmpty() then
                            PurchasePostPrepayments.CalcVATAmountLines("Purchase Header", TempPurchLine, TempPrePmtVATAmountLineDeduct, 1);
                    end;
                    PurchasePostPrepayments.CalcVATAmountLines("Purchase Header", TempPrepmtPurchLine, TempPrepmtVATAmountLine, 0);
                    TempPrepmtVATAmountLine.DeductVATAmountLine(TempPrePmtVATAmountLineDeduct);
                    PurchasePostPrepayments.UpdateVATOnLines("Purchase Header", TempPrepmtPurchLine, TempPrepmtVATAmountLine, 0);
                    PurchasePostPrepayments.BuildInvLineBuffer("Purchase Header", TempPrepmtPurchLine, 0, TempPrepaymentInvLineBuffer);
                    PrepmtVATAmount := TempPrepmtVATAmountLine.GetTotalVATAmount();
                    PrepmtVATBaseAmount := TempPrepmtVATAmountLine.GetTotalVATBase();
                    PrepmtTotalAmountInclVAT := TempPrepmtVATAmountLine.GetTotalAmountInclVAT();
                end;
            }
            dataitem(VATCounter; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(VATAmtLineVATBase; TempVATAmountLine."VAT Base")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmtLineVATAmt; TempVATAmountLine."VAT Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmtLineLineAmt; TempVATAmountLine."Line Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmtLineInvDiscBaseAmt; TempVATAmountLine."Inv. Disc. Base Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmtLineInvDiscAmt; TempVATAmountLine."Invoice Discount Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmtLineVAT; TempVATAmountLine."VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(VATAmtLineVATIdentifier; TempVATAmountLine."VAT Identifier")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TempVATAmountLine.GetLine(Number);
                end;

                trigger OnPreDataItem()
                begin
                    if VATAmount = 0 then
                        CurrReport.Break();
                    SetRange(Number, 1, TempVATAmountLine.Count);
                end;
            }
            dataitem(VATCounterLCY; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(VALExchRate; VALExchRate)
                {
                }
                column(VALSpecLCYHeader; VALSpecLCYHeader)
                {
                }
                column(VALVATAmountLCY; VALVATAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(VALVATBaseLCY; VALVATBaseLCY)
                {
                    AutoFormatType = 1;
                }

                trigger OnAfterGetRecord()
                begin
                    TempVATAmountLine.GetLine(Number);
                    VALVATBaseLCY :=
                      TempVATAmountLine.GetBaseLCY(
                        "Purchase Header"."Posting Date", "Purchase Header"."Currency Code", "Purchase Header"."Currency Factor");
                    VALVATAmountLCY :=
                      TempVATAmountLine.GetAmountLCY(
                        "Purchase Header"."Posting Date", "Purchase Header"."Currency Code", "Purchase Header"."Currency Factor");
                end;

                trigger OnPreDataItem()
                begin
                    if (not GLSetup."Print VAT specification in LCY") or
                       ("Purchase Header"."Currency Code" = '') or
                       (TempVATAmountLine.GetTotalVATAmount() = 0)
                    then
                        CurrReport.Break();

                    SetRange(Number, 1, TempVATAmountLine.Count);

                    if GLSetup."LCY Code" = '' then
                        VALSpecLCYHeader := VATAmountSpecificationLbl + LocalCurrentyLbl
                    else
                        VALSpecLCYHeader := VATAmountSpecificationLbl + Format(GLSetup."LCY Code");

                    CurrExchRate.FindCurrency("Purchase Header"."Posting Date", "Purchase Header"."Currency Code", 1);
                    VALExchRate := StrSubstNo(ExchangeRateLbl, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                end;
            }
            dataitem(PrepmtLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(PrepmtLineAmount; PrepmtLineAmount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtInvBufGLAccNo; TempPrepaymentInvLineBuffer."G/L Account No.")
                {
                }
                column(PrepmtInvBufDesc; TempPrepaymentInvLineBuffer.Description)
                {
                }
                column(TotalInclVATText2; TotalInclVATText)
                {
                }
                column(TotalExclVATText2; TotalExclVATText)
                {
                }
                column(PrepmtInvBufAmt; TempPrepaymentInvLineBuffer.Amount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtVATAmountText; TempPrepmtVATAmountLine.VATAmountText())
                {
                }
                column(PrepmtVATAmount; PrepmtVATAmount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtTotalAmountInclVAT; PrepmtTotalAmountInclVAT)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtVATBaseAmount; PrepmtVATBaseAmount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtInvBuDescCaption; PrepmtInvBuDescCaptionLbl)
                {
                }
                column(PrepmtInvBufGLAccNoCaption; PrepmtInvBufGLAccNoCaptionLbl)
                {
                }
                column(PrepaymentSpecCaption; PrepaymentSpecCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                        if not TempPrepaymentInvLineBuffer.Find('-') then
                            CurrReport.Break();
                    end else
                        if TempPrepaymentInvLineBuffer.Next() = 0 then
                            CurrReport.Break();

                    if "Purchase Header"."Prices Including VAT" then
                        PrepmtLineAmount := TempPrepaymentInvLineBuffer."Amount Incl. VAT"
                    else
                        PrepmtLineAmount := TempPrepaymentInvLineBuffer.Amount;
                end;
            }
            dataitem(PrepmtVATCounter; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(PrepmtVATAmtLineVATAmt; TempPrepmtVATAmountLine."VAT Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtVATAmtLineVATBase; TempPrepmtVATAmountLine."VAT Base")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtVATAmtLineLineAmt; TempPrepmtVATAmountLine."Line Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtVATAmtLineVAT; TempPrepmtVATAmountLine."VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(PrepmtVATAmtLineVATId; TempPrepmtVATAmountLine."VAT Identifier")
                {
                }
                column(PrepymtVATAmtSpecCaption; PrepymtVATAmtSpecCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TempPrepmtVATAmountLine.GetLine(Number);
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, TempPrepmtVATAmountLine.Count);
                end;
            }
            dataitem(LetterText; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(GreetingText; GreetingLbl)
                {
                }
                column(BodyText; BodyLbl)
                {
                }
                column(ClosingText; ClosingLbl)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                TotalAmount := 0;
                CurrReport.Language := gLanguage.GetLanguageIdOrDefault("Language Code");

                FormatAddressFields("Purchase Header");
                FormatDocumentFields("Purchase Header");
                if BuyFromContact.Get("Buy-from Contact No.") then;
                if PayToContact.Get("Pay-to Contact No.") then;

                if not IsReportInPreviewMode() then begin
                    CODEUNIT.Run(CODEUNIT::"Purch.Header-Printed", "Purchase Header");
                    if bArchiveDocument then
                        ArchiveManagement.StorePurchDocument("Purchase Header", bLogInteraction);
                end;
                FillingShipToAddress();
                FillingVendorTelAndFax();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Options"}]}';
                    field(ArchiveDocument; bArchiveDocument)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Archive Document', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Archiver document"}]}';
                        ToolTip = 'Specifies whether to archive the order.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie si la commande doit être archivée."}]}';

                    }
                    field(LogInteraction; bLogInteraction)
                    {
                        ApplicationArea = Suite;
                        Enabled = LogInteractionEnable;
                        Caption = 'Log Interaction', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Journal interaction"}]}';
                        ToolTip = 'Specifies if you want the program to log this interaction.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie si vous souhaitez que le programme enregistre cette interaction."}]}';
                    }
                }
            }
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
            bArchiveDocument := PurchSetup."Archive Orders";
        end;

        trigger OnOpenPage()
        begin
            LogInteractionEnable := bLogInteraction;
        end;
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
        PurchSetup.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPostReport()
    begin
        if bLogInteraction and not IsReportInPreviewMode() then
            if "Purchase Header".FindSet() then
                repeat
                    SegManagement.LogDocument(
                      13, "Purchase Header"."No.", 0, 0, DATABASE::Vendor, "Purchase Header"."Buy-from Vendor No.",
                      "Purchase Header"."Purchaser Code", '', "Purchase Header"."Posting Description", '');
                until "Purchase Header".Next() = 0;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage() then
            InitLogInteraction();
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempPrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        TempPurchLine: Record "Purchase Line" temporary;
        TempPrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer" temporary;
        TempPrePmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        RespCenter: Record "Responsibility Center";
        CurrExchRate: Record "Currency Exchange Rate";
        PurchSetup: Record "Purchases & Payables Setup";
        BuyFromContact: Record Contact;
        PayToContact: Record Contact;
        GeneralApplicationSetup: Record "General Application Setup";
        DimensionSetEntry: Record "Dimension Set Entry";
        Vendor: Record Vendor;
        gLanguage: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        PurchPost: Codeunit "Purch.-Post";
        SegManagement: Codeunit SegManagement;
        PurchasePostPrepayments: Codeunit "Purchase-Post Prepayments";
        ArchiveManagement: Codeunit ArchiveManagement;
        VendAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        BuyFromAddr: array[8] of Text[100];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        FormattedQuanitity: Text;
        FormattedDirectUnitCost: Text;
        FormattedVATPct: Text;
        FormattedLineAmount: Text;
        OutputNo: Integer;
        DimText: Text[120];
        bLogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        AllowInvDisctxt: Text[30];
        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        DefaultShorCutDim3: Code[20];
        ShipToAddress: Text[100];
        VendorPhoneNo: Text[30];
        VendorFaxNo: Text[30];
        VATAmountSpecificationLbl: Label 'VAT Amount Specification in ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Détail TVA dans"}]}';
        LocalCurrentyLbl: Label 'Local Currency', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Devise société"}]}';
        ExchangeRateLbl: Label 'Exchange rate: %1/%2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Taux de change : %1/%2"}]}';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° téléphone"}]}';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° CCP"}]}';
        CompanyInfoBankNameCaptionLbl: Label 'Bank', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Banque"}]}';
        CompanyInfoBankAccNoCaptionLbl: Label 'Account No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° compte"}]}';
        OrderNoCaptionLbl: Label 'Order No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° commande"}]}';
        PageCaptionLbl: Label 'Page', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Page"}]}';
        DocumentDateCaptionLbl: Label 'Document Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date document"}]}';
        DirectUniCostCaptionLbl: Label 'Direct Unit Cost', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Coût unitaire direct"}]}';
        PurchLineLineDiscCaptionLbl: Label 'Discount %', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"% remise"}]}';
        VATDiscountAmountCaptionLbl: Label 'Payment Discount on VAT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Escompte sur TVA"}]}';
        PaymentDetailsCaptionLbl: Label 'Payment Details', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Détail paiement"}]}';
        VendNoCaptionLbl: Label 'Vendor No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° fournisseur"}]}';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse destinataire"}]}';
        PrepmtInvBuDescCaptionLbl: Label 'Description', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Description"}]}';
        PrepmtInvBufGLAccNoCaptionLbl: Label 'G/L Account No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° compte général"}]}';
        PrepaymentSpecCaptionLbl: Label 'Prepayment Specification', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécification acompte"}]}';
        PrepymtVATAmtSpecCaptionLbl: Label 'Prepayment VAT Amount Specification', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécification montant TVA acompte"}]}';
        AmountCaptionLbl: Label 'Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant"}]}';
        PurchLineInvDiscAmtCaptionLbl: Label 'Invoice Discount Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant remise facture"}]}';
        SubtotalCaptionLbl: Label 'Subtotal', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Sous-total"}]}';
        VATAmtLineVATCaptionLbl: Label 'VAT %', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"% TVA"}]}';
        VATAmtLineVATAmtCaptionLbl: Label 'VAT Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant TVA"}]}';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Détail TVA"}]}';
        VATIdentifierCaptionLbl: Label 'VAT Identifier', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Identifiant TVA"}]}';
        VATAmtLineInvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant base remise facture"}]}';
        VATAmtLineLineAmtCaptionLbl: Label 'Line Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant ligne"}]}';
        VALVATBaseLCYCaptionLbl: Label 'VAT Base', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Base TVA"}]}';
        PricesInclVATtxtLbl: Label 'Prices Including VAT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Prix TTC"}]}';
        TotalCaptionLbl: Label 'Total', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total"}]}';
        PaymentTermsDescCaptionLbl: Label 'Payment Terms', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Conditions de paiement"}]}';
        ShipmentMethodDescCaptionLbl: Label 'Shipment Method', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Conditions de livraison"}]}';
        PrepymtTermsDescCaptionLbl: Label 'Prepmt. Payment Terms', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Conditions paiement acompte"}]}';
        HomePageCaptionLbl: Label 'Home Page', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Page d''accueil"}]}';
        EmailIDCaptionLbl: Label 'Email', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse e-mail"}]}';
        AllowInvoiceDiscCaptionLbl: Label 'Allow Invoice Discount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Autoriser remise facture"}]}';
        BuyFromContactPhoneNoLbl: Label 'Buy-from Contact Phone No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tél. fournisseur"}]}';
        BuyFromContactMobilePhoneNoLbl: Label 'Buy-from Contact Mobile Phone No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tél. mobile fournisseur"}]}';
        BuyFromContactEmailLbl: Label 'Buy-from Contact E-Mail', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Email fournisseur"}]}';
        PayToContactPhoneNoLbl: Label 'Pay-to Contact Phone No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Tél contact"}]}';
        PayToContactMobilePhoneNoLbl: Label 'Pay-to Contact Mobile Phone No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Tél mobile contact"}]}';
        PayToContactEmailLbl: Label 'Pay-to Contact E-Mail', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Email contact"}]}';
        DocumentTitleLbl: Label 'Purchase Order', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commande achat"}]}';
        CompanyLogoPosition: Integer;
        ReceivebyCaptionLbl: Label 'Receive By', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Réceptionner par"}]}';
        BuyerCaptionLbl: Label 'Buyer', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Approvisionneur"}]}';
        ItemNumberCaptionLbl: Label 'Item No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° article"}]}';
        ItemDescriptionCaptionLbl: Label 'Description', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Description"}]}';
        ItemQuantityCaptionLbl: Label 'Quantity', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Quantité"}]}';
        ItemUnitCaptionLbl: Label 'Unit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Unité"}]}';
        ItemUnitPriceCaptionLbl: Label 'Unit Price', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Prix unitaire"}]}';
        ItemLineAmountCaptionLbl: Label 'Line Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant ligne"}]}';
        PricesIncludingVATCaptionLbl: Label 'Prices Including VAT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Prix TTC"}]}';
        ItemUnitOfMeasureCaptionLbl: Label 'Unit', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Unité"}]}';
        ToCaptionLbl: Label 'To:', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"À :"}]}';
        VendorIDCaptionLbl: Label 'Vendor ID', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ID fournisseur"}]}';
        ConfirmToCaptionLbl: Label 'Confirm To', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Confirmer à"}]}';
        PurchOrderCaptionLbl: Label 'PURCHASE ORDER', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"COMMANDE ACHAT"}]}';
        PurchOrderNumCaptionLbl: Label 'Purchase Order Number:', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Numéro de commande:"}]}';
        PurchOrderDateCaptionLbl: Label 'Purchase Order Date:', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date du bon de commande:"}]}';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type Ident. Taxe"}]}';
        TotalPriceCaptionLbl: Label 'Total Price', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Prix total"}]}';
        InvDiscCaptionLbl: Label 'Invoice Discount:', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Remise facture :"}]}';
        GreetingLbl: Label 'Hello', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Bonjour"}]}';
        ClosingLbl: Label 'Sincerely', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Cordialement"}]}';
        BodyLbl: Label 'The purchase order is attached to this message.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La commande achat est jointe à ce message."}]}';
        OrderDateLbl: Label 'Order Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de commande"}]}';
        bArchiveDocument: Boolean;
        VendorOrderNoLbl: Label 'Vendor Order No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° commande fournisseur"}]}';
        VendorInvoiceNoLbl: Label 'Vendor Invoice No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° facture fournisseur"}]}';
        UnitPriceLbl: Label 'Unit Price (LCY)', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Prix unitaire DS"}]}';
        JobNoLbl: Label 'Job No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° projet"}]}';
        JobTaskNoLbl: Label 'Job Task No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° tâche projet"}]}';
        PromisedReceiptDateLbl: Label 'Promised Receipt Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date réception confirmée"}]}';
        RequestedReceiptDateLbl: Label 'Requested Receipt Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date réception demandée"}]}';
        ExpectedReceiptDateLbl: Label 'Expected Receipt Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date réception prévue"}]}';
        PlannedReceiptDateLbl: Label 'Planned Receipt Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date planifiée de réception"}]}';
        DefaultShorCutDim3Lbl: Label 'Business No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Affaire"}]}';
        RefSupplierLbl: Label 'Ref. Supplier', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ref. Fours"}]}';
        RefLbl: Label 'Ref.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ref."}]}';
        EmailBuyerLbl: Label 'E-mail Buyer', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Mail approvisionneur"}]}';
        TelBuyerLbl: Label 'Tel. Buyer', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tél. approvisionneur"}]}';

        VendorPhoneNoLbl: Label 'Tel. Vendor', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tél. fournisseur"}]}';
        VendorFaxNoLbl: Label 'Fax Vendor', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Télécopie fournisseur"}]}';
        CompanyAPECodeLbl: Label 'APE Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code APE"}]}';
        CompanyCapitalLbl: Label 'Capital', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Capital social"}]}';
        CompanyTradeRegisterLbl: Label 'Trade Register', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Registre du commerce"}]}';
        CompanyLegalFormLbl: Label 'Legal Form', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Forme juridique"}]}';
        ItemNo: Text;

    procedure InitializeRequest(LogInteractionParam: Boolean)
    begin
        bLogInteraction := LogInteractionParam;
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure FormatAddressFields(var PurchaseHeader: Record "Purchase Header")
    begin
        FormatAddr.GetCompanyAddr(PurchaseHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.PurchHeaderBuyFrom(BuyFromAddr, PurchaseHeader);
        if PurchaseHeader."Buy-from Vendor No." <> PurchaseHeader."Pay-to Vendor No." then
            FormatAddr.PurchHeaderPayTo(VendAddr, PurchaseHeader);
        FormatAddr.PurchHeaderShipTo(ShipToAddr, PurchaseHeader);
    end;

    local procedure FormatDocumentFields(PurchaseHeader: Record "Purchase Header")
    begin
        FormatDocument.SetTotalLabels(PurchaseHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
#pragma warning disable AA0139 // Impossible à CopyStr
        FormatDocument.SetPurchaser(SalespersonPurchaser, PurchaseHeader."Purchaser Code", PurchaserText);
#pragma warning restore AA0139 // Impossible a copystr
        FormatDocument.SetPaymentTerms(PaymentTerms, PurchaseHeader."Payment Terms Code", PurchaseHeader."Language Code");
        FormatDocument.SetPaymentTerms(PrepmtPaymentTerms, PurchaseHeader."Prepmt. Payment Terms Code", PurchaseHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, PurchaseHeader."Shipment Method Code", PurchaseHeader."Language Code");

        ReferenceText := FormatDocument.SetText(PurchaseHeader."Your Reference" <> '', CopyStr(PurchaseHeader.FieldCaption("Your Reference"), 1, 80));
        VATNoText := FormatDocument.SetText(PurchaseHeader."VAT Registration No." <> '', CopyStr(PurchaseHeader.FieldCaption("VAT Registration No."), 1, 80));
    end;

    local procedure InitLogInteraction()
    begin
        bLogInteraction := SegManagement.FindInteractTmplCode(13) <> '';
    end;

    local procedure FillingVendorTelAndFax()
    begin
        if Vendor.Get("Purchase Header"."Pay-to Vendor No.") then begin
            VendorPhoneNo := Vendor."Phone No.";
            VendorFaxNo := Vendor."Fax No.";
        end;
    end;

    local procedure FillingShipToAddress()
    begin
        ShipToAddress := "Purchase Header"."Ship-to Address";
        if ShipToAddress = '' then
            ShipToAddress := CompanyInfo."Ship-to Address";
    end;

    local procedure GetDefaultShorCutDim3(PurchLine: Record "Purchase Line")
    begin
        DefaultShorCutDim3 := '';
        if GeneralApplicationSetup.Get() then
            if DimensionSetEntry.Get(PurchLine."Dimension Set ID", GeneralApplicationSetup."Business Dimension Code") then
                DefaultShorCutDim3 := DimensionSetEntry."Dimension Value Code";
    end;
}