<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Status_to_Inactive</fullName>
        <field>Status__c</field>
        <literalValue>Inactive</literalValue>
        <name>Update Status to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MAJOR EVENT Update Status When End Date Populates</fullName>
        <actions>
            <name>Update_Status_to_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Major_Event__c.End_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Major_Event__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>