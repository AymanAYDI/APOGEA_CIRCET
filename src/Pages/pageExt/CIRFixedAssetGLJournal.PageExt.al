pageextension 50069 "CIR Fixed Asset G/L Journal" extends "Fixed Asset G/L Journal"
{
    layout
    {
        modify(ARBVRNJobNo)
        {
            Visible = false;
            Editable = false;
        }
        modify(ARBVRNJobTaskNo)
        {
            Visible = false;
            Editable = false;
        }
    }
}