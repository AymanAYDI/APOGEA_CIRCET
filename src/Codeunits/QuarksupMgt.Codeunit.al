codeunit 50018 "Quarksup Mgt."
{
    internal procedure AddModifyResource("Registration Number": Code[20]; Series: Code[10]; Lastname: Text[30]; Firstname: Text[30]; "Resource Group": Code[20]; "Department code": Code[20]): Text[100]
    var
        Employee: Record Employee;
        Resource: Record Resource;
        ResourceGroup: Record "Resource Group";
        NoSeries: Record "No. Series";
        DimensionValue: Record "Dimension Value";
        HumanResourcesSetup: Record "Human Resources Setup";
        NoSeriesRelationship: Record "No. Series Relationship";
        ResCapacityEntry: Record "Res. Capacity Entry";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        HumanResourceUnitofMeasure: Record "Human Resource Unit of Measure";
        recResUnitOfMeasure: Record "Resource Unit of Measure";
        InterfaceSetup: Record "Interface Setup";

        Created: Boolean;
        ErrorRoot: Text[30];
        FullNameTxt: Text[50];

        //Gestion des labels
        ERR_CREATION_Lbl: Label 'Creation failure : ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Echec création : "}]}';
        ERR_MODIFICATION_Lbl: Label 'Modification failure', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Echec modification : "}]}';
        ERR_RESSOURCE_Lbl: Label 'Missing Resource', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ressource absente"}]}';
        ERR_SOUCHE_Lbl: Label 'Series Employee Unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Souche salariés inconnue"}]}';
        ERR_GRP_RESS_Lbl: Label 'Resource Group Unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Groupe ressource inconnue"}]}';
        ERR_GRP_RESS_BLOQUE_Lbl: Label 'Resource Group Blocked', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Groupe ressource bloqué"}]}';
        ERR_CODE_DEPT_Lbl: Label 'Department Code Unknown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code département inconnu"}]}';
        ERR_CODE_DEPT_BLOQUE_Lbl: Label 'Department Code Blocked', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"code département bloqué"}]}';
    begin
        // Vérification des champs de paramètrage obligatoire
        CheckQuarkSupInterfaceSetup(InterfaceSetup);

        // Identification type de traitement (création / mise à jour)
        Created := NOT Employee.GET("Registration Number");

        // Initialisation de la racine du message d'erreur
        IF Created THEN
            ErrorRoot := ERR_CREATION_Lbl
        ELSE
            ErrorRoot := ERR_MODIFICATION_Lbl;

        // Test existence de la ressource associée au salarié
        IF (NOT Created) AND (NOT Resource.GET("Registration Number")) THEN
            EXIT(ErrorRoot + ERR_RESSOURCE_Lbl);

        // Test validité de la souche
        IF NOT NoSeries.GET(Series) THEN
            EXIT(ErrorRoot + ERR_SOUCHE_Lbl);

        IF NOT HumanResourcesSetup.GET() THEN
            EXIT(ErrorRoot + ERR_SOUCHE_Lbl);

        IF HumanResourcesSetup."Employee Nos." <> Series THEN
            IF NOT NoSeriesRelationship.GET(HumanResourcesSetup."Employee Nos.", Series) THEN
                EXIT(ErrorRoot + ERR_SOUCHE_Lbl);

        // Test existence groupe ressources
        IF NOT ResourceGroup.GET("Resource Group") THEN
            EXIT(ErrorRoot + ERR_GRP_RESS_Lbl);

        // Test blocage groupe ressource
        IF ResourceGroup.Blocked THEN
            EXIT(ErrorRoot + ERR_GRP_RESS_BLOQUE_LBL);

        // Test existence code département
        DimensionValue.RESET();
        DimensionValue.SETCURRENTKEY(Code, "Global Dimension No.");
        DimensionValue.SETRANGE(Code, "Department code");
        DimensionValue.SETRANGE("Global Dimension No.", 1);
        IF NOT DimensionValue.FINDFIRST() THEN
            EXIT(ErrorRoot + ERR_CODE_DEPT_Lbl);

        // Test blocage code département
        IF DimensionValue.Blocked THEN
            EXIT(ErrorRoot + ERR_CODE_DEPT_BLOQUE_Lbl);

        // Identification type de traitement
        IF Created THEN BEGIN
            // Gestion de la création d'un salarié
            Employee.INIT();
            Employee."No." := "Registration Number";
            Employee."No. Series" := Series;

            Employee."Last Date Modified" := TODAY();
            Employee.INSERT(TRUE);

            // Initialisation du nouveau salarié
            // Nom et prénom
            Employee.VALIDATE(Employee."Last Name", Lastname);
            Employee.VALIDATE(Employee."First Name", Firstname);

            // Code département
            Employee.VALIDATE("Global Dimension 1 Code", "Department code");
            Employee.ValidateShortcutDimCode(1, "Department code");

            Employee.VALIDATE("Employee Posting Group", InterfaceSetup."Employee Posting Group");

            // Liaison Salarié <--> Ressource
            Employee."Resource No." := Employee."No.";

            // Sauvegarde
            Employee.VALIDATE("Last Date Modified", TODAY());
            Employee.MODIFY(TRUE);

            // Création de la nouvelle ressource
            Resource.INIT();
            Resource."No." := Employee."No.";
            Resource.Type := Resource.Type::Person;
            Resource.INSERT(TRUE);

            // Initialisation de la nouvelle ressource
            // Nom
            Resource.Name := COPYSTR(FullName(Employee), 1, MAXSTRLEN(Resource.Name));
            Resource."Search Name" := Resource.Name;

            // Fonction
            Resource."Job Title" := Employee."Job Title";

            // Unité
            Resource."Base Unit of Measure" := InterfaceSetup."Base Unit of Measure";
            HumanResourceUnitofMeasure.RESET();
            IF HumanResourceUnitofMeasure.FINDSET() THEN
                REPEAT
                    // Association de l'unité en cours de sélection à la ressource courante
                    recResUnitOfMeasure.INIT();
                    recResUnitOfMeasure."Resource No." := Resource."No.";
                    recResUnitOfMeasure.Code := HumanResourceUnitofMeasure.Code;
                    recResUnitOfMeasure.INSERT(TRUE);
                UNTIL HumanResourceUnitofMeasure.NEXT() = 0;

            // Code département
            Resource."Global Dimension 1 Code" := "Department code";
            Resource.ValidateShortcutDimCode(1, "Department code");

            // Groupe ressource
            Resource.VALIDATE("Resource Group No.", "Resource Group");
            ValidateResourceGroupNo(Resource, "Resource Group");

            //Groupe compta produit
            Resource.VALIDATE("Gen. Prod. Posting Group", InterfaceSetup."Gen. Prod. Posting Group");

            // Sauvegarde
            Resource.VALIDATE("Last Date Modified", TODAY());
            Resource.VALIDATE("Last User Modified", CopyStr(USERID(), 1, MaxStrLen(Resource."Last User Modified")));
            Resource.MODIFY(TRUE);
        END ELSE BEGIN
            // Gestion de la modification d'un salarié

            // Test modification du salarié
            IF (Series <> Employee."No. Series") OR
               (LastName <> Employee."Last Name") OR
               (FirstName <> Employee."First Name") OR
               ("Department code" <> Employee."Global Dimension 1 Code") THEN BEGIN

                // Mise à jour du salarié
                Employee.VALIDATE(Employee."No. Series", Series);
                Employee.VALIDATE(Employee."Last Name", LastName);
                Employee.VALIDATE(Employee."First Name", Firstname);

                IF "Department code" <> Employee."Global Dimension 1 Code" THEN BEGIN
                    Employee.VALIDATE("Global Dimension 1 Code", "Department code");
                    Employee.ValidateShortcutDimCode(1, "Department code");
                END;

                Employee.VALIDATE("Employee Posting Group", InterfaceSetup."Employee Posting Group");
                Employee.VALIDATE("Last Date Modified", TODAY);
                Employee.MODIFY(TRUE);
            END;

            // Test modification de la ressource
            FullNameTxt := COPYSTR(FullName(Employee), 1, MAXSTRLEN(FullNameTxt));
            Resource.GET("Registration Number");
            IF (COPYSTR(FullNameTxt, 1, MAXSTRLEN(Resource.Name)) <> Resource.Name) OR
               ("Resource Group" <> Resource."Resource Group No.") OR
               ("Department code" <> Resource."Global Dimension 1 Code") THEN BEGIN

                Resource.Name := COPYSTR(FullNameTxt, 1, MAXSTRLEN(Resource.Name));
                Resource.VALIDATE("Search Name", Resource.Name);

                IF "Department code" <> Resource."Global Dimension 1 Code" THEN BEGIN
                    Resource.VALIDATE("Global Dimension 1 Code", "Department code");
                    Resource.ValidateShortcutDimCode(1, "Department code");

                    // Mise à jour des écritures capacité ressources
                    ResCapacityEntry.SETCURRENTKEY("Resource No.", Date);
                    ResCapacityEntry.SETRANGE("Resource No.", Resource."No.");
                    ResCapacityEntry.MODIFYALL("Global Dimension 1 Code", "Department code");
                END;

                IF "Resource Group" <> Resource."Resource Group No." THEN BEGIN
                    ValidateResourceGroupNo(Resource, "Resource Group");

                    // Mise à jour des écritures capacité ressources
                    ResCapacityEntry.SETCURRENTKEY("Resource No.", Date);
                    ResCapacityEntry.SETRANGE("Resource No.", Resource."No.");
                    ResCapacityEntry.MODIFYALL("Resource Group No.", "Resource Group");
                END;

                Resource.VALIDATE("Last Date Modified", TODAY());
                Resource."Last User Modified" := CopyStr(USERID(), 1, MaxStrLen(Resource."Last User Modified"));
                Resource.MODIFY(TRUE);
            END;

            // Test modification de l'acheteur/vendeur
            IF SalespersonPurchaser.GET(Resource."No.") THEN
                IF COPYSTR(FullNameTxt, 1, MAXSTRLEN(SalespersonPurchaser.Name)) <> SalespersonPurchaser.Name THEN BEGIN
                    SalespersonPurchaser.VALIDATE(Name, COPYSTR(FullNameTxt, 1, MAXSTRLEN(SalespersonPurchaser.Name)));
                    SalespersonPurchaser.MODIFY(TRUE);
                END;
        END;

        // Succès du traitement
        IF Created THEN
            EXIT(Employee."No.")
        ELSE
            EXIT('');
    end;

    procedure UpdateCreateJob(piNo: Code[20]; piSeries: Code[20]; piDescription: Text[50]; piSite: Code[50]; piDepartmentCode: Code[20]; piCustNo: Code[20];
                              piBillCustNo: Code[20]; piResp: Code[20]; piAssResp: Code[20]; piSalesPerson: Code[20]; piAssSalesPerson: Code[20]): Text[250]
    var
        NoSeries: Record "No. Series";
        NoSeriesRelationship: Record "No. Series Relationship";
        JobsSetup: Record "Jobs Setup";
        Job: Record "Job";
        JobOld: Record "Job";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Resource: Record "Resource";
        Customer: Record "Customer";
        DimensionValue: Record "Dimension Value";
        ContactBusinessRelation: Record "Contact Business Relation";
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        cduDimMgt: Codeunit "DimensionManagement";

        ERR_SOUCHE_INCONNUE_Lbl: Label 'Err : job series unkown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : souche projet inconnue"}]}';
        ERR_PARAM_PROJET_Lbl: Label 'Err : error jobs setup', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : anomalie paramétrage projets"}]}';
        ERR_SOUCHE_INVALIDE_Lbl: Label 'Err : jobs series invalid', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : souche projet invalide"}]}';
        ERR_DEPT_VIDE_Lbl: Label 'Err : department code missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : code département absent"}]}';
        ERR_DEPT_INCONNU_Lbl: Label 'Err : department code unkown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : code département inconnu"}]}';
        ERR_DEPT_BLOCKED_Lbl: Label 'Err : department code blocked', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : code département bloqué"}]}';
        ERR_CLT_DO_VIDE_Lbl: Label 'Err : sell-to customer missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : client DO absent"}]}';
        ERR_CLT_DO_INCONNU_Lbl: Label 'Err : sell-to customer unkown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : client DO inconnu"}]}';
        ERR_CLT_FACT_VIDE_Lbl: Label 'Err : bill-to customer missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : client facturé absent"}]}';
        ERR_CLT_FACT_INCONNU_Lbl: Label 'Err : bill-to customer unkown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : client facturé inconnu"}]}';
        ERR_RESP_AFF_INCONNU_Lbl: Label 'Err : responsable unkown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : responsable affaire inconnu"}]}';
        ERR_ASS_RESP_AFF_INCONNU_Lbl: Label 'Err : responsale assistant unkown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : assistant responsable affaire inconnu"}]}';
        ERR_VENDEUR_INCONNU_Lbl: Label 'Err : salesperson unkown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : vendeur inconnu"}]}';
        ERR_ASS_VENDEUR_INCONNU_Lbl: Label 'Err : salesperson assist unkown', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : assistant vendeur inconnu"}]}';
        ERR_SOUCHE_INCOMPATIBLE_Lbl: Label 'Err : series incompatible', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : souche incompatible"}]}';
        ERR_ABSENCE_LIGNE_SOUCHE_Lbl: Label 'Err : series line missing', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : ligne de souche absente"}]}';
        ERR_SOUCHE_FERMEE_Lbl: Label 'Err : series closed', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : souche fermée"}]}';
        ERR_NO_PROJET_INVALIDE_Lbl: Label 'Err : project no. not valid', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Err : n° de projet invalide"}]}';
    begin
        // Test existence de la souche
        IF NOT NoSeries.GET(piSeries) THEN EXIT(ERR_SOUCHE_INCONNUE_Lbl);

        // Test si la souche correspond à une souche projet
        IF NOT JobsSetup.GET() THEN EXIT(ERR_PARAM_PROJET_Lbl);

        NoSeries.INIT();
        NoSeries.Code := '';
        IF NoSeries.GET(JobsSetup."Job Nos.") THEN;
        IF NoSeries.Code = '' THEN EXIT(ERR_PARAM_PROJET_Lbl);
        IF JobsSetup."Job Nos." <> piSeries THEN
            IF NOT NoSeriesRelationship.GET(NoSeries.Code, piSeries) THEN
                EXIT(ERR_SOUCHE_INVALIDE_Lbl);

        // Test spécification code département
        IF piDepartmentCode = '' THEN EXIT(ERR_DEPT_VIDE_Lbl);

        // Test existence code département
        DimensionValue.RESET();
        DimensionValue.SETCURRENTKEY("Code", "Global Dimension No.");
        DimensionValue.SETRANGE("Code", piDepartmentCode);
        DimensionValue.SETRANGE("Global Dimension No.", 1);
        DimensionValue.SETRANGE(Blocked, TRUE);
        IF NOT DimensionValue.ISEMPTY() THEN
            EXIT(ERR_DEPT_BLOCKED_Lbl);

        DimensionValue.SETRANGE(Blocked, FALSE);
        IF DimensionValue.ISEMPTY() THEN
            EXIT(ERR_DEPT_INCONNU_Lbl);

        // Test spécification client DO
        IF piCustNo = '' THEN
            EXIT(ERR_CLT_DO_VIDE_Lbl);

        // Test existence client DO
        Customer.RESET();
        Customer.SETRANGE("No.", piCustNo);
        Customer.SETRANGE(Blocked, Customer.Blocked::" ");
        Customer.SETFILTER("Customer Posting Group", '<>%1', '');
        IF Customer.ISEMPTY THEN
            EXIT(ERR_CLT_DO_INCONNU_Lbl);

        // Test spécification d'un client payeur différent du client DO
        IF piCustNo <> piBillCustNo THEN BEGIN
            // Test spécification client payeur
            IF piBillCustNo = '' THEN
                EXIT(ERR_CLT_FACT_VIDE_Lbl);

            // Test existence client payeur
            Customer.RESET();
            Customer.SETRANGE("No.", piBillCustNo);
            Customer.SETRANGE(Blocked, Customer.Blocked::" ");
            Customer.SETFILTER("Customer Posting Group", '<>%1', '');
            IF Customer.ISEMPTY THEN
                EXIT(ERR_CLT_FACT_INCONNU_Lbl);
        END;

        // Test existence du responsable affaire
        IF piResp <> '' THEN BEGIN
            Resource.RESET();
            Resource.SETRANGE("No.", piResp);
            Resource.SETRANGE(Blocked, FALSE);
            IF Resource.ISEMPTY() THEN
                EXIT(ERR_RESP_AFF_INCONNU_Lbl);
        END;

        // Test exitence de l'assistant responsable affaire
        IF piAssResp <> '' THEN BEGIN
            Resource.RESET();
            Resource.SETRANGE("No.", piAssResp);
            Resource.SETRANGE(Blocked, FALSE);
            IF Resource.ISEMPTY() THEN
                EXIT(ERR_ASS_RESP_AFF_INCONNU_Lbl);
        END;

        // Test existence du vendeur
        IF piSalesPerson <> '' THEN BEGIN
            SalespersonPurchaser.SETRANGE(Code, piSalesPerson);
            SalespersonPurchaser.SETRANGE(Salesperson, true);
            IF SalespersonPurchaser.IsEmpty() THEN
                EXIT(ERR_VENDEUR_INCONNU_Lbl);
        END;

        // Test existence de l'assistant vendeur
        IF piAssSalesPerson <> '' THEN BEGIN
            Resource.RESET();
            Resource.SETRANGE("No.", piAssSalesPerson);
            Resource.SETRANGE(Blocked, FALSE);
            IF Resource.ISEMPTY() THEN
                EXIT(ERR_ASS_VENDEUR_INCONNU_Lbl);
        END;

        // Test si le projet existe
        IF Job.GET(piNo) THEN BEGIN
            // Test compatibilité de la souche demandée avec la souche actuelle du projet
            IF piSeries <> Job."No. Series" THEN EXIT(ERR_SOUCHE_INCOMPATIBLE_Lbl);

            // Test modification du projet
            IF (Job.Description <> piDescription) OR
                (Job."Search Description" <> piSite) OR
                (Job."Global Dimension 1 Code" <> piDepartmentCode) OR
                (Job.ARBCIRFRSelltoCustomerNo <> piCustNo) OR
                (Job."Bill-to Customer No." <> piBillCustNo) OR
                (Job."Person Responsible" <> piResp) OR
                (Job.ARBCIRFRAssistBusinessManager <> piAssResp) OR
                (Job.ARBCIRFRSalespersonCode <> piSalesPerson) OR
                (Job.ARBCIRFRAssistanceSalesperson <> piAssSalesPerson) THEN BEGIN

                // Mise à jour du projet
                JobOld := Job;
                Job.Description := piDescription;
                Job."Search Description" := piSite;
                IF Job."Global Dimension 1 Code" <> piDepartmentCode THEN BEGIN
                    Job."Global Dimension 1 Code" := piDepartmentCode;
                    //Job.SpreadJobDeptChange(FALSE);
                    Job.ValidateShortcutDimCode(1, Job."Global Dimension 1 Code");
                END;

                Job."Person Responsible" := piResp;
                Job.ARBCIRFRAssistBusinessManager := piAssResp;
                Job.ARBCIRFRSalespersonCode := piSalesPerson;
                Job.ARBCIRFRAssistanceSalesperson := piAssSalesPerson;
                Job.ARBCIRFRSelltoCustomerNo := piCustNo;
                IF Job."Bill-to Customer No." <> piBillCustNo THEN BEGIN
                    Customer.GET(piBillCustNo);
                    Job."Bill-to Customer No." := piBillCustNo;
                    Job."Bill-to Name" := Customer.Name;
                    Job."Bill-to Name 2" := Customer."Name 2";
                    Job."Bill-to Address" := Customer.Address;
                    Job."Bill-to Address 2" := Customer."Address 2";
                    Job."Bill-to City" := Customer.City;
                    Job."Bill-to Post Code" := Customer."Post Code";
                    Job."Bill-to Country/Region Code" := Customer."Country/Region Code";
                    Job."Invoice Currency Code" := Customer."Currency Code";
                    IF Job."Invoice Currency Code" <> '' THEN
                        Job."Currency Code" := '';
                    Job."Customer Disc. Group" := Customer."Customer Disc. Group";
                    Job."Customer Price Group" := Customer."Customer Price Group";
                    Job."Language Code" := Customer."Language Code";
                    Job."Bill-to County" := Customer.County;
                    Job.Reserve := Customer.Reserve;
                    IF Customer."Primary Contact No." <> '' THEN
                        Job."Bill-to Contact No." := Customer."Primary Contact No."
                    ELSE BEGIN
                        ContactBusinessRelation.RESET();
                        ContactBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                        ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                        ContactBusinessRelation.SETRANGE("No.", piBillCustNo);
                        IF ContactBusinessRelation.FINDFIRST() THEN
                            Job."Bill-to Contact No." := ContactBusinessRelation."Contact No.";
                    END;
                    Job."Bill-to Contact" := Customer.Contact;
                END;

                IF (JobOld.Description <> Job.Description) OR
                    (JobOld."Search Description" <> Job."Search Description") OR
                    (JobOld."Global Dimension 1 Code" <> Job."Global Dimension 1 Code") OR
                    (JobOld."Person Responsible" <> Job."Person Responsible") OR
                    (JobOld.ARBCIRFRAssistBusinessManager <> Job.ARBCIRFRAssistBusinessManager) OR
                    (JobOld.ARBCIRFRSalespersonCode <> Job.ARBCIRFRSalespersonCode) OR
                    (JobOld.ARBCIRFRAssistanceSalesperson <> Job.ARBCIRFRAssistanceSalesperson) OR
                    (JobOld.ARBCIRFRSelltoCustomerNo <> Job.ARBCIRFRSelltoCustomerNo) OR
                    (JobOld."Bill-to Customer No." <> Job."Bill-to Customer No.") OR
                    (JobOld.ARBCIRFRMarketPhaseSegment <> Job.ARBCIRFRMarketPhaseSegment) OR
                    (JobOld.ARBCIRFRTask <> Job.ARBCIRFRTask) OR
                    (JobOld.ARBCIRFRStepActivity <> Job.ARBCIRFRStepActivity) THEN
                    Job."Last Date Modified" := TODAY();
                Job.MODIFY(FALSE);
                EXIT('');
            END;
        END ELSE BEGIN
            // Lecture de la ligne courante de la souche
            NoSeriesLine.RESET();
            NoSeriesLine.SETCURRENTKEY("Series Code", "Starting Date", "Starting No.");
            NoSeriesLine.SETRANGE("Series Code", piSeries);
            NoSeriesLine.SETFILTER("Starting Date", '<=%1', WORKDATE());
            IF NOT NoSeriesLine.FINDLAST() THEN EXIT(ERR_ABSENCE_LIGNE_SOUCHE_Lbl);

            // Test création avec No automatique ou imposé
            IF piNo <> '' THEN BEGIN
                // Vérification de la validité du N° de projet imposé
                IF NOT ((piNo >= NoSeriesLine."Starting No.") AND (piNo <= NoSeriesLine."Ending No.")) THEN EXIT(ERR_NO_PROJET_INVALIDE_Lbl);

                // Verrouillage de la souche afin d'interdire la création d'un nouveau projet depuis l'interface de Navision.
                NoSeriesLine.VALIDATE("Last No. Used", NoSeriesLine."Ending No.");
                NoSeriesLine.MODIFY(TRUE);
            END ELSE
                // Test ouverture de la souche
                IF NOT NoSeriesLine.Open THEN EXIT(ERR_SOUCHE_FERMEE_Lbl);

            // Création du projet
            IF piNo = '' THEN BEGIN
                NoSeriesMgt.InitSeries(JobsSetup."Job Nos.", piSeries, 0D, Job."No.", Job."No. Series");
                piNo := Job."No.";
            END ELSE BEGIN
                Job."No." := piNo;
                Job."No. Series" := piSeries;
            END;

            Job.VALIDATE("Apply Usage Link", JobsSetup."Apply Usage Link by Default");
            Job.VALIDATE("Allow Schedule/Contract Lines", JobsSetup."Allow Sched/Contract Lines Def");
            Job.VALIDATE("WIP Method", JobsSetup."Default WIP Method");
            Job.VALIDATE("Job Posting Group", JobsSetup."Default Job Posting Group");
            Job.VALIDATE("WIP Posting Method", JobsSetup."Default WIP Posting Method");
            cduDimMgt.UpdateDefaultDim(DATABASE::Job, Job."No.", Job."Global Dimension 1 Code", Job."Global Dimension 2 Code");

            Job.InitWIPFields();
            Job.INSERT(TRUE);

            // Initialisation du projet
            Job.Description := piDescription;
            Job."Search Description" := piSite;
            Job."Global Dimension 1 Code" := piDepartmentCode;
            Job.ValidateShortcutDimCode(1, Job."Global Dimension 1 Code");
            Job."Person Responsible" := piResp;
            Job.ARBCIRFRAssistBusinessManager := piAssResp;
            Job.ARBCIRFRSalespersonCode := piSalesPerson;
            Job.ARBCIRFRAssistanceSalesperson := piAssSalesPerson;
            Job.VALIDATE(ARBCIRFRSelltoCustomerNo, piCustNo);
            Job."Bill-to Customer No." := piBillCustNo;
            Customer.GET(piBillCustNo);
            Job."Bill-to Customer No." := piBillCustNo;
            Job."Bill-to Name" := Customer.Name;
            Job."Bill-to Name 2" := Customer."Name 2";
            Job."Bill-to Address" := Customer.Address;
            Job."Bill-to Address 2" := Customer."Address 2";
            Job."Bill-to City" := Customer.City;
            Job."Bill-to Post Code" := Customer."Post Code";
            Job."Bill-to Country/Region Code" := Customer."Country/Region Code";
            Job."Invoice Currency Code" := Customer."Currency Code";
            IF Job."Invoice Currency Code" <> '' THEN
                Job."Currency Code" := '';
            Job."Customer Disc. Group" := Customer."Customer Disc. Group";
            Job."Customer Price Group" := Customer."Customer Price Group";
            Job."Language Code" := Customer."Language Code";
            Job."Bill-to County" := Customer.County;
            Job.Reserve := Customer.Reserve;
            IF Customer."Primary Contact No." <> '' THEN
                Job."Bill-to Contact No." := Customer."Primary Contact No."
            ELSE BEGIN
                ContactBusinessRelation.RESET();
                ContactBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SETRANGE("No.", piBillCustNo);
                IF ContactBusinessRelation.FINDFIRST() THEN
                    Job."Bill-to Contact No." := ContactBusinessRelation."Contact No.";
            END;
            Job."Bill-to Contact" := Customer.Contact;
            Job."Creation Date" := TODAY();
            Job."Last Date Modified" := TODAY();
            Job."Starting Date" := TODAY();

            //Affectation axe projet
            Job.ValidateShortcutDimCode(4, Job."No.");

            Job.MODIFY(FALSE);
            EXIT(piNo);
        END
    end;

    /// <summary>
    /// Function to return the full name of employee
    /// </summary>
    /// <param name="Employee">Record Employee.</param>
    /// <returns>Return value of type Text[150].</returns>
    local procedure FullName(Employee: Record Employee): Text[150]
    begin
        IF Employee."Middle Name" = '' THEN
            EXIT(Employee."First Name" + ' ' + Employee."Last Name");

        EXIT(Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name");
    end;

    /// <summary>
    /// Function to control data in Interface setup
    /// </summary>
    /// <param name="InterfaceSetup"></param>
    local procedure CheckQuarkSupInterfaceSetup(var InterfaceSetup: Record "Interface Setup")
    begin
        InterfaceSetup.GET();
        InterfaceSetup.TESTFIELD(InterfaceSetup."Employee Posting Group");
        InterfaceSetup.TESTFIELD(InterfaceSetup."Base Unit of Measure");
        InterfaceSetup.TESTFIELD(InterfaceSetup."Gen. Prod. Posting Group");
    end;

    local procedure ValidateResourceGroupNo(var pResource: Record Resource; pResourceGroup: Code[20])
    var
        ResCapacityEntry: Record "Res. Capacity Entry";
        PlanningLine: Record "Job Planning Line";
    begin
        pResource."Resource Group No." := pResourceGroup;

        // Resource Capacity Entries
        ResCapacityEntry.SetCurrentKey("Resource No.");
        ResCapacityEntry.SetRange("Resource No.", pResource."No.");
        ResCapacityEntry.ModifyAll("Resource Group No.", pResource."Resource Group No.");

        PlanningLine.SetCurrentKey(Type, "No.");
        PlanningLine.SetRange(Type, PlanningLine.Type::Resource);
        PlanningLine.SetRange("No.", pResource."No.");
        PlanningLine.SetRange("Schedule Line", true);
        PlanningLine.ModifyAll("Resource Group No.", pResource."Resource Group No.");
    end;
}