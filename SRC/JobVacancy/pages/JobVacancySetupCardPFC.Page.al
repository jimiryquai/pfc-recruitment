page 50106 "JobVacancySetupCard_PFC"
{
    AdditionalSearchTerms = 'people setup';
    ApplicationArea = All;
    Caption = 'Job Vacancy Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Documents';
    SourceTable = "JobVacancySetup_PFC";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Vacancy Nos."; "Vacancy Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series code to use when assigning numbers to vacancies.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}
