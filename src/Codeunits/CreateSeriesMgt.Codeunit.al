/// <summary>
/// Codeunit créé pour catcher les erreurs susceptibles de se produire lors du traitement de la création d'un nouveau N° d'une souche.
/// </summary>
codeunit 50011 "CreateSeriesMgt"
{
    trigger OnRun()
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        NoSeriesManagement.InitSeries(SeriesSetup, '', DateSetup, NoResult, SeriesResult);
    end;

    /// <summary>
    /// SetParameters : Initialisation des paramètres de création d'un nouveau N° de souche.
    /// </summary>
    /// <param name="pSeries">Code[10] : souche sur laquelle le N° a été créé</param> 
    /// <param name="pDate">Date : date : date de valeur de la création du N° </param>
    procedure SetParameters(pSeries: Code[20]; pDate: Date)
    begin
        SeriesSetup := pSeries;
        DateSetup := pDate;
    end;

    /// <summary>
    /// GetResult : Récupération du résultat de la création d'un nouveau N° de souche.
    /// </summary>
    /// <param name="pSeries">souche sur laquelle le N° a été créé</param>
    /// <param name="pNo">N° créé </param>
    procedure GetResult(var pSeries: Code[20]; var pNo: Code[20])
    begin
        pSeries := SeriesResult;
        pNo := NoResult;
    end;

    var
        SeriesSetup: Code[20];
        DateSetup: Date;
        SeriesResult: Code[20];
        NoResult: Code[20];
}
