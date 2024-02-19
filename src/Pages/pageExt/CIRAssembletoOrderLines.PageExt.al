pageextension 50058 "CIR Assemble-to-Order Lines" extends "Assemble-to-Order Lines"
{
    layout
    {
        modify("Consumed Quantity")
        {
            Visible = true;
        }
        modify("Qty. per Unit of Measure")
        {
            Visible = true;
        }
        addafter("Reserved Quantity")
        {
            field("Remaining Quantity"; Rec."Remaining Quantity")
            {
                ToolTip = 'Remaining Quantity', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Quantité restante"}]}';
                ApplicationArea = All;
            }
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
}