tableextension 50036 "CIR Assembly Line" extends "Assembly Line"
{
    fields
    {
        field(50000; "Unit Net Weight"; Decimal)
        {
            Caption = 'Unit Net Weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids net unitaires"}]}';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50001; "Weight of line"; Decimal)
        {
            Caption = 'Weight of line', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids de la ligne"}]}';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50002; "Qty Physical Stock"; Decimal)
        {
            Caption = 'Qty Physical Stock', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Quantité stock physique"}]}';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50003; "Substitutes Exist"; Boolean)
        {
            Caption = 'Substitutes Exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Substituable"}]}';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50004; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code catégorie article"}]}';
            FieldClass = FlowField;
            CalcFormula = Max(Item."Item Category Code" Where("No." = Field("No.")));
            Editable = false;
        }
        modify("Quantity per")
        {
            trigger OnAfterValidate()
            var
                AssemblyMgt: codeUnit "Assembly Mgt.";
            begin
                AssemblyMgt.SetLineFieldstInformation(Rec);
            end;
        }
    }

    procedure UpdateUnitCost()
    begin
        "Unit Cost" := GetUnitCost();
        "Cost Amount" := CalcCostAmount(Quantity, "Unit Cost");
        modify(true);
    end;
}