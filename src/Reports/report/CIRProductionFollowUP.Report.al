report 50016 "CIR Production Follow UP"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRProductionFollowUP.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Production follow-up', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Suivi de production"}]}';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(ProductionOrder; "Production Order")
        {
            column(No_ProductionOrder; "No.")
            {
            }
            column(SourceNo_ProductionOrder; "Source No.")
            {
            }
            column(Quantity_ProductionOrder; Quantity)
            {
            }
            column(DimensionValueCode_ProductionOrder; DimensionValueCode)
            {
            }
            column(DimensionValueName_ProductionOrder; DimensionValueName)
            {
            }
            column(Picture; CompanyInformation.Picture)
            {
            }
            column(DueDate_ProductionOrder; Format("Due Date", 0, '<Closing><Day,2>/<Month,2>/<Year>'))
            {
            }
            column(PublishingDate; Format(Today, 0, '<Closing><Day,2>/<Month,2>/<Year>'))
            {
            }
            dataitem(ProdOrderLine; "Prod. Order Line")
            {
                DataItemLink = "Prod. Order No." = field("No.");
                DataItemTableView = sorting("Item No.");
                dataitem(ProdOrderRoutingLine; "Prod. Order Routing Line")
                {
                    DataItemLink = "Prod. Order No." = field("Prod. Order No."), "Routing Reference No." = field("Routing Reference No."), "Routing No." = field("Routing No.");
                    DataItemTableView = sorting("Routing No.");
                    column(No_ProdOrderRoutingLine; "No.")
                    {
                    }
                    column(Description_ProdOrderRoutingLine; Description)
                    {
                    }
                }
                dataitem(ProdOrderComponent; "Prod. Order Component")
                {
                    DataItemLink = "Prod. Order No." = field("Prod. Order No.");
                    DataItemTableView = Sorting("Prod. Order Line No.");
                    column(ItemNo_ProdOrderComponent; "Item No.")
                    {
                    }
                    column(ProdOrderLineNo_ProdOrderComponent; "Prod. Order Line No.")
                    {
                    }
                    column(Description_ProdOrderComponent; Description)
                    {
                    }
                    column(Quantity_ProdOrderComponent; "Expected Quantity")
                    {
                    }
                    column(BinCode_ProdOrderComponent; "Bin Code")
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            var
                DimensionSetEntry: Record "Dimension Set Entry";
            begin
                DimensionSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");
                if DimensionSetEntry.FindFirst() then begin
                    DimensionValueCode := DimensionSetEntry."Dimension Value Code";
                    DimensionSetEntry.CalcFields("Dimension Value Name");
                    DimensionValueName := DimensionSetEntry."Dimension Value Name";
                end;
            end;

            trigger OnPostDataItem()
            begin
                Codeunit.Run(Codeunit::"Production Order Printed", ProductionOrder);
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
        CompanyInformation: Record "Company Information";

        DimensionValueCode: code[20];
        DimensionValueName: Text[50];
}