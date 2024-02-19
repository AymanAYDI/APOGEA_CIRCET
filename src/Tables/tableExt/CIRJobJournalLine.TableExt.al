tableextension 50027 "CIR Job Journal Line" extends "Job Journal Line"
{
    fields
    {
        field(50000; "Start Date"; Date)
        {
            Caption = 'Start Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date début" }, { "lang": "FRB", "txt": "Date début"  } ] }';
            DataClassification = CustomerContent;
        }
    }
}