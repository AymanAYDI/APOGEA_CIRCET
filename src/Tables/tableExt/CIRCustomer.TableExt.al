tableextension 50020 "CIR Customer" extends Customer
{
    fields
    {
        field(50000; "Generic Customer"; Boolean)
        {
            Caption = 'Generic Customer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Client générique" }, { "lang": "FRB", "txt": "Client générique" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50001; "Generic Customer No."; Code[20])
        {
            Caption = 'Generic Customer No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° client générique" }, { "lang": "FRB", "txt": "N° client générique" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CustomerIsNotGeneric_Err: Label 'The selected customer is not generic', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Le client sélectionné n''est pas générique" }, { "lang": "FRB", "txt": "Le client sélectionné n''est pas générique" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                CannotModifyGenericCustomer_Err: Label 'You cannot change the generic customer of a generic customer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous ne pouvez pas modifier le client générique d''un client générique" }, { "lang": "FRB", "txt": "Vous ne pouvez pas modifier le client générique d''un client générique" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            begin
                IF "Generic Customer No." <> '' THEN BEGIN
                    Customer.GET("Generic Customer No.");
                    IF NOT Customer."Generic Customer" THEN
                        ERROR(CustomerIsNotGeneric_Err);
                END;

                // Interdiction de modification du client générique d'un client générique
                IF "Generic Customer" AND ("Generic Customer No." <> "No.") THEN
                    ERROR(CannotModifyGenericCustomer_Err);

                // Mise à jour du nom du client générique sélectionné
                CALCFIELDS("Generic Customer Name");
            end;

            trigger OnLookup()
            begin
                // Reset des variables
                CLEAR(Customer);
                CLEAR(CustomerList);

                // Sélectionner dans la liste l'enregistrement correspondant à la valeur du champ.
                IF Customer.GET("Generic Customer No.") THEN
                    CustomerList.SETRECORD(Customer);

                // Afficher les boutons Ok et Annuler au niveau de la liste des clients.
                CustomerList.LOOKUPMODE := TRUE;

                // Activation de l'affichage des clients génériques uniquement
                CustomerList.ShowGenericCustomerOnly();

                // Déclencher l'affichage de la liste des clients
                IF CustomerList.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    // Initialiser la valeur du champ avec le code du client sélectionné.
                    CustomerList.GETRECORD(Customer);
                    VALIDATE("Generic Customer No.", Customer."No.");
                END;
            end;
        }
        field(50002; "Generic Customer Name"; Text[100])
        {
            Caption = 'Generic Customer Name', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom client générique" }, { "lang": "FRB", "txt": "Nom client générique" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Generic Customer No.")));
            editable = false;
        }
        field(50003; "Doubtful Customer"; Boolean)
        {
            Caption = 'Doubtful Customer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Douteux" }, { "lang": "FRB", "txt": "Douteux" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50004; "Paperless Type"; Enum "Customer Paperless Type")
        {
            Caption = 'Paperless Type', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type dématérialisation" }, { "lang": "FRB", "txt": "Type dématérialisation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50005; "Receipt Slip Mandatory"; Boolean)
        {
            Caption = 'Receipt Slip Mandatory', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "PV recette obligatoire" }, { "lang": "FRB", "txt": "PV recette obligatoire" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50006; "Do Not Display"; Boolean)
        {
            Caption = 'Do not display', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ne pas afficher" }, { "lang": "FRB", "txt": "Ne pas afficher" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CannotActivateJobGeneric_Err: Label 'Vous ne pouvez pas activer l''affichage d''un projet générique';
            begin
                // Interdiction d'activation de l'affichage pour un client générique
                IF ("Generic Customer") AND (not "Do Not Display") THEN
                    ERROR(CannotActivateJobGeneric_Err);
            end;
        }
        field(50007; "Bank Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            TableRelation = "Bank Account"."No.";
        }
        field(50008; "APE Code"; Code[10])
        {
            Caption = 'APE Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code APE"}]}';
            DataClassification = CustomerContent;
        }
        field(50009; "Legal Form"; enum "Legal Form FRA")
        {
            Caption = 'Legal Form', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Forme juridique"}]}';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(GenericFields; "Generic Customer No.", "Generic Customer")
        {
        }
    }

    trigger OnInsert()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.GET();
        IF (SalesReceivablesSetup."Generic Customer No." <> '') AND
           (SalesReceivablesSetup."Generic Customer No." = Customer."No. Series") THEN BEGIN
            // Initialisation des caractéristiques du client générique
            Customer."Do Not Display" := TRUE;
            Customer.Blocked := Customer.Blocked::All;
            Customer."Generic Customer" := TRUE;
            Customer."Generic Customer No." := Customer."No.";
        END
    end;

    trigger OnDelete()
    var
        lCustomer: Record Customer;
    begin
        // Dans le cas ou le client supprimé est générique, mise à jour du
        //   numéro de client générique pour tous les clients rattachés.
        IF "Generic Customer" THEN BEGIN
            // Sélection de l'ensemble des clients rattachés au client
            //                 générique supprimé.
            lCustomer.SETCURRENTKEY("Generic Customer No.", "Generic Customer");
            lCustomer.SETRANGE("Generic Customer No.", "No.");
            lCustomer.SETRANGE("Generic Customer", FALSE);

            // Reset du numéro du client générique de rattachement
            lCustomer.MODIFYALL("Generic Customer No.", '');
        END;
    end;

    trigger OnRename()
    var
        lCustomer: Record Customer;
    begin
        // Dans le cas ou le client renommé est générique, mise à jour du
        //   numéro de client générique pour tous les clients rattachés.
        IF "Generic Customer" THEN BEGIN
            // Sélection de l'ensemble des clients rattachés au client
            //                 générique renommé.
            lCustomer.SETCURRENTKEY("Generic Customer No.", "Generic Customer");
            lCustomer.SETRANGE("Generic Customer No.", xRec."No.");
            lCustomer.SETRANGE("Generic Customer", FALSE);

            // Mise à jour du numéro du client générique de rattachement
            lCustomer.MODIFYALL("Generic Customer No.", Rec."No.");
            "Generic Customer No." := Rec."No.";
        END;
    end;

    var
        Customer: Record Customer;

        CustomerList: Page "Customer List";
}