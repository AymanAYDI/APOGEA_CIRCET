page 50019 "Activity Agency Region List"
{
    PageType = List;
    SourceTable = "Activity Agency Region";
    Caption = 'Activity Agency Region List', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Liste Activité Agence Région"}]}';
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.Type)
                {
                    Visible = TypeVisible;
                    ApplicationArea = All;
                    ToolTip = 'Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type"}]}';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom"}]}';
                }
                field(Responsible; Rec.Responsible)
                {
                    ApplicationArea = All;
                    ToolTip = 'Responsible', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Responsable"}]}';

                    trigger OnValidate()
                    begin
                        ResponsableOnAfterValidate();
                    end;
                }
                field("Responsible Name"; Rec."Responsible Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Responsible Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom responsable"}]}';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        filtreType: Text;
        Captions: Text;
        i: Integer;
    begin
        filtreType := Rec.GETFILTER(Type);
        Rec.RESET();
        Rec.FILTERGROUP(2);
        Rec.SETFILTER(Type, filtreType);
        Rec.FILTERGROUP(0);

        case Rec.type of
            "Activity Agency Region Type"::Activity,
            "Activity Agency Region Type"::Agency,
            "Activity Agency Region Type"::Region,
            "Activity Agency Region Type"::"Business Unit":
                CurrPage.CAPTION := StrSubstNo(Listof_Lbl, Format(Rec.Type));
            else begin
                Captions := '';
                for i := 0 to "Activity Agency Region Type".Ordinals().Count - 1 do begin
                    if i > 0 then
                        Captions := Captions + '/';
                    Captions := Captions + Format(Enum::"Activity Agency Region Type".FromInteger(i));
                end;
                CurrPage.CAPTION := StrSubstNo(Listof_Lbl, Captions);
                TypeVisible := TRUE;
            end;
        end;
    end;

    var
        TypeVisible: Boolean;
        Listof_Lbl: Label 'List of %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Liste des %1"}]}';

    local procedure ResponsableOnAfterValidate()
    begin
        Rec.CALCFIELDS("Responsible Name");
    end;


    procedure GetSelectionFilter(): Text
    var
        ActiviteAgenceRegion: Record "Activity Agency Region";

    begin
        CurrPage.SETSELECTIONFILTER(ActiviteAgenceRegion);
        EXIT(GetSelectionFilterForActiviteAgenceRegion(ActiviteAgenceRegion));

    end;

    procedure GetSelectionFilterForActiviteAgenceRegion(VAR ActiviteAgenceRegion: Record "Activity Agency Region"): Text
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        RecRef.GETTABLE(ActiviteAgenceRegion);
        EXIT(SelectionFilterManagement.GetSelectionFilter(RecRef, ActiviteAgenceRegion.FIELDNO(Name)));
    end;
}