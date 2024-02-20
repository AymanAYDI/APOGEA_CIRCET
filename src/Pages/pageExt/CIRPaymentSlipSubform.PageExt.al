pageextension 50003 "CIR Payment Slip Subform" extends "Payment Slip Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Account Name"; Rec."Account Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of account for the payment line', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie le nom du compte sur lequel l''écriture de la ligne feuille sera validée." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
            field("Reference"; Rec."Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reference for the payment line.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la référence de la ligne de paiement." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
            field("Applies-to Purch. Doc. Nbr"; PaymentSlipSubformMgt.AppliesToVendorLedgerEntries(Rec, false))
            {
                ApplicationArea = All;
                Caption = 'Applies-to Purch. Doc. Number', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nbre doc. achat à lettrer" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ToolTip = 'Specifies the applies-to purch. doc. number of the payment line.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie le nombre doc. achat à lettrer de la ligne de paiement" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';

                trigger OnDrillDown()
                begin
                    PaymentSlipSubformMgt.AppliesToVendorLedgerEntries(Rec, true);
                end;
            }
            field("Vendor E-Mail"; Rec."Vendor E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the email of the vendor.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie l''adresse e-mail du fournisseur." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
            field("Country Code"; Rec."Country Code")
            {
                ToolTip = 'Specifies the value of the Country Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code pays"}]}';
                ApplicationArea = All;
            }
            field("Shortcut Dimension 1 Code"; ShortcutDimCode[1])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,1';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                             "Dimension Value Type" = CONST(Standard),
                                                             Blocked = CONST(false));
                ToolTip = 'Specifies the value of the ShortcutDimCode[1]';

                trigger OnValidate()
                begin
                    ValidateShortcutDimension(1);
                end;
            }
            field("Shortcut Dimension 2 Code"; ShortcutDimCode[2])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,2';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                             "Dimension Value Type" = CONST(Standard),
                                                             Blocked = CONST(false));
                ToolTip = 'Specifies the value of the ShortcutDimCode[2]';

                trigger OnValidate()
                begin
                    ValidateShortcutDimension(2);
                end;
            }
            field("Shortcut Dimension 4 Code"; ShortcutDimCode[4])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,4';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                             "Dimension Value Type" = CONST(Standard),
                                                             Blocked = CONST(false));
                ToolTip = 'Specifies the value of the ShortcutDimCode[4]';

                trigger OnValidate()
                var
                    Job: Record Job;
                begin
                    ValidateShortcutDimension(4);
                    if Job.Get(ShortcutDimCode[4]) then begin
                        Rec.Validate("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
                        CurrPage.Update();
                    end;
                end;
            }
            field("Issuer/Recipient"; Rec."Issuer/Recipient")
            {
                ToolTip = 'Specifies the value of the Issuer/Recipient field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du champ Émetteur/Destinataire."}]}';
                ApplicationArea = All;
            }
            field("Intermediary Account No."; Rec."Intermediary Account No.")
            {
                ToolTip = 'Specifies the value of the Intermediary Account No. field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du champ N° Compte Banque Intermediaire"}]}';
                ApplicationArea = All;
            }
        }

        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                Rec.ShowShortcutDimCode(ShortcutDimCode);
            end;
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    local procedure ValidateShortcutDimension(DimIndex: Integer)
    var
    begin
        Rec.ValidateShortcutDimCode(DimIndex, ShortcutDimCode[DimIndex]);
    end;

    var
        PaymentSlipSubformMgt: Codeunit "Payment Slip Subform Mgt";

    protected var
        ShortcutDimCode: array[8] of Code[20];
}