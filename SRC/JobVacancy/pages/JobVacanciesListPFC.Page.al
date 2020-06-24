page 50104 JobVacanciesList_PFC
{
    Caption = 'Job Vacancies';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = JobVacancies_PFC;
    CardPageID = JobVacancyCard_PFC;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Caption = 'No.';
                }
                field("Applcation Open Date"; "Application Open Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the opening date for applications to this vacancy.';
                    Caption = 'Applcation Open Date';
                }
                field("Applcation Close Date"; "Application Close Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the closing date for applications to this vacancy.';
                    Caption = 'Applcation Close Date';
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the job title for this vacancy.';
                    Caption = 'Job Title';
                }
                field("Location"; "Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location for this vacancy.';
                    Caption = 'Location';
                }
            }
        }
    }
}
