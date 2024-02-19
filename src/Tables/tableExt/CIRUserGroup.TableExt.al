tableextension 50031 "CIRUserGroup" extends "User Group"
{
    fields
    {
        field(50000; "Accounts receivable"; Boolean)
        {
            Caption = 'Accounts receivable', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Service comptabilité client"}]}';
            DataClassification = CustomerContent;
        }
        field(50010; "Invoice Purchase Rights"; Boolean)
        {
            Caption = 'Invoice Purchase Rights', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Droits facturation achat" }, { "lang": "FRB", "txt": "Droits facturation achat" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = customerContent;
        }
        field(50020; "Leader Sales Invoice"; Boolean)
        {
            Caption = 'Leader Sales Invoice', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Leader facturation vente" } ] }';
            DataClassification = CustomerContent;
        }
        field(50030; "Invoice Sales Rights"; Boolean)
        {
            Caption = 'Invoice Sales Rights', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Droits facturation vente" }, { "lang": "FRB", "txt": "Droits facturation vente" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = customerContent;
        }
        field(50040; "Financial Controller"; Boolean)
        {
            Caption = 'Financial Controller', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Contrôleur de gestion"}]}';
            DataClassification = CustomerContent;
        }
        field(50050; "Deletion Vendor RIB"; Boolean)
        {
            Caption = 'Deletion Vendor RIB', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Suppression RIB Fournisseur"}]}';
            DataClassification = CustomerContent;
            Description = 'Utilisé pour supprimer un compte bancaire fournisseur.';
        }
        field(50060; "Allow Purchase Order Post"; Boolean)
        {
            Caption = 'Allow Purchase Order Post', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Autoriser validation commande achat"}]}';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Not used';
        }
        field(50070; "Allow employees entries"; Boolean)
        {
            Caption = 'Allow employees entries', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Autoriser écritures salariés"}]}';
            DataClassification = CustomerContent;
        }
    }
}