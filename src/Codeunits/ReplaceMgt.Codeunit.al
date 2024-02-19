codeunit 50033 "Replace Mgt"
{
    internal procedure FindAndReplace(var vRecordRef: RecordRef; IntPFieldNo: Integer)
    var
        Replace: Page Replace;
        IntLFieldNo: Integer;
    begin
        IntLFieldNo := IntPFieldNo;
        while true do begin
            Replace.Set(vRecordRef, IntLFieldNo);
            if Replace.RunModal() = Action::OK then begin
                Replace.ReplaceValues();
                exit;
            end else begin
                if not Replace.Again() then
                    exit;
                IntLFieldNo := Replace.CurrFieldNo();
                Clear(Replace);
            end;
        end;
    end;
}