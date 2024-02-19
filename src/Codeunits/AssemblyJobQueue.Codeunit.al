codeunit 50030 "Assembly Job Queue"
{
    trigger OnRun()
    var
        AssemblyHeader: Record "Assembly Header";
        AssemblyMgt: Codeunit "Assembly Mgt.";
    begin
        if AssemblyHeader.FindSet() then
            repeat
                AssemblyMgt.RefreshUnitAndAmountCostLines(AssemblyHeader);
                AssemblyMgt.RefreshTotalFieldsAssembly(AssemblyHeader);
                AssemblyMgt.UpdateWarningOnLines(AssemblyHeader);       // Génération du calcul de disponibilité
                AssemblyHeader.Modify();
            until AssemblyHeader.next() = 0;
    end;
}