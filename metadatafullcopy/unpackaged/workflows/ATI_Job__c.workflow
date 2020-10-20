<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AE1_Job_Alert</fullName>
        <description>AE1 Job Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Executive_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Executive_2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_AE_Assignment</template>
    </alerts>
    <alerts>
        <fullName>AE2_Job_Alert</fullName>
        <description>AE2 Job Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Executive_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Executive_2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_AE_Assignment</template>
    </alerts>
    <alerts>
        <fullName>AE_Job_Alert</fullName>
        <description>AE Job Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Executive_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Executive_2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_AE_Assignment</template>
    </alerts>
    <alerts>
        <fullName>ATI_Job_Hurricane_Florence_Notification</fullName>
        <description>ATI Job: Hurricane Florence Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>channyn.rowe@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>doug.fairless@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>gary.moore@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>luan.nguyen@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomas.mcguire@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_Hurricane_Florence_Notification</template>
    </alerts>
    <alerts>
        <fullName>ATI_Jobs_Branch_Manager_PM_Assignment</fullName>
        <description>ATI Jobs: Branch Manager PM Assignment</description>
        <protected>false</protected>
        <recipients>
            <field>Branch_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>After_Hour_Lead_entry_Email_Alert_ATI</fullName>
        <description>After Hour Lead entry Email Alert ATI</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Alert_Admin_Managers_and_Job_Creator_of_Job_Approval_via_email</fullName>
        <description>Alert Admin Managers and Job Creator of Job Approval via email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Submitted_for_Approval_By__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_Job_Approval_Approved</template>
    </alerts>
    <alerts>
        <fullName>Alert_Admin_Managers_and_Job_Creator_of_Job_Rejection_via_email</fullName>
        <description>Alert Admin Managers and Job Creator of Job Rejection via email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Submitted_for_Approval_By__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_Job_Approval_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Alert_Collections_for_all_Jobs_with_project_type_equal_to_certified</fullName>
        <description>Alert Collections for all Jobs with project type equal to certified</description>
        <protected>false</protected>
        <recipients>
            <recipient>Collections</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Project_Type_Certified</template>
    </alerts>
    <alerts>
        <fullName>Branch_Manager_PD_Notification_SJ_SF</fullName>
        <description>Branch Manager PD Notification - SJ/SF</description>
        <protected>false</protected>
        <recipients>
            <recipient>Regional_Director_Northwest</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>San_Francisco_Branch</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Building_Consultant_on_a_Job</fullName>
        <description>Building Consultant on a Job</description>
        <protected>false</protected>
        <recipients>
            <field>Branch_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager_new__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/Building_Consultant_on_a_jobb</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Chicago</fullName>
        <ccEmails>ChicagoNewLoss@atirestoration.com</ccEmails>
        <description>Call Center New ATI Job Notification - Chicago</description>
        <protected>false</protected>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Dallas</fullName>
        <ccEmails>DallasNewLoss@atirestoration.com</ccEmails>
        <description>Call Center New ATI Job Notification - Dallas</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admin_Managers_Dallas</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Admins_Dallas</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Denver</fullName>
        <ccEmails>DenverNewLoss@atirestoration.com</ccEmails>
        <description>Call Center New ATI Job Notification - Denver</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admins_Denver</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Flagstaff</fullName>
        <ccEmails>FlagstaffNewLoss@atirestoration.com</ccEmails>
        <description>Call Center New ATI Job Notification - Flagstaff</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admin_Managers_Phoenix</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Admins_Phoenix</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>andrew.kahler@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jason.rains@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jason.silvius@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Florida</fullName>
        <description>Call Center New ATI Job Notification - Florida</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admin_Managers_Tampa</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Admins_Tampa</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Houston</fullName>
        <ccEmails>HoustonNewLoss@atirestoration.com</ccEmails>
        <description>Call Center New ATI Job Notification - Houston</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admin_Managers_Houston</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Admins_Houston</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_LA</fullName>
        <description>Call Center New ATI Job Notification - LA</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admin_Managers_Los_Angeles</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Admins_Los_Angeles</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Las_Vegas</fullName>
        <description>Call Center New ATI Job Notification - Las Vegas</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admins_Las_Vegas</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_New_England</fullName>
        <description>Call Center New ATI Job Notification - New England</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admins_New_England</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Orange</fullName>
        <description>Call Center New ATI Job Notification - Anaheim</description>
        <protected>false</protected>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>natalie.yrineo@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tiffany.entsminger@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>veronica.campos@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Philly</fullName>
        <description>Call Center New ATI Job Notification - Philly</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admins_Philadelphia</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Phoenix</fullName>
        <ccEmails>PhoenixNewLoss@atirestoration.com</ccEmails>
        <description>Call Center New ATI Job Notification - Phoenix</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admins_Phoenix</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>charley.felton@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jason.rains@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Riverside</fullName>
        <description>Call Center New ATI Job Notification - Riverside</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admin_Managers_Riverside</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Admins_Riverside</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>gerardo.morenojr@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_SD</fullName>
        <description>Call Center New ATI Job Notification - SD</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admin_Managers_San_Diego</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Admins_San_Diego</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_SF</fullName>
        <ccEmails>SanFranciscoNewLoss@atirestoration.com</ccEmails>
        <description>Call Center New ATI Job Notification - San Francisco</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admin_Managers_San_Francisco</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Admins_San_Francisco</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_SJ</fullName>
        <ccEmails>SanJoseNewLoss@atirestoration.com</ccEmails>
        <description>Call Center New ATI Job Notification - San Jose</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admins_San_Jose</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>dan.ward@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>heather.szopa@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kelli.smith@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Sacramento</fullName>
        <description>Call Center New ATI Job Notification - Sacramento</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admin_Managers_Sacramento</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Admins_Sacramento</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Seattle</fullName>
        <description>Call Center New ATI Job Notification - Seattle</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admin_Managers_Seattle</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Admins_Seattle</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Sonoma</fullName>
        <description>Call Center New ATI Job Notification - Sonoma</description>
        <protected>false</protected>
        <recipients>
            <recipient>dan.ward@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>danielle.harris@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>francisco.vega@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kelli.smith@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tom.thomas@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Call_Center_New_ATI_Job_Notification_Tucson</fullName>
        <ccEmails>TucsonNewLoss@atirestoration.com</ccEmails>
        <description>Call Center New ATI Job Notification - Tucson</description>
        <protected>false</protected>
        <recipients>
            <recipient>Admin_Managers_Tucson</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Admins_Tucson</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>fred.osburn@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jay.post@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>Completed_Job_Notification_to_PD</fullName>
        <description>Completed Job Notification to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/Completed_Job_Notifications</template>
    </alerts>
    <alerts>
        <fullName>Credit_Request_Approval</fullName>
        <description>Credit Request Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Credit_Request_Submitter_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/Credit_Request_Approvals</template>
    </alerts>
    <alerts>
        <fullName>Credit_Request_Rejection</fullName>
        <description>Credit Request Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Credit_Request_Submitter_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/Credit_Request_Rejections</template>
    </alerts>
    <alerts>
        <fullName>ERA_on_Job_Notification</fullName>
        <description>ERA on Job Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Executive_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ERA_on_Job_notifications</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_Prevailing_Wage</fullName>
        <ccEmails>prevailing_wage@atirestoration.com</ccEmails>
        <description>Email Alert for Prevailing Wage</description>
        <protected>false</protected>
        <recipients>
            <recipient>mark.owens@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Email_Templates/ATI_Job_Job_is_Prevailing_Wage</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Payroll_for_Union_Certified_or_Biohazard_Jobs</fullName>
        <description>Email Alert to Payroll for Union, Certified or Biohazard Jobs</description>
        <protected>false</protected>
        <recipients>
            <recipient>chad.rose@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>janine.watson@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_Job_is_Union_Certified_or_BIO</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Scott_Moore_for_new_Orange_E_S_jobs</fullName>
        <description>Email Alert to Scott Moore for new Anaheim E/S jobs</description>
        <protected>false</protected>
        <recipients>
            <recipient>scott.moore@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/ATI_Job_E_S_Job_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Charlotte_for_2_Allocations_Project</fullName>
        <description>Email Charlotte for 2% Allocations Project</description>
        <protected>false</protected>
        <recipients>
            <recipient>scott.moore@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Branch_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/X2PercentAllocationApprovedEmail</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_for_new_Los_Angeles_E_S_jobs_in_ATI_jobs</fullName>
        <description>Email alert for new Los Angeles E/S jobs in ATI jobs</description>
        <protected>false</protected>
        <recipients>
            <recipient>chris.fucci@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>drew.wendland@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>joanne.kelley@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>julie.marcus@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>julie.paris@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rich.campos@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vicky.flores@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_E_S_Job_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_for_new_Orange_E_S_jobs_in_ATI_Job</fullName>
        <description>Email alert for new Anaheim E/S jobs in ATI Job</description>
        <protected>false</protected>
        <recipients>
            <recipient>don.marvel@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>gregg.zembik@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>natalie.yrineo@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ruby.granados@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>scott.moore@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tiffany.entsminger@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>veronica.campos@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_E_S_Job_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_for_new_Riverside_E_S_jobs_in_ATI_Job</fullName>
        <description>Email alert for new Riverside E/S jobs in ATI Job</description>
        <protected>false</protected>
        <recipients>
            <recipient>henry.cho@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>joel.guzman@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maria.vasquez@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nancy.rodriguez@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_E_S_Job_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_for_new_San_Diego_E_S_jobs_in_ATI_jobs</fullName>
        <description>Email alert for new San Diego E/S jobs in ATI jobs</description>
        <protected>false</protected>
        <recipients>
            <recipient>david.ambriz@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.gotham@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jenny.pace@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rick.labella@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_E_S_Job_Notification</template>
    </alerts>
    <alerts>
        <fullName>Error_City_of_LA</fullName>
        <description>Error - City of LA</description>
        <protected>false</protected>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sean.gray@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Email_Templates/Error_City_of_LA</template>
    </alerts>
    <alerts>
        <fullName>JOB_23rd_Group_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - 23rd Group New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_23rd_Group_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_Blackrock_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - Blackrock New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Blackrock_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_Blackstone_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - Blackstone New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Blackstone_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_Facility_Source_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - Facility Source New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Facility_Source_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_From_Contact_Center</fullName>
        <description>JOB - From Contact Center</description>
        <protected>false</protected>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/New_Job_From_Contact_Center</template>
    </alerts>
    <alerts>
        <fullName>JOB_GLP_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - GLP New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_GLP_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_Job_Request_Form_Completed</fullName>
        <description>JOB - Job Request Form Completed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/JOB_Job_Request_Completed</template>
    </alerts>
    <alerts>
        <fullName>JOB_Job_Request_Form_Submitted</fullName>
        <description>JOB - Job Request Form Submitted</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/JOB_Job_Request_Submitted</template>
    </alerts>
    <alerts>
        <fullName>JOB_La_Quinta_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - La Quinta New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_La_Quinta_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_Large_Loss_Notification</fullName>
        <description>JOB - Large Loss Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Large_Loss_Management_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Branch_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Regional_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/ATI_Job_Large_Loss_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>JOB_Large_Loss_Notification_500K</fullName>
        <description>JOB - Large Loss Notification 500K</description>
        <protected>false</protected>
        <recipients>
            <recipient>Large_Loss_Management_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>jeff.moore@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kelly.kambs@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>richard.devos@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ross.linquiti@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ryan.moore@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>steve.pace@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Branch_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager_new__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Regional_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/ATI_Job_Large_Loss_Email_Template_500K</template>
    </alerts>
    <alerts>
        <fullName>JOB_PD_Assignment</fullName>
        <description>JOB - PD Assignment</description>
        <protected>false</protected>
        <recipients>
            <field>Office_New_Loss_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/ATI_Job_New_Job_requires_BM_to_assign_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_PM_Assignment_Approval</fullName>
        <description>JOB PM Assignment Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Branch_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Suggested_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/JOB_PM_Assignment_Approval</template>
    </alerts>
    <alerts>
        <fullName>JOB_PM_Assignment_Rejection</fullName>
        <description>JOB PM Assignment Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Branch_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/JOB_PM_Assignment_Rejection</template>
    </alerts>
    <alerts>
        <fullName>JOB_Request_Completed_Email_Alert_ATI</fullName>
        <description>JOB Request Completed Email Alert ATI</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sean.gray@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/JOB_Job_Request_Completed</template>
    </alerts>
    <alerts>
        <fullName>JOB_Santander_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - Santander New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Santander_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_Sodexo_Roth_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - Sodexo/Roth New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Sodexo_Roth_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_TCB_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - TCB New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_TCB_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_U_S_Bank_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - U.S. Bank New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_US_Bank_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_Vixxo_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - Vixxo New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Vixxo_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>JOB_Welltower_New_Loss_Info_Request_to_PD</fullName>
        <ccEmails>nat.lee@atirestoration.com</ccEmails>
        <description>JOB - Welltower New Loss Info Request to PD</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Welltower_New_Loss_Info_Request_to_PD</template>
    </alerts>
    <alerts>
        <fullName>Job_Lost_Alert</fullName>
        <description>Job Lost Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_Lost_Job</template>
    </alerts>
    <alerts>
        <fullName>Job_Name_Change_Alert</fullName>
        <description>Job Name Change Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_Job_Name_Change_Notification</template>
    </alerts>
    <alerts>
        <fullName>Job_Number_Change_Alert</fullName>
        <description>Job Number Change Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>jenny.pace@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>susan.hart@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_Job_Number_Change_Notification</template>
    </alerts>
    <alerts>
        <fullName>Large_Loss_Notification_for_Bucky_Buchanan_ATI_Job</fullName>
        <description>Large Loss Notification for Bucky Buchanan ATI Job</description>
        <protected>false</protected>
        <recipients>
            <recipient>bucky.buchanan@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/ATI_Job_Large_Loss_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Large_Loss_Notification_for_Jeff_Huddleston_in_ATI_Job</fullName>
        <description>Large Loss Notification for Jeff Huddleston in ATI Job</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeff.huddleston@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/ATI_Job_Large_Loss_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Large_Loss_Notification_for_Scott_Moore_in_ATI_Job</fullName>
        <description>Large Loss Notification for Scott Moore in ATI Job</description>
        <protected>false</protected>
        <recipients>
            <recipient>scott.moore@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/ATI_Job_Large_Loss_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>New_PD_Job_Assignment</fullName>
        <description>New PD Job Assignment</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_Job_Assignment_PD</template>
    </alerts>
    <alerts>
        <fullName>New_PD_Job_Assignments</fullName>
        <description>New PD Job Assignment</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_Job_Assignment_PD</template>
    </alerts>
    <alerts>
        <fullName>Project_Manager_formerly_Superintendent_Job_Alert</fullName>
        <description>Project Manager (formerly Superintendent) Job Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager_new__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_Project_Manager_formerly_Superintendent_Assignment</template>
    </alerts>
    <alerts>
        <fullName>Send_client_welcome_email_when_job_is_marked_won</fullName>
        <description>Send client welcome email when job is marked won</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Site_Contact_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Project_Contact_Information_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_PD_PM_RM_and_Cust_Svc_when_customer_replies_to_SMS_that_they_re_no</fullName>
        <description>Send email to PD, PM, RM, and Cust Svc when customer replies to SMS that they&apos;re not satisfied with job</description>
        <protected>false</protected>
        <recipients>
            <recipient>kristen.butler@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Branch_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager_new__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Send_PD_email_when_customer_is_not_satisfied</template>
    </alerts>
    <alerts>
        <fullName>Survey_Participation</fullName>
        <description>Survey Participation</description>
        <protected>false</protected>
        <recipients>
            <field>Getfeedback_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>survey@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Survey_Templates/Survey_Participation</template>
    </alerts>
    <alerts>
        <fullName>Survey_Participation_Test</fullName>
        <ccEmails>vdurairaj@demandblue.com</ccEmails>
        <ccEmails>sdhandapani@demandblue.com</ccEmails>
        <ccEmails>vganesan@demandblue.com</ccEmails>
        <description>Survey Participation Test</description>
        <protected>false</protected>
        <senderAddress>survey@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Survey_Templates/Survey_Participation</template>
    </alerts>
    <alerts>
        <fullName>Survey_Participation_Yelp_Link</fullName>
        <description>Survey Participation Yelp Link</description>
        <protected>false</protected>
        <recipients>
            <field>Getfeedback_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>survey@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Survey_Templates/Survey_Participation_Yelp_Link</template>
    </alerts>
    <alerts>
        <fullName>Survey_Participation_Yelp_Link_Test</fullName>
        <ccEmails>vdurairaj@demandblue.com</ccEmails>
        <ccEmails>sdhandapani@demandblue.com</ccEmails>
        <ccEmails>vganesan@demandblue.com</ccEmails>
        <description>Survey Participation Yelp Link Test</description>
        <protected>false</protected>
        <senderAddress>survey@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Survey_Templates/Survey_Participation_Yelp_Link</template>
    </alerts>
    <alerts>
        <fullName>Wine_Country_Fire_Email_Alert</fullName>
        <description>Wine Country Fire Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>kelli.smith@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ATI_Job_Templates/ATI_Job_Wine_Country_Fire_Job_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>ATI_Job_Naming_Convention</fullName>
        <field>Name</field>
        <formula>Job_Number__c &amp; &quot; &quot; &amp; &quot;|&quot; &amp; &quot; &quot; &amp; Job_Name__c</formula>
        <name>ATI Job Naming Convention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Blank_Operations_Manager</fullName>
        <description>Job Assignment must be blanked out when cloning a new job.</description>
        <field>Operations_Manager__c</field>
        <name>Blank Operations Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_Job_Approved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Job_Approved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to Job (Approved)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_PM_Approval_Only_Checkbox</fullName>
        <description>Check the PM Approval Only Checkbox (must assign PM prior to this)</description>
        <field>PM_Approval_Only__c</field>
        <literalValue>1</literalValue>
        <name>Check PM Approval Only Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Job_Complete_Field</fullName>
        <field>Completion_Date__c</field>
        <name>Clear Job Complete Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Job_Completion_Date</fullName>
        <description>Clears job completion date when job is marked back to &quot;Won&quot; from &quot;Complete&quot;.</description>
        <field>Completion_Date__c</field>
        <name>Clear Job Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Job_Completion_Datee</fullName>
        <description>Clears job completion date when job is marked back to &quot;Won&quot; from &quot;Complete&quot;.</description>
        <field>Completion_Date__c</field>
        <name>Clear Job Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Job_Start_Date</fullName>
        <description>Clears job start date when job is marked &quot;Lost&quot;</description>
        <field>Job_Start_Date__c</field>
        <name>Clear Job Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_PN_Request_Date</fullName>
        <field>PN_Request_Date__c</field>
        <name>Clear PN Request Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Completion_Date_Stamp</fullName>
        <description>Time stamp of when Job stage is set to &apos;Complete&apos;</description>
        <field>Completion_Date__c</field>
        <formula>TODAY()</formula>
        <name>Completion Date Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Request_Status_to_Approved</fullName>
        <description>Field update to set Credit Request Status to &apos;Approved&apos; upon approval of Manager in the Credit Request Approval Process</description>
        <field>Credit_Request_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Credit Request Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Request_Status_to_Rejected</fullName>
        <description>Field update to set the Credit Request Status to &apos;Rejected,&apos; when a Manager rejects a request in the Credit Request Approval Process</description>
        <field>Credit_Request_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Credit Request Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Request_Status_to_Unapproved</fullName>
        <description>Field update to set Credit Request Status to &apos;Unapproved&apos; in Credit Request Approval Process</description>
        <field>Credit_Request_Status__c</field>
        <literalValue>Unapproved</literalValue>
        <name>Credit Request Status to Unapproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Request_Submitter_Email</fullName>
        <description>Field update to populate email of credit request submitter&apos;s email</description>
        <field>Credit_Request_Submitter_Email__c</field>
        <formula>$User.Email</formula>
        <name>Credit Request Submitter Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Update_on_Job</fullName>
        <description>Field update to clear out &apos;Add/Correct Email&apos; field after trigger to populate updated email onto Contact record</description>
        <field>Add_Correct_Email__c</field>
        <name>Email Update on Job</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GetFeedBack_Phone_Number</fullName>
        <field>Getfeedback_Phone_Number__c</field>
        <formula>Project_Site_Contact_Name__r.MobilePhone</formula>
        <name>GetFeedBack Phone Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GetfeedBack_Email</fullName>
        <field>Getfeedback_Email__c</field>
        <formula>Project_Site_Contact_Name__r.Email</formula>
        <name>GetfeedBack Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Getfeedback_3_Day_Remainder</fullName>
        <field>Getfeedback_Remainder_Text__c</field>
        <formula>&quot;3-Day&quot;</formula>
        <name>Getfeedback 3-Day Remainder Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Getfeedback_6_Day_Remainder_Update</fullName>
        <field>Getfeedback_Remainder_Text__c</field>
        <formula>&quot;6-Day&quot;</formula>
        <name>Getfeedback 6-Day Remainder Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Getfeedback_Remainder_Update</fullName>
        <field>Getfeedback_Remainder_Text__c</field>
        <formula>&quot;&quot;</formula>
        <name>Getfeedback Remainder Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Job_Approval_Date_Time</fullName>
        <field>Date_Time_Approved__c</field>
        <formula>NOW()</formula>
        <name>Job Approval Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Job_Approved_By</fullName>
        <field>Approved_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Job Approved By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Job_Send_Prelim_Last_Modified_By</fullName>
        <field>Send_Prelim_Last_Modified_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Job Send Prelim Last Modified By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Job_Send_Prelim_Last_Modified_Date_Time</fullName>
        <description>Records the Date/Time that the Send Prelim field was last modified</description>
        <field>Send_Prelim_Last_Modified_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Job Send Prelim Last Modified Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Job_Start_Date_Stamp</fullName>
        <field>Job_Start_Date__c</field>
        <formula>NOW()</formula>
        <name>Job Start Date Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Job_Submittal_Date_Time</fullName>
        <field>Date_Time_Submitted_for_Approval__c</field>
        <formula>NOW()</formula>
        <name>Job Submittal Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Job_Submitted_for_Approval_By</fullName>
        <description>Field to indicate which Admin submitted the new job for approval-- fed by Job Approval Process Initial Submission Actions field update.</description>
        <field>Submitted_for_Approval_By__c</field>
        <formula>$User.Email</formula>
        <name>Job Submitted for Approval By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Job_Type_update</fullName>
        <field>Job_Type__c</field>
        <formula>IF( ISPICKVAL (Account__r.Job_Type__c, &quot;Existing Business&quot;),&quot;Existing Business&quot;, &quot;New Business&quot;)</formula>
        <name>Job Type update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Job_Workflow_for_LA_USD</fullName>
        <description>If Job is LA USD, mark the Job as union. Look at Job class (school or government agency) and county is LA.</description>
        <field>Project_Type__c</field>
        <literalValue>Certified</literalValue>
        <name>Job Workflow for LA USD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Job_Workflow_for_SD_USD</fullName>
        <description>If Job is SD USD, mark the Job as Certified. Look at Job class (school or government agency) and county is SD</description>
        <field>Project_Type__c</field>
        <literalValue>Certified</literalValue>
        <name>Job Workflow for SD USD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ManualSuveyFalse</fullName>
        <description>Manual Survey False</description>
        <field>ManualSurveySend__c</field>
        <literalValue>0</literalValue>
        <name>ManualSuveyFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Description_of_Loss</fullName>
        <field>Description_of_Loss__c</field>
        <formula>LEFT(Description__c,255)</formula>
        <name>Populate Description of Loss</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_previous_job_name</fullName>
        <description>Populates the previous job name if job name is changed.</description>
        <field>Job_Prev_Name__c</field>
        <formula>PRIORVALUE( Job_Name__c )</formula>
        <name>Record previous job name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_previous_job_number</fullName>
        <field>Job_Prev_Number__c</field>
        <formula>PRIORVALUE( Job_Number__c )</formula>
        <name>Record previous job number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_Time_Client_Welcome_Email_Sent</fullName>
        <field>Date_Time_Client_Welcome_Email_Sent__c</field>
        <formula>NOW()</formula>
        <name>Set Date/Time Client Welcome Email Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Mod_Alloc</fullName>
        <description>Sets the modified allocations field to &quot;22.5&quot;</description>
        <field>Modified_Allocations__c</field>
        <formula>22.5</formula>
        <name>Set Mod Alloc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PM_to_Pete_Carlson</fullName>
        <description>Set PM to Pete Carlson</description>
        <field>Project_Manager_new__c</field>
        <lookupValue>pete.carlson@atirestoration.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set PM to Pete Carlson</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PN_Request_Date</fullName>
        <field>PN_Request_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set PN Request Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Send_Prelim_field_to_no_for_prg_jobs</fullName>
        <field>Send_Prelim__c</field>
        <literalValue>No</literalValue>
        <name>Set Send Prelim field to no for prg jobs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Sent_Date</fullName>
        <field>Survey_Sent_Date__c</field>
        <formula>TODAY()</formula>
        <name>Survey Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unlock_Record</fullName>
        <field>Unlock_Record__c</field>
        <literalValue>1</literalValue>
        <name>Unlock Record</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_1_sub</fullName>
        <field>X1sub__c</field>
        <literalValue>1</literalValue>
        <name>Update 1 sub</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_1_sub_and_Timberline_boxes</fullName>
        <field>X1sub__c</field>
        <literalValue>1</literalValue>
        <name>Update 1 sub</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Close_Date_when_Won_or_Lost</fullName>
        <field>CloseDate__c</field>
        <formula>TODAY()</formula>
        <name>Update Close Date when Won or Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Approval</fullName>
        <field>Last_NCLS_Approval_Date_and_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Last Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Approver</fullName>
        <field>Last_NCLS_Approver__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Update Last Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Timberline_Update_field</fullName>
        <description>Updates Last Timberline Update field with current date time when a record is saved.</description>
        <field>Last_Timberline_Update__c</field>
        <formula>NOW()</formula>
        <name>Update Last Timberline Update field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PM_Assignment_Status</fullName>
        <field>PM_Assignment_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update PM Assignment Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Won</fullName>
        <field>Stage__c</field>
        <literalValue>Won</literalValue>
        <name>Update Stage to Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Timberline_box</fullName>
        <field>Sync_to_Timberline__c</field>
        <literalValue>1</literalValue>
        <name>Update Timberline box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_of_Last_Stage_Change</fullName>
        <description>Records date/time of last change to/from Won Stage</description>
        <field>Date_of_Last_Stage_Change_To_From_Won__c</field>
        <formula>NOW()</formula>
        <name>Update of Last Stage Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>check_1sub_checkbox</fullName>
        <field>X1sub__c</field>
        <literalValue>1</literalValue>
        <name>check 1sub checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>GF_Survey_10PtAtiSurvey2016Cons_1ebd0e60</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://123</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>out of use</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_10PtAtiSurvey2016Cons_819dc429</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://123</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>out of use</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_10PtAtiSurvey2016Cont_40a89e08</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://123</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>out of use</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_10PtAtiSurvey2016Emer_0bd247b7</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://123</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>out of use</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_10PtAtiSurvey2016Envi_1a48964c</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://123</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>out of use</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_10PtAtiSurvey2016Tech_4128d281</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://123</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>out of use</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyConstruct_18965fcf</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/KWojpzTZ/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Id</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>GF_Survey_NpsAtiSurveyConstruct_18965fcf</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyConstruct_3a695795</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/sg7DYpof/transactional_send</endpointUrl>
        <fields>Getfeedback_EMAIL_API__c</fields>
        <fields>Getfeedback_Email__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Name</fields>
        <fields>PM_Super_Ops_1__c</fields>
        <fields>Project_Director_Name__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager_New_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Address__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <fields>Project_Site_Zipcode__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Contruction Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyConstruct_e44a5423</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/9sQXlLCX/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Getfeedback_SMS_API__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Job_Number__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager_New_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Contact_Name__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Contruction SMS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyConsultin_827581ce</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/iXIN7P2J/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Id</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>GF_Survey_NpsAtiSurveyConsultin_827581ce</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyConsultin_96c9ae3a</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/mDe2eyAM/transactional_send</endpointUrl>
        <fields>Getfeedback_EMAIL_API__c</fields>
        <fields>Getfeedback_Email__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Name</fields>
        <fields>PM_Manager_s_Full_Name__c</fields>
        <fields>Project_Director_Name__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Address__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <fields>Project_Site_Zipcode__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Consulting Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyConsultin_d178d745</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/t28Rn8ga/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Getfeedback_SMS_API__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Job_Number__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager_New_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Contact_Name__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Consulting SMS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyContentsC_cc7576d3</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/SGoRtRz6/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Getfeedback_SMS_API__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Job_Number__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager_New_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Content SMS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyContentsC_cf8a41ad</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/gslWsDIw/transactional_send</endpointUrl>
        <fields>Credit_Request_Submitter_Email__c</fields>
        <fields>Getfeedback_EMAIL_API__c</fields>
        <fields>Getfeedback_Email__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Name</fields>
        <fields>PM_Super_Ops_1__c</fields>
        <fields>Project_Director_Name__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager_New_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Address__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <fields>Project_Site_Zipcode__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Content Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyContentsC_ebfec9af</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/OKgAJKpd/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Id</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>GF_Survey_NpsAtiSurveyContentsC_ebfec9af</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyEmergency_5e0f8b17</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/u0WcTZRX/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Getfeedback_SMS_API__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Job_Number__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager_New_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Emergency SMS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyEmergency_b4f53eaf</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/62s6WiVL/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Id</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>GF_Survey_NpsAtiSurveyEmergency_b4f53eaf</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyEmergency_e710c5c7</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/HZ3BoP3v/transactional_send</endpointUrl>
        <fields>Getfeedback_EMAIL_API__c</fields>
        <fields>Getfeedback_Email__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Name</fields>
        <fields>PM_Super_Ops_1__c</fields>
        <fields>Project_Director_Name__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager_New_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Address__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <fields>Project_Site_Zipcode__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Emergency Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyEnvironme_38d9a891</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/9M3CuAvj/transactional_send</endpointUrl>
        <fields>Getfeedback_EMAIL_API__c</fields>
        <fields>Getfeedback_Email__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Name</fields>
        <fields>PM_Super_Ops_1__c</fields>
        <fields>Project_Director_Name__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Site_Address__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <fields>Project_Site_Zipcode__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Environmental Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyEnvironme_c0dd2e94</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://123</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>out of use</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyEnvironme_c90dd69b</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/Ig5C1faB/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Getfeedback_SMS_API__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Job_Number__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager_New_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Environmental SMS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyEnvironme_cb34b096</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/wzsLQup8/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Id</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>GF_Survey_NpsAtiSurveyEnvironme_cb34b096</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyTechnical_308c2aca</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/M0C8816R/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Getfeedback_SMS_API__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Job_Number__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager_New_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Technical Email SMS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyTechnical_43b9f834</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/IoIOfAwr/transactional_send</endpointUrl>
        <fields>Getfeedback_Phone_Number__c</fields>
        <fields>Id</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>GF_Survey_NpsAtiSurveyTechnical_43b9f834</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>GF_Survey_NpsAtiSurveyTechnical_8f9a6ec1</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://www.getfeedback.com/campaigns/lxxHLXsM/transactional_send</endpointUrl>
        <fields>Getfeedback_EMAIL_API__c</fields>
        <fields>Getfeedback_Email__c</fields>
        <fields>Getfeedback_Remainder_Text__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Name</fields>
        <fields>PM_Manager_s_Full_Name__c</fields>
        <fields>Project_Director_Name__c</fields>
        <fields>Project_Manager_Full_Name__c</fields>
        <fields>Project_Manager__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Address__c</fields>
        <fields>Project_Site_Contact_Only_Name__c</fields>
        <fields>Project_Site_Zipcode__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>john.mourani@atirestoration.com</integrationUser>
        <name>Getfeedback NPS Technical Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Jitterbit_Job_OBM</fullName>
        <apiVersion>43.0</apiVersion>
        <description>Outbound message to send Opportunity fields to Timberline via Jitterbit</description>
        <endpointUrl>https://ATI69420.jitterbit.net/PROD/atiapiCall</endpointUrl>
        <fields>Account_Executive_1_Timber__c</fields>
        <fields>Account_Executive_2_Timber__c</fields>
        <fields>Actual_Start_Date__c</fields>
        <fields>City_of_LA_Timber__c</fields>
        <fields>Completion_Date__c</fields>
        <fields>County__c</fields>
        <fields>Division__c</fields>
        <fields>GL_Account_Prefix__c</fields>
        <fields>Id</fields>
        <fields>Job_Name__c</fields>
        <fields>Job_Number__c</fields>
        <fields>Modified_Allocations__c</fields>
        <fields>PM_Approval_Only__c</fields>
        <fields>Project_Manager_Email__c</fields>
        <fields>Project_Manager_Timber__c</fields>
        <fields>Project_Manager_new__c</fields>
        <fields>Project_Site_Address_2__c</fields>
        <fields>Project_Site_Address__c</fields>
        <fields>Project_Site_City__c</fields>
        <fields>Project_Site_Fax__c</fields>
        <fields>Project_Site_State__c</fields>
        <fields>Project_Site_Zipcode__c</fields>
        <fields>ReferenceId__c</fields>
        <fields>Super_Ops_Email__c</fields>
        <fields>Superintendent__c</fields>
        <fields>SystemModstamp</fields>
        <fields>Work_Phone__c</fields>
        <fields>X1sub__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>jitterbit@atirestoration.com</integrationUser>
        <name>Jitterbit Job OBM</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Job_Record_To_Jitterbit</fullName>
        <apiVersion>48.0</apiVersion>
        <endpointUrl>https://ATI69420.jitterbit.net/DEV/SFtoXactIntegration</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>sf.test@atirestoration.com</integrationUser>
        <name>Send Job Record To Jitterbit</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>AE Job Alert</fullName>
        <actions>
            <name>AE_Job_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2) and 3 and 4</booleanFilter>
        <criteriaItems>
            <field>ATI_Job__c.Account_Executive_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Account_Executive_2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Job (Approved)</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>When an AE gets assigned to a job, they get notified ONLY on approved job.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AE1 Job Alert</fullName>
        <actions>
            <name>AE1_Job_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>ATI_Job__c.Account_Executive_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Job (Approved)</value>
        </criteriaItems>
        <description>When an AE gets assigned to a job, they get notified ONLY on approved job.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AE2 Job Alert</fullName>
        <actions>
            <name>AE2_Job_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>ATI_Job__c.Account_Executive_2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Job (Approved)</value>
        </criteriaItems>
        <description>When an AE gets assigned to a job, they get notified ONLY on approved job.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ATI Job Naming Convention</fullName>
        <actions>
            <name>ATI_Job_Naming_Convention</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Name</field>
            <operation>greaterOrEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Workflow field update to populate ATI Job Name with &apos;Job Name | Job Number&apos;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Alert Collections for certified%2Funion project types</fullName>
        <actions>
            <name>Alert_Collections_for_all_Jobs_with_project_type_equal_to_certified</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Project_Type__c</field>
            <operation>equals</operation>
            <value>Certified,Union</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Email notification sent to collections for all Jobs with a Project Type of &apos;Prevailing Wage / Certified&apos; or &apos;Union&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Alert File Clerk when Jobs are marked Lost</fullName>
        <actions>
            <name>Job_Lost_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Stage__c</field>
            <operation>equals</operation>
            <value>Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Email notification to flie clerk when Opportunity Stage is set to Lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Alert payroll when job is PW%2C union%2C or biohazard</fullName>
        <actions>
            <name>Email_Alert_to_Payroll_for_Union_Certified_or_Biohazard_Jobs</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Call_Union_Bring_in_New_Hires_Contact_Payroll</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>If project type is union, certified or division is biohazard, and only if job stage is Won, notify Payroll and set task for Project Manager for new hire orientation. Task Due date is 6 hours within assignment</description>
        <formula>AND(OR(  ISPICKVAL(Division__c , &quot;Biohazard&quot;),  ISPICKVAL(Project_Type__c , &quot;Union&quot;),  ISPICKVAL(Project_Type__c , &quot;Certified&quot;)  )   &amp;&amp;   ISPICKVAL(Stage__c,&quot;Won&quot;),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Alert payroll when job is Prevailing Wage</fullName>
        <actions>
            <name>Email_Alert_for_Prevailing_Wage</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>If project type is union or certified, and only if job stage is Won, notify Prevailing Wage email</description>
        <formula>AND(OR(ISPICKVAL(Project_Type__c , &quot;Union&quot;),  ISPICKVAL(Project_Type__c , &quot;Certified&quot;)  )   &amp;&amp;   ISPICKVAL(Stage__c,&quot;Won&quot;),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BM email for PD assignment</fullName>
        <actions>
            <name>ATI_Jobs_Branch_Manager_PM_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Branch_Manager__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Email Alert to Branch Managers to assign a Project Director to a Job.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BM email for PD assignment - new</fullName>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Branch_Manager__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Email Alert to Branch Managers to assign a Project Director to a Job.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BM email for PD assignment- SF%2FSJ</fullName>
        <actions>
            <name>Branch_Manager_PD_Notification_SJ_SF</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Branch_Manager__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Office__c</field>
            <operation>equals</operation>
            <value>San Francisco,San Jose</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Email Alert to Branch Managers to assign a Project Director to a Job.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Building Consultant on a Job</fullName>
        <actions>
            <name>Building_Consultant_on_a_Job</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Building_Consultant__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>When this checkbox is check, it will send email to EVP&apos;s, BM, PM, Super, and Ops Manager.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Clear PN Request Date if Send Prelim is No</fullName>
        <actions>
            <name>Clear_PN_Request_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Send_Prelim__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Completion Date Stamp</fullName>
        <actions>
            <name>Completion_Date_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Stamps the Date that a Job&apos;s Stage was set to Complete</description>
        <formula>AND(ISBLANK(Completion_Date__c),  OR(  AND(ISNEW(), OR(TEXT(Stage__c) = &apos;Work Complete&apos;, TEXT(Stage__c) = &apos;Billing Complete&apos;)),  AND(ISCHANGED(Stage__c ), OR(TEXT(Stage__c) = &apos;Work Complete&apos;, TEXT(Stage__c) = &apos;Billing Complete&apos;))  )  ,$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Construction Job to Blank Ops Manager</fullName>
        <actions>
            <name>Blank_Operations_Manager</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( OR( TEXT(Division__c )== &apos;Construction&apos;, TEXT(Division__c )== &apos;Marketing&apos; ), OR( ISNEW(), ISCHANGED(Division__c ) ),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ERA on Job</fullName>
        <actions>
            <name>ERA_on_Job_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.ERA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Workflow email alert to notify PM and AE that there is an ERA related to a Job</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Alert to Scott Moore for new Anaheim E%2FS jobs</fullName>
        <actions>
            <name>Email_Alert_to_Scott_Moore_for_new_Orange_E_S_jobs</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(Office2__c = &apos;Orange&apos; , ISPICKVAL(Division__c, &quot;Emergency Svces&quot;) ,$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Update on Job</fullName>
        <actions>
            <name>Email_Update_on_Job</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Field update to clear out &apos;Add/Correct Email&apos; field after trigger to populate updated email onto Contact record</description>
        <formula>AND(Add_Correct_Email__c != null,$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Error - City of LA</fullName>
        <actions>
            <name>Error_City_of_LA</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.City_of_LA__c</field>
            <operation>notEqual</operation>
            <value>Yes,No</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.City_of_LA__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>When City of LA throws an error, it will send an email to recipient</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Getfeedback Construction Survey</fullName>
        <actions>
            <name>Getfeedback_Remainder_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ManualSuveyFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Survey_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GF_Survey_NpsAtiSurveyConstruct_3a695795</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>OR(AND( Estimate_Only__c = false,   Ladder_Assist__c = false,   Completion_Date__c &gt;= DATE(2019,01,19),  No_Email_Available__c = false,  Project_Site_Contact_Name__c != &apos;&apos;,  Project_Site_Contact_Name__r.Email != &apos;&apos;,  Project_Site_Contact_Name__r.HasOptedOutOfEmail = false,  ISNULL(Survey_Sent_Date__c ),  OR(  ISPICKVAL(Division__c, &apos;Demolition&apos;),  ISPICKVAL(Division__c, &apos;Construction&apos;)  ),  OR(  ISPICKVAL(Stage__c, &apos;Work Complete&apos;),  ISPICKVAL(Stage__c, &apos;Billing Complete&apos;)),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;),(AND( ManualSurveySend__c = True,OR(  ISPICKVAL(Division__c, &apos;Demolition&apos;),  ISPICKVAL(Division__c, &apos;Construction&apos;) ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Getfeedback Construction Survey Remainder Email</fullName>
        <active>false</active>
        <formula>AND(  !ISNULL(Survey_Sent_Date__c)  , Survey_Completed__c == false,OR( ISPICKVAL(Division__c, &apos;Demolition&apos;), ISPICKVAL(Division__c, &apos;Construction&apos;) ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_3_Day_Remainder</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyConstruct_3a695795</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyConstruct_e44a5423</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_6_Day_Remainder_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyConstruct_3a695795</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyConstruct_e44a5423</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Getfeedback Consulting Services Remainder Email</fullName>
        <active>false</active>
        <formula>AND( !ISNULL(Survey_Sent_Date__c) , Survey_Completed__c == false,OR( ISPICKVAL(Division__c, &apos;Consulting&apos;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_6_Day_Remainder_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyConsultin_96c9ae3a</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyConsultin_d178d745</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_3_Day_Remainder</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyConsultin_96c9ae3a</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyConsultin_d178d745</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Getfeedback Consulting Services Survey</fullName>
        <actions>
            <name>Getfeedback_Remainder_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ManualSuveyFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Survey_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GF_Survey_NpsAtiSurveyConsultin_96c9ae3a</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>OR(AND(  Estimate_Only__c = false,   Ladder_Assist__c = false,   Completion_Date__c &gt;= DATE(2019,01,19),  No_Email_Available__c = false,  Project_Site_Contact_Name__c != &apos;&apos;,  Project_Site_Contact_Name__r.Email != &apos;&apos;,  Project_Site_Contact_Name__r.HasOptedOutOfEmail = false,  ISNULL(Survey_Sent_Date__c ),  ISPICKVAL(Division__c, &apos;Consulting&apos;),  OR(  ISPICKVAL(Stage__c, &apos;Work Complete&apos;),  ISPICKVAL(Stage__c, &apos;Billing Complete&apos;)),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;),(AND( ManualSurveySend__c = True,OR( ISPICKVAL(Division__c, &apos;Consulting&apos;) ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Getfeedback Content Survey</fullName>
        <actions>
            <name>Getfeedback_Remainder_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ManualSuveyFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Survey_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GF_Survey_NpsAtiSurveyContentsC_cf8a41ad</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>OR(AND(  Estimate_Only__c = false,   Ladder_Assist__c = false,   Completion_Date__c &gt;= DATE(2019,01,19),  No_Email_Available__c = false,  Project_Site_Contact_Name__c != &apos;&apos;,  Project_Site_Contact_Name__r.Email != &apos;&apos;,  Project_Site_Contact_Name__r.HasOptedOutOfEmail = false,  ISNULL(Survey_Sent_Date__c ),  ISPICKVAL(Division__c, &apos;Contents&apos;),  OR(  ISPICKVAL(Stage__c, &apos;Work Complete&apos;),  ISPICKVAL(Stage__c, &apos;Billing Complete&apos;)),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;),(AND( ManualSurveySend__c = True,OR( ISPICKVAL(Division__c, &apos;Contents&apos;) ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Getfeedback Content Survey Remainder Email</fullName>
        <active>false</active>
        <formula>AND( !ISNULL(Survey_Sent_Date__c) , Survey_Completed__c == false,OR( ISPICKVAL(Division__c, &apos;Contents&apos;) ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_3_Day_Remainder</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyContentsC_cc7576d3</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyContentsC_cf8a41ad</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_6_Day_Remainder_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyContentsC_cc7576d3</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyContentsC_cf8a41ad</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Getfeedback Email %26 Number Update</fullName>
        <actions>
            <name>GetFeedBack_Phone_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GetfeedBack_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Getfeedback Emergency Survey</fullName>
        <actions>
            <name>Getfeedback_Remainder_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ManualSuveyFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Survey_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GF_Survey_NpsAtiSurveyEmergency_e710c5c7</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>OR(AND(  Estimate_Only__c = false,   Ladder_Assist__c = false,   Completion_Date__c &gt;= DATE(2019,01,19),  No_Email_Available__c = false,  Project_Site_Contact_Name__c != &apos;&apos;,  Project_Site_Contact_Name__r.Email != &apos;&apos;,  Project_Site_Contact_Name__r.HasOptedOutOfEmail = false,  ISNULL(Survey_Sent_Date__c ),  OR(  ISPICKVAL(Division__c, &apos;Catastrophes&apos;),  ISPICKVAL(Division__c, &apos;Emergency Svces&apos;)  ),  OR(  ISPICKVAL(Stage__c, &apos;Work Complete&apos;),  ISPICKVAL(Stage__c, &apos;Billing Complete&apos;)),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;),(AND( ManualSurveySend__c = True,OR( ISPICKVAL(Division__c, &apos;Catastrophes&apos;), ISPICKVAL(Division__c, &apos;Emergency Svces&apos;) ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Getfeedback Emergency Survey Remainder Email</fullName>
        <active>false</active>
        <formula>AND( !ISNULL(Survey_Sent_Date__c) , Survey_Completed__c == false,OR( ISPICKVAL(Division__c, &apos;Catastrophes&apos;), ISPICKVAL(Division__c, &apos;Emergency Svces&apos;) ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_3_Day_Remainder</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyEmergency_5e0f8b17</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyEmergency_e710c5c7</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_6_Day_Remainder_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyEmergency_5e0f8b17</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyEmergency_e710c5c7</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Getfeedback Environmental Survey</fullName>
        <actions>
            <name>Getfeedback_Remainder_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ManualSuveyFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Survey_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GF_Survey_NpsAtiSurveyEnvironme_38d9a891</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>OR(AND(  Estimate_Only__c = false,  Ladder_Assist__c = false,  Completion_Date__c &gt;= DATE(2019,01,19),  No_Email_Available__c = false,  Project_Site_Contact_Name__c != &apos;&apos;,  Project_Site_Contact_Name__r.Email != &apos;&apos;,  Project_Site_Contact_Name__r.HasOptedOutOfEmail = false,  ISNULL(Survey_Sent_Date__c ),  OR(  ISPICKVAL(Division__c, &apos;Asbestos&apos;),  ISPICKVAL(Division__c, &apos;Biohazard&apos;),  ISPICKVAL(Division__c, &apos;Lead&apos;),  ISPICKVAL(Division__c, &apos;Microbial&apos;)  ),  OR(  ISPICKVAL(Stage__c, &apos;Work Complete&apos;),  ISPICKVAL(Stage__c, &apos;Billing Complete&apos;)),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;),(AND( ManualSurveySend__c = True,OR(  ISPICKVAL(Division__c, &apos;Asbestos&apos;),  ISPICKVAL(Division__c, &apos;Biohazard&apos;),  ISPICKVAL(Division__c, &apos;Lead&apos;),  ISPICKVAL(Division__c, &apos;Microbial&apos;)  ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Getfeedback Environmental Survey Remainder Email</fullName>
        <active>false</active>
        <formula>AND( !ISNULL(Survey_Sent_Date__c) , Survey_Completed__c == false,OR(  ISPICKVAL(Division__c, &apos;Asbestos&apos;),  ISPICKVAL(Division__c, &apos;Biohazard&apos;),  ISPICKVAL(Division__c, &apos;Lead&apos;),  ISPICKVAL(Division__c, &apos;Microbial&apos;)  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_3_Day_Remainder</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyEnvironme_38d9a891</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyEnvironme_c90dd69b</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_6_Day_Remainder_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyEnvironme_38d9a891</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyEnvironme_c90dd69b</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Getfeedback Technical Services Survey</fullName>
        <actions>
            <name>Getfeedback_Remainder_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ManualSuveyFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Survey_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GF_Survey_NpsAtiSurveyTechnical_8f9a6ec1</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>OR(AND(  Estimate_Only__c = false,   Ladder_Assist__c = false,   Completion_Date__c &gt;= DATE(2019,01,19),  No_Email_Available__c = false,  Project_Site_Contact_Name__c != &apos;&apos;,  Project_Site_Contact_Name__r.Email != &apos;&apos;,  Project_Site_Contact_Name__r.HasOptedOutOfEmail = false,  ISNULL(Survey_Sent_Date__c ),  ISPICKVAL(Division__c, &apos;Technical Svces&apos;),  OR(  ISPICKVAL(Stage__c, &apos;Work Complete&apos;),  ISPICKVAL(Stage__c, &apos;Billing Complete&apos;)),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;),(AND( ManualSurveySend__c = True,OR( ISPICKVAL(Division__c, &apos;Technical Svces&apos;) ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Getfeedback Technical Services Survey Remainder Email</fullName>
        <active>false</active>
        <formula>AND( !ISNULL(Survey_Sent_Date__c) , Survey_Completed__c == false,OR( ISPICKVAL(Division__c, &apos;Technical Svces&apos;) ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_6_Day_Remainder_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyTechnical_308c2aca</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyTechnical_8f9a6ec1</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Getfeedback_3_Day_Remainder</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyTechnical_308c2aca</name>
                <type>OutboundMessage</type>
            </actions>
            <actions>
                <name>GF_Survey_NpsAtiSurveyTechnical_8f9a6ec1</name>
                <type>OutboundMessage</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Hurricane Florence Notification</fullName>
        <actions>
            <name>ATI_Job_Hurricane_Florence_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Job_Category__c</field>
            <operation>equals</operation>
            <value>Hurricane Florence</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Notification goes to:
Gary Moore
Doug Fairless
Tom McGuire
Luan Nguyen
Channyn Rowe</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JOB - Large Loss Notification</fullName>
        <actions>
            <name>JOB_Large_Loss_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>ATI_Job__c.Amount__c</field>
            <operation>greaterOrEqual</operation>
            <value>100000</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Total_Billing_Forecast_Amount__c</field>
            <operation>greaterOrEqual</operation>
            <value>100000</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Large_Loss_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Total_Billing_Forecast_Amount__c</field>
            <operation>lessThan</operation>
            <value>500000</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Amount__c</field>
            <operation>lessThan</operation>
            <value>500000</value>
        </criteriaItems>
        <description>To notify Large Loss Management Team of Large Loss jobs</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JOB - Large Loss Notification 500k</fullName>
        <actions>
            <name>JOB_Large_Loss_Notification_500K</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>ATI_Job__c.Amount__c</field>
            <operation>greaterOrEqual</operation>
            <value>500000</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Total_Billing_Forecast_Amount__c</field>
            <operation>greaterOrEqual</operation>
            <value>500000</value>
        </criteriaItems>
        <description>Purpose: FYI alerting management, operations, and finance of very large jobs as soon as they are identified.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JOB - Record previous job number</fullName>
        <actions>
            <name>Record_previous_job_number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous job number if job number is changed.</description>
        <formula>AND(ISCHANGED( Job_Number__c ),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Jitterbit Job OBM</fullName>
        <actions>
            <name>Jitterbit_Job_OBM</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <description>Outbound message to send Opportunity fields to Timberline via Jitterbit</description>
        <formula>AND(
	OR(
		AND(ISCHANGED(Stage__c),
		ISPICKVAL(Stage__c, &quot;Won&quot;)) ,
		Sync_to_Timberline__c = TRUE, 
		ISCHANGED(PM_Approval_Only__c), 
		AND(OR(ISCHANGED(Project_Manager_new__c), 
			ISCHANGED(Project_Manager__c),
			ISCHANGED(Account_Executive_1_Timber__c),
			ISCHANGED(Account_Executive_2_Timber__c),
			ISCHANGED(Job_Name__c)
			),
		NOT(ISNULL( Last_Successful_Timberline_Update__c)), 
X1sub__c = FALSE),NOT(ISNULL (Project_Manager__c))
),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Job Lost - Clear Start%2FCompletion Dates</fullName>
        <actions>
            <name>Clear_Job_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Job_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Stage__c</field>
            <operation>equals</operation>
            <value>Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Clears job start date and completion date when job is marked &quot;Lost&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Job Name Change Alert</fullName>
        <actions>
            <name>Job_Name_Change_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>When Job name has changed, email Vonda Barela that Job name has changed.</description>
        <formula>AND(ISCHANGED(Job_Name__c),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Job Number Change Alert</fullName>
        <actions>
            <name>Job_Number_Change_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>When Job number has changed, email Jenny Pace, Vonda Barela, and payroll.</description>
        <formula>AND(ISCHANGED (Job_Number__c) ,  $Profile.Name &lt;&gt; &apos;Restricted Process Execution&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Job Start Date Stamp</fullName>
        <actions>
            <name>Clear_Job_Complete_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Job_Completion_Datee</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Job_Start_Date_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Stamps the Date that a Job&apos;s Stage was set to Won (and overwrites Job Start Date each time)</description>
        <formula>AND(OR(AND(ISNEW(),TEXT(Stage__c) = &apos;Won&apos;),AND(ISCHANGED(Stage__c ),TEXT(Stage__c) = &apos;Won&apos;)),$Profile.Name &lt;&gt; &apos;Restricted Process Execution&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Job Type update</fullName>
        <actions>
            <name>Job_Type_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( NOT( (ISPICKVAL(Account__r.Job_Type__c, &quot;&quot;))) , NOT(ISPICKVAL(Stage__c , &quot;Work Complete&quot;)), NOT(ISPICKVAL(Stage__c , &quot;Billing Complete&quot;)),$Profile.Name &lt;&gt; &apos;Restricted Process Execution&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Job Workflow for LA County Educational</fullName>
        <actions>
            <name>Job_Workflow_for_LA_USD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If Job is LA county educational or governmental and stage is won, mark the Job as union. Look at Job class (school or government agency) and county is LA.</description>
        <formula>AND( CONTAINS( County__c , &quot;Los Angeles&quot;), ISPICKVAL( Stage__c,&quot;Won&quot;), OR( ISPICKVAL( Job_Class__c , &quot;Municipality/ Gov&apos;t&quot;), ISPICKVAL( Job_Class__c , &quot;Educational&quot;) ),$Profile.Name &lt;&gt; &apos;Restricted Process Execution&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Job Workflow for SD USD</fullName>
        <actions>
            <name>Job_Workflow_for_SD_USD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If Job is SD USD, mark the Job as Certified. Look at Job class (school or government agency) and county is SD</description>
        <formula>AND( CONTAINS( County__c , &quot;San Diego&quot;), OR( ISPICKVAL( Job_Class__c , &quot;Municipality/ Gov&apos;t&quot;), ISPICKVAL( Job_Class__c , &quot;Educational&quot;) ),$Profile.Name &lt;&gt; &apos;Restricted Process Execution&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Last Job Date Population</fullName>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Population of the Last Job Date to be used in Bonus calculations of New Business vs. Existing Business.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New PD Job Assignment</fullName>
        <actions>
            <name>New_PD_Job_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>A workflow email alert will be created to alert a Project Director immediately following Job assignment.</description>
        <formula>AND( RecordTypeId = &apos;0120g000000l3yM&apos; &amp;&amp;  (ISCHANGED( Project_Manager__c )),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Ops Manager Assignment</fullName>
        <active>false</active>
        <formula>AND(RecordTypeId = &apos;01270000000UPGF&apos; &amp;&amp;  (ISCHANGED(Project_Manager_new__c)),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Description of Loss</fullName>
        <actions>
            <name>Populate_Description_of_Loss</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(ISCHANGED(Description__c),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Project Manager %28formerly Superintendent%29 Assignment</fullName>
        <actions>
            <name>Project_Manager_formerly_Superintendent_Job_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends an email when a Project Manager is assigned to a job</description>
        <formula>AND(OR(ISCHANGED( Project_Manager_new__c ), ISNEW()),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Record Date%2FTime of Status Change</fullName>
        <actions>
            <name>Update_of_Last_Stage_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Records date/time of last change to/from Won Stage</description>
        <formula>AND(OR( AND( ISCHANGED(Stage__c), ISPICKVAL(Stage__c, &quot;Won&quot;) ), AND( ISCHANGED(Stage__c), ISPICKVAL(PRIORVALUE(Stage__c),&quot;Won&quot;)) ),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Record previous job name</fullName>
        <actions>
            <name>Record_previous_job_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous job name if job name is changed.</description>
        <formula>AND(OR(ISCHANGED( Name ) , ISCHANGED( Job_Name__c )),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Job Record To Jitterbit</fullName>
        <actions>
            <name>Send_Job_Record_To_Jitterbit</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>OR(
AND(
ISCHANGED( Customer_Contacted__c ),
NOT(ISBLANK(Customer_Contacted__c ))
),
AND(
ISCHANGED( Approved_Date__c ),
NOT(ISBLANK(Approved_Date__c ))
),
AND(
ISCHANGED( Estimate_Rejection_Date__c ),
NOT(ISBLANK(Estimate_Rejection_Date__c ))
),
AND(
ISCHANGED( Inspected__c ),
NOT(ISBLANK(Inspected__c ))
),
AND(
ISCHANGED( XASP_Recent_Activity__c ),
NOT(ISBLANK(XASP_Recent_Activity__c ))
)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Prelim Last Modified</fullName>
        <actions>
            <name>Job_Send_Prelim_Last_Modified_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Job_Send_Prelim_Last_Modified_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Records the user that modified the &apos;Send Prelim&apos; field and the date/time of modification.</description>
        <formula>AND(ISCHANGED( Send_Prelim__c ),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send client welcome email when job is marked won</fullName>
        <actions>
            <name>Send_client_welcome_email_when_job_is_marked_won</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Date_Time_Client_Welcome_Email_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sent_client_welcome_email</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9</booleanFilter>
        <criteriaItems>
            <field>ATI_Job__c.Stage__c</field>
            <operation>equals</operation>
            <value>Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Project_Site_Contact_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Date_Time_Client_Welcome_Email_Sent__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager_New_Full_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Division__c</field>
            <operation>notEqual</operation>
            <value>Consulting,Marketing</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Estimate_Only__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Ladder_Assist__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Sends client welcome email when the job is marked as won and there is a superintendent/operations manager entered</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Mod Alloc - Consultants</fullName>
        <actions>
            <name>Set_Mod_Alloc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4 OR 5 OR 6) AND 7</booleanFilter>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>equals</operation>
            <value>Rudi Suminski</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>equals</operation>
            <value>Brian Bailey</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>equals</operation>
            <value>Consultant Consultant</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>equals</operation>
            <value>Thomas Moreno</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>equals</operation>
            <value>Andy England</value>
        </criteriaItems>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>equals</operation>
            <value>Aaron Berkman</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Sets the modified allocations field to &quot;22.5&quot; for jobs where PM is Rudi Suminski, Brian Bailey, Consultant, Thomas Moreno, Andy England, or Aaron Berkman.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set PN Request Date if Send Prelim is Yes</fullName>
        <actions>
            <name>Set_PN_Request_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Send_Prelim__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Send Prelim field to no for program jobs</fullName>
        <actions>
            <name>Set_Send_Prelim_field_to_no_for_prg_jobs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Workflow rule to update &apos;Send Prelim&apos; field to &apos;No&apos; for most program Jobs, all national accounts (lead source), all contents, marketing, and consulting jobs, certain accounts, and all jobs in certain states.</description>
        <formula>AND(ISPICKVAL(Send_Prelim__c, &quot;&quot;) &amp;&amp;   	((BEGINS(TEXT(Lead_Source__c), &quot;Program&quot;) &amp;&amp; NOT(ISPICKVAL(Lead_Source__c, &quot;Program - Contractor Connection&quot;))) ||   	BEGINS(TEXT(Lead_Source__c),&quot;National Account__r&quot;) || ISPICKVAL(Division__c,&quot;Contents&quot;) || ISPICKVAL(Division__c,&quot;Marketing&quot;) || ISPICKVAL(Division__c,&quot;Consulting&quot;) || ISPICKVAL(Job_Class__c,&quot;Educational&quot;) || ISPICKVAL(Job_Class__c,&quot;Municipality/ Gov&apos;t&quot;) || BEGINS(Account__r.Name, &quot;Allstate&quot;) || BEGINS(Account__r.Name, &quot;Alacrity&quot;) || BEGINS(Account__r.Name, &quot;Encompass&quot;) || BEGINS(Account__r.Name, &quot;CSAA&quot;) || BEGINS(Account__r.Name, &quot;Farmers&quot;) || BEGINS(Account__r.Name, &quot;Watterson&quot;) || BEGINS(Account__r.Name, &quot;JC Penney&quot;) || BEGINS(Account__r.Name, &quot;JP Morgan Chase&quot;) || BEGINS(Account__r.Name, &quot;Wyndham Worldwide&quot;) || BEGINS(Account__r.Name, &quot;National Community Renaissance&quot;) || BEGINS(Account__r.Name, &quot;Burlington Northern&quot;) || BEGINS(Account__r.Name, &quot;Facility Source&quot;) || BEGINS(Account__r.Name, &quot;Jones Lang LaSalle Americas&quot;) || BEGINS(Account__r.Name, &quot;2B Adjusting&quot;) || BEGINS(Account__r.Name, &quot;Essex Property Trust&quot;) || BEGINS(Account__r.Name, &quot;Wal-Mart&quot;) || BEGINS(Account__r.Name, &quot;City of Phoenix&quot;) || BEGINS(Account__r.Name, &quot;Aimco Property Management&quot;) || BEGINS(Account__r.Name, &quot;Cushman &amp; Wakefield&quot;) || BEGINS(Account__r.Name, &quot;St. Joseph&apos;s Hosp.&quot;) || BEGINS(Account__r.Name, &quot;Walgreens&quot;) || BEGINS(Account__r.Name, &quot;Watterson Environmental Group&quot;) || BEGINS(Account__r.Name, &quot;Prometheus Real Estate Group&quot;) || BEGINS(Account__r.Name, &quot;Irvine Company&quot;) || Project_Site_State__c = &quot;CO&quot; || Project_Site_State__c = &quot;CT&quot; || Project_Site_State__c = &quot;DE&quot; || (Project_Site_State__c = &quot;FL&quot; &amp;&amp; ISPICKVAL(Job_Class__c,&quot;Residential&quot;)) || Project_Site_State__c = &quot;HI&quot; || Project_Site_State__c = &quot;ID&quot; || Project_Site_State__c = &quot;IL&quot; || Project_Site_State__c = &quot;KY&quot; || Project_Site_State__c = &quot;MD&quot; || Project_Site_State__c = &quot;NE&quot; || Project_Site_State__c = &quot;NJ&quot; || Project_Site_State__c = &quot;NY&quot; || Project_Site_State__c = &quot;ND&quot; || Project_Site_State__c = &quot;PA&quot; || Project_Site_State__c = &quot;VT&quot;),$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task reminder to PM to call customer at 42 hours after approval</fullName>
        <active>false</active>
        <description>Automatic task creation 42 hours after approval of an opportunity if the PM has not yet modified the record.</description>
        <formula>AND ( RecordTypeId = &quot;012n00000000B3t&quot;, ISPICKVAL (Stage__c, &quot;Qualified&quot;), Date_Time_Approved__c &gt; LastModifiedDate,$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_to_follow_up_with_job_contact</name>
                <type>Task</type>
            </actions>
            <offsetFromField>ATI_Job__c.Date_Time_Approved__c</offsetFromField>
            <timeLength>42</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update 1sub checkbox%2C PM%2C and PM Approval Only checkbox</fullName>
        <actions>
            <name>Check_PM_Approval_Only_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_PM_to_Pete_Carlson</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>check_1sub_checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Project_Manager__c</field>
            <operation>equals</operation>
            <value>Cort Gilliam</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>If Cort Gilliam is the Project Director, check the 1sub checkbox, assign the PM as Pete Carlson, and check the PM Approval Only checkbox.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Close Date when Won or Lost</fullName>
        <actions>
            <name>Update_Close_Date_when_Won_or_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Stage__c</field>
            <operation>equals</operation>
            <value>Won,Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Last Timberline Update field</fullName>
        <actions>
            <name>Update_Last_Timberline_Update_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Updates Last Timberline Update field with current date time when a record is saved.</description>
        <formula>AND(
OR(
AND(ISCHANGED(Stage__c),
ISPICKVAL(Stage__c, &quot;Won&quot;)) ,
Sync_to_Timberline__c = TRUE,
ISCHANGED(PM_Approval_Only__c),
AND(OR(ISCHANGED(Project_Manager_new__c),
ISCHANGED(Project_Manager__c),
ISCHANGED(Account_Executive_1_Timber__c),
ISCHANGED(Account_Executive_2_Timber__c),
ISCHANGED(Job_Name__c)
),
NOT(ISNULL( Last_Successful_Timberline_Update__c)),
X1sub__c = FALSE)),
$Profile.Name &lt;&gt; &quot;Restricted Process Execution&quot;, Project_Manager__c &lt;&gt; null)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wine Country Fire Notification</fullName>
        <actions>
            <name>Wine_Country_Fire_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ATI_Job__c.Job_Category__c</field>
            <operation>equals</operation>
            <value>Wine Country Fires</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Restricted Process Execution</value>
        </criteriaItems>
        <description>Kelli Smith would like to be notified for any lead is created for bay area.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Call_Union_Bring_in_New_Hires_Contact_Payroll</fullName>
        <assignedToType>owner</assignedToType>
        <description>Call the Union, bring in workers for new hire orientation and contact payroll to discuss hiring procedures.  Task is due within 6 hours of creation.  Escalate to Steve if not completed.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Call Union, Bring in New Hires &amp; Contact Payroll</subject>
    </tasks>
    <tasks>
        <fullName>Reminder_to_follow_up_with_job_contact</fullName>
        <assignedToType>owner</assignedToType>
        <description>It has been 42 hours since this Job has been approved and the record.  Please follow up with the client.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>ATI_Job__c.Date_Time_Approved__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Reminder to follow up with job contact</subject>
    </tasks>
    <tasks>
        <fullName>Sent_client_welcome_email</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent client welcome email</subject>
    </tasks>
</Workflow>