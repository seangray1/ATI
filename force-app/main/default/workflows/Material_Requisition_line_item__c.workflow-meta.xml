<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Extended_Cost_Value</fullName>
        <field>Extended_Cost_Value__c</field>
        <formula>Extended_Cost__c</formula>
        <name>Update Extended Cost Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Extended Value Changed</fullName>
        <actions>
            <name>Update_Extended_Cost_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Material_Requisition_line_item__c.Extended_Cost__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When Extended Cost changes update the same into Extended Cost Value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
