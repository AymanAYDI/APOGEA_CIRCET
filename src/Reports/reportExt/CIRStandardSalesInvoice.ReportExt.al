reportextension 50003 "CIR Standard Sales - Invoice" extends "Standard Sales - Invoice"
{
    dataset
    {
        add(Header)
        {
            column(CIRCompanyAgencyCode; CIRCompanyAgencyCode) { }
            column(CIRCompanyBankAccountNo; CIRCompanyBankAccountNo) { }
            column(CIRCompanyBankBranchNo; CIRCompanyBankBranchNo) { }
            column(CIRCompanyBankName; CIRCompanyBankName) { }
            column(CIRCompanyIBAN; CIRCompanyIBAN) { }
            column(CIRCompanyRibKey; CIRCompanyInfoRibKey) { }
            column(CIRCompanySWIFT; CIRCompanySWIFT) { }
            column(CompanyAgencyCode_Lbl; CompanyAgencyCodeLbl) { }
            column(CompanyAPECode; CompanyInfoSup."APE Code") { }
            column(CompanyAPECode_Lbl; CompanyAPECodeLbl) { }
            column(CompanyCapital; CompanyInfoSup."Stock Capital") { }
            column(CompanyCapital_Lbl; CompanyCapitalLbl) { }
            column(CompanyLegalForm; CompanyInfoSup."Legal Form") { }
            column(CompanyLegalText; CompanyInfoSup."Legal Text EML") { }
            column(CompanyRegistrationNo; CompanyInfoSup."Registration No.") { }
            column(CompanyRegistrationNo_Lbl; CompanyRegistrationNoLbl) { }
            column(CompanyReverseChargeLbl; ReverseChargeLbl) { }
            column(CompanyRibKey_Lbl; CompanyInfoRibKeyLbl) { }
            column(CompanyTradeRegister; CompanyInfoSup."Trade Register") { }
            column(CompanyTradeRegister_Lbl; CompanyTradeRegister_Lbl) { }
            column(GeneralLedgerSetupCurrencyEuro; GeneralLedgerSetup."Local Currency Description") { }
            column(GeneralLedgerSetupCurrencyEuro_Lbl; GeneralLedgerSetupCurrencyEuro_Lbl) { }
            column(HeaderExitPoint; Header."Exit Point") { }
            column(HeaderJobNo; Header.ARBVRNJobNo) { }
            column(Number_of_packages; Header."Number of packages") { }
            column(Number_of_packages_Lbl; NumberOfPackagesLbl) { }
            column(Origin_SalesInvoiceHeader; EntryExitPoint.Description) { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_Lbl; ShipToAddressLbl) { }
            column(ShipmentMethodCode; Header."Shipment Method Code") { }
            column(ShipmentMethodCode_Lbl; ShipmentMethodCode_Lbl) { }
            column(Total_weight; Header."Total weight") { }
            column(Total_weight_Lbl; TotalWeightLbl) { }
            column(VATRegistration; "VAT Registration No.") { }
            column(VATRegistration_Lbl; VATRegistration_Lbl) { }
            column(HeaderCurrency_Lbl; HeaderCurrencyLbl) { }
        }
        add(Line)
        {
            column(CIR_AmountExcludingVAT_Line; ReportMgt.BlankZero(Amount))
            {
                AutoFormatExpression = GetCurrencyCode();
                AutoFormatType = 1;
            }
            column(CIR_UnitPrice; ReportMgt.BlankZero("Unit Price"))
            {
                AutoFormatExpression = GetCurrencyCode();
                AutoFormatType = 2;
            }
            column(Description2_Line; "Description 2") { }
            column(Description2_Line_Lbl; FieldCaption("Description 2")) { }
            column(LineControlStationRef; Line."Control Station Ref.") { }
        }
        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            begin
                IF NOT EntryExitPoint.GET(Header."Exit Point") THEN
                    EntryExitPoint.INIT();

                if Header."Bank Account No." <> '' then
                    if BankAccount.get(Header."Bank Account No.") then begin
                        CIRCompanyBankName := BankAccount.Name;
                        CIRCompanyBankBranchNo := BankAccount."Bank Branch No.";
                        CIRCompanyAgencyCode := BankAccount."Agency Code";
                        CIRCompanyBankAccountNo := BankAccount."Bank Account No.";
                        CIRCompanyInfoRibKey := FORMAT(BankAccount."RIB Key");
                        CIRCompanyIBAN := BankAccount.IBAN;
                        CIRCompanySWIFT := BankAccount."SWIFT Code";
                    end;

                if Header."Gen. Bus. Posting Group" <> '' then
                    if Header."Gen. Bus. Posting Group" = GeneralApplicationSetup."Gen. Bus. Posting Group RC" then
                        ReverseChargeLbl := CompanyInfoSup."Reverse Charge Text";
                HeaderCurrencyLbl := Header."Currency Code";
            end;
        }
        addlast(Line)
        {
            dataitem("Shipment Invoiced"; "Shipment Invoiced")
            {
                DataItemLink = "Invoice No." = FIELD("Document No."), "Invoice Line No." = FIELD("Line No.");
                DataItemLinkReference = Line;
                DataItemTableView = SORTING("Invoice No.", "Invoice Line No.", "Shipment No.", "Shipment Line No.");
                PrintOnlyIfDetail = true;
                column(InvoiceNo_ShipmentInvoiced; "Invoice No.")
                {
                }
                column(PostingDate_ShipmentInvoiced; RecGSalesShipmentHeader."Posting Date")
                {
                }
                column(QtytoShip_ShipmentInvoiced; "Qty. to Ship")
                {
                }
                column(ShipmentNo_ShipmentInvoiced; "Shipment No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF RecGSalesShipmentHeader.GET("Shipment Invoiced"."Shipment No.") THEN;
                end;
            }
        }
    }

    trigger OnPreReport()
    begin
        if GeneralApplicationSetup.Get() then;
        if GeneralLedgerSetup.Get() then;
        if CompanyInfoSup.Get() then begin
            CIRCompanyBankName := CompanyInfoSup."Bank Name";
            CIRCompanyBankBranchNo := CompanyInfoSup."Bank Branch No.";
            CIRCompanyAgencyCode := CompanyInfoSup."CIR Agency Code";
            CIRCompanyBankAccountNo := CompanyInfoSup."Bank Account No.";
            if StrLen(Format(CompanyInfoSup."CIR RIB Key")) <= 2 then
                CIRCompanyInfoRibKey := PadStr('', 2 - StrLen(Format(CompanyInfoSup."CIR RIB Key")), '0') + Format(CompanyInfoSup."CIR RIB Key");
            CIRCompanyIBAN := CompanyInfoSup.IBAN;
            CIRCompanySWIFT := CompanyInfoSup."SWIFT Code";
        end
    end;

    var
        BankAccount: Record "Bank Account";
        CompanyInfoSup: Record "Company Information";
        EntryExitPoint: Record "Entry/Exit Point";
        GeneralApplicationSetup: Record "General Application Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        RecGSalesShipmentHeader: Record "Sales Shipment Header";
        ReportMgt: Codeunit "Report Mgt.";
        CIRCompanySWIFT: Code[20];
        CIRCompanyIBAN: Code[50];
        CompanyAgencyCodeLbl: Label 'Agency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code guichet"}]}';
        CompanyAPECodeLbl: Label 'APE Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code APE"}]}';
        CompanyCapitalLbl: Label 'Capital', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Capital"}]}';
        CompanyInfoRibKeyLbl: Label 'RIB Key', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Clé banque"}]}';
        CompanyRegistrationNoLbl: Label 'Registration No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° SIRET"}]}';
        CompanyTradeRegister_Lbl: Label 'Trade Register', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Registre du commerce"}]}';
        GeneralLedgerSetupCurrencyEuro_Lbl: Label 'Currency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code Devise"}]}';
        NumberOfPackagesLbl: Label 'Number of packages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de colis"}]}';
        ShipmentMethodCode_Lbl: Label 'Shipment Method Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code Incoterms"}]}';
        ShipToAddressLbl: Label 'Ship-to Address', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse de livraison"}]}';
        TotalWeightLbl: Label 'Total weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids total"}]}';
        VATRegistration_Lbl: Label 'VAT Registration No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° identif. intracomm."}]}';
        HeaderCurrency_Lbl: Label 'Bill Currency', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Devise Facture"}]}';
        CIRCompanyInfoRibKey: Text;
        CIRCompanyAgencyCode: Text[5];
        CIRCompanyBankBranchNo: Text[20];
        CIRCompanyBankAccountNo: Text[30];
        CIRCompanyBankName: Text[100];
        ReverseChargeLbl: Text[1024];
        HeaderCurrencyLbl: Text[10];
}