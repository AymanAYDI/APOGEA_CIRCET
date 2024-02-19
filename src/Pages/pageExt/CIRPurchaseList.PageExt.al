/*
Version------Trigramme-------Date------- N° REF   -    Domain : Comments
AC.FAB002       JCO       15/06/2021     Feature 10324 FAB002 : Ajout de l'axe analytique 3 en affichage
*/
pageextension 50019 "CIR Purchase List" extends "Purchase List"
{
    layout
    {
        addafter("Purchaser Code")
        {
            field("Name Buyer"; Rec."Name Buyer")
            {
                ToolTip = 'Specifies the value of the Name Buyer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom approvisionneur" }, { "lang": "FRB", "txt": "Nom approvisionneur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }

            field("ShorCut Dimension 3 Code"; ShorCutDimension3Code)
            {
                ApplicationArea = All;
                Caption = 'ShorCut Dimension 3 Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code section axe 3" } ] }';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
                CaptionClass = '1,2,3';
                ToolTip = 'Specifies the value of the ShorCut Dimension 3 Code', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Code section axe 3" } ] }';
                Editable = false;
            }
        }
    }

    trigger OnOpenPage()
    begin
        GeneralLedgerSetup.GET();
    end;

    trigger OnAfterGetRecord()
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        if DimensionSetEntry.Get(Rec."Dimension Set ID", GeneralLedgerSetup."Shortcut Dimension 3 Code") then
            ShorCutDimension3Code := DimensionSetEntry."Dimension Value Code"
        else
            ShorCutDimension3Code := '';
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        ShorCutDimension3Code: Code[20];
}