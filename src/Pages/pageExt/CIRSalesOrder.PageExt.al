pageextension 50010 "CIR Sales Order" extends "Sales Order"
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
        movebefore("Sell-to Customer No."; ARBVRNJobNo)
        addafter(WorkDescription)
        {
            field("ShorCut Dimension 3 Code"; ShorCutDimension3Code)
            {
                ApplicationArea = All;
                Caption = 'ShorCut Dimension 3 Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code section axe 3" } ] }';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
                CaptionClass = '1,2,3';
                ToolTip = 'Specifies the value of the ShorCut Dimension 3 Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code section axe 3" } ] }';
                Editable = false;
            }
        }
        addafter("Your Reference")
        {
            field("Site Code"; Rec."Site Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Site Code field', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du champ code site"}]}';
            }
        }
        modify("Sell-to Customer No.")
        {
            Editable = (NOT SellToCustomerNOEditable) OR (Rec.ARBVRNJobNo = '');
        }
        modify("Sell-to Customer Name")
        {
            Editable = (NOT SellToCustomerNOEditable) OR (Rec.ARBVRNJobNo = '');
        }
        modify("Exit Point")
        {
            Caption = 'Exit Point', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Pays origine"}]}';
        }
    }
    trigger OnOpenPage()
    begin
        GeneralLedgerSetup.GET();
        IF GeneralApplicationSetup.GET() THEN
            SellToCustomerNOEditable := GeneralApplicationSetup."Blocked Custo. Sales Order";
    end;

    trigger OnAfterGetRecord()
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        if DimensionSetEntry.Get(Rec."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 3 Code") then
            ShorCutDimension3Code := DimensionSetEntry."Dimension Value Code"
        else
            ShorCutDimension3Code := '';
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GeneralApplicationSetup: Record "General Application Setup";
        SellToCustomerNOEditable: Boolean;
        ShorCutDimension3Code: Code[20];
}