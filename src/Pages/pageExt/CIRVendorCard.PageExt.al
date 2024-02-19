pageextension 50004 "CIR Vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(Payments)
        {
            field("Com. Transfer E-mail"; Rec."Com. Transfer E-mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor''s com. transfer email address', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifier l''adresse e-mail diffusion virement du fournisseur en cours." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
            field("Check Order"; Rec."Check Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Check Order', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifier l''ordre du chèque." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
        }
        addafter(Name)
        {
            field("Class"; Rec.Class)
            {
                ToolTip = 'Specifies the value of the Class', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur de la classe" }, { "lang": "FRB", "txt": "Spécifie la valeur de la classe" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
            field("Subclass"; Rec.Subclass)
            {
                ToolTip = 'Specifies the value of the Subclass', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur de la sous-classe" }, { "lang": "FRB", "txt": "Spécifie la valeur de la sous-classe" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
            field("Subcontractor"; Rec.Subcontractor)
            {
                ToolTip = 'Specifies the value of the subcontractor', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du sous-traitant"},{"lang":"FRB","txt":"Spécifie la valeur du sous-traitant"},{"lang":"DEU","txt":""},{"lang":"ESP","txt":""},{"lang":"ITA","txt":""},{"lang":"NLB","txt":""},{"lang":"NLD","txt":""},{"lang":"PTG","txt":""}]}';
                ApplicationArea = All;
            }
            field("Vendor Materials"; Rec."Vendor Materials")
            {
                ToolTip = 'Specifies the value of the vendor materials', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du fournisseur de matière"},{"lang":"FRB","txt":"Spécifie la valeur du fournisseur de matière"},{"lang":"DEU","txt":""},{"lang":"ESP","txt":""},{"lang":"ITA","txt":""},{"lang":"NLB","txt":""},{"lang":"NLD","txt":""},{"lang":"PTG","txt":""}]}';
                ApplicationArea = All;
            }
        }
        addafter(Payments)
        {
            group("Subcontractor Monitoring")
            {
                Caption = 'Subcontractor Monitoring', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Suivi sous-traitant" }, { "lang": "FRB", "txt": "Suivi sous-traitant" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                Visible = Rec.Subcontractor;

                field("HIVEO"; Rec."HIVEO")
                {
                    ToolTip = 'Specifies the value of HIVEO', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur de l''activation Hiveo" }, { "lang": "FRB", "txt": "Spécifie la valeur de l''activation Hiveo" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                    Editable = HiveoEditableActive;
                }
                field("Invitation Hiveo"; Rec."Invitation Hiveo")
                {
                    ToolTip = 'Specifies the value of the Invitation Hiveo', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur de l''Invitation Hiveo" }, { "lang": "FRB", "txt": "Spécifie la valeur de l''Invitation Hiveo" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                    Editable = HiveoEditableInvitation;
                }
                field("Mail Notif. Invit. HIVEO"; Rec."Mail Notif. Invit. HIVEO")
                {
                    ToolTip = 'Specifies the value of the Mail Notif. Invit. HIVEO', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur du mail notification invitation HIVEO" }, { "lang": "FRB", "txt": "Spécifie la valeur du mail notification invitation HIVEOO" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                }
                field("Presence of posted workers"; Rec."Presence of posted workers")
                {
                    ToolTip = 'Specifies the value of Presence of posted workers', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur de Présence travailleurs détachés" }, { "lang": "FRB", "txt": "Spécifie la valeur de Présence travailleurs détachés" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                }
                field("Blocking Derogation Start Date"; Rec."Blocking Derogation Start Date")
                {
                    ToolTip = 'Specifies the value of Blocking Derogation Start Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur de Date début dérogation blocage" }, { "lang": "FRB", "txt": "Spécifie la valeur de Date début dérogation blocage" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                }
                field("Blocking Exemption End Date"; Rec."Blocking Exemption End Date")
                {
                    ToolTip = 'Specifies the value of Blocking Exemption End Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur de Date fin dérogation blocage" }, { "lang": "FRB", "txt": "Spécifie la valeur de Date fin dérogation blocage" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicationArea = All;
                }
            }
        }
        addafter("Purchaser Code")
        {
            field("APE Code"; Rec."APE Code")
            {
                ToolTip = 'Specifies the value of the APE Code ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code APE"}]}';
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Legal Form"; Rec."Legal Form")
            {
                ToolTip = 'Specifies the value of the Legal Form ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Forme juridique"}]}';
                ApplicationArea = All;
                Importance = Additional;
            }
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        addafter("Vendor Materials")
        {
            field("Strategic Vendor"; Rec."Strategic Vendor")
            {
                ToolTip = 'Specifies the value of the Strategic Vendor', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fournisseur stratégique"}]}';
                ApplicationArea = All;
                Importance = Additional;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        VendorMgmt.ManagEditableFieldsHiveoOnPageVendor(Rec, HiveoEditableActive, HiveoEditableInvitation);
    end;

    trigger OnModifyRecord(): Boolean
    var
        RenamingConfirm_Qst: Label 'Are you sure you want to change ?', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Etes-vous sûr de vouloir modifier ?"}]}';
        DataNotChanged_Err: Label 'The data has not been changed.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Les données n''ont pas été modifiées."}]}';
    begin
        IF NOT CONFIRM(RenamingConfirm_Qst, FALSE) THEN
            ERROR(DataNotChanged_Err);
    end;

    var
        VendorMgmt: Codeunit "Vendor Mgmt";
        HiveoEditableInvitation: Boolean;
        HiveoEditableActive: Boolean;
}