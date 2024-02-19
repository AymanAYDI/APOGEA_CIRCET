tableextension 50030 "CIR Accounting Period" extends "Accounting Period"
{
    fields
    {
        field(50000; "Activity Closing Date"; Date)
        {
            Caption = 'Activity Closing Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de clôture activité"}]}';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ControlActivityClosingDate_Err: Label 'Activity closing date must not be less than the starting date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La date de clôture d''activité ne doit pas être inférieure à la date de début"}]}';
            begin
                IF xRec."Activity Closing Date" <> "Activity Closing Date" THEN
                    IF "Activity Closing Date" < "Starting Date" THEN
                        ERROR(ControlActivityClosingDate_Err);
            end;
        }
        field(50001; "Sales Closing Date"; Date)
        {
            Caption = 'Sales Closing Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date clôture ventes"}]}';
            DataClassification = CustomerContent;
        }
        field(50002; "Purchases Closing Date"; Date)
        {
            Caption = 'Purchases Closing Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date clôture achats"}]}';
            DataClassification = CustomerContent;
        }
        field(50003; "GL Closing Date"; Date)
        {
            Caption = 'GL Closing Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date clôture comptabilité"}]}';
            DataClassification = CustomerContent;
        }
    }
}