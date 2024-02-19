page 50010 "Management Control Setup"
{
    AdditionalSearchTerms = 'Setup';
    Caption = 'Management Control Setup', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramètres contrôle de gestion" } ] }';
    PageType = Card;
    SourceTable = "General Application Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    DataCaptionExpression = '';

    layout
    {
        area(content)
        {
            group(Situation)
            {
                Caption = 'Situation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Situation"}]}';

                field("Evaluation period situation"; Rec."Evaluation Period Situation")
                {
                    ToolTip = 'Specifies the value of the Evaluation period situation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Période évaluation situation"}]}';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserNotAuthorizedLbl: Label 'You are not authorized to open this page, please contact an administrator.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''êtes pas autorisé à ouvrir cette page, veuillez contacter un administrateur."}]}';
    begin

        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        IF NOT CIRUsermanagement.CheckRightUserByGroup(UserGroup.FieldNo("Financial Controller")) then begin
            MESSAGE(UserNotAuthorizedLbl);
            ERROR('');      // Exit page --<>
        end;
    end;

    var
        UserGroup: Record "User Group";
        CIRUsermanagement: Codeunit "CIR User management";
}