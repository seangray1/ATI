<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Annual_Quota_Reminder_Emails_to_Branch_Managers</fullName>
        <description>Send Annual Quota Reminder Emails to Branch Managers</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AE_Quota_for_Branch_Manager</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Send_Annual_Quota_Reminder_Email</fullName>
        <field>Send_Anual_Quota_Update_Reminder_Email__c</field>
        <literalValue>0</literalValue>
        <name>Update Send Annual Quota Reminder Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Send Annual Quota Reminder Emails</fullName>
        <actions>
            <name>Send_Annual_Quota_Reminder_Emails_to_Branch_Managers</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Send_Annual_Quota_Reminder_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Send_Anual_Quota_Update_Reminder_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
