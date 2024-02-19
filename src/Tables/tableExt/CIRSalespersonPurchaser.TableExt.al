tableextension 50012 "CIR Salesperson/Purchaser" extends "Salesperson/Purchaser"
{
    fields
    {
        field(50000; "Purchaser"; boolean)
        {
            Caption = 'Purchaser', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Acheteur" }, { "lang": "FRB", "txt": "Acheteur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50002; "Fax No."; Text[30])
        {
            Caption = 'Fax No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° de fax"}]}';
            DataClassification = CustomerContent;
        }
        field(50003; "E-Mail Service"; Text[80])
        {
            Caption = 'E-mail Service', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Mail Service"}]}';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }

        field(50010; "Salesperson"; boolean)
        {
            Caption = 'Salesperson', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vendeur" }]}';
            DataClassification = CustomerContent;
        }
        field(50011; "Ship-to Customer"; Code[20])
        {
            Caption = 'Ship-to Customer', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Client destinataire"}]}';
            DataClassification = CustomerContent;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if "Ship-to Customer" <> xRec."Ship-to Customer" then
                    Validate("Ship-to Customer Adress", '');
            end;
        }
        field(50012; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom destinataire"}]}';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Ship-to Name" <> xRec."Ship-to Name" then begin
                    "Ship-to Customer" := '';
                    "Ship-to Customer Adress" := '';
                end;
            end;
        }
        field(50014; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse destinataire"}]}';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Ship-to Address" <> xRec."Ship-to Address" then begin
                    "Ship-to Customer" := '';
                    "Ship-to Customer Adress" := '';
                end
            end;
        }
        field(50015; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse destinataire 2"}]}';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Ship-to Address 2" <> xRec."Ship-to Address 2" then begin
                    "Ship-to Customer" := '';
                    "Ship-to Customer Adress" := '';
                end
            end;
        }
        field(50016; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code postal destinataire"}]}';
            DataClassification = CustomerContent;
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode("Ship-to City", "Ship-to Post Code", TxtPCountry, CodePCountryCode, (CurrFieldNo <> 0) AND GUIALLOWED);

                if ("Ship-to Post Code" <> xRec."Ship-to Post Code") OR ("Ship-to City" <> xRec."Ship-to City") then begin
                    "Ship-to Customer" := '';
                    "Ship-to Customer Adress" := '';
                end
            end;

            trigger OnLookup()
            begin
#pragma warning disable AA0139 // TODO - Pas la possibilité de copystr car type "var text"
                PostCode.LookupPostCode("Ship-to City", "Ship-to Post Code", TxtPCountry, CodePCountryCode);
#pragma warning restore AA0139 // TODO - Pas la possibilité de copystr car type "var text"

                if ("Ship-to Post Code" <> xRec."Ship-to Post Code") OR ("Ship-to City" <> xRec."Ship-to City") then begin
                    "Ship-to Customer" := '';
                    "Ship-to Customer Adress" := '';
                end
            end;
        }

        field(50017; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ville destinataire"}]}';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PostCode.ValidateCity("Ship-to City", "Ship-to Post Code", TxtPCountry, CodePCountryCode, (CurrFieldNo <> 0) AND GUIALLOWED);

                if ("Ship-to Post Code" <> xRec."Ship-to Post Code") OR ("Ship-to City" <> xRec."Ship-to City") then begin
                    "Ship-to Customer" := '';
                    "Ship-to Customer Adress" := '';
                end
            end;

            trigger OnLookup()
            begin
#pragma warning disable AA0139 // TODO - Pas la possibilité de copystr car type "var text"
                PostCode.LookupPostCode("Ship-to City", "Ship-to Post Code", TxtPCountry, CodePCountryCode);
#pragma warning restore AA0139 // TODO - Pas la possibilité de copystr car type "var text"

                if ("Ship-to Post Code" <> xRec."Ship-to Post Code") OR ("Ship-to City" <> xRec."Ship-to City") then begin
                    "Ship-to Customer" := '';
                    "Ship-to Customer Adress" := '';
                end
            end;
        }
        field(50018; "Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Contact destinataire"}]}';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Ship-to Contact" <> xRec."Ship-to Contact" then begin
                    "Ship-to Customer" := '';
                    "Ship-to Customer Adress" := '';
                end
            end;
        }
        field(50019; "Ship-to Customer Adress"; Code[10])
        {
            Caption = 'Ship-to Customer Adress', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse client destinataire"}]}';
            DataClassification = CustomerContent;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Ship-to Customer"));

            trigger OnValidate()
            var
                Customer: Record Customer;
                ShiptoAddress: Record "Ship-to Address";
            begin
                if "Ship-to Customer Adress" = '' then begin
                    if Customer.get("Ship-to Customer") then begin
                        "Ship-to Name" := Customer.Name;
                        "Ship-to Address" := Customer.Address;
                        "Ship-to Address 2" := Customer."Address 2";
                        "Ship-to Post Code" := Customer."Post Code";
                        "Ship-to City" := Customer.City;
                        "Ship-to Contact" := Customer.Contact;
                    end else begin
                        "Ship-to Customer" := '';
                        "Ship-to Name" := '';
                        "Ship-to Address" := '';
                        "Ship-to Address 2" := '';
                        "Ship-to Post Code" := '';
                        "Ship-to City" := '';
                        "Ship-to Contact" := '';
                    end;
                end else
                    if ShiptoAddress.get("Ship-to Customer", "Ship-to Customer Adress") then begin
                        "Ship-to Name" := ShiptoAddress.Name;
                        "Ship-to Address" := ShiptoAddress.Address;
                        "Ship-to Address 2" := ShiptoAddress."Address 2";
                        "Ship-to Post Code" := ShiptoAddress."Post Code";
                        "Ship-to City" := ShiptoAddress.City;
                        "Ship-to Contact" := ShiptoAddress.Contact;
                    end else begin
                        "Ship-to Customer" := '';
                        "Ship-to Name" := '';
                        "Ship-to Address" := '';
                        "Ship-to Address 2" := '';
                        "Ship-to Post Code" := '';
                        "Ship-to City" := '';
                        "Ship-to Contact" := '';
                    end;
            end;
        }
    }

    //Fonction qui permet de déterminer si la ressource et un acheteur.
    internal procedure SalespersonPurchaserIsPurchaser(pResourceNo: Code[20]): Boolean
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        If SalespersonPurchaser.Get(pResourceNo) then
            exit(SalespersonPurchaser.Purchaser)
    end;

    //Fonction qui permet de déterminer si la ressource et un vendeur.
    internal procedure SalespersonPurchaserIsVendor(pResourceNo: Code[20]): Boolean
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        If SalespersonPurchaser.Get(pResourceNo) then
            exit(SalespersonPurchaser."Salesperson")
    end;

    var
        PostCode: Record "Post Code";
        TxtPCountry: Text[30];
        CodePCountryCode: Code[10];
}