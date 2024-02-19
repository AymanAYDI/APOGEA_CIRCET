xmlport 50005 "Import Asset"
{
    Direction = Import;
    FieldSeparator = ';';
    Format = VariableText;
    Caption = 'Asset import', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import immobilisation"}]}';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(root)
        {
            tableelement(IntegerTable; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';
                SourceTableView = SORTING(Number)
                                  ORDER(Ascending)
                                  WHERE(Number = FILTER(>= 1));

                textelement(Serie)
                {
                }
                textelement(No)
                {
                }
                textelement(OldNo)
                {
                }
                textelement(Description)
                {
                }
                textelement(Description2)
                {
                }
                textelement(Brand)
                {
                }
                textelement(ResourceValue)
                {
                }
                textelement(inClasse)
                {
                }
                textelement(SubClasse)
                {
                }
                textelement(Bin)
                {
                }
                textelement(ProjectAttribution)
                {
                }
                textelement(SerieNo)
                {
                }
                textelement(HardwareIndicatorInfor)
                {
                }
                textelement(DepreciationLaw)
                {
                }
                textelement(inGrpCpta)
                {
                }
                textelement(DepreciationStartDate)
                {
                }
                textelement(NbrYearAmortization)
                {
                }

                trigger OnAfterInitRecord()
                begin
                    // Reset des variables d'import
                    Serie := '';
                    No := '';
                    OldNo := '';
                    Description := '';
                    Description2 := '';
                    Brand := '';
                    ResourceValue := '';
                    inClasse := '';
                    SubClasse := '';
                    Bin := '';
                    ProjectAttribution := '';
                    SerieNo := '';
                    HardwareIndicatorInfor := '';
                    DepreciationLaw := '';
                    inGrpCpta := '';
                    DepreciationStartDate := '';
                    NbrYearAmortization := '';
                end;

                trigger OnBeforeInsertRecord()
                var
                    NoSerie: Record "No. Series";
                    FixedAsset: Record "Fixed Asset";
                    Resource: Record "Resource";
                    FAClass: Record "FA Class";
                    FASubClass: Record "FA Subclass";
                    FALocation: Record "FA Location";
                    Job: Record "Job";
                    DepreciationBook: Record "Depreciation Book";
                    FAPostGrp: Record "FA Posting Group";
                    FADeprecBook: Record "FA Depreciation Book";
                    FASetup: Record "FA Setup";
                    NoSeriesMngt: Codeunit NoSeriesManagement;
                    DimensionMngt: Codeunit DimensionManagement;
                    HardIndicInfoValue: Boolean;
                    DepreciatStartDateValue: Date;
                    NbrYearAmortValue: Decimal;
                begin
                    // Incrémentation du nombre de lignes importées
                    nbrLine += 1;

                    // Test validité du format des paramètres de type binaire
                    // Matériel informatique
                    HardIndicInfoValue := FALSE;
                    IF HardwareIndicatorInfor <> '' THEN
                        IF NOT EVALUATE(HardIndicInfoValue, HardwareIndicatorInfor) THEN
                            ERROR(ErrHardwareIndicatorLbl, nbrLine, HardwareIndicatorInfor);

                    // Test validité du format des paramètres de type date
                    // Date de début d'amortissement
                    DepreciatStartDateValue := 0D;
                    IF DepreciationStartDate <> '' THEN
                        IF NOT EVALUATE(DepreciatStartDateValue, DepreciationStartDate) THEN
                            ERROR(ErrInDateDebutAmortLbl, nbrLine, DepreciationStartDate);

                    // Test validité du format des paramètres de type numérique
                    // Nbre d'années d'amortissement
                    NbrYearAmortValue := 0;
                    IF NbrYearAmortization <> '' THEN
                        IF NOT EVALUATE(NbrYearAmortValue, NbrYearAmortization) THEN
                            ERROR(ErrStartDateDepreciatLbl, nbrLine, NbrYearAmortization);

                    // Initialisation de la souche à sa valeur par défaut en l'absence de valeur
                    IF Serie = '' THEN BEGIN
                        FASetup.INIT();
                        IF FASetup.GET() THEN;
                        Serie := FASetup."Fixed Asset Nos.";
                    END;

                    // Test validité des données

                    // Souche
                    IF NOT NoSerie.GET(Serie) THEN
                        ERROR(ErrUnknownStrainLbl, nbrLine, Serie);

                    // Immobilisation
                    IF FixedAsset.GET(No) THEN
                        ERROR(ErrFixedAssetLbl, nbrLine, No);

                    // Responsable
                    IF ResourceValue <> '' THEN
                        IF Resource.GET(ResourceValue) THEN BEGIN
                            IF Resource.Blocked THEN
                                ERROR(ErrManagerBlokedLbl, nbrLine, ResourceValue)
                        END ELSE
                            ERROR(ErrManagerNotExistLbl, nbrLine, ResourceValue);

                    // Classe d'immobilisation
                    IF (inClasse <> '') AND (NOT FAClass.GET(inClasse)) THEN
                        ERROR(ErrUnknownClassLbl, nbrLine, inClasse);

                    // Sous-classe d'immobilisation
                    IF (SubClasse <> '') THEN
                        IF NOT FASubClass.GET(SubClasse) THEN
                            ERROR(ErrUnknownSubClassLbl, nbrLine, SubClasse)
                        ELSE
                            IF (inClasse <> '') AND
                               (FASubClass."FA Class Code" <> '') AND
                               (FASubClass."FA Class Code" <> inClasse) THEN
                                ERROR(ErrSubclassIncompatibleLbl, nbrLine, SubClasse, inClasse);

                    // Emplacement immobilisation
                    IF (Bin <> '') AND (NOT FALocation.GET(Bin)) THEN
                        ERROR(ErrUnknownAssetLocatLbl, nbrLine, Bin);

                    // Projet attribution
                    Job.INIT();
                    IF (ProjectAttribution <> '') THEN
                        IF NOT Job.GET(ProjectAttribution) THEN
                            ERROR(ErrProjectUnknownLbl, nbrLine, ProjectAttribution);


                    // Loi amortissement
                    IF (DepreciationLaw <> '') AND (NOT DepreciationBook.GET(DepreciationLaw)) THEN
                        ERROR(ErrUnknownDampingLawLbl, nbrLine, DepreciationLaw);

                    // Groupe compta.
                    IF (inGrpCpta <> '') AND (NOT FAPostGrp.GET(inGrpCpta)) THEN
                        ERROR(ErrAccountAssetUnknownLbl, nbrLine, inGrpCpta);

                    // Test spécification d'un nombre d'années d'amortissement positif ou nul
                    IF NbrYearAmortValue < 0 THEN
                        ERROR(ErrNbrYearDepreciationLbl, nbrLine);

                    // Création de l'immobilisation
                    FixedAsset.RESET();
                    FixedAsset.INIT();
                    IF No = '' THEN
                        NoSeriesMngt.InitSeries(Serie, '', 0D, FixedAsset."No.", FixedAsset."No. Series")
                    ELSE BEGIN
                        // Numérotation imposée
                        FixedAsset."No." := No;
                        FixedAsset."No. Series" := Serie;
                    END;
                    FixedAsset.VALIDATE(Description, Description);
                    FixedAsset.VALIDATE("Description 2", Description2);
                    IF inClasse <> '' THEN
                        FixedAsset.VALIDATE("FA Class Code", inClasse);
                    IF SubClasse <> '' THEN
                        FixedAsset.VALIDATE("FA Subclass Code", SubClasse);
                    IF Bin <> '' THEN
                        FixedAsset.VALIDATE("FA Location Code", Bin);

                    FixedAsset.VALIDATE("Responsible Employee", ResourceValue);
                    FixedAsset.VALIDATE("Serial No.", SerieNo);
                    FixedAsset.VALIDATE("Last Date Modified", TODAY);
                    FixedAsset.INSERT(FALSE);
                    DimensionMngt.ValidateDimValueCode(1, FixedAsset."Global Dimension 1 Code");
                    DimensionMngt.SaveDefaultDim(DATABASE::"Fixed Asset", FixedAsset."No.", 1, FixedAsset."Global Dimension 1 Code");

                    FixedAsset.VALIDATE("Job No.", ProjectAttribution);
                    FixedAsset.MODIFY(FALSE);

                    // Création de la loi d'amortissement associée à l'immobilisation
                    IF (DepreciationLaw <> '') AND
                        (inGrpCpta <> '') AND
                        (DepreciatStartDateValue <> 0D) THEN BEGIN
                        FADeprecBook.RESET();
                        FADeprecBook.INIT();
                        FADeprecBook."FA No." := FixedAsset."No.";
                        FADeprecBook."Depreciation Book Code" := DepreciationLaw;
                        FADeprecBook.INSERT(TRUE);
                        FADeprecBook.VALIDATE("FA Posting Group", inGrpCpta);
                        FADeprecBook.VALIDATE("Depreciation Starting Date", DepreciatStartDateValue);
                        FADeprecBook.VALIDATE("No. of Depreciation Years", NbrYearAmortValue);
                        FADeprecBook.MODIFY(TRUE);
                    END;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        // Notification fin du traitement
        MESSAGE(MessendOfTreatmentLbl);
    end;

    trigger OnPreXmlPort()
    begin
        // Reset du nombre de lignes importées
        nbrLine := 0;
    end;

    var
        nbrLine: Integer;
        ErrHardwareIndicatorLbl: Label 'Line %1: The value of the hardware indicator (%2) is invalid', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : La valeur de l''indicateur matériel informatique (%2) est invalide"}]}';
        ErrInDateDebutAmortLbl: Label 'Line %1: The value of the start date of depreciation (%2) is invalid', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : La valeur de la date de début d''amortissement (%2) est invalide"}]}';
        ErrStartDateDepreciatLbl: Label 'Line %1: The number of years of depreciation (%2) is invalid', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Le nombre d''années d''amortissement (%2) est invalide"}]}';
        ErrUnknownStrainLbl: Label 'Row %1: Unknown Serie (%2)', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Souche (%2) inconnue"}]}';
        ErrFixedAssetLbl: Label 'Line %1: The fixed asset (%2) already exists', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : L''immobilisation (%2) existe déjà"}]}';
        ErrManagerBlokedLbl: Label 'Line %1: The manager (%2) is blocked', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Le responsable (%2) est bloqué"}]}';
        ErrManagerNotExistLbl: Label 'Line %1: The manager (%2) does not exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Le responsable (%2) n''existe pas"}]}';
        ErrUnknownClassLbl: Label 'Row %1: Unknown asset class %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Classe immobilisation %2 inconnue"}]}';
        ErrUnknownSubClassLbl: Label 'Row %1: Asset subclass %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Sous-classe immobilisation %2 inconnue"}]}';
        ErrSubclassIncompatibleLbl: Label 'Line %1: Subclass %2 incompatible with class %3', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Sous-classe %2 incompatible avec la classe %3"}]}';
        ErrUnknownAssetLocatLbl: Label 'Line %1: Unknown asset location %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Emplacement immobilisation %2 inconnu"}]}';
        ErrProjectUnknownLbl: Label 'Line %1: Project %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Projet %2 inconnu"}]}';
        ErrUnknownDampingLawLbl: Label 'Row %1: Unknown %2 damping law', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Loi d''amortissement %2 inconnue"}]}';
        ErrAccountAssetUnknownLbl: Label 'Line %1: Accounting group. immo. %2 unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Groupe compta. immo. %2 inconnu"}]}';
        ErrNbrYearDepreciationLbl: Label 'Line %1: the number of years of depreciation must be greater than or equal to 0', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : le nombre d''années d''amortissement doit être supérieur ou égal à 0"}]}';
        MessendOfTreatmentLbl: Label 'Import completed', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Importation terminée"}]}';
}