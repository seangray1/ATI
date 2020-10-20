<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Send_Batch_Details_to_Jitterbit</fullName>
        <apiVersion>40.0</apiVersion>
        <endpointUrl>https://ATI69420.jitterbit.net/PROD/MRBatchAPICall</endpointUrl>
        <fields>Accounting_Date__c</fields>
        <fields>Batch_Date__c</fields>
        <fields>Batch_Value__c</fields>
        <fields>Id</fields>
        <fields>Number_of_Entries__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>jitterbit@atirestoration.com</integrationUser>
        <name>Send Batch Details to Jitterbit</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Jitterbit Batch OBM</fullName>
        <actions>
            <name>Send_Batch_Details_to_Jitterbit</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Batch__c.Timberline_Batch_No__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Batch__c.Send__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
