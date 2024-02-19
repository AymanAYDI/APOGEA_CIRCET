pageextension 50096 "CIR Get Shipment Lines" extends "Get Shipment Lines"
{
    layout
    {
        addafter("Qty. Shipped Not Invoiced")
        {
            field("Job No.42914"; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the related job.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le N° projet associé"}]}';
            }
            field("Shortcut Dimension 1 Code14720"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Axe 1"}]}';
            }
        }
        addafter("Document No.")
        {
            field("Order No.27929"; Rec."Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order No. ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du N° de commande"}]}';
            }
        }
    }
    actions
    {
        addafter("&Line")
        {
            action("Display Comment Lines")
            {
                Caption = 'Display Comment Lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Voir lignes commentaire de l''expédition"}]}';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = ShowSelected;
                ToolTip = 'Executes the Display Comment Lines ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Permet d''afficher les lignes de commentaire d''une expédition suivant la ligne sélectionnée"}]}';

                trigger OnAction()
                begin
                    TempSalesShipmentLine := Rec;
                    //Reset des filtres
                    Rec.SetRange("Bill-to Customer No.");
                    Rec.SetRange("Sell-to Customer No.");
                    Rec.SetRange("Qty. Shipped Not Invoiced");
                    Rec.SetRange("Currency Code");
                    Rec.SetRange("Authorized for Credit Card");

                    //Application du filtre sur le n° d'exp
                    Rec.SetRange("Document No.", TempSalesShipmentLine."Document No.");
                end;
            }
            action("Reset Filters")
            {
                Caption = 'Reset Filters', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Réinitialiser les fitres"}]}';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = ClearFilter;
                ToolTip = 'Executes the Reset Filters ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Réinitialise les filtres"}]}';

                trigger OnAction()
                begin
                    Rec.SetRange("Bill-to Customer No.", TempSalesShipmentLine."Bill-to Customer No.");
                    Rec.SetRange("Sell-to Customer No.", TempSalesShipmentLine."Sell-to Customer No.");
                    Rec.SetFilter("Qty. Shipped Not Invoiced", '<>0');
                    Rec.SetRange("Currency Code", TempSalesShipmentLine."Currency Code");
                    Rec.SetRange("Authorized for Credit Card", false);
                    Rec.SetRange("Document No.");
                end;
            }
        }
    }

    var
        TempSalesShipmentLine: Record "Sales Shipment Line" temporary;
}