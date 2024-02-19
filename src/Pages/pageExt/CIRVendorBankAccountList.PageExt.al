pageextension 50061 "CIR Vendor Bank Account List" extends "Vendor Bank Account List"
{
    layout
    {
        modify(IBAN)
        {
            visible = true;
        }
        modify("SWIFT Code")
        {
            visible = true;
        }
    }
}