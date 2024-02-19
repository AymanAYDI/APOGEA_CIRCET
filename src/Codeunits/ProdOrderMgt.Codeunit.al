codeunit 50031 "Prod. Order Mgt."
{
    [EventSubscriber(ObjectType::Codeunit, CODEUNIT::"Prod. Order Status Management", 'OnAfterChangeStatusOnProdOrder', '', false, false)]
    local procedure OnAfterChangeStatusOnProdOrder(var ProdOrder: Record "Production Order"; var ToProdOrder: Record "Production Order"; NewStatus: Enum "Production Order Status"; NewPostingDate: Date; NewUpdateUnitCost: Boolean)
    begin
        if NewStatus in [NewStatus::Released, NewStatus::Finished] then
            ExecuteProductionFollowUP(ToProdOrder."No.", false, false);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Refresh Production Order", 'OnAfterRefreshProdOrder', '', false, false)]
    local procedure OnAfterRefreshProdOrder(var ProductionOrder: Record "Production Order"; ErrorOccured: Boolean)
    begin
        if not ErrorOccured then
            if ProductionOrder.Status in [ProductionOrder.Status::Released, ProductionOrder.Status::Finished] then
                ExecuteProductionFollowUP(ProductionOrder."No.", false, false);
    end;

    internal procedure ExecuteProductionFollowUP(ProdOrderNo: Code[20]; pRequestWindows: Boolean; pSystemPrinter: Boolean)
    var
        ProductionOrder: Record "Production Order";
    begin
        ProductionOrder.SetFilter("No.", ProdOrderNo);
        Report.RUN(REPORT::"CIR Production Follow UP", pRequestWindows, pSystemPrinter, ProductionOrder);
    end;
}