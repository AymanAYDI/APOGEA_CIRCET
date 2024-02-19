pageextension 50062 "CIR Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. ';
            }
        }
        addafter("Sell-to Customer Name")
        {
            field(ARBVRNJobNo; Rec.ARBVRNJobNo)
            {
                ToolTip = 'Specifies the number of the related job.';
                ApplicationArea = All;
            }
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
    }
}