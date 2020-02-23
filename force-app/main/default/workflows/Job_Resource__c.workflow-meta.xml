<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Resource_Type_Field_Update</fullName>
        <field>Name</field>
        <formula>Resource_Name__r.Title</formula>
        <name>Resource Type Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Resource Type Field Update</fullName>
        <actions>
            <name>Resource_Type_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Job_Resource__c.Resource_Title__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Resource Type Update</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Job_Resource__c.Resource_Title__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
