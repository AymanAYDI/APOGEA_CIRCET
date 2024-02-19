page 53000 "Fix : reservation"
{
    ApplicationArea = All;
    Caption = 'Fix : reservation';
    PageType = List;
    SourceTable = "Reservation Entry";
    UsageCategory = Administration;
    Permissions = TableData "Reservation Entry" = rimd;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                }
                field("Reservation Status"; Rec."Reservation Status")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Transferred from Entry No."; Rec."Transferred from Entry No.")
                {
                }
                field("Source Type"; Rec."Source Type")
                {
                }
                field("Source Subtype"; Rec."Source Subtype")
                {
                }
                field("Source ID"; Rec."Source ID")
                {
                }
                field("Source Batch Name"; Rec."Source Batch Name")
                {
                }
                field("Source Prod. Order Line"; Rec."Source Prod. Order Line")
                {
                }
                field("Source Ref. No."; Rec."Source Ref. No.")
                {
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                }
                field("Serial No."; Rec."Serial No.")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Changed By"; Rec."Changed By")
                {
                }
                field(Positive; Rec.Positive)
                {
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Action Message Adjustment"; Rec."Action Message Adjustment")
                {
                }
                field(Binding; Rec.Binding)
                {
                }
                field("Suppressed Action Msg."; Rec."Suppressed Action Msg.")
                {
                }
                field("Planning Flexibility"; Rec."Planning Flexibility")
                {
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                }
                field("Warranty Date"; Rec."Warranty Date")
                {
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                }
                field("Qty. to Handle (Base)"; Rec."Qty. to Handle (Base)")
                {
                }
                field("Qty. to Invoice (Base)"; Rec."Qty. to Invoice (Base)")
                {
                }
                field("Quantity Invoiced (Base)"; Rec."Quantity Invoiced (Base)")
                {
                }
                field("New Serial No."; Rec."New Serial No.")
                {
                }
                field("New Lot No."; Rec."New Lot No.")
                {
                }
                field("Disallow Cancellation"; Rec."Disallow Cancellation")
                {
                }
                field("Lot No."; Rec."Lot No.")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                }
                field("Appl.-from Item Entry"; Rec."Appl.-from Item Entry")
                {
                }
                field(Correction; Rec.Correction)
                {
                }
                field("New Expiration Date"; Rec."New Expiration Date")
                {
                }
                field("Item Tracking"; Rec."Item Tracking")
                {
                }
                field("Untracked Surplus"; Rec."Untracked Surplus")
                {
                }
                field("Package No."; Rec."Package No.")
                {
                }
                field("New Package No."; Rec."New Package No.")
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                }
                field(SystemId; Rec.SystemId)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                }
            }
        }
    }
}