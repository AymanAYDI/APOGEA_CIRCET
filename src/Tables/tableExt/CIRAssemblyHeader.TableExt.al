tableextension 50035 "CIR Assembly Header" extends "Assembly Header"
{
    fields
    {
        field(50000; "Assembly to Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Assembly to Order No', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Assembler pour commande"}]}';
        }
        field(50001; "Assembly to Order Line No."; integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Assembly to Order', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Assembler pour commande"}]}';
        }
        field(50002; "Ship-to Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code destinataire"}]}';
            trigger OnLookup()
            var
                ShiptoAddress: Record "Ship-to Address";
                AssemblyMgt: Codeunit "Assembly Mgt.";
                ConfirmationLbl: Label 'Warning, you are going to change the delivery address. Do you want to continue?',
                                        Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Attention, vous allez modifier l''adresse de livraison. Voulez-vous continuer?"}]}';
            begin
                if Page.RunModal(Page::"Ship-to Address List", ShiptoAddress) = Action::LookupOK then
                    if Dialog.Confirm(ConfirmationLbl, false) then
                        AssemblyMgt.SetAddressInformations(Rec, ShiptoAddress);
            end;
        }
        field(50003; "Ship-to Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du destinataire"}]}';
        }
        field(50004; "Ship-to Name 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Name 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du destinataire 2"}]}';
        }
        field(50005; "Ship-to Address"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Address', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse destinataire"}]}';
        }
        field(50006; "Ship-to Address 2"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Address 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse destinataire 2"}]}';
        }
        field(50007; "Ship-to City"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to City', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ville destinataire"}]}';
        }
        field(50008; "Number of packages"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Number of packages', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de colis"}]}';
        }
        field(50009; "Total weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids total"}]}';
        }
        field(50010; "Business"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Business Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code affaire"}]}';
        }
        field(50011; "Business name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Business name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom affaire"}]}';
        }
        field(50012; "Ship-to Post Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Post Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code postal destinataire"}]}';
        }
        field(50013; "Shipping Agent Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Shipping Agent Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code transporteur"}]}';
        }
        field(50015; "Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° projet"}]}';
        }
        field(50016; "Comment 1"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment 1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaire 1"}]}';
        }
        field(50017; "Comment 2"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaire 2"}]}';
        }
        field(50018; "Customer Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom client"}]}';
        }
        field(50019; ChangeTotalWeight; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Change total weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Changer le poids total"}]}';
        }
        field(50020; "Change Bin Code"; Boolean)
        {
            Caption = 'Change Bin Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Changer le code emplacement"}]}';
            DataClassification = CustomerContent;
        }
        field(50021; "New Bin Code"; Code[20])
        {
            Caption = 'New Bin Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouveau code emplacement"}]}';
            DataClassification = CustomerContent;
            TableRelation = if (Quantity = filter(< 0)) "Bin Content"."Bin Code" where("Location Code" = field("Location Code"),
                                                                                     "Item No." = field("Item No."),
                                                                                     "Variant Code" = field("Variant Code"))
            else
            Bin.Code where("Location Code" = field("Location Code"));
        }
        field(50022; "Your Reference"; Text[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Your Reference', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Votre référence"}]}';
        }
        field(50023; "Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code site"}]}';
        }
    }
}