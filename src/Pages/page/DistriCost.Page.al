page 50013 "Distri. Cost"
{
    Caption = 'Distribute the cost of subcontracting', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Répartir le coût de la sous-traitance"}]}';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Distribution Subcontracting";

    layout
    {
        area(Content)
        {
            group(Subcontracting)
            {
                Caption = 'Subcontracting', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Sous-traitance"}]}';
                field(AmountToDistributed; Rec."Amount To Distributed")
                {
                    ToolTip = 'Specifies the amount to distribute', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le montant à répartir"}]}';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Init();
        Rec.Insert();
    end;
}