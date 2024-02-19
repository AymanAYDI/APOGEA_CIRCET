tableextension 50050 "CIR Bank Account Ledger Entry" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50000; "Value Date"; Date)
        {
            Caption = 'Value Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de valeur"}]}';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Bank Acc. Reconciliation Line"."Value Date" WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                        "Statement No." = FIELD("Statement No.")));
        }
    }
    keys
    {
        key(CIRKey1; Amount)
        {
        }
        key(CIRKey2; "Reason Code")
        {
        }
    }
}