page 50021 "Mod Posted SalesCrMem"
{
    Caption = 'Modify Posted Sales Credit Memo', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modifier l''avoir de vente enregistré"}]}';
    PageType = Card;
    SourceTable = "Sales Cr.Memo Header";
    Permissions = TableData "Sales Cr.Memo Header" = rm;
    RefreshOnActivate = true;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the posted credit memo number.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du N°"}]}';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the number of the customer.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du N° client"}]}';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the external document number that is entered on the sales header that this line was posted from.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du N° doc. externe"}]}';
                    ApplicationArea = All;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ToolTip = 'Specifies the name of the customer that the credit memo was sent to.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du nom client facturé"}]}';
                    ApplicationArea = All;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ToolTip = 'Specifies the address of the customer that the credit memo was sent to.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur de l''adresse"}]}';
                    ApplicationArea = All;
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ToolTip = 'Specifies additional address information.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur de l''adresse (2ème ligne)"}]}';
                    ApplicationArea = All;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ToolTip = 'Specifies the postal code.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du code postal"}]}';
                    ApplicationArea = All;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ToolTip = 'Specifies the city of the customer on the sales document.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur de la ville"}]}';
                    ApplicationArea = All;
                }
                field("Bill-to County"; Rec."Bill-to County")
                {
                    ToolTip = 'Specifies the state, province or county as a part of the address.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Région"}]}';
                    ApplicationArea = All;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ToolTip = 'Specifies the country or region of the address.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du pays/région"}]}';
                    ApplicationArea = All;
                }
            }
            part(PostSalesCrMemLines; "Mod Post Sales CrMem Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }

    trigger OnInit()
    begin
        Saved := false;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::OK then begin
            Saved := true;
            CurrPage.Close();
        end;
    end;

    procedure GetSaved(): Boolean
    begin
        exit(Saved);
    end;

    var
        Saved: Boolean;
}