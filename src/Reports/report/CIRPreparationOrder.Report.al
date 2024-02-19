report 50015 "CIR Preparation Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRPreparationOrder.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Preparation order', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ordre de préparation"}]}';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(AssemblyHeader; "Assembly Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.", "Item No.", "Due Date";
            column(No_AssemblyHeader; "No.")
            {
            }
            column(ItemNo_AssemblyHeader; "Item No.")
            {
                IncludeCaption = true;
            }
            column(Description_AssemblyHeader; Description)
            {
                IncludeCaption = true;
            }
            column(Quantity_AssemblyHeader; Quantity)
            {
                IncludeCaption = true;
            }
            column(QuantityToAssemble_AssemblyHeader; "Quantity to Assemble")
            {
                IncludeCaption = true;
            }
            column(UnitOfMeasureCode_AssemblyHeader; "Unit of Measure Code")
            {
            }
            column(DueDate_AssemblyHeader; FORMAT("Due Date"))
            {
            }
            column(StartingDate_AssemblyHeader; FORMAT("Starting Date"))
            {
            }
            column(EndingDate_AssemblyHeader; FORMAT("Ending Date"))
            {
            }
            column(LocationCode_AssemblyHeader; "Location Code")
            {
                IncludeCaption = true;
            }
            column(BinCode_AssemblyHeader; "Bin Code")
            {
                IncludeCaption = true;
            }
            column(SalesDocNo; SalesDocNo)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(Affaire_AssemblyHeader; AssemblyHeader.Business)
            {
            }
            column(NomAffaire_AssemblyHeader; AssemblyHeader."Business name")
            {
            }
            column(ShipToName_AssemblyHeader; AssemblyHeader."Ship-to Name")
            {
            }
            column(TotalWeight_AssemblyHeader; AssemblyHeader."Total weight")
            {
                DecimalPlaces = 0 : 3;
            }
            column(Picture; CompanyInformation.Picture)
            {
            }
            column(ShippingAgent_AssemblyHeader; AssemblyHeader."Shipping Agent Code")
            {
            }
            dataitem(AssemblyLine; "Assembly Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = Field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(Type_AssemblyLine; Type)
                {
                    IncludeCaption = true;
                }
                column(ItemCategoryCode_AssemblyLine; "Item Category Code")
                {
                }
                column(No_AssemblyLine; "No.")
                {
                    IncludeCaption = true;
                }
                column(Description_AssemblyLine; Description)
                {
                    IncludeCaption = true;
                }
                column(Description2_AssemblyLine; "Description 2")
                {
                }
                column(VariantCode_AssemblyLine; "Variant Code")
                {
                }
                column(DueDate_AssemblyLine; FORMAT("Due Date"))
                {
                }
                column(QuantityPer_AssemblyLine; "Quantity per")
                {
                    IncludeCaption = true;
                }
                column(Quantity_AssemblyLine; Quantity)
                {
                    IncludeCaption = true;
                }
                column(UnitOfMeasureCode_AssemblyLine; "Unit of Measure Code")
                {
                }
                column(LocationCode_AssemblyLine; "Location Code")
                {
                    IncludeCaption = true;
                }
                column(BinCode_AssemblyLine; "Bin Code")
                {
                    IncludeCaption = true;
                }
                column(QuantityToConsume_AssemblyLine; "Quantity to Consume")
                {
                    IncludeCaption = true;
                }
                column(WeightLine; Weight)
                {
                }
                column(BinCode_WarehouseActivityLine; BinCode)
                {
                }

                trigger OnAfterGetRecord()
                var
                    BinContent: record "Bin Content";
                begin
                    if Item.Get("No.") then
                        Weight := Weight + (Quantity * Item."Net Weight");

                    BinCode := '';
                    BinContent.SetRange("Item No.", "No.");
                    BinContent.SetRange(Default, true);
                    If BinContent.FindFirst() then
                        if BinContent."Bin Code" <> '' then
                            BinCode := BinContent."Bin Code";
                end;
            }

            trigger OnAfterGetRecord()
            var
                AssembletoOrderLink: Record "Assemble-to-Order Link";
            begin
                Clear(SalesDocNo);
                if AssembletoOrderLink.Get("Document Type", "No.") then
                    SalesDocNo := AssembletoOrderLink."Document No.";
                Weight := 0;
            end;
        }
    }

    trigger OnInitReport()
    begin
        CompanyInformation.GET();
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        Item: Record Item;
        CompanyInformation: Record "Company Information";
        SalesDocNo: Code[20];
        BinCode: Code[100];
        Weight: Decimal;
}