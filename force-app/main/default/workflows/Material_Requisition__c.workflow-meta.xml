<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MR_In_Progress_Record_Reminder</fullName>
        <description>MR In Progress Record Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/MR_In_Progress_Email_Reminder</template>
    </alerts>
    <rules>
        <fullName>MR In Progress Alert</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Material_Requisition__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <description>Send reminder email to MR creator and PM when MR is not marked complete 5 days after creation.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>MR_In_Progress_Record_Reminder</name>
                <type>Alert</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
