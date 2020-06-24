table 50101 "JobApplicantSetup_PFC"
{
    Caption = 'Job Applicant Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Applicant Nos."; Code[20])
        {
            Caption = 'Applicant Nos.';
            TableRelation = "No. Series";
        }

    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}
