tableextension 50003 "CIR Payment Line" extends "Payment Line"
{
    fields
    {
        field(50000; "Account Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Account Name', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom du compte" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        }
        field(50001; "Reference"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Reference', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Référence" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        }
        field(50002; "Applies-to Purch. Doc. Nbr"; Integer)
        {
            Caption = 'Applies-to Purch. Doc. Number', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nbre doc. achat à lettrer" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = count("Vendor Ledger Entry" where("Applies-to ID" = field("Applies-to ID")));
            Editable = false;
        }
        field(50003; "Vendor E-Mail"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Email', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Adresse e-mail" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            ExtendedDatatype = EMail;
        }
        field(50007; "Country Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Country Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code pays"}]}';
        }

        field(50010; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(50020; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(50030; "Selected"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Selected', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Selection"}]}';
        }

        field(50040; "Issuer/Recipient"; Option)
        {
            Caption = 'Issuer/Recipient', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Emetteur/Beneficiaire"}]}';
            DataClassification = CustomerContent;
            OptionMembers = "15-Issuer","14-Both","13-Recipient";
            OptionCaption = '15-Issuer,14-Both,13-Recipient', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"15-Emetteur,14-Les deux,13-Beneficiaire"}]}';
        }
        field(50050; "Intermediary Account No."; Code[20])
        {
            Caption = 'Intermediary Account No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° compte bancaire intermédiaire"}]}';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account";
        }

        modify("Account No.")
        {
            trigger OnBeforeValidate()
            var
                Vendor: Record Vendor;
            begin
                if ("Account Type" = "Account Type"::"Vendor") then
                    if Vendor.get("Account No.") then begin
                        Vendor.LockTable();
                        Vendor.Blocked := Vendor.Blocked::" ";
                        Vendor.Modify();
                    end;
            end;

            trigger OnAfterValidate()
            var
                GLAccount: Record "G/L Account";
                Customer: Record Customer;
                Vendor: Record Vendor;
                BankAccount: Record "Bank Account";
                Employee: Record Employee;
                ICPartner: Record "IC Partner";
                FixedAsset: Record "Fixed Asset";
                PaymentHeader: Record "Payment Header";
            begin
                if (rec."Account No." <> xRec."Account No.") then
                    if rec."Account No." = '' then begin
                        "Account Name" := '';
                        "Vendor E-Mail" := '';
                        "Country Code" := '';
                    end else begin
                        if ("Account Type" = "Account Type"::"G/L Account") then begin
                            GLAccount.GET(rec."Account No.");
                            "Account Name" := GLAccount.Name;
                        end;

                        if ("Account Type" = "Account Type"::"Customer") then begin
                            Customer.GET(rec."Account No.");
                            "Account Name" := Customer.Name;
                            "Vendor E-Mail" := Customer."E-Mail";
                            "Country Code" := Customer."Country/Region Code";
                        end;

                        if ("Account Type" = "Account Type"::"Vendor") then begin
                            Vendor.GET(rec."Account No.");
                            "Account Name" := Vendor.Name;
                            "Vendor E-Mail" := Vendor."Com. Transfer E-mail";
                            "Country Code" := Vendor."Country/Region Code";

                            PaymentHeader.Get("No.");
                            "Due Date" := PaymentHeader."Posting Date";
                        end;

                        if ("Account Type" = "Account Type"::"Bank Account") then begin
                            BankAccount.GET(rec."Account No.");
                            "Account Name" := BankAccount.Name;
                        end;

                        if ("Account Type" = "Account Type"::Employee) then begin
                            Employee.GET(rec."Account No.");
                            "Account Name" := Employee.FullName();
                            "Vendor E-Mail" := Employee."E-Mail";
                            "Country Code" := Employee."Country/Region Code";
                        end;

                        if ("Account Type" = "Account Type"::"IC Partner") then begin
                            ICPartner.GET(rec."Account No.");
                            "Account Name" := ICPartner.Name;
                        end;

                        if ("Account Type" = "Account Type"::"Fixed Asset") then begin
                            FixedAsset.GET(rec."Account No.");
                            "Account Name" := FixedAsset.Description;
                        end;
                    end;
                if ("Account Type" = "Account Type"::"Vendor") then
                    if Vendor.GET(rec."Account No.") then
                        //Test sur la valeur du champ Bloqué spécifique
                        if Vendor."CIR Blocked" in [Vendor."CIR Blocked"::All, Vendor."CIR Blocked"::Payment] then begin
                            Vendor.Blocked := Vendor."CIR Blocked";
                            Vendor.Modify();
                            ERROR(VendorBlockedAllAndPayment_Err, Vendor."No.", Vendor.Name);
                        end else begin
                            Vendor.Blocked := Vendor."CIR Blocked";
                            Vendor.Modify();
                        end;
            end;
        }
    }

    trigger OnBeforeInsert()
    var
        Vendor: Record Vendor;
    begin
        if ("Account Type" = "Account Type"::"Vendor") then
            if Vendor.get("Account No.") then begin
                Vendor.LockTable();
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.Modify();
            end;
    end;

    trigger OnAfterInsert()
    var
        Vendor: Record Vendor;
    begin
        //Test sur la valeur du champ Bloqué spécifique
        if ("Account Type" = "Account Type"::"Vendor") then begin
            Vendor.GET(rec."Account No.");
            if Vendor."CIR Blocked" in [Vendor."CIR Blocked"::All, Vendor."CIR Blocked"::Payment] then begin
                Vendor.Blocked := Vendor."CIR Blocked";
                Vendor.Modify();
                ERROR(VendorBlockedAllAndPayment_Err, Vendor."No.", Vendor.Name);
            end else begin
                Vendor.Blocked := Vendor."CIR Blocked";
                Vendor.Modify();
            end;
        end;

        ModifyDocNo();
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode, IsHandled);
        if IsHandled then
            exit;

        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, rec."Dimension Set ID");

        OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    local procedure ModifyDocNo()
    var
        vPaymentLine: Record "Payment Line";
    begin
        if Rec."No." <> '' then begin
            vPaymentLine.SetRange("No.", Rec."No.");
            if vPaymentLine.FindLast() then
                if vPaymentLine."Line No." <> 10000 then
                    Rec.Validate("Document No.", CopyStr(Rec."No." + '/' + Format((vPaymentLine."Line No.")), 1, MaxStrLen(Rec."Document No.")))
                else
                    Rec.Validate("Document No.", CopyStr(Rec."No." + '/' + Format(10000), 1, MaxStrLen(Rec."Document No.")));
            Rec.Modify();
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShortcutDimCode(var PaymentLine: Record "Payment Line"; var xPaymentLine: Record "Payment Line"; FieldNumber: Integer; var ShortcutDimCode: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var PaymentLine: Record "Payment Line"; var xPaymentLine: Record "Payment Line"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    var
        DimMgt: codeunit DimensionManagement;
        VendorBlockedAllAndPayment_Err: label 'Vendor %1 - %2 is blocked at all or in payment', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le fournisseur %1 - %2 est bloqué à tous ou en paiement"}]}';
}