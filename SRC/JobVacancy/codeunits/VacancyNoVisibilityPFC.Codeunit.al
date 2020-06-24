codeunit 50101 VacancyNoVisibility_PFC
{

    trigger OnRun()
    begin
    end;

    procedure VacancyNoIsVisible(): Boolean
    var
        NoSeriesCode: Code[20];
        IsHandled: Boolean;
        IsVisible: Boolean;
    begin
        IsHandled := false;
        IsVisible := false;
        OnBeforeVacancyNoIsVisible(IsVisible, IsHandled);
        if IsHandled then
            exit(IsVisible);

        NoSeriesCode := DetermineVacancySeriesNo();
        exit(ForceShowNoSeriesForDocNo(NoSeriesCode));
    end;

    procedure VacancyNoSeriesIsDefault(): Boolean
    var
        NoSeries: Record "No. Series";
    begin
        if NoSeries.Get(DetermineVacancySeriesNo()) then
            exit(NoSeries."Default Nos.");
    end;

    local procedure DetermineVacancySeriesNo(): Code[20]
    var
        JobVacancySetup: Record "JobVacancySetup_PFC";
        Vacancy: Record JobVacancies_PFC;
    begin
        JobVacancySetup.Get();
        CheckNumberSeries(Vacancy, JobVacancySetup."Vacancy Nos.", Vacancy.FieldNo("No."));
        exit(JobVacancySetup."Vacancy Nos.");
    end;

    procedure ForceShowNoSeriesForDocNo(NoSeriesCode: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
        NoSeriesRelationship: Record "No. Series Relationship";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SeriesDate: Date;
    begin
        if not NoSeries.Get(NoSeriesCode) then
            exit(true);

        SeriesDate := WorkDate();
        NoSeriesRelationship.SetRange(Code, NoSeriesCode);
        if not NoSeriesRelationship.IsEmpty then
            exit(true);

        if NoSeries."Manual Nos." or (NoSeries."Default Nos." = false) then
            exit(true);

        exit(NoSeriesMgt.DoGetNextNo(NoSeriesCode, SeriesDate, false, true) = '');
    end;

    procedure CheckNumberSeries(RecVariant: Variant; NoSeriesCode: Code[20]; FieldNo: Integer)
    var
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        NewNo: Code[20];
    begin
        if RecVariant.IsRecord and (NoSeriesCode <> '') and NoSeries.Get(NoSeriesCode) then begin
            NewNo := NoSeriesMgt.DoGetNextNo(NoSeriesCode, 0D, false, true);
            RecRef.GetTable(RecVariant);
            FieldRef := RecRef.Field(FieldNo);
            FieldRef.SetRange(NewNo);
            if RecRef.FindFirst() then begin
                NoSeriesMgt.SaveNoSeries();
                CheckNumberSeries(RecRef, NoSeriesCode, FieldNo);
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeVacancyNoIsVisible(var IsVisible: Boolean; var IsHandled: Boolean)
    begin
    end;
}
