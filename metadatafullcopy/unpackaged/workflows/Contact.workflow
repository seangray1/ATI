<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Lunch_and_Learn_Approval</fullName>
        <description>Lunch and Learn Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Lunch_and_Learn_Submitter_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contact_Email_Templates/Lunch_and_Learn_Approval</template>
    </alerts>
    <alerts>
        <fullName>Lunch_and_Learn_Rejection</fullName>
        <description>Lunch and Learn Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Lunch_and_Learn_Submitter_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contact_Email_Templates/Lunch_and_Learn_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Ownership_Request_Approval</fullName>
        <description>Ownership Request Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Ownership_Request_Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contact_Email_Templates/Contact_Ownership_Request_Approval</template>
    </alerts>
    <alerts>
        <fullName>Ownership_Request_Rejection_Email</fullName>
        <description>Ownership Request Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contact_Email_Templates/Contact_Ownership_Request_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>Contact_Ownership_Requester</fullName>
        <description>Field update to populate submitter of Contact ownership request</description>
        <field>Contact_Ownership_Requester__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Contact Ownership Requester</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Opt_Out_Date</fullName>
        <field>Email_Opt_Out_Date__c</field>
        <formula>TODAY()</formula>
        <name>Email Opt Out Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lunch_and_Learn_Status_to_Approved</fullName>
        <description>Field update to set Lunch and Learn Status to Approved upon approval of Lunch and Learn Approval process</description>
        <field>Lunch_and_Learn_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Lunch and Learn Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lunch_and_Learn_Status_to_Rejected</fullName>
        <description>Field update to set Lunch and Learn Status to Rejected upon rejection of Lunch and Learn Approval Process</description>
        <field>Lunch_and_Learn_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Lunch and Learn Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lunch_and_Learn_Status_to_Unapproved</fullName>
        <description>Field update to set Lunch and Learn Status to Unapproved upon submission of Lunch and Learn Approval Process</description>
        <field>Lunch_and_Learn_Status__c</field>
        <literalValue>Unapproved</literalValue>
        <name>Lunch and Learn Status to Unapproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ownership_Request_Status_to_Approved</fullName>
        <description>Field update to set Ownership Request Status to Approved upon approval of Contact Ownership Request Approval Process.</description>
        <field>Ownership_Request_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Ownership Request Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ownership_Request_Status_to_Rejected</fullName>
        <description>Field update to set Ownership Request Status to Rejected</description>
        <field>Ownership_Request_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Ownership Request Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ownership_Request_Status_to_Unapproved</fullName>
        <description>Field update to set Ownership Request Status to Unapproved upon initiation of Contact Ownership Request Approval Process</description>
        <field>Ownership_Request_Status__c</field>
        <literalValue>Unapproved</literalValue>
        <name>Ownership Request Status to Unapproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ownership_Request_Submitter_Email</fullName>
        <description>Field update to populate Ownership Request submitter&apos;s email</description>
        <field>Ownership_Request_Submitter_Email__c</field>
        <formula>$User.Email</formula>
        <name>Ownership Request Submitter Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ownership_Requester_ID</fullName>
        <field>Ownership_Requester_ID__c</field>
        <formula>$User.Id</formula>
        <name>Ownership Requester ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Opt Out Date</fullName>
        <actions>
            <name>Email_Opt_Out_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
