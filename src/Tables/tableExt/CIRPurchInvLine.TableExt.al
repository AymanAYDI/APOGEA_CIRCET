/*
Version------Trigramme-------Date------- N° REF   -    Domain : Comments
AC.FAB011       JCO       16/06/2021     F10325        FAB011 : Affectation automatique du code affaire en fonction de l'article
AC.ACH012       JCO       19/07/2021                   ACH012 : gestion des paiements directs
*/
tableextension 50032 "CIRPurch. Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {
        field(50000; Applicant; Code[20])
        {
            Caption = 'Applicant', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Demandeur" }, { "lang": "FRB", "txt": "Demandeur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
            TableRelation = Resource."No.";
        }
        field(50001; Site; Text[50])
        {
            Caption = 'Site', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site" }, { "lang": "FRB", "txt": "Site" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50010; "Accrue"; Boolean)
        {
            Caption = 'Accrue', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"FNP"}]}';
            DataClassification = CustomerContent;
        }
    }
}
