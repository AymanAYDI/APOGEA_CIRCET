tableextension 50037 "CIR Requisition Line" extends "Requisition Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if (Item.Get("No.")) and (GeneralApplicationSetup.Get()) then begin
                    GeneralApplicationSetup.TestField("Location Code");
                    if (Item."Business Code by Default") then
                        Validate("Location Code", GeneralApplicationSetup."Location Code");
                end;
            end;
        }
    }

    var
        GeneralApplicationSetup: Record "General Application Setup";
}