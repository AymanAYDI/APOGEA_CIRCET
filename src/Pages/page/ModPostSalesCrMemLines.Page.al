page 50020 "Mod Post Sales CrMem Lines"
{
    Caption = 'Lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Lignes"}]}';
    Editable = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Cr.Memo Line";
    AutoSplitKey = true;
    Permissions = TableData "Sales Cr.Memo Line" = rimd;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Control Station Ref."; Rec."Control Station Ref.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Control Station Ref.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du poste de commande"}]}';

                    trigger OnValidate()
                    var
                        Customer: Record Customer;
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                        ControlStationRefCannotBeEmpty_Err: Label 'The control station ref. must be different from 0', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ref. poste de commande doit être différent de 0"}]}';
                    begin
                        //Controle lors du changement du ref poste de commande
                        IF SalesCrMemoHeader.GET(rec."Document No.") THEN
                            if Customer.get(SalesCrMemoHeader."Bill-to Customer No.") then;

                        if (Customer."Paperless Type" in [Customer."Paperless Type"::"EDI Cegedim - Bouygues", Customer."Paperless Type"::"EDI Cegedim - Orange", Customer."Paperless Type"::"EDI Seres - SFR"])
                            AND (Rec.Quantity <> 0) and (Rec."Control Station Ref." = 0) then
                            Error(ControlStationRefCannotBeEmpty_Err);
                    end;

                }
                field(FilteredTypeField; Rec.FormatType())
                {
                    Caption = 'Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type"}]}';
                    ToolTip = 'Specifies the value of the Type field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du type"}]}';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    Caption = 'No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N°"}]}';
                    ToolTip = 'Specifies the value of the No. field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du N°"}]}';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant"}]}';
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du montant"}]}';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    Caption = 'Job No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° projet"}]}';
                    ToolTip = 'Specifies the value of the Job No. field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du N° projet"}]}';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désignation"}]}';
                    ToolTip = 'Specifies a descriptive text.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie un texte descriptif"}]}';
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Caption = 'Description 2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Désignation 2"}]}';
                    ToolTip = 'Specifies a second descriptive text.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie un second texte descriptif."}]}';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TESTFIELD(Type, Rec.Type::" ");
    end;
}