codeunit 50022 "Assembly Mgt."
{
    //Désactivation du calcul de la disponibilité à l'ouverture de l'ordre d'assemblage
    [EventSubscriber(ObjectType::Table, Database::"Assembly Line", 'OnBeforeUpdateAvailWarning', '', false, false)]
    local procedure OnBeforeUpdateAvailWarning(var AssemblyLine: Record "Assembly Line"; var Result: Boolean; var IsHandled: Boolean);
    begin
        // Désactivation de la fonction de calcul de disponibilité car problème de performance à l'ouverture de la page.
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Assemble-to-Order Link", 'OnBeforeAsmHeaderModify', '', false, false)]
    local procedure OnBeforeAsmHeaderModify_AssigAssemblyFields(var AssemblyHeader: Record "Assembly Header"; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        IF AssemblyHeader."Assembly to Order No." <> '' THEN
            EXIT;

        if SalesHeader.Get(SalesHeader."Document Type"::Order, SalesLine."Document No.") then begin
            AssemblyHeader.Description := SalesLine.Description;
            AssemblyHeader."Job No." := SalesLine."Job No.";
            AssemblyHeader."Shipping Agent Code" := SalesHeader."Shipping Agent Code";
            AssemblyHeader."Customer Name" := SalesHeader."Sell-to Customer No.";
            AssemblyHeader."Assembly to Order No." := SalesHeader."No.";
            AssemblyHeader."Assembly to Order Line No." := SalesLine."Line No.";
            AssemblyHeader."Your Reference" := SalesHeader."Your Reference";
            AssemblyHeader."Site Code" := SalesHeader."Site Code";

            UpdateBusinnessInfoOnAssemblyHeader(AssemblyHeader, SalesHeader."Dimension Set ID");
        end;
    end;

    internal procedure UpdateBusinnessInfoOnAssemblyHeader(var AssemblyHeader: Record "Assembly Header"; DimensionSetID: Integer);
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        GetGeneralApplicationSetup();
        IF (GeneralApplicationSetup."Business Dimension Code" = '') then
            EXIT;

        IF DimensionSetEntry.GET(DimensionSetID, GeneralApplicationSetup."Business Dimension Code") THEN BEGIN
            AssemblyHeader."Business" := DimensionSetEntry."Dimension Value Code";
            DimensionSetEntry.CalcFields("Dimension Value Name");
            AssemblyHeader."Business name" := DimensionSetEntry."Dimension Value Name";
        end else begin
            AssemblyHeader."Business" := '';
            AssemblyHeader."Business name" := '';
        end;
    end;

    local procedure GetGeneralApplicationSetup();
    begin
        if GeneralApplicationSetup.Get() then;
    end;

    internal procedure RefreshTotalFieldsAssembly(var AssemblyHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
    begin
        SetLinkToLines(AssemblyHeader, AssemblyLine);
        if not AssemblyLine.IsEmpty() then begin
            AssemblyLine.SetLoadFields("Weight of line", "Unit Cost", "Cost Amount", "Quantity per");
            AssemblyLine.FindSet();
            AssemblyHeader."Unit Cost" := 0;
            AssemblyHeader."Cost Amount" := 0;
            if not AssemblyHeader.ChangeTotalWeight then
                AssemblyHeader."Total weight" := 0;
            repeat
                if not AssemblyHeader.ChangeTotalWeight then
                    AssemblyHeader."Total weight" += AssemblyLine."Weight of line";
                AssemblyHeader."Unit Cost" += AssemblyLine."Unit Cost" * AssemblyLine."Quantity per";
                AssemblyHeader."Cost Amount" += AssemblyLine."Cost Amount";
            until AssemblyLine.Next() = 0;
        end;
    end;

    internal procedure RefreshUnitAndAmountCostLines(var AssemblyHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
        Item: Record Item;
    begin
        SetLinkToLines(AssemblyHeader, AssemblyLine);
        if not AssemblyLine.IsEmpty() then begin
            AssemblyLine.FindSet();
            repeat
                IF (AssemblyLine."Reserved Quantity" = 0) THEN  //Pas de mise à jour si quantité déjà réservée
                    if Item.Get(AssemblyLine."No.") then begin
                        AssemblyLine."Unit Cost" := Item."Unit Cost";
                        AssemblyLine."Cost Amount" := Item."Unit Cost" * AssemblyLine."Quantity per";
                        AssemblyLine.Modify();
                    end;
            until AssemblyLine.Next() = 0;
        end;
    end;

    internal procedure UpdateWarningOnLines(AsmHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        IsHandled: boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateWarningOnLines(AsmHeader, IsHandled);

        if IsHandled then
            exit;

        SetLinkToLines(AsmHeader, AssemblyLine);
        if AssemblyLine.FindSet() then
            repeat
                AssemblyLine."Avail. Warning" := false;
                if AssemblyLine.Type = AssemblyLine.Type::Item then
                    AssemblyLine."Avail. Warning" := ItemCheckAvail.AsmOrderLineShowWarning(AssemblyLine);
                AssemblyLine.modify();
            until AssemblyLine.Next() = 0;
    end;

    local procedure SetLinkToLines(AsmHeader: Record "Assembly Header"; var AssemblyLine: Record "Assembly Line")
    begin
        AssemblyLine.SetRange("Document Type", AsmHeader."Document Type");
        AssemblyLine.SetRange("Document No.", AsmHeader."No.");
    end;

    internal procedure SetAddressInformations(var AssemblyHeader: Record "Assembly Header"; ShiptoAddress: Record "Ship-to Address")
    begin
        AssemblyHeader."Ship-to Code" := ShiptoAddress.Code;
        AssemblyHeader."Ship-to Name" := ShiptoAddress.Name;
        AssemblyHeader."Ship-to Name 2" := ShiptoAddress."Name 2";
        AssemblyHeader."Ship-to Address" := ShiptoAddress.Address;
        AssemblyHeader."Ship-to Address 2" := ShiptoAddress."Address 2";
        AssemblyHeader."Ship-to City" := ShiptoAddress.City;
        AssemblyHeader."Ship-to Post Code" := ShiptoAddress."Post Code";
        AssemblyHeader."Shipping Agent Code" := ShiptoAddress."Shipping Agent Code";
    end;

    internal Procedure SetLineFieldstInformation(var AssemblyLine: record "Assembly Line")
    var
        Item: Record Item;
    begin
        if AssemblyLine.Type = AssemblyLine.Type::Item then
            if Item.Get(AssemblyLine."No.") then begin
                Item.CalcFields(Inventory, "Substitutes Exist");
                AssemblyLine."Qty Physical Stock" := Item.Inventory;
                AssemblyLine."Substitutes Exist" := Item."Substitutes Exist";
                AssemblyLine."Unit Net Weight" := Item."Net Weight";
                AssemblyLine."Weight of line" := Item."Net Weight" * AssemblyLine.Quantity;
            end;
    end;

    internal procedure ExplodeBOM(AssemblyHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
        BOMComponent: Record "BOM Component";
        AssemblyLineManagement: Codeunit "Assembly Line Management";
    begin
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        if AssemblyLine.FindSet(false, false) then
            repeat
                BOMComponent.SetRange("Parent Item No.", AssemblyLine."No.");
                if not BOMComponent.IsEmpty() then
                    AssemblyLineManagement.ExplodeAsmList(AssemblyLine);
            until AssemblyLine.Next() = 0;
    end;

    internal procedure ChangeNoAssemblyOrder(SalesLine: Record "Sales Line")
    var
        AssembletoOrderLinkToDelete: Record "Assemble-to-Order Link";
        AssembletoOrderLink: Record "Assemble-to-Order Link";
        AssemblyHeaderToDelete: Record "Assembly Header";
        AssemblyHeader: Record "Assembly Header";
        ReservationEntry: Record "Reservation Entry";
    begin
        AssembletoOrderLinkToDelete.SetCurrentKey(Type, "Document Type", "Document No.", "Document Line No.");
        AssembletoOrderLinkToDelete.SetRange(Type, AssembletoOrderLinkToDelete.Type::Sale);
        AssembletoOrderLinkToDelete.SetRange("Document Type", SalesLine."Document Type");
        AssembletoOrderLinkToDelete.SetRange("Document No.", SalesLine."Document No.");
        AssembletoOrderLinkToDelete.SetRange("Document Line No.", SalesLine."Line No.");
        if AssembletoOrderLinkToDelete.FindFirst() then
            if AssemblyHeaderToDelete.Get(AssembletoOrderLinkToDelete."Assembly Document Type", AssembletoOrderLinkToDelete."Assembly Document No.") then begin
                AssemblyHeader.TransferFields(AssemblyHeaderToDelete);
                AssemblyHeader."No." := SalesLine."NAV Assembly Order No.";
                AssemblyHeader.Insert();
                AssembletoOrderLink.TransferFields(AssembletoOrderLinkToDelete);
                AssembletoOrderLink."Assembly Document No." := AssemblyHeader."No.";
                AssembletoOrderLink.Insert();
                ReservationEntry.SetRange("Source ID", AssemblyHeaderToDelete."No.");
                ReservationEntry.SetRange("Source Type", Database::"Assembly Header");
                ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type");
                ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
                if ReservationEntry.FindFirst() then begin
                    ReservationEntry."Source ID" := SalesLine."NAV Assembly Order No.";
                    ReservationEntry.Modify();
                end;
                AssembletoOrderLinkToDelete.Delete();
                AssemblyHeaderToDelete.Delete();
            end;
    end;

    internal procedure ChangeBinCode(AssemblyHeader: Record "Assembly Header")
    begin
        UpdateBinAssemblyHeader(AssemblyHeader);
        UpdateBinAssemblyLines(AssemblyHeader);
        AssemblyHeader.CalcFields("Assemble to Order");
        if AssemblyHeader."Assemble to Order" then
            UpdateSalesLineFromAssemblyHeader(AssemblyHeader);
        UpdateWarehouseActivityLineBin(AssemblyHeader);
    end;

    local procedure UpdateBinAssemblyHeader(AssemblyHeader: Record "Assembly Header")
    begin
        AssemblyHeader."Bin Code" := AssemblyHeader."New Bin Code";
        AssemblyHeader.Modify();
    end;

    local procedure UpdateBinAssemblyLines(AssemblyHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
    begin
        AssemblyLine.Reset();
        AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        if not Assemblyline.IsEmpty then begin
            AssemblyLine.FindSet();
            AssemblyLine.ModifyAll("Bin Code", AssemblyHeader."New Bin Code");
        end;
    end;

    local procedure UpdateSalesLineFromAssemblyHeader(AssemblyHeader: Record "Assembly Header")
    var
        SalesLine: Record "Sales Line";
        AssembletoOrderLink: Record "Assemble-to-Order Link";
    begin
        AssembletoOrderLink.SetRange("Assembly Document No.", AssemblyHeader."No.");
        AssembletoOrderLink.SetRange(Type, AssembletoOrderLink.Type::Sale);
        AssembletoOrderLink.SetRange("Document Type", AssembletoOrderLink."Document Type"::Order);
        AssembletoOrderLink.SetRange("Document No.", AssemblyHeader."Assembly to Order No.");
        if AssembletoOrderLink.FindFirst() then
            if SalesLine.Get(SalesLine."Document Type"::Order, AssemblyHeader."Assembly to Order No.", AssembletoOrderLink."Document Line No.") then begin
                SalesLine."Bin Code" := AssemblyHeader."New Bin Code";
                SalesLine.Modify(true);
            end;
    end;

    internal procedure UpdateAssemblyHeaderFromSalesLine(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    var
        AssemblyHeader: Record "Assembly Header";
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        GetGeneralApplicationSetup();
        IF (GeneralApplicationSetup."Business Dimension Code" = '') then
            EXIT;

        AssemblyHeader.SETRANGE("Assembly to Order No.", SalesLine."Document No.");
        AssemblyHeader.SETRANGE("Assembly to Order Line No.", SalesLine."Line No.");
        IF AssemblyHeader.FindFirst() then begin
            if DimensionSetEntry.Get(SalesLine."Dimension Set ID", GeneralApplicationSetup."Business Dimension Code") then;

            IF (DimensionSetEntry."Dimension Value Code" <> AssemblyHeader.Business) THEN BEGIN
                AssemblyHeader.VALIDATE(Business, DimensionSetEntry."Dimension Value Code");
                DimensionSetEntry.CalcFields("Dimension Value Name");
                AssemblyHeader.VALIDATE("Business Name", DimensionSetEntry."Dimension Value Name");
                AssemblyHeader.MODIFY(true);
            END;
        end;
    end;

    local procedure UpdateWarehouseActivityLineBin(AssemblyHeader: Record "Assembly Header")
    var
        WarehouseActivityLine: Record "Warehouse Activity Line";
    begin
        WarehouseActivityLine.SetRange("Source Type", Database::"Assembly Line");
        WarehouseActivityLine.SetRange("Source Subtype", WarehouseActivityLine."Source Subtype"::"1");
        WarehouseActivityLine.SetRange("Source No.", AssemblyHeader."No.");
        WarehouseActivityLine.SetRange("Action Type", WarehouseActivityLine."Action Type"::Place);
        if WarehouseActivityLine.FindSet() then
            WarehouseActivityLine.ModifyAll("Bin Code", AssemblyHeader."New Bin Code");
    end;

    internal procedure UpdateBusinessNameOnAssemblyHeader(ShorCutDimension3Code: Code[20]; Description: Text[50])
    var
        AssemblyHeader: Record "Assembly Header";
    begin
        AssemblyHeader.SETRANGE("Business", ShorCutDimension3Code);
        AssemblyHeader.MODIFYALL("Business name", Description);
    end;

    var
        GeneralApplicationSetup: Record "General Application Setup";


    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateWarningOnLines(var AssemblyHeader: Record "Assembly Header"; var IsHandled: Boolean)
    begin
    end;
}