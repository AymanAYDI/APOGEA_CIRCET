tableextension 50005 "CIR Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(50001; "Name Buyer"; Text[50])
        {
            Caption = 'Name Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom approvisionneur" }, { "lang": "FRB", "txt": "Nom approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Purchaser Code")));
            Editable = false;
        }
        field(50002; "Tel. Buyer"; Text[30])
        {
            Caption = 'Tel. Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Tél. approvisionneur" }, { "lang": "FRB", "txt": "Tél. approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50003; "Fax Buyer"; Text[30])
        {
            Caption = 'Fax Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Fax approvisionneur" }, { "lang": "FRB", "txt": "Fax approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50004; "E-mail Buyer"; Text[80])
        {
            Caption = 'E-mail Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Mail approvisionneur" }, { "lang": "FRB", "txt": "Mail approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50005; "E-mail Service Buyer"; Text[80])
        {
            Caption = 'E-mail Service Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Mail Service approvisionneur" }, { "lang": "FRB", "txt": "Mail Service approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50010; "Direct Customer Payment"; Boolean)
        {
            Caption = 'Direct Customer Payment', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Paiement direct client"}]}';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                PurchaseMgmt: Codeunit "Purchase Mgmt";
                ExistReceptLineOnPurchaseErr: Label 'You are not authorized to change Direct Customer Payment because recept line exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''êtes pas autorisé à changer la valeur car il existe des lignes réceptionnées."}]}';
            begin
                // Il ne doit pas être possible d'activer l'indicateur "Paiement direct client" sur une commande réceptionnée partiellement ou complètement
                IF PurchaseMgmt.ExistReceptLine(rec) THEN
                    Error(ExistReceptLineOnPurchaseErr);

                IF xRec."Direct Customer Payment" <> "Direct Customer Payment" THEN
                    PurchaseMgmt.UpdateDirectCustPayment(rec);
            end;
        }
        field(50020; Approved; Boolean)
        {
            Caption = 'Approved', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Approuvé"}]}';
            DataClassification = CustomerContent;
            Description = 'ITESOFT';
        }
        field(50030; "ITESOFT User ID"; Code[50])
        {
            Caption = 'ITESOFT User ID"', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code utilisateur ITESOFT"}]}';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Description = 'ITESOFT';
        }
        field(50080; "Dimension Value"; Code[20])
        {
            Caption = 'Dimension Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Affaire"}]}';
            NotBlank = false;
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Dimension Set Entry"."Dimension Value Code" WHERE("Dimension Set ID" = FIELD("Dimension Set ID"), "Dimension Code" = const('AFFAIRE')));
        }
        field(50090; "Dimension Value Name"; Text[50])
        {
            Caption = 'Dimension Value Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom Affaire"}]}';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Dimension Value".Name WHERE("Dimension Code" = CONST('AFFAIRE'), Code = FIELD("Dimension Value")));
        }
        field(50100; "Description"; text[50])
        {
            Caption = 'Description', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désignation"}]}';
            DataClassification = CustomerContent;
        }
        modify("Pay-to Vendor No.")
        {
            trigger OnAfterValidate()
            var
                Vendor: Record Vendor;
                VendorMgmt: Codeunit "Vendor Mgmt";
            begin
                Vendor.get("Pay-to Vendor No.");
                IF NOT ("Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) THEN
                    VendorMgmt.CheckBlockedVendOnOrders(Vendor, false);

                SetPurchaserCode();
                if "Purchaser Code" = '' then
                    "Purchaser Code" := Vendor."Purchaser Code";
            end;
        }
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                Vendor: Record Vendor;
                VendorMgmt: Codeunit "Vendor Mgmt";
            begin
                Vendor.get("Buy-from Vendor No.");
                IF NOT ("Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) THEN
                    VendorMgmt.CheckBlockedVendOnOrders(Vendor, false);
            end;
        }
        modify("Purchaser Code")
        {
            trigger OnAfterValidate()
            var
                PurchaseMgmt: Codeunit "Purchase Mgmt";
            begin
                PurchaseMgmt.updateAddressFromPurchaser(Rec);
            end;
        }
    }

    trigger OnInsert()
    begin
        SetPurchaserCode();
    end;

    local procedure SetPurchaserCode()
    var
        Resource: Record Resource;
        UserSetup: Record "User Setup";
    begin
        if "Document Type" = "Document Type"::Order then begin
            UserSetup.GET(UserId);
            IF Resource.GET(UserSetup.ARBVRNRelatedResourceNo) THEN
                if "Purchaser Code" <> Resource."No." THEN
                    VALIDATE("Purchaser Code", Resource."No.");
        end;
    end;
}