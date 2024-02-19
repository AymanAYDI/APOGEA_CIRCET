report 50012 "Purchase - Receipt Circet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/PurchaseReceipt.rdl';
    Caption = 'Purchase - Receipt', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Bon de réception"}]}';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Posted Purchase Receipt';
            column(No_PurchRcptHeader; "No.")
            {
            }
            column(DocDateCaption; DocDateCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(DescCaption; DescCaptionLbl)
            {
            }
            column(QtyCaption; QtyCaptionLbl)
            {
            }
            column(UOMCaption; UOMCaptionLbl)
            {
            }
            column(PaytoVenNoCaption; PaytoVenNoCaptionLbl)
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(CstG001; STRSUBSTNO(ReceivedBy_Lbl, "User ID", FORMAT("Posting Date", 0, 4)))
            {
            }
            column(Text003; Page_Lbl)
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                        WHERE(Number = CONST(1));
                    column(VendAddr1; VendAddr[1])
                    {
                    }
                    column(VendAddr2; VendAddr[2])
                    {
                    }
                    column(VendAddr3; VendAddr[3])
                    {
                    }
                    column(VendAddr4; VendAddr[4])
                    {
                    }
                    column(VendAddr5; VendAddr[5])
                    {
                    }
                    column(VendAddr6; VendAddr[6])
                    {
                    }
                    column(VendAddr7; VendAddr[7])
                    {
                    }
                    column(VendAddr8; VendAddr[8])
                    {
                    }
                    column(CompanyInfoPicture; CompanyInfo.Picture)
                    {
                    }
                    column(PurchRcptCopyText; STRSUBSTNO(PurchaseReceipt_Lbl, "Purch. Rcpt. Header"."No."))
                    {
                    }
                    column(CurrentReportPageNo; Page_Lbl)
                    {
                    }
                    column(ShipToAddr1; ShipToAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(ShipToAddr2; ShipToAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(ShipToAddr3; ShipToAddr[3])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(ShipToAddr4; ShipToAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(ShipToAddr5; ShipToAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(ShipToAddr6; ShipToAddr[6])
                    {
                    }
                    column(CompanyInfoName; CompanyInfo.Name)
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(DocDate_PurchRcptHeader; FORMAT("Purch. Rcpt. Header"."Document Date", 0, 4))
                    {
                    }
                    column(PurchaserText; PurchaserText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(No1_PurchRcptHeader; "Purch. Rcpt. Header"."No.")
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourRef_PurchRcptHeader; "Purch. Rcpt. Header"."Your Reference")
                    {
                    }
                    column(ShipToAddr7; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr8; ShipToAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(HomePageCaption; HomePageCaptionLbl)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(AccNoCaption; AccNoCaptionLbl)
                    {
                    }
                    column(ShipmentNoCaption; ShipmentNoCaptionLbl)
                    {
                    }
                    column(Desg_cmde_PurchRcptHeader; "Purch. Rcpt. Header"."Description Order")
                    {
                    }
                    column(BuyfromVenNo_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Vendor No.")
                    {
                    }
                    column(BuyfromVenName_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Vendor Name")
                    {
                    }
                    column(CstG002; Vendor_Lbl)
                    {
                    }
                    column(CstG003; STRSUBSTNO(Fax_Lbl, recVendor."Fax No."))
                    {
                    }
                    column(CstG004; ShippingAddress_Lbl)
                    {
                    }
                    column(CstG005; ReceptionReport_Lbl)
                    {
                    }
                    column(CstG006; ReceiptWithoutRes_Lbl)
                    {
                    }
                    column(CstG007; Total_Lbl)
                    {
                    }
                    column(CstG008; Partial_Lbl)
                    {
                    }
                    column(CstG009; Name_Lbl)
                    {
                    }
                    column(CstG010; Date_Lbl)
                    {
                    }
                    column(CstG011; Visa_Lbl)
                    {
                    }
                    column(CstG012; Empty_Lbl)
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Purch. Rcpt. Header";
                        DataItemTableView = SORTING(Number)
                            WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(HeaderDimCaption; HeaderDimCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            Percent1Percent2_Lbl: Label '%1 - %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1 - %2"}]}';
                            Percent1Percent2Percent3_Lbl: Label '%1; %2 - %3', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1; %2 - %3"}]}';
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FINDSET() THEN
                                    CurrReport.BREAK();
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK();

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO(Percent1Percent2_Lbl, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      CopyStr(STRSUBSTNO(
                                        Percent1Percent2Percent3_Lbl, DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code"), 1, MaxStrLen(DimText));
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT() = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK();
                        end;
                    }
                    dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Purch. Rcpt. Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");

                        column(CoutTotaldevsoc_PurchRcptLine; "Unit Cost (LCY)" * Quantity/*"Cout Total (dev soc)"*/)
                        {
                        }
                        column(JobNo_PurchRcptLine; "Job No.")
                        {
                            IncludeCaption = true;
                        }
                        column(LocationCode_PurchRcptLine; "Location Code")
                        {
                            IncludeCaption = true;
                        }
                        column(OrderNo_PurchRcptLine; "Order No.")
                        {
                            IncludeCaption = true;
                        }
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(Type_PurchRcptLine; FORMAT(Type, 0, 9))
                        {
                        }
                        column(Desc_PurchRcptLine; Description)
                        {
                            IncludeCaption = false;
                        }
                        column(Qty_PurchRcptLine; Quantity)
                        {
                            IncludeCaption = false;
                        }
                        column(UOM_PurchRcptLine; "Unit of Measure")
                        {
                            IncludeCaption = false;
                        }
                        column(Site; Site)
                        {
                            IncludeCaption = true;
                        }
                        column(No_PurchRcptLine; "No.")
                        {
                        }
                        column(DocNo_PurchRcptLine; "Document No.")
                        {
                        }
                        column(LineNo_PurchRcptLine; "Line No.")
                        {
                            IncludeCaption = false;
                        }
                        column(No_PurchRcptLineCaption; FIELDCAPTION("No."))
                        {
                        }
                        column(CoutCaption; CostCaption_Lbl)
                        {
                        }
                        column(TotalCaption; TotalCaption_Lbl)
                        {
                        }
                        Column(ProjectDimension; ProjectDimension)
                        {
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
                            column(DimText1; DimText)
                            {
                            }
                            column(LineDimCaption; LineDimCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                Percent1Percent2_Lbl: Label '%1 - %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1 - %2"}]}';
                                Percent1Percent2Percent3_Lbl: Label '%1; %2 - %3', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1; %2 - %3"}]}';
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDSET() THEN
                                        CurrReport.BREAK();
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK();

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO(Percent1Percent2_Lbl, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            Percent1Percent2Percent3_Lbl, DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL DimSetEntry2.NEXT() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK();
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            GLSetup: record "General Ledger Setup";
                        begin
                            IF (NOT ShowCorrectionLines) AND Correction THEN
                                CurrReport.SKIP();
                            DimSetEntry2.SETRANGE("Dimension Set ID", "Dimension Set ID");
                            IF DimSetEntry2.GET() THEN begin
                                GLSetup.GET();
                                repeat
                                    if DimSetEntry2."Dimension Code" = GLSetup."Shortcut Dimension 4 Code" then
                                        ProjectDimension := DimSetEntry2."Dimension Value Code";
                                until DimSetEntry2.NEXT() = 0;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := FIND('+');
                            WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) DO
                                MoreLines := NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK();
                            SETRANGE("Line No.", 0, "Line No.");
                        end;
                    }
                    dataitem(Total; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                            WHERE(Number = CONST(1));
                        column(BuyfromVenNo_PurchRcptHeaderCaption; "Purch. Rcpt. Header".FIELDCAPTION("Buy-from Vendor No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            IF "Purch. Rcpt. Header"."Buy-from Vendor No." = "Purch. Rcpt. Header"."Pay-to Vendor No." THEN
                                CurrReport.BREAK();
                        end;
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                            WHERE(Number = CONST(1));
                        column(PaytoVenNo_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to Vendor No.")
                        {
                        }
                        column(PaytoAddrCaption; PaytoAddrCaptionLbl)
                        {
                        }
                        column(PaytoVenNo_PurchRcptHeaderCaption; "Purch. Rcpt. Header".FIELDCAPTION("Pay-to Vendor No."))
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number > 1 THEN BEGIN
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    END;
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT CurrReport.PREVIEW THEN
                        CODEUNIT.RUN(CODEUNIT::"Purch.Rcpt.-Printed", "Purch. Rcpt. Header");
                end;

                trigger OnPreDataItem()
                begin
                    OutputNo := 1;

                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddressFields("Purch. Rcpt. Header");
                FormatDocumentFields("Purch. Rcpt. Header");

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN
                        SegManagement.LogDocument(15, "No.", 0, 0, DATABASE::Vendor, "Buy-from Vendor No.", "Purchaser Code", '', "Posting Description", '');

                IF recVendor.GET("Buy-from Vendor No.") THEN;
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
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° de copies"}]}';
                        ApplicationArea = All;
                        ToolTip = 'No. of Copies', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° de copies"}]}';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Voir information interne"}]}';
                        ApplicationArea = All;
                        ToolTip = 'Show Internal Information', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Voir information interne"}]}';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Interaction du journal de Log"}]}';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = All;
                        ToolTip = 'Log Interaction', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Interaction du journal de Log"}]}';
                    }
                    field(ShowCorrectionLines; ShowCorrectionLines)
                    {
                        Caption = 'Show Correction Lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Voir lignes de correction"}]}';
                        ApplicationArea = All;
                        ToolTip = 'Show Correction Lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Voir lignes de correction"}]}';
                    }
                }
            }
        }

        trigger OnInit()
        begin
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            LogInteraction := SegManagement.FindInteractTmplCode(15) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }
    trigger OnInitReport()
    begin
        CompanyInfo.GET();
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        recVendor: Record Vendor;
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        VendAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        PurchaserText: Text[50];
        ReferenceText: Text[80];
        MoreLines: Boolean;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[120];
        ProjectDimension: Text[40];
        Continue: Boolean;
#pragma warning disable AA0204
        ShowInternalInfo, LogInteraction, ShowCorrectionLines : Boolean;
        NoOfCopies: Integer;
#pragma warning restore AA0204
        OutputNo: Integer;
        LogInteractionEnable: Boolean;
        PurchaseReceipt_Lbl: Label 'PURCHASE - RECEIPT %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"BON DE RECEPTION : %1"}]}';
        Page_Lbl: Label 'Page %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Page %1"}]}';
        PhoneNoCaptionLbl: Label 'Phone No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° de téléphone"}]}';
        HomePageCaptionLbl: Label 'Home Page', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Page d''accueil"}]}';
        VATRegNoCaptionLbl: Label 'VAT Registration No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° identif. intracomm."}]}';
        GiroNoCaptionLbl: Label 'Giro No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° CCP"}]}';
        BankNameCaptionLbl: Label 'Bank', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Banque"}]}';
        AccNoCaptionLbl: Label 'Account No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° compte"}]}';
        ShipmentNoCaptionLbl: Label 'Shipment No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° expédition"}]}';
        HeaderDimCaptionLbl: Label 'Header Dimensions', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Analytique en-tête"}]}';
        LineDimCaptionLbl: Label 'Line Dimensions', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Analytique ligne"}]}';
        PaytoAddrCaptionLbl: Label 'Pay-to Address', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse"}]}';
        DocDateCaptionLbl: Label 'Document Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date document"}]}';
        PageCaptionLbl: Label 'Page', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Page"}]}';
        DescCaptionLbl: Label 'Description', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désignation"}]}';
        QtyCaptionLbl: Label 'Quantity', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Qté"}]}';
        UOMCaptionLbl: Label 'Unit Of Measure', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Unité"}]}';
        PaytoVenNoCaptionLbl: Label 'Pay-to Vendor No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° fournisseur à payer"}]}';
        EmailCaptionLbl: Label 'Email', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"E-mail"}]}';
        ReceivedBy_Lbl: Label 'Received By %1 At %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Réceptionné par %1 le %2"}]}';
        Vendor_Lbl: Label 'Vendor :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fournisseur :"}]}';
        Fax_Lbl: Label '(Fax :  %1 )', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"(Fax :  %1 )"}]}';
        ShippingAddress_Lbl: Label 'Shipping Address :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse de livraison :"}]}';
        ReceptionReport_Lbl: Label 'Reception report site / service', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"PV de réception de chantier / prestation"}]}';
        ReceiptWithoutRes_Lbl: Label 'The receipt of services is pronounced unreserved.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La réception des prestations est prononcée sans réserve."}]}';
        Total_Lbl: Label 'Total', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Totale"}]}';
        Partial_Lbl: Label 'Partial', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Partielle"}]}';
        Name_Lbl: Label 'Name :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom :"}]}';
        Date_Lbl: Label 'Date :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date :"}]}';
        Visa_Lbl: Label 'Visa :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Visa :"}]}';
        Empty_Lbl: Label '', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":""}]}';
        CostCaption_Lbl: Label 'Cost', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Coût"}]}';
        TotalCaption_Lbl: Label 'Total', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total"}]}';


    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; NewShowCorrectionLines: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        ShowCorrectionLines := NewShowCorrectionLines;
    end;

    local procedure FormatAddressFields(var PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        FormatAddr.GetCompanyAddr(PurchRcptHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.PurchRcptShipTo(ShipToAddr, PurchRcptHeader);
        FormatAddr.PurchRcptBuyFrom(VendAddr, PurchRcptHeader);
    end;

    local procedure FormatDocumentFields(PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        FormatDocument.SetPurchaser(SalesPurchPerson, PurchRcptHeader."Purchaser Code", PurchaserText);
        ReferenceText := FormatDocument.SetText(PurchRcptHeader."Your Reference" <> '', CopyStr(PurchRcptHeader.FIELDCAPTION("Your Reference"), 1, 80));
    end;
}