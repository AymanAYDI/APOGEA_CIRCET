pageextension 50041 "CIR Chart of Accounts" extends "Chart of Accounts"
{
    layout
    {
        moveafter("No."; "No. 2")
        modify("No. 2")
        {
            Visible = true;
        }
    }
}