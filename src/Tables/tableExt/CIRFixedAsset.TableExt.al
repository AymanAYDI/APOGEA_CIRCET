tableextension 50038 "CIR Fixed Asset" extends "Fixed Asset"
{
    fields
    {
        field(50000; "Job No."; Code[20])
        {
            Caption = 'Job No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° projet"}]}';
            TableRelation = Job."No." WHERE(ARBCIRFRJobStatus = filter(<> Completed & <> "Completed/Invoiced"));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                JobMgt: Codeunit "Job Mgt.";
            begin
                if Rec."Job No." <> xRec."Job No." then
                    JobMgt.UpdateDefaultDimension(Rec);
            end;
        }
    }
}