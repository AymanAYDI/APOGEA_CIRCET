tableextension 50024 "CIR Resource" extends Resource
{
    fields
    {
        field(50110; "Last User Modified"; Code[50])
        {
            Caption = 'Last User Modified', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Utilisateur dernière modification"}]}';
            TableRelation = User."User Name";
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    trigger OnModify()
    var
        recFixedAsset: Record "Fixed Asset";
        Immo: Boolean;
    begin
        // Test modification du code département
        IF "Global Dimension 1 Code" <> xRec."Global Dimension 1 Code" THEN BEGIN
            // Mise à jour de l'axe analytique et propagation de la modification du code département sur les écritures capacité ressources.
            ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            // Propagation de la modification du code département sur le salarié éventuellement rattaché.
            IF Salarie AND Employee.GET("No.") THEN BEGIN
                Employee."Global Dimension 1 Code" := "Global Dimension 1 Code";
                Employee.ValidateShortcutDimCode(1, Employee."Global Dimension 1 Code");
                Employee."Last Date Modified" := TODAY;
                Employee.MODIFY(FALSE);
            END;
            // Propagation de la modification du code département sur l'immobilisation éventuellement rattachée.
            IF Immo AND recFixedAsset.GET("No.") THEN BEGIN
                recFixedAsset."Global Dimension 1 Code" := "Global Dimension 1 Code";
                recFixedAsset.ValidateShortcutDimCode(1, recFixedAsset."Global Dimension 1 Code");
                recFixedAsset."Last Date Modified" := TODAY;
                recFixedAsset.MODIFY(FALSE);
            END;
            // Modification réalisée dans le cadre de l'ajout d'une fonctionnalité qui permet
            // de piloter la création ou la modification d'un salarié depuis une application externe.
            // Mise à jour écritures capacité ressources
            ResCapacityEntry.SETCURRENTKEY("Resource No.", Date);
            ResCapacityEntry.SETRANGE("Resource No.", "No.");
            ResCapacityEntry.MODIFYALL(ResCapacityEntry."Global Dimension 1 Code", "Global Dimension 1 Code");
        END;
        // Test modification du code dossier
        IF "Global Dimension 2 Code" <> xRec."Global Dimension 2 Code" THEN BEGIN
            // Mise à jour de l'axe analytique
            ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            // Propagation de la modification du code dossier sur le salarié éventuellement rattaché.
            IF Salarie AND Employee.GET("No.") THEN BEGIN
                Employee."Global Dimension 2 Code" := "Global Dimension 2 Code";
                Employee.ValidateShortcutDimCode(2, Employee."Global Dimension 2 Code");
                Employee."Last Date Modified" := TODAY;
                Employee.MODIFY(FALSE);
            END;
            // Propagation de la modification du code dossier sur l'immobilisation éventuellement rattachée.
            IF Immo AND recFixedAsset.GET("No.") THEN BEGIN
                recFixedAsset."Global Dimension 2 Code" := "Global Dimension 2 Code";
                recFixedAsset.ValidateShortcutDimCode(2, recFixedAsset."Global Dimension 2 Code");
                recFixedAsset."Last Date Modified" := TODAY;
                recFixedAsset.MODIFY(FALSE);
            END;
        END;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Resource, "No.", FieldNumber, ShortcutDimCode);

        // Propagation de la modification du code département sur les écritures capacité ressources.
        IF FieldNumber = 1 THEN BEGIN
            ResCapacityEntry.RESET();
            ResCapacityEntry.SETCURRENTKEY("Resource No.", Date);
            ResCapacityEntry.SETRANGE("Resource No.", "No.");
            ResCapacityEntry.SETFILTER(Date, '>=%1', WORKDATE());
            IF ResCapacityEntry.FindFirst() THEN
                ResCapacityEntry.MODIFYALL(ResCapacityEntry."Global Dimension 1 Code", ShortcutDimCode);
        END;
    end;

    var
        ResCapacityEntry: Record "Res. Capacity Entry";
        Employee: Record Employee;
        DimMgt: Codeunit DimensionManagement;
        Salarie: Boolean;
}