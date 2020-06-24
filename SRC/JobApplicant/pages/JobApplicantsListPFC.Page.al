page 50100 JobApplicantsList_PFC
{
    Caption = 'Job Applicants';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = JobApplicants_PFC;
    CardPageID = JobApplicantCard_PFC;

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

                field("First Name"; "First Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s first name.';
                    Caption = 'First Name';
                }

                field("Last Name"; "Last Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s last name.';
                    Caption = 'Last Name';
                }

                field("Mobile No."; "Mobile No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s mobile phone number.';
                    Caption = 'Mobile No.';
                }

                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the applicant''s email address.';
                    Caption = 'Email';

                }

            }
        }
    }
}