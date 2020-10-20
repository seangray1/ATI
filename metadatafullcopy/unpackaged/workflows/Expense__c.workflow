<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Expense_Status_Update</fullName>
        <description>Expense Status Update</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Expense_Reports_Emails/Expense_Reports_Approval_Response_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved_Date</fullName>
        <field>Approved_Date__c</field>
        <formula>NOW()</formula>
        <name>Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Submitted</fullName>
        <field>Date_Submitted__c</field>
        <formula>NOW()</formula>
        <name>Date Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Recalled</fullName>
        <field>Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Status = Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status = Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Submitted</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Status = Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>status_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>status = Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
