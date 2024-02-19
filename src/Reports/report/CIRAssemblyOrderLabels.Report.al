report 50030 "CIR Assembly Order Labels"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/AssemblyOrderLabels.rdl';
    Caption = 'Assembly Order Labels', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Étiquette d''ordre d''assemblage"}]}';
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(AssemblyHeader; "Assembly Header")
        {
            column(Picture; CompanyInformation.Picture)
            {
            }
            column(BusinessCode_Caption; BusinessCode_CaptionLbl)
            {
            }
            column(BusinessValue_AssemblyHeader; BusinessDimensionCode)
            {
            }
            column(BusinessName_Caption; BusinessName_CaptionLbl)
            {
            }
            column(BusinessValueName_AssemblyHeader; BusinessDimensionValueName)
            {
            }
            column(No_AssemblyHeader_Caption; AssemblyHeader.FieldCaption("No."))
            {
            }
            column(No_AssemblyHeader; AssemblyHeader."No.")
            {
            }
            column(Shipping_Caption; Shipping_CaptionLbl)   //Livraison
            {
            }
            column(ShiptoName_AssemblyHeader; AssemblyHeader."Ship-to Name")
            {
            }
            column(ShiptoName2_AssemblyHeader; AssemblyHeader."Ship-to Name 2")
            {
            }
            column(ShiptoAddress_AssemblyHeader; AssemblyHeader."Ship-to Address")
            {
            }
            column(ShiptoAddress2_AssemblyHeader; AssemblyHeader."Ship-to Address 2")
            {
            }
            column(ShiptoPostCode_AssemblyHeader; AssemblyHeader."Ship-to Post Code")
            {
            }
            column(ShiptoCity_AssemblyHeader; AssemblyHeader."Ship-to City")
            {
            }
            column(StartingDate_Caption; StartingDate_CaptionLbl)
            {
            }
            column(DueDate_AssemblyHeader; AssemblyHeader."Due Date")
            {
            }
            column(ShippingType_Caption; ShippingType_CaptionLbl)
            {
            }
            column(ShippingAgentCode_AssemblyHeader; AssemblyHeader."Shipping Agent Code")
            {
            }
            column(NumberOfPackages_AssemblyHeader_Caption; NumberPackageLbl)
            {
            }
            column(NumberOfPackages_AssemblyHeader; AssemblyHeader."Number of packages")
            {
            }
            column(TotalWeight_Caption; AssemblyHeader.FieldCaption("Total weight"))
            {
            }
            column(TotalWeight_AssemblyHeader; FORMAT(AssemblyHeader."Total weight", 0, PrecisionStandardFormatLbl))
            {
            }
            column(PostingDate_AssemblyHeader; AssemblyHeader."Posting Date")
            {
            }

            trigger OnAfterGetRecord()
            var
                DimensionSetEntry: Record "Dimension Set Entry";
            begin
                BusinessDimensionCode := '';
                BusinessDimensionValueName := '';
                if GeneralApplicationSetup."Business Dimension Code" <> '' then
                    if DimensionSetEntry.Get(AssemblyHeader."Dimension Set ID", GeneralApplicationSetup."Business Dimension Code") then begin
                        BusinessDimensionCode := DimensionSetEntry."Dimension Value Code";
                        DimensionSetEntry.CalcFields("Dimension Value Name");
                        BusinessDimensionValueName := DimensionSetEntry."Dimension Value Name";
                    end;
            end;
        }
    }
    trigger OnInitReport()
    begin
        CompanyInformation.GET();
        GeneralApplicationSetup.Get();
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        GeneralApplicationSetup: Record "General Application Setup";
        BusinessDimensionCode: Code[20];
        BusinessDimensionValueName: Text[50];
        PrecisionStandardFormatLbl: Label '<Precision,2:2><Standard Format,0>', Locked = true;
        BusinessCode_CaptionLbl: Label 'Business Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code affaire"}]}';
        BusinessName_CaptionLbl: Label 'Business Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom affaire"}]}';
        Shipping_CaptionLbl: Label 'Shipping', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Livraison"}]}';
        StartingDate_CaptionLbl: Label 'Starting Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de départ"}]}';
        ShippingType_CaptionLbl: Label 'Shipping Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type d''expédition"}]}';
        NumberPackageLbl: Label 'Package Number', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Numéro de colis"}]}';
}