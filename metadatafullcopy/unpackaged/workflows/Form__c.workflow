<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PRLDE_Update_Count</fullName>
        <field>Forms_Count_Jobs__c</field>
        <formula>IF(TEXT(New_Job_Number__r.Forms_Count_Jobs__c) == &apos;&apos;, 1, VALUE(TEXT(New_Job_Number__r.Forms_Count_Jobs__c)) + 1)</formula>
        <name>PRLDE Update Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>New_Job_Number__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PRLDE_Update_Form_Name</fullName>
        <field>Name</field>
        <formula>IF(TEXT(New_Job_Number__r.Forms_Count_Jobs__c) == &apos;&apos;, 
&apos;FA&apos;+&apos;-&apos;+ New_Job_Number__r.Job_Number_No_Dashes__c+ &apos;-1&apos;, 
&apos;FA&apos;+&apos;-&apos;+ New_Job_Number__r.Job_Number_No_Dashes__c+ &apos;-&apos;+ TEXT( VALUE(TEXT(New_Job_Number__r.Forms_Count_Jobs__c)) + 1))</formula>
        <name>PRLDE Update Form Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PRLDE Update Form Name</fullName>
        <actions>
            <name>PRLDE_Update_Form_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PRLDE_Form_Creation</fullName>
        <actions>
            <name>PRLDE_Update_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
