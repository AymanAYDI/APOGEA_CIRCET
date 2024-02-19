pageextension 50038 "CIRPurchaseOrderSubform" extends "Purchase Order Subform"
{
    layout
    {
        addafter("Bin Code")
        {
            field("Accrue"; Rec.Accrue)
            {
                ApplicationArea = ALL;
                ToolTip = 'Specifies the value of the Accrue', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"FNP"}]}';
            }
        }
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ToolTip = 'Specifies the value of the Description 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Description 2"}]}';
                ApplicationArea = All;
                Width = 14;
            }
            field(Site; Rec.Site)
            {
                Visible = true;
                ApplicationArea = All;
                Width = 20;
                ToolTip = 'Specifies the value of the Site ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site" }, { "lang": "FRB", "txt": "Site" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
            field("Vendor Item No."; Rec."Vendor Item No.")
            {
                ToolTip = 'Specifies the value of the Vendor Item No.';
                ApplicationArea = All;
                Visible = true;
                Width = 10;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                ToolTip = 'Specifies the value of the Outstanding Quantity', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Quantité restante"}]}';
                Width = 10;
                ApplicationArea = All;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("Line Weight"; Rec."Line Weight")
            {
                ToolTip = 'Line Weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids ligne"}]}';
                ApplicationArea = All;
                Width = 10;
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ToolTip = 'Net Weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids net"}]}';
                ApplicationArea = All;
                Width = 10;
            }
        }
        addafter("Direct Unit Cost")
        {
            field("Line Discount %49281"; Rec."Line Discount %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line Discount % ';
            }
        }

        moveafter("Direct Unit Cost"; "Line Discount %")
        moveafter("Tax Area Code"; "Qty. to Assign")
        moveafter("Qty. to Assign"; "Qty. Assigned")
        moveafter(ARBVRNJobUnitNo; "Tax Area Code")
        moveafter(ARBVRNJobUnitNo; "Tax Group Code")
        moveafter(ARBVRNJobUnitNo; "Reserved Quantity")
        moveafter("Qty. to Invoice"; "Qty. Assigned")
        moveafter("Qty. Assigned"; "Quantity Received")
        moveafter("Direct Unit Cost"; "Line Amount")
        moveafter("Description 2"; "Job No.")
        moveafter("Qty. to Receive"; "Quantity Received")
        moveafter("Qty. to Invoice"; "Quantity Invoiced")
        moveafter("Expected Receipt Date"; ShortcutDimCode4)
        moveafter("Qty. to Invoice"; "Qty. to Assign")
        modify("Qty. to Assign")
        {
            Width = 4;
        }
        modify("Qty. Assigned")
        {
            Width = 5;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }

        modify("Line Discount %")
        {
            Width = 9;
        }
        modify(Description)
        {
            Editable = IsFAEditable;
            Width = 22;
        }
        modify("Location Code")
        {
            Width = 5;
        }
        modify(Type)
        {
            Width = 4;
        }
        modify(Quantity)
        {
            Width = 9;
        }
        modify("Reserved Quantity")
        {
            QuickEntry = false;
        }
        modify("Unit of Measure Code")
        {
            Width = 5;
        }
        modify("Direct Unit Cost")
        {
            Width = 8;
        }
        modify("Qty. to Receive")
        {
            Width = 8;
        }
        modify("Quantity Received")
        {
            Width = 8;
        }
        modify("Qty. to Invoice")
        {
            Width = 7;
        }
        modify("Quantity Invoiced")
        {
            Width = 9;
        }
        modify("Line Amount")
        {
            Editable = false;
        }
        modify(ShortcutDimCode4)
        {
            Editable = IsFAEditable;
        }
        modify("Job No.")
        {
            Editable = IsFAEditable;
        }
    }

    trigger OnAfterGetRecord()
    begin
        CASE Type of
            rec.Type::"Fixed Asset":
                IsFAEditable := false;
            ELSE
                IsFAEditable := true;
        END;
    end;

    var
        IsFAEditable: Boolean;
}