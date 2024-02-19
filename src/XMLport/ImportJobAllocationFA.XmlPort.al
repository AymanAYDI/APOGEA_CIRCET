xmlport 50006 "Import Job Allocation FA"
{
    Caption = 'Import Job Allocation FA', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import projet attribution immo"}]}';
    Direction = Import;
    TextEncoding = UTF8;
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';
                SourceTableView = SORTING(Number)
                                  ORDER(Ascending)
                                  WHERE(Number = FILTER(>= 0));
                textelement(inFA)
                {
                }
                textelement(inJob)
                {
                }

                trigger OnPreXmlItem()
                begin
                    // Reset du nombre de lignes importées
                    nbreLigne := 0;
                end;

                trigger OnAfterInitRecord()
                begin
                    // Reset des variables d'import
                    inFA := '';
                    inJob := '';
                end;

                trigger OnBeforeInsertRecord()
                var
                    recFA: Record "Fixed Asset";
                    recJob: Record "Job";
                    recRes: Record "Resource";
                    DimMgt: Codeunit "DimensionManagement";
                    FixedAsset_Err: Label 'Line %1 : Unspecified fixed asset', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Immobilisation non spécifiée"}]}';
                    JobAllocation_Err: Label 'Line %1 : Job Allocation not specified', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Projet d''attribution non spécifié"}]}';
                    FAErrorLength_Err: Label 'Line %1 : Length Fixed Asset No. > %2 chars', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Longueur N° immobilisation > %2 caractères"}]}';
                    JobErrorLength_Err: Label 'Line %1 : Job No. length > %2 chars', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Longueur N° projet > %2 caractères"}]}';
                    FixedAssetUnknown_Err: Label 'Line %1 : Fixed Asset %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : immobilisation %2 inconnue"}]}';
                    JobUnknown_Err: Label 'Line %1 : Job %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : projet %2 inconnu"}]}';
                    JobAlreadyClosed_Err: Label 'Line %1 : Job %2 closed', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : projet %2 clôturé"}]}';
                begin
                    // Incrémentation du nombre de lignes importées
                    nbreLigne += 1;

                    // Test validité des données
                    IF inFA = '' THEN
                        ERROR(FixedAsset_Err, nbreLigne);

                    IF inJob = '' THEN
                        ERROR(JobAllocation_Err, nbreLigne);

                    IF STRLEN(inFA) > MAXSTRLEN(recFA."No.") THEN
                        ERROR(FAErrorLength_Err, nbreLigne, MAXSTRLEN(recFA."No."));

                    IF STRLEN(inJob) > MAXSTRLEN(recJob."No.") THEN
                        ERROR(JobErrorLength_Err, nbreLigne, MAXSTRLEN(recJob."No."));

                    // Test existence de l'immobilisation
                    IF NOT recFA.GET(inFA) THEN
                        ERROR(FixedAssetUnknown_Err, nbreLigne, inFA);

                    // Test existence du projet
                    IF NOT recJob.GET(inJob) THEN
                        ERROR(JobUnknown_Err, nbreLigne, inJob);

                    // Test clôture du projet
                    IF recJob.ARBCIRFRJobStatus <> recJob.ARBCIRFRJobStatus::Active THEN
                        ERROR(JobAlreadyClosed_Err, nbreLigne, inJob);

                    // Initialisation du projet d'affectation de l'immobilisation
                    recFA.VALIDATE("Job No.", inJob);

                    // Mise à jour de l'axe analytique de l'immobilisation
                    DimMgt.ValidateDimValueCode(1, recFA."Global Dimension 1 Code");
                    DimMgt.SaveDefaultDim(DATABASE::"Fixed Asset", recFA."No.", 1, recFA."Global Dimension 1 Code");

                    // Actualisation de la date de dernière modification de l'immobilisation
                    recFA."Last Date Modified" := TODAY;

                    // Sauvegarde des modifications de l'immobilisation
                    recFA.MODIFY(FALSE);

                    // Propagation de la modification du code département sur la ressource
                    //                   éventuellement rattachée.
                    IF recRes.GET(inFA) THEN BEGIN
                        recRes."Global Dimension 1 Code" := recFA."Global Dimension 1 Code";
                        recRes.ValidateShortcutDimCode(1, recRes."Global Dimension 1 Code");
                        recRes."Last Date Modified" := TODAY;
                        recRes."Last User Modified" := CopyStr(USERID, 1, MaxStrLen(recRes."Last User Modified"));
                        recRes.MODIFY(FALSE);
                    END;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    var
        ImportComplete_Msg: Label 'Import Complete', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import terminé"}]}';
    begin
        MESSAGE(ImportComplete_Msg);
    end;

    var
        nbreLigne: Integer;
}