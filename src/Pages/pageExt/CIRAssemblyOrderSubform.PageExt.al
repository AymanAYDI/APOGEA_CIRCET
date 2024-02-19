pageextension 50059 "CIR Assembly Order Subform" extends "Assembly Order Subform"
{
    layout
    {
        addafter("Reserved Quantity")
        {
            field("Unit Net Weight"; Rec."Unit Net Weight")
            {
                ToolTip = 'Unit Net Weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids net unitaires"}]}';
                ApplicationArea = ALL;
            }
            field("Weight of line"; Rec."Weight of line")
            {
                ToolTip = 'Weight of line', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids de la ligne"}]}';
                ApplicationArea = ALL;
            }
            field("Qty Physical Stock"; Rec."Qty Physical Stock")
            {
                ToolTip = 'Qty Physical Stock', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Quantité stock physique"}]}';
                ApplicationArea = ALL;
            }
            field("Substitutes Exist"; Rec."Substitutes Exist")
            {
                ToolTip = 'Substitutes Exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Substituable"}]}';
                ApplicationArea = ALL;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        AssemblyMgt: codeUnit "Assembly Mgt.";
    begin
        AssemblyMgt.SetLineFieldstInformation(Rec);
    end;

}