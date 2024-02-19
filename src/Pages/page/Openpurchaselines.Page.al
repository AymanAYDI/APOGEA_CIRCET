page 50016 "Open Purchase Lines"
{
    Caption = 'Open Purchase Lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Lignes achat ouvertes"}]}';
    DeleteAllowed = false;
    InsertAllowed = false;
    UsageCategory = None;
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = CONST(Order),
                            Type = FILTER(Item | "Fixed Asset"),
                            "Outstanding Quantity" = FILTER(> 0));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. ';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Buy-from Vendor No. ';
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type ';
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. ';
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description ';
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Item No. ';
                }
                field("Job No."; Rec."Job No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job No. ';
                }
                field("Search Description"; Job."Search Description")
                {
                    Caption = 'Site name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du site"}]}';
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nom du site ';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code ';
                }
                field("Person Responsible"; Job."Person Responsible")
                {
                    Caption = 'Person Responsible', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom resp. projet"}]}';
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nom Resp. projet ';
                }
                field("Purchaser Code"; PurchaseHeader2."Purchaser Code")
                {
                    Caption = 'Buyer No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Approvisionneur"}]}';
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the N° Approvisionneur ';
                }
                field(nomAppro; nomAppro)
                {
                    Caption = 'Buyer Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom Approvisionneur"}]}';
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Buyer Name ';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code ';
                }
                field("Shelf No."; StockkeepingUnit."Shelf No.")
                {
                    Caption = 'Shelf No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Localisation article"}]}';
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shelf No. ';
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity ';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure ';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Amount ';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Quantity ';
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qty. to Receive ';
                }
            }
            group("Receipt Date")
            {
                ShowCaption = false;
                field(dateReception; ReceiptDate)
                {
                    Caption = 'Receipt Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date réception"}]}';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt Date ';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Receipt")
            {
                Caption = 'Receipt', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Réception"}]}';
                Image = Receipt;
                action("Purchase Order")
                {
                    Caption = 'Purchase Order', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commande achat"}]}';
                    Image = "Order";
                    RunObject = Page "Purchase Order";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("Document No.");
                    ShortCutKey = 'Shift+F5';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Purchase Order ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Affiche la commande d''achat"}]}';
                }
                action("&Post")
                {
                    Caption = 'Post', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valider"}]}';
                    Image = ValidateEmailLoggingSetup;
                    ShortCutKey = 'F11';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Post ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Effectue la validation"}]}';
                    trigger OnAction()
                    begin
                        Post(FALSE);
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and Print', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valider et imprimer"}]}';
                    Image = Print;
                    ShortCutKey = 'Shift+F11';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Post and Print ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Effectue la validation et l''impression"}]}';
                    trigger OnAction()
                    begin
                        Post(TRUE);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Lecture des caractéristiques de la commande à laquelle la ligne est associée
        PurchaseHeader2.GET(Rec."Document Type", Rec."Document No.");

        // Evaluation du nom de l'approvisionneur
        nomAppro := '';
        IF Resource.GET(PurchaseHeader2."Purchaser Code") THEN
            nomAppro := Resource.Name;

        // Evaluation des caractéristiques du projet concerné par la ligne achat
        nomRespProjet := '';
        IF Job.GET(Rec."Job No.") THEN
            // Evaluation du nom du responsable du projet
            IF Resource.GET(Job."Person Responsible") THEN
                nomRespProjet := Resource.Name;

        // Dans la situation ou la ligne d'achat en cours de sélection concerne un article, recherche de la localisation de l'article en magasin.
        IF Rec.Type = Rec.Type::Item THEN
            // L'appel de la fonction GET est entouré par les instructions IF et THEN de manière à éviter une erreur d'exécution en cas d'échec de
            // la recherche, lorsque la localisation n'est pas spécifiée pour l'article dans le magasin concerné.
            IF StockkeepingUnit.GET(Rec."Location Code", Rec."No.", Rec."Variant Code") THEN;
    end;

    trigger OnClosePage()
    begin
        IF ReStart THEN
            REPORT.RUNMODAL(REPORT::"Preparing Receipts");
    end;

    trigger OnOpenPage()
    begin
        ReStart := FALSE;
        // Initialisation par défaut de la date de réception à la date de travail.
        ReceiptDate := WORKDATE();
    end;

    internal procedure Post(inBooImprime: Boolean)
    var
        lPurchaseLine: Record "Purchase Line";
        lItem: Record Item;
        lHideDialog: Boolean;
        lBoolean: Boolean;
        ConfirmReceipt_Qst: Label 'Validate receipt on %1 ?', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valider réception en date du %1 ?"}]}';
    begin
        // Demande de confirmation de la validation de la réception
        IF NOT CONFIRM(ConfirmReceipt_Qst, TRUE, ReceiptDate) THEN
            EXIT;
        COMMIT();

        // Filtrage des lignes de commande achat sur lesquelles le traitement de la réception doit être appliqué.
        PurchaseLine.RESET();
        PurchaseLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
        PurchaseLine.COPYFILTERS(Rec);
        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SETFILTER(Type, '%1|%2', PurchaseLine.Type::Item, PurchaseLine.Type::"Fixed Asset");
        PurchaseLine.SETFILTER("Qty. to Receive", '<>0');

        // Parcours des lignes à valider
        IF PurchaseLine.FindSet() THEN
            REPEAT
                // Test si toutes les lignes de la commande à laquelle est rattachée la ligne en cours de sélection sont dotées d'un numéro de projet.
                lPurchaseLine.RESET();
                lPurchaseLine.SETRANGE("Document Type", lPurchaseLine."Document Type"::Order);
                lPurchaseLine.SETRANGE("Document No.", PurchaseLine."Document No.");
                lPurchaseLine.SETFILTER("Type", '<>%1', Type::"Fixed Asset");       // Pas de test du projet sur les immo
                lPurchaseLine.SETFILTER("Qty. to Receive", '<>0');
                lPurchaseLine.SETRANGE("Job No.", '');
                IF lPurchaseLine.FindFirst() THEN
                    //On vérifie qu'un projet a été affecté uniquement pour les articles non stockés
                    IF (lPurchaseLine.Type = lPurchaseLine.Type::Item) then
                        IF lItem.GET("No.") then
                            IF lItem.Type <> lItem.Type::Inventory THEN
                                lPurchaseLine.TESTFIELD("Job No.");

                // Lecture des caractéristiques de l'entête de la commande à laquelle est rattachée la ligne en cours de sélection.
                IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, PurchaseLine."Document No.") THEN BEGIN
                    //Control
                    PurchaseMgmt.CheckPostPurchaseHeader(PurchaseHeader, lHideDialog, lBoolean);

                    // Traitement de la réception de la commande à laquelle est rattachée la ligne en cours de sélection.
                    PurchaseHeader.Receive := TRUE;
                    PurchaseHeader.Invoice := FALSE;
                    IF inBooImprime THEN
                        PurchaseMgmt.ReceiptAndPrint(PurchaseHeader, ReceiptDate)
                    ELSE
                        PurchaseMgmt.Receipt(PurchaseHeader, ReceiptDate);
                END;
            UNTIL PurchaseLine.NEXT() = 0;

        ReStart := TRUE;
        CurrPage.CLOSE();
    end;

    var
        PurchaseHeader, PurchaseHeader2 : Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Job: Record Job;
        Resource: Record Resource;
        StockkeepingUnit: Record "Stockkeeping Unit";
        PurchaseMgmt: Codeunit "Purchase Mgmt";
        nomRespProjet: Text[100];
        nomAppro: Text[100];
        ReStart: Boolean;
        ReceiptDate: Date;
}