tableextension 50022 "CIR Reminder/Fin. Charge Entry" extends "Reminder/Fin. Charge Entry"
{
    keys
    {
        key(SK20; "Document No.")
        {
            SumIndexFields = "Reminder Level";
        }
    }
}