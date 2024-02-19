pageextension 50501 "CIR G/L Registers" extends "G/L Registers"
{
    trigger OnOpenPage()
    begin
        Rec.SetFilter("No.", '>0');
    end;
}