<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Activity_Type</fullName>
        <field>Activity_Type_2__c</field>
        <formula>TEXT(Type)</formula>
        <name>Activity Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TaskTypeChange</fullName>
        <field>Type</field>
        <literalValue>Marketing Note</literalValue>
        <name>TaskTypeChange</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_Task_Record_To_Jitterbit</fullName>
        <apiVersion>48.0</apiVersion>
        <endpointUrl>https://ATI69420.jitterbit.net/DEV/jobAtiCall</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>sf.test@atirestoration.com</integrationUser>
        <name>Send Task Record To Jitterbit</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Activity Type</fullName>
        <actions>
            <name>Activity_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TaskTypeChage</fullName>
        <actions>
            <name>TaskTypeChange</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Activity_Type__c</field>
            <operation>equals</operation>
            <value>Marketing Note</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
