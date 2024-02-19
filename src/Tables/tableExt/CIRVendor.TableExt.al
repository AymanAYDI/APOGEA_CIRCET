tableextension 50004 "CIR Vendor" extends Vendor
{
    fields
    {
        field(50000; "Com. Transfer E-mail"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Com. transfer e-mail', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Mail diffusion virement" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        }
        field(50001; HIVEO; Boolean)
        {
            Caption = 'HIVEO', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Activation Hiveo" }, { "lang": "FRB", "txt": "Activation Hiveo" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            Description = 'HIVEO';
            DataClassification = CustomerContent;
        }
        field(50002; "Invitation Hiveo"; enum "Invitation Hiveo")
        {
            Caption = 'Invitation Hiveo', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Invitation Hiveo" }, { "lang": "FRB", "txt": "Invitation Hiveo" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            Description = 'HIVEO';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                VendorMgmt: Codeunit "Vendor Mgmt";
            begin
                VendorMgmt.NotSelectInvitTreated(Rec);
            end;
        }
        field(50003; "Mail Notif. Invit. HIVEO"; Text[200])
        {
            Caption = 'Mail Notif. Invit. HIVEO', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Mail notification invitation HIVEO" }, { "lang": "FRB", "txt": "Mail notification invitation HIVEO" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50004; Subcontractor; Boolean)
        {
            Caption = 'Subcontractor', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Sous-traitant" }, { "lang": "FRB", "txt": "Sous-traitant" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not Subcontractor then begin
                    HIVEO := false;
                    "Invitation Hiveo" := "Invitation Hiveo"::" ";
                end else
                    "Invitation Hiveo" := "Invitation Hiveo"::Immediate;
            end;
        }
        field(50005; "Vendor Materials"; Boolean)
        {
            Caption = 'Vendor Materials', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Fournisseur matière" }, { "lang": "FRB", "txt": "Fournisseur matière" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50007; Class; enum "Vendor Class")
        {
            Caption = 'Class', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Classe" }, { "lang": "FRB", "txt": "Classe" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50008; Subclass; Code[30])
        {
            Caption = 'Subclass', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Sous-classe" }, { "lang": "FRB", "txt": "Sous-classe" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
            TableRelation = "Vendor Subclass".Code;
        }
        field(50010; "APE Code"; Code[10])
        {
            Caption = 'APE Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code APE"}]}';
            DataClassification = CustomerContent;
        }
        field(50011; "Legal Form"; Enum "Legal Form FRA")
        {
            Caption = 'Legal Form', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Forme juridique"}]}';
            DataClassification = CustomerContent;
        }
        field(50012; "Create Date Vendor"; Date)
        {
            Caption = 'Create Date Vendor', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date de création fournisseur" }, { "lang": "FRB", "txt": "Date de création fournisseur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50013; "Check Order"; Text[80])
        {
            Caption = 'Check Order', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ordre chèque"}]}';
            DataClassification = CustomerContent;
            Editable = true;
        }
        field(50014; "CIR Blocked"; Enum "Vendor Blocked")
        {
            Caption = 'Blocked', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Bloqué"}]}';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Blocked <> Blocked::All) and "Privacy Blocked" then
                    if GuiAllowed then
                        if Confirm(ConfirmBlockedPrivacyBlockedQst) then
                            "Privacy Blocked" := false
                        else
                            Error('')
                    else
                        Error(CanNotChangeBlockedDueToPrivacyBlockedErr);
                Rec.Blocked := Rec."CIR Blocked";
            end;
        }
        modify(Blocked)
        {
            trigger OnAfterValidate()
            begin
                Rec."CIR Blocked" := Rec."Blocked";
            end;
        }
        field(50015; "Blocking Derogation Start Date"; Date)
        {
            Caption = 'Blocking Derogation Start Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date début dérogation blocage"}]}';
            DataClassification = CustomerContent;
            Editable = true;

            trigger OnValidate()
            var

            begin
                if (Rec."Blocking Derogation Start Date" >= Rec."Blocking Exemption End Date") and (Rec."Blocking Exemption End Date" <> 0D) then begin
                    Rec."Blocking Derogation Start Date" := TODAY();
                    if Rec."Blocking Exemption End Date" <= Rec."Blocking Derogation Start Date" THEN
                        Rec."Blocking Exemption End Date" := 0D;
                    Message(DerogationStartDateMustGreatherThanEndDateLbl);
                end;
            end;
        }
        field(50016; "Blocking Exemption End Date"; Date)
        {
            Caption = 'Blocking Exemption End Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date fin dérogation blocage"}]}';
            DataClassification = CustomerContent;
            Editable = true;

            trigger OnValidate()
            var
                Text001Lbl: Label 'The derogation start date cannot be less than the end date!', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "La date de début de dérogation ne peut être inférieur à la date de fin !" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            begin
                if Rec."Blocking Derogation Start Date" = 0D THEN
                    Rec."Blocking Derogation Start Date" := TODAY();
                if Rec."Blocking Derogation Start Date" >= Rec."Blocking Exemption End Date" then begin
                    Rec."Blocking Derogation Start Date" := TODAY();
                    if Rec."Blocking Exemption End Date" <= Rec."Blocking Derogation Start Date" THEN
                        Rec."Blocking Exemption End Date" := 0D;
                    Message(Text001Lbl);
                end;
            end;
        }
        field(50017; "Presence Of Posted Workers"; Boolean)
        {
            Caption = 'Presence Of Posted Workers', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Présence travailleurs détachés"}]}';
            DataClassification = CustomerContent;
            Editable = true;
        }
        field(50018; "Strategic Vendor"; Boolean)
        {
            Caption = 'Strategic Vendor', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fournisseur stratégique"}]}';
            DataClassification = CustomerContent;
            Editable = true;
        }
    }

    trigger OnRename()
    var
        RenamingConfirm_Qst: Label 'Are you sure you want to change ?', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Etes-vous sûr de vouloir modifier ?"}]}';
        DataNotChanged_Err: Label 'The data has not been changed.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Les données n''ont pas été modifiées."}]}';
    begin
        IF NOT CONFIRM(RenamingConfirm_Qst, FALSE) THEN
            ERROR(DataNotChanged_Err);
    end;

    trigger OnInsert()
    begin
        HIVEO := false;
        "Invitation Hiveo" := "Invitation Hiveo"::" ";
    end;

    var
        ConfirmBlockedPrivacyBlockedQst: Label 'If you change the Blocked field, the Privacy Blocked field is changed to No. Do you want to continue?', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Si vous modifiez le champ Bloqué, le champ Confidentialité bloquée prend la valeur Non. Voulez-vous continuer"}]}';
        CanNotChangeBlockedDueToPrivacyBlockedErr: Label 'The Blocked field cannot be changed because the user is blocked for privacy reasons.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le champ Bloqué ne peut pas être modifié, car l''utilisateur est bloqué pour des raisons de confidentialité."}]}';
        DerogationStartDateMustGreatherThanEndDateLbl: Label 'The derogation start date cannot be less than the end date!', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "La date de début de dérogation ne peut être inférieur à la date de fin !" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
}