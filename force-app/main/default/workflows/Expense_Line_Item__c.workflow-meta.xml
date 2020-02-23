<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>isCreated_true</fullName>
        <field>isCreated__c</field>
        <literalValue>1</literalValue>
        <name>isCreated = true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>isCreated %3D true</fullName>
        <actions>
            <name>isCreated_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Expense_Line_Item__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This will be checked when a record is created for locking the record.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
