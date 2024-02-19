tableextension 50042 "CIR Production Order" extends "Production Order"
{
    fields
    {
        field(50000; "Print count"; Integer)
        {
            Caption = 'Print count', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nbre impressions"}]}';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50080; "Dimension Value"; Code[20])
        {
            Caption = 'Dimension Value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Affaire"}]}';
            NotBlank = false;
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Dimension Set Entry"."Dimension Value Code" WHERE("Dimension Set ID" = FIELD("Dimension Set ID"), "Dimension Code" = const('AFFAIRE')));
        }
        field(50090; "Dimension Value Name"; Text[50])
        {
            Caption = 'Dimension Value Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom Affaire"}]}';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Dimension Value".Name WHERE("Dimension Code" = CONST('AFFAIRE'), Code = FIELD("Dimension Value")));
        }

        modify("Source No.")
        {
            trigger OnAfterValidate()
            var
                GeneralApplicationSetup: Record "General Application Setup";
                BinContent: Record "Bin Content";
            begin
                GeneralApplicationSetup.Get();
                BinContent.SETRANGE("Item No.", Rec."Source No.");
                BinContent.SETRANGE(Default, true);
                if BinContent.FindFirst() then
                    "Location Code" := BinContent."Location Code"
                else
                    "Location Code" := GeneralApplicationSetup."Location Code";
            end;
        }
    }
}