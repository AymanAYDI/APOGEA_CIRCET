page 50024 "Modify Shipment Posted Sales"
{
    Caption = 'Modify Shipment information', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modification information expédition"}]}';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(Detail)
            {

                field("Number of packages"; "Number of packages")
                {
                    Caption = 'Number of packages', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nombre de colis" }]}';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Number of packages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du nombre de colis"}]}';
                }
                field("Total Weigth"; "Total Weight")
                {
                    ApplicationArea = All;
                    Caption = 'Total Weigth', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids total"}]}';
                    ToolTip = 'Specifies the value of the Total Weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du poids total"}]}';
                }
            }
        }
    }

    internal procedure SetData(piNumberOfPackages: Integer; piTotalWeight: Decimal)
    begin
        "Number of packages" := piNumberOfPackages;
        "Total Weight" := piTotalWeight;
    end;

    internal procedure GetData(var poNumberOfPackages: Integer; var poTotalWeight: Decimal)
    begin
        poNumberOfPackages := "Number of packages";
        poTotalWeight := "Total Weight";
    end;

    var
        "Number of packages": Integer;
        "Total Weight": decimal;
}