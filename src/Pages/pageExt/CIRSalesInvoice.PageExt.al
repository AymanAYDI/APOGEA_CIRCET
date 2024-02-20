pageextension 50016 "CIR Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Breakdown Invoice No."; Rec."Breakdown Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Breakdown Invoice No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° facture ventilée" }, { "lang": "FRB", "txt": "N° facture ventilée" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }

            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
        }
        addafter("Prices Including VAT")
        {
            field("CIR Customer Posting Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Posting Group ';
            }
        }

        moveafter(ARBVRNJobNo; "Sell-to Customer No.")
        moveafter("Sell-to Customer No."; ARBVRNJobNo)

        modify("Sell-to Customer No.")
        {
            Importance = Promoted;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
    }
}