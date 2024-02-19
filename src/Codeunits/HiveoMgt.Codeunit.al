codeunit 50009 "Hiveo Mgt."
{
    internal procedure InitInvitation(piVendor: Code[20]): Text[250]
    var
        Vendor: Record "Vendor";
        MissingVendor_Err: Label 'Err : Unknown Vendor', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : fournisseur inconnu"}]}';
        MissingSubContractor_Err: Label 'Err : Unknown Subcontractor', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : sous-traitant inconnu"}]}';
    begin
        // Test existence du fournisseur
        IF NOT Vendor.GET(piVendor) THEN EXIT(MissingVendor_Err);

        // Test existence du sous-traitant
        IF NOT Vendor.Subcontractor THEN EXIT(MissingSubContractor_Err);

        // Enregistrement de l'invitation
        Vendor.HIVEO := TRUE;
        Vendor."Invitation Hiveo" := Vendor."Invitation Hiveo"::Treated;
        Vendor.MODIFY(TRUE);
    end;

    internal procedure InitBlockVendor(piVendor: Code[20]; Blocked: enum "Vendor Blocked"): Text[250]
    var
        Vendor: Record Vendor;
        Company: Record Company;
        MissingVendor_Err: Label 'Err : Unknown Vendor', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : fournisseur inconnu"}]}';
        BlockedStatus_Err: Label 'Err : invalid Status', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : statut invalide"}]}';
    begin
        // Test existence du fournisseur
        IF NOT Vendor.GET(piVendor) THEN EXIT(MissingVendor_Err);

        IF (Blocked.AsInteger() > Blocked::All.AsInteger()) AND (Blocked.AsInteger() < Blocked::Order.AsInteger()) THEN EXIT(BlockedStatus_Err);
        IF (Blocked.AsInteger() > Blocked::Order.AsInteger()) OR (Blocked.AsInteger() < Blocked::" ".AsInteger()) THEN EXIT(BlockedStatus_Err);

        // Initialisation du statut de blocage du fournisseur
        Vendor.Blocked := Blocked;
        Vendor."Last Date Modified" := TODAY;
        Vendor.MODIFY(FALSE);

        // Mise à jour du blocage sur les autre sociétés.
        Company.SETFILTER(name, '<>%1', Company.Name);
        IF Company.FINDSET() then
            REPEAT
                Vendor.CHANGECOMPANY(Company.Name);
                IF Vendor.GET(piVendor) THEN BEGIN
                    vendor.Blocked := Blocked;
                    Vendor."Last Date Modified" := TODAY;
                    vendor.MODIFY(FALSE);
                END;
            UNTIL Company.NEXT() = 0;
        EXIT;
    end;
}