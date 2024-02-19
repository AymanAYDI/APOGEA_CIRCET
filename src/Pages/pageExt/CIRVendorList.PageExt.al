pageextension 50018 "CIR Vendor List" extends "Vendor List"
{
    layout
    {
        addafter("Fax No.")
        {
            field("Com. Transfer E-mail"; Rec."Com. Transfer E-mail")
            {
                ToolTip = 'Specifies the value of the Com. transfer e-mail', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur du Mail diffusion virement" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("Search Name")
        {
            field(Class; Rec.Class)
            {
                ToolTip = 'Specifies the value of the Class', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur de la classe" }, { "lang": "FRB", "txt": "Spécifie la valeur de la classe" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
            field(Subclass; Rec.Subclass)
            {
                ToolTip = 'Specifies the value of the Subclass', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur de la sous-classe" }, { "lang": "FRB", "txt": "Spécifie la valeur de la sous-classe" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
            field(Subcontractor; Rec.Subcontractor)
            {
                ToolTip = 'Specifies the value of the Subcontractor', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur du sous-traitant" }, { "lang": "FRB", "txt": "Spécifie la valeur du sous-traitant" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
            field("Vendor Materials"; Rec."Vendor Materials")
            {
                ToolTip = 'Specifies the value of the Vendor Materials', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur du fournisseur de matière" }, { "lang": "FRB", "txt": "Spécifie la valeur du fournisseur de matière" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("HIVEO"; Rec."HIVEO")
            {
                ToolTip = 'Specifies the value of HIVEO', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur de l''activation Hiveo" }, { "lang": "FRB", "txt": "Spécifie la valeur de l''activation Hiveo" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
                Visible = false;
            }
            field("Invitation Hiveo"; Rec."Invitation Hiveo")
            {
                ToolTip = 'Specifies the value of the Invitation Hiveo', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur de l''Invitation Hiveo" }, { "lang": "FRB", "txt": "Spécifie la valeur de l''Invitation Hiveo" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
                Visible = false;
            }
            field("Mail Notif. Invit. HIVEO"; Rec."Mail Notif. Invit. HIVEO")
            {
                ToolTip = 'Specifies the value of the Mail Notif. Invit. HIVEO', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Mail notification invitation HIVEO" }, { "lang": "FRB", "txt": "Mail notification invitation HIVEO" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] } ';
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}