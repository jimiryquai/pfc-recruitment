page 50103 JobApplicantsAPI_PFC
{
    PageType = API;
    Caption = 'JobApplicantAPI';
    APIPublisher = 'pfc';
    APIGroup = 'custom';
    APIVersion = 'v1.0';
    EntityName = 'jobapplicant';
    EntitySetName = 'jobapplicants';
    SourceTable = JobApplicants_PFC;
    DelayedInsert = true;
    ODataKeyFields = "No.";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(no; "No.")
                {
                    Caption = 'No.', Locked = true;
                }

                field(firstName; "First Name")
                {
                    Caption = 'First Name', Locked = true;
                }

                field("lastName"; "Last Name")
                {
                    Caption = 'Last Name', Locked = true;
                }

                field(email; "E-Mail")
                {
                    Caption = 'E-Mail', Locked = true;
                }

            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Insert(true);
        Modify(true);
        exit(false);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Delete(true);
    end;
}