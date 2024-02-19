reportextension 50001 "CIR Std. Sales - Credit Memo" extends "Standard Sales - Credit Memo"
{
    dataset
    {
        add(Header)
        {
            column(CustRegistrationNo; Header."VAT Registration No.") { }
            column(CompanyRegistrationNo; CompanyInfoSup."Registration No.") { }
            column(CompanyRegistrationNo_Lbl; CompanyRegistrationNoLbl) { }
            column(CompanyAgencyCode; CompanyInfoSup."CIR Agency Code") { }
            column(CompanyAgencyCode_Lbl; CompanyAgencyCodeLbl) { }
            column(CompanyRibKey; CompanyInfoRibKey) { }
            column(CompanyRibKey_Lbl; CompanyInfoRibKeyLbl) { }
            column(CompanyAPECode; CompanyInfoSup."APE Code") { }
            column(CompanyAPECode_Lbl; CompanyAPECodeLbl) { }
            column(CompanyCapital; CompanyInfoSup."Stock Capital") { }
            column(CompanyCapital_Lbl; CompanyCapitalLbl) { }
            column(ARBVRNJobNo_Header; ARBVRNJobNo) { }
            column(ARBVRNJobNo_Header_Lbl; FieldCaption(ARBVRNJobNo)) { }
            column(CompanyTradeRegister_Lbl; CompanyTradeRegisterLbl) { }
            column(CompanyTradeRegister; CompanyInfoSup."Trade Register") { }
            column(CompanyLegalForm; CompanyInfoSup."Legal Form") { }
            column(CompanyLegalForm_Lbl; CompanyLegalFormLbl) { }
        }
        add(Line)
        {
            column(LineControlStationRef; Line."Control Station Ref.") { }
            column(LineARBVRNVeronaJobNo; Line.ARBVRNVeronaJobNo) { }
            column(LineJobNo; Line."Job No.") { }
            column(JobLineNo_Lbl; JobLineNo_Lbl) { }
            column(Description2_Line; "Description 2") { }
            column(Description2_Line_Lbl; FieldCaption("Description 2")) { }
            column(CIR_AmountExcludingVAT_Line; ReportMgt.BlankZero(Amount))
            {
                AutoFormatExpression = GetCurrencyCode();
                AutoFormatType = 1;
            }
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
        ReportMgt: Codeunit "Report Mgt.";
        CompanyInfoRibKey: Text;
        JobLineNo_Lbl: Label 'Job Line No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° projet ligne"}]}';
        CompanyTradeRegisterLbl: Label 'Trade Register', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Registre du commerce"}]}';
        CompanyLegalFormLbl: Label 'Legal Form', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Forme juridique"}]}';
        CompanyInfoRibKeyLbl: Label 'RIB Key', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Clé banque"}]}';
        CompanyAgencyCodeLbl: Label 'Agency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code guichet"}]}';
        CompanyAPECodeLbl: Label 'APE Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code APE"}]}';
        CompanyCapitalLbl: Label 'Capital', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Capital social"}]}';
        CompanyRegistrationNoLbl: Label 'Registration No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° SIRET"}]}';
}