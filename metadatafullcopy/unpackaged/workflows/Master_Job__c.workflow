<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
</Workflow>