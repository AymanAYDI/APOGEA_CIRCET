pageextension 50007 "CIR Purchase Order" extends "Purchase Order"
{
    layout
    {
        addbefore("Invoice Details")
        {
            group(Buyer)
            {
                Caption = 'Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Approvisionneur" }, { "lang": "FRB", "txt": "Approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';

                field("Name Buyer"; Rec."Name Buyer")
                {
                    ToolTip = 'Specifies the value of the Name Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom approvisionneur" }, { "lang": "FRB", "txt": "Nom approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                }
                field("Tel. Buyer"; Rec."Tel. Buyer")
                {
                    ToolTip = 'Specifies the value of the Tel. Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Tél. approvisionneur" }, { "lang": "FRB", "txt": "Tél. approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                }
                field("Fax Buyer"; Rec."Fax Buyer")
                {
                    ToolTip = 'Specifies the value of the Fax Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Fax approvisionneur" }, { "lang": "FRB", "txt": "Fax approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                }
                field("E-mail Buyer"; Rec."E-mail Buyer")
                {
                    ToolTip = 'Specifies the value of the E-mail Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Mail approvisionneur" }, { "lang": "FRB", "txt": "Mail approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                }
                field("E-mail Service Buyer"; Rec."E-mail Service Buyer")
                {
                    ToolTip = 'Specifies the value of the E-mail Service Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Mail Service approvisionneur" }, { "lang": "FRB", "txt": "Mail Service approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                }
            }
        }
        addbefore("VAT Bus. Posting Group")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Groupe compta. marché"}]}';
            }
        }
        addafter("Posting Date")
        {
            field("Requested Receipt Date83768"; Rec."Requested Receipt Date")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the value of the Requested Receipt Date ';
            }
            field(Description; Description)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désignation"}]}';
            }
        }
        addafter("Inbound Whse. Handling Time")
        {
            field(SystemCreatedAt46563; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies the value of the SystemCreatedAt ';
            }
            field(SystemCreatedBy04895; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies the value of the SystemCreatedBy ';
            }
            field(SystemModifiedAt59732; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies the value of the SystemModifiedAt ';
            }
            field(SystemModifiedBy29304; Rec.SystemModifiedBy)
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies the value of the SystemModifiedBy ';
            }
        }

        movefirst("Buy-from"; ARBVRNJobNo)
        movebefore("Name Buyer"; "Purchaser Code")
        movebefore("Due Date"; "Requested Receipt Date")
        movebefore("Due Date"; "Order Address Code")
        moveafter("Document Date"; "Order Date")
        moveafter("Creditor No."; "Prices Including VAT")
        moveafter("Prices Including VAT"; "Tax Area Code")
        moveafter("Prices Including VAT"; "On Hold")
        moveafter("On Hold"; "Tax Liable")
        movefirst("Buy-from"; "Buy-from Vendor No.")
        moveafter("Buy-from Vendor No."; "Buy-from Vendor Name")
        moveafter("E-mail Service Buyer"; "Quote No.")
        moveafter("Quote No."; "Vendor Order No.")
        moveafter("Vendor Order No."; "Vendor Invoice No.")
        moveafter("Vendor Invoice No."; "Vendor Shipment No.")
        moveafter("Buy-from Contact No."; "Buy-from Contact")
        moveafter(BuyFromContactMobilePhoneNo; "Order Address Code")
        moveafter(BuyFromContactMobilePhoneNo; BuyFromContactEmail)
        moveafter("Buy-from"; Status)
        moveafter("Vendor Shipment No."; "Responsibility Center")
        moveafter("Due Date"; ShippingOptionWithLocation)
        moveafter(ShippingOptionWithLocation; "Ship-to Code")
        moveafter(ShippingOptionWithLocation; "Ship-to Name")
        moveafter("Ship-to Name"; "Ship-to Address")
        moveafter("Ship-to Address"; "Ship-to Address 2")
        moveafter("Ship-to Address 2"; "Ship-to City")
        moveafter("Ship-to Address 2"; "Ship-to Post Code")
        moveafter("Ship-to City"; "Ship-to Country/Region Code")
        moveafter("Ship-to Country/Region Code"; "Ship-to Contact")
        movefirst(Control99; "Requested Receipt Date")
        moveafter("Requested Receipt Date"; "Expected Receipt Date")
        moveafter("Expected Receipt Date"; "Promised Receipt Date")
        movefirst("Foreign Trade"; "Currency Code")
        moveafter(PayToOptions; "Payment Terms Code")
        moveafter("Payment Terms Code"; "Payment Method Code")
        moveafter("Promised Receipt Date"; "Shipment Method Code")
        moveafter("Payment Method Code"; "Payment Reference")
        moveafter("Payment Reference"; "Payment Discount %")
        moveafter("Tax Area Code"; "Inbound Whse. Handling Time")
        moveafter("Tax Area Code"; "Lead Time Calculation")
        moveafter("Payment Reference"; "Pmt. Discount Date")
        moveafter("Posting Date"; "Requested Receipt Date")
        moveafter("Payment Method Code"; "On Hold")
        moveafter(ShippingOptionWithLocation; "Location Code")

        addafter("Ship-to Code")
        {
            field("Direct Customer Payment65723"; Rec."Direct Customer Payment")
            {
                ApplicationArea = ALL;
                Visible = true;
                Importance = Standard;
                ToolTip = 'Specifies the value of the Direct Customer Payment', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Paiement direct client"}]}';
            }
        }

        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Importance = Additional;
        }
        modify("Prices Including VAT")
        {
            Importance = Additional;
        }
        modify("Payment Reference")
        {
            Importance = Additional;
        }
        modify("Payment Discount %")
        {
            Importance = Additional;
        }
        modify("Purchaser Code")
        {
            Importance = Promoted;
        }
        modify(Status)
        {
            Importance = Standard;
        }
        modify(ARBVRNGuaranteeTaxCode)
        {
            Visible = false;
        }
        modify(ARBVRNIncomeTaxwithholdingCode)
        {
            Visible = false;
        }
        modify("No. of Archived Versions")
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {
            Importance = Standard;
        }
        modify("Ship-to Name")
        {
            Importance = Standard;
        }
        modify("Posting Date")
        {
            Importance = Standard;
        }
        modify("Buy-from Vendor No.")
        {
            Importance = Standard;
        }
        modify(ARBVRNJobNo)
        {
            Importance = Promoted;
        }
        modify("Vendor Order No.")
        {
            Importance = Standard;
        }
        modify("Requested Receipt Date")
        {
            Importance = Standard;
            Visible = false;
        }
        modify("Document Date")
        {
            Importance = Promoted;
        }
    }
    actions
    {
        addafter(CopyDocument)
        {
            action(Subcontracting)
            {
                Caption = 'Distribute the cost of subcontracting', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Répartir le coût de la sous-traitance"}]}';
                ToolTip = 'Distribute the cost of subcontracting', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Répartir le coût de la sous-traitance"}]}';
                ApplicationArea = all;
                Image = SuggestItemCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    DistributionSubcontracting: Record "Distribution Subcontracting";
                    CompanyInformation: Record "Company Information";
                    DistriCostMgt: Codeunit "Distri. Cost Mgt.";
                    DistriCost: Page "Distri. Cost";
                    ErrorNotSubContractingOrderLbl: Label 'Processing impossible! This is not a subcontract order.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Traitement impossible! Il ne s''agit pas d''une commande de sous-traitance."}]}';
                begin
                    if not DistriCostMgt.CheckIsSubContractingOrder(Rec) then
                        Error(ErrorNotSubContractingOrderLbl);
                    CompanyInformation.Get();
                    if not CompanyInformation."Manufacturing Mgt." then
                        Error(NotManufactCompanyLbl);
                    Clear(DistriCost);
                    DistriCost.SetTableView(DistributionSubcontracting);
                    DistriCost.SetRecord(DistributionSubcontracting);
                    DistriCost.LookupMode := true;
                    if DistriCost.RunModal() = Action::LookupOK then begin
                        DistriCost.GetRecord(DistributionSubcontracting);
                        if DistributionSubcontracting."Amount To Distributed" = 0 then
                            Error(NotAmountLbl)
                        else
                            DistriCostMgt.SetCalculDistriSubContracting(Rec, DistributionSubcontracting."Amount To Distributed");
                    end;
                end;
            }
        }
        modify("Post")
        {
            Enabled = EnabledPost;
        }
        modify("Post and &Print")
        {
            Enabled = EnabledPost;
        }
        modify("Post &Batch")
        {
            Enabled = EnabledPost;
        }
        modify(PostAndNew)
        {
            Enabled = EnabledPost;
        }
    }

    trigger OnOpenPage()
    var
        SalespersonPurchaserInformationsEmpty_Err: Label 'You must specify your Phone, Fax and Mail in your buyer preferences to access the purchase orders.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez spécifier votre N° de téléphone, votre n° fax et votre E-mail au niveau de vos préférences approvisionneur pour accéder aux commandes achats."}]}';
    begin
        if UserSetup.Get(UserId()) then
            if not SalespersonPurchaser.SalespersonPurchaserIsPurchaser(UserSetup.ARBVRNRelatedResourceNo) then
                CurrPage.Editable := false
            else begin
                if SalespersonPurchaser.Get(UserSetup.ARBVRNRelatedResourceNo) then;
                If (SalespersonPurchaser."E-Mail" = '') or (SalespersonPurchaser."Phone No." = '') or (SalespersonPurchaser."Fax No." = '') then
                    Error(SalespersonPurchaserInformationsEmpty_Err);
            end;

        EnabledPost := CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Invoice Purchase Rights"))
    end;

    var
        UserSetup: Record "User Setup";
        UserGroup: Record "User Group";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        CIRUserManagement: Codeunit "CIR User Management";
        EnabledPost: Boolean;
        NotAmountLbl: Label 'Please enter an amount to distribute', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Veuillez renseigner un montant à répartir"}]}';
        NotManufactCompanyLbl: Label 'This is a feature dedicated to the production company', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ceci est une fonctionnalité dédiée aux sociétés de production"}]}';
}