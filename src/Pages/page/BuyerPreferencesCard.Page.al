page 50008 "Buyer Preferences Card"
{
    Caption = 'Buyer Preferences', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Préférences approvisionneur"}]}';
    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;
    SourceTable = "Salesperson/Purchaser";
    SourceTableView = SORTING(Code) ORDER(Ascending) WHERE(Purchaser = CONST(true));
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le code du vendeur ou de l''acheteur"}]}';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le nom du vendeur ou de l''acheteur"}]}';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le numéro de téléphone du vendeur"}]}';
                    ApplicationArea = All;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the value of the Fax No. ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le numéro de fax du vendeur"}]}';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the Email ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie l''adresse email du vendeur"}]}';
                    ApplicationArea = All;
                }
                field("E-Mail Service"; Rec."E-Mail Service")
                {
                    ToolTip = 'Specifies the value of the E-mail Service ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le mail de service du vendeur"}]}';
                    ApplicationArea = All;
                }
            }
            group(Ship)
            {
                caption = 'Ship', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Livraison"}]}';
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ToolTip = 'Specifies the value of the Ship-to Name ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom destinataire"}]}';
                    ApplicationArea = All;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ToolTip = 'Specifies the value of the Ship-to Address ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse destinataire"}]}';
                    ApplicationArea = All;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ToolTip = 'Specifies the value of the Ship-to Address 2 ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse destinataire 2"}]}';
                    ApplicationArea = All;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ToolTip = 'Specifies the value of the Ship-to Post Code ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code postal destinataire"}]}';
                    ApplicationArea = All;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ToolTip = 'Specifies the value of the Ship-to City ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ville destinataire"}]}';
                    ApplicationArea = All;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ToolTip = 'Specifies the value of the Ship-to Contact ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Contact destinataire"}]}';
                    ApplicationArea = All;
                }
                field("Ship-to Customer"; Rec."Ship-to Customer")
                {
                    ToolTip = 'Specifies the value of the Ship-to Customer ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Client destinataire"}]}';
                    ApplicationArea = All;
                }
                field("Ship-to Customer Adress"; Rec."Ship-to Customer Adress")
                {
                    ToolTip = 'Specifies the value of the Ship-to Customer Adress ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse client destinataire"}]}';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        YouHaventBuyerRights_Err: Label 'You have no buyer rights', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''avez pas le droit approvisionneur."}]}';
    begin
        if UserSetup.Get(UserId()) then;
        if not Rec.SalespersonPurchaserIsPurchaser(UserSetup.ARBVRNRelatedResourceNo) then
            Error(YouHaventBuyerRights_Err)
        else
            Rec.Get(UserSetup.ARBVRNRelatedResourceNo);
    end;
}