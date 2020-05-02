<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Waiver_Approved_Notification</fullName>
        <description>Waiver Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Waiver_Templates/Waiver_Approved</template>
    </alerts>
    <alerts>
        <fullName>Waiver_Rejected_Notification</fullName>
        <description>Waiver Rejected Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Waiver_Templates/Waiver_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approver_Id</fullName>
        <field>Approved_By_Id__c</field>
        <formula>$User.Id</formula>
        <name>Approver Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Submitted_for_Approval</fullName>
        <description>Time stamp to indicate when an unconditional waiver has been submitted for approval</description>
        <field>Date_Time_Submitted_for_Approval__c</field>
        <formula>NOW ()</formula>
        <name>Date/Time Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lock_letter_after_PDF_generation</fullName>
        <description>This workflow updates the Letter record type and page layout to the locked record type after the Letter PDF has been generated.</description>
        <field>RecordTypeId</field>
        <lookupValue>Locked_Letter</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lock letter after PDF generation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lock_waiver_after_PDF_generation</fullName>
        <description>This workflow updates the Waiver record type and page layout to the locked record type after the Waiver PDF has been generated.</description>
        <field>RecordTypeId</field>
        <lookupValue>Locked_Waiver</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lock waiver after PDF generation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lock letter after PDF generation</fullName>
        <actions>
            <name>Lock_letter_after_PDF_generation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Waiver__c.Final__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Waiver__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Letter</value>
        </criteriaItems>
        <description>This workflow updates the Letter record type and page layout to the locked record type after the Letter PDF has been generated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lock waiver after PDF generation</fullName>
        <actions>
            <name>Lock_waiver_after_PDF_generation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Waiver__c.Final__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Waiver__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Waiver</value>
        </criteriaItems>
        <description>This workflow updates the Waiver record type and page layout to the locked record type after the Waiver PDF has been generated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
