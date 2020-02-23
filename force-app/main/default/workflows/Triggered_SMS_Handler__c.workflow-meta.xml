<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Check_ISSENT_box</fullName>
        <field>IsSent__c</field>
        <literalValue>1</literalValue>
        <name>Check ISSENT box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Check ISSENT to Send SMS</fullName>
        <actions>
            <name>Check_ISSENT_box</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Triggered_SMS_Handler__c.MobileNumber__c</field>
            <operation>equals</operation>
            <value>7144122411</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
