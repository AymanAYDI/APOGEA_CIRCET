reportextension 50002 "CIR Standard Sales - Shipment" extends "Standard Sales - Shipment"
{
    dataset
    {
        add(Header)
        {
            column(Ship_to_Address_Lbl; ShipToAddressLbl) { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Total_weight_Lbl; TotalWeightLbl) { }
            column(Total_weight; Header."Total weight") { }
            column(Number_of_packages_Lbl; NumberOfPackagesLbl) { }
            column(Number_of_packages; Header."Number of packages") { }
            column(CompanyRegistrationNo_Lbl; CompanyRegistrationNoLbl) { }
            column(CompanyRegistrationNo; CompanyInfoSup."Registration No.") { }
            column(CompanyAgencyCode_Lbl; CompanyAgencyCodeLbl) { }
            column(CompanyAgencyCode; CompanyInfoSup."CIR Agency Code") { }
            column(CompanyRibKey_Lbl; CompanyInfoRibKeyLbl) { }
            column(CompanyRibKey; CompanyInfoRibKey) { }
            column(CompanyAPECode_Lbl; CompanyAPECodeLbl) { }
            column(CompanyAPECode; CompanyInfoSup."APE Code") { }
            column(CompanyCapital_Lbl; CompanyCapitalLbl) { }
            column(CompanyCapital; CompanyInfoSup."Stock Capital") { }
            column(CompanyTradeRegister; CompanyInfoSup."Trade Register") { }
            column(CompanyLegalForm; CompanyInfoSup."Legal Form") { }
            column(CompanyTradeRegister_Lbl; CompanyTradeRegisterLbl) { }
            column(CompanyLegalForm_Lbl; CompanyLegalFormLbl) { }
            column(SiteCodeLbl; SiteCodeLbl) { }
            column(SiteCode; "Site Code") { }
            column(BusinessCodeLbl; BusinessCodeLbl) { }
            column(BusinessCode; "Business Code") { }
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
        ShipToAddressLbl: Label 'Ship-to Address', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse de livraison"}]}';
        TotalWeightLbl: Label 'Total weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids total"}]}';
        NumberOfPackagesLbl: Label 'Number of packages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de colis"}]}';
        CompanyAgencyCodeLbl: Label 'Agency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code guichet"}]}';
        CompanyInfoRibKeyLbl: Label 'RIB Key', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Clé banque"}]}';
        CompanyAPECodeLbl: Label 'APE Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code APE"}]}';
        CompanyCapitalLbl: Label 'Capital', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Capital social"}]}';
        CompanyRegistrationNoLbl: Label 'Registration No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° SIRET"}]}';
        CompanyTradeRegisterLbl: Label 'Trade Register', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Registre du commerce"}]}';
        CompanyLegalFormLbl: Label 'Legal Form', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Forme juridique"}]}';
        SiteCodeLbl: Label 'Site Code :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code site"}]}';
        BusinessCodeLbl: Label 'Business Code :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code affaire"}]}';
}