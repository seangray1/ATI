<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Budget_Allocation_update</fullName>
        <field>Allocation_Amount__c</field>
        <formula>Allocations__c</formula>
        <name>Budget Allocation update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budget_Goal_Update</fullName>
        <field>Budget_Goal_Amount__c</field>
        <formula>Budget_Goal__c</formula>
        <name>Budget Goal Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Budget Update</fullName>
        <actions>
            <name>Budget_Allocation_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Budget_Goal_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
