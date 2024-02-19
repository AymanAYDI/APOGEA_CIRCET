reportextension 50000 "CIR Std. Sales - Order Conf." extends "Standard Sales - Order Conf."
{
    dataset
    {
        add(Header)
        {
            column(CustRegistrationNo; Header."VAT Registration No.") { }
            column(CompanyRegistrationNo; CompanyInfoSup."Registration No.") { }
            column(CompanyAgencyCode; CompanyInfoSup."CIR Agency Code") { }
            column(CompanyRibKey_Lbl; CompanyInfoRibKey_Lbl) { }
            column(CompanyRibKey; CompanyInfoRibKey) { }
            column(CompanyAPECode; CompanyInfoSup."APE Code") { }
            column(CompanyCapital; CompanyInfoSup."Stock Capital") { }
            column(CompanyLegalForm; CompanyInfoSup."Legal Form") { }
            column(CompanyTradeRegister; CompanyInfoSup."Trade Register") { }
            column(CompanyTradeRegister_Lbl; CompanyTradeRegister_Lbl) { }
            column(PromisedDeliveryDate; Format(Header."Promised Delivery Date", 0, 4)) { }
            column(PromisedDeliveryDate_Lbl; FieldCaption(Header."Promised Delivery Date")) { }
            column(SiteCode; Header."Site Code") { }
            column(SiteCode_Lbl; FieldCaption(Header."Site Code")) { }
        }
        add(Line)
        {
            column(LineDescription2; Line."Description 2") { }
            column(DiscountLbl; Discount_Lbl) { }
        }
    }

    trigger OnPreReport()
    begin
        if CompanyInfoSup.Get() then
            if StrLen(Format(CompanyInfoSup."CIR RIB Key")) <= 2 then
                CompanyInfoRibKey := PadStr('', 2 - StrLen(Format(CompanyInfoSup."CIR RIB Key")), '0') + Format(CompanyInfoSup."CIR RIB Key");
    end;

    var
        CompanyInfoSup: Record "Company Information";
        CompanyInfoRibKey: Text;
        CompanyInfoRibKey_Lbl: Label 'RIB Key', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Clé banque"}]}';
        CompanyTradeRegister_Lbl: Label 'Trade Register', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Registre du commerce"}]}';
        Discount_Lbl: Label 'Discount %', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"% Remise"}]}';
}