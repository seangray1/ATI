<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Budget_Approval_Request</fullName>
        <description>Budget Approval Request</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Budget_Approval_Required</template>
    </alerts>
    <alerts>
        <fullName>Budget_Approved</fullName>
        <description>Budget Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Budget_Approved</template>
    </alerts>
    <alerts>
        <fullName>Budget_Rejected</fullName>
        <description>Budget Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Budget_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Budget_Rejected1</fullName>
        <description>Budget Rejected1</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Regional_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ATI_Job_Templates/Budget_Rejected1</template>
    </alerts>
    <alerts>
        <fullName>Notify_PD_PM_RM_when_JTD_costs_are_within_20_of_total_actual_costs_from_budget</fullName>
        <description>Notify PD, PM, RM when JTD costs are within 20% of total actual costs from budget</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Regional_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Budget_Email_Templates/Job_cost_approaching_total_budget</template>
    </alerts>
    <fieldUpdates>
        <fullName>Budget_Approved</fullName>
        <field>Approved_Budget__c</field>
        <literalValue>1</literalValue>
        <name>Budget Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flag</fullName>
        <field>Flag__c</field>
        <literalValue>1</literalValue>
        <name>Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Budget_Status_to_Approved</fullName>
        <field>Budget_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Budget Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Budget_Status_to_Rejected</fullName>
        <field>Budget_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Budget Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Budget_Status_to_Submitted</fullName>
        <field>Budget_Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Update Budget Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Notify when JTD Costs reaches 80%25 of total actual costs on budget</fullName>
        <actions>
            <name>Notify_PD_PM_RM_when_JTD_costs_are_within_20_of_total_actual_costs_from_budget</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(Job__r.Job_to_Date_Costs__c  &gt; 0, Total_Actual_Costs__c  &gt; 0, Job__r.Job_to_Date_Costs__c  &gt;= (0.8 * Total_Actual_Costs__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify when JTD Costs reaches 80%25 of total actual costs on budget%28Financial%29</fullName>
        <actions>
            <name>Notify_PD_PM_RM_when_JTD_costs_are_within_20_of_total_actual_costs_from_budget</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  ATI_Job__r.Job_to_Date_Cost_Workflow_Field__c   &gt; 0, Total_Actual_Costs__c  &gt; 0, ATI_Job__r.Job_to_Date_Cost_Workflow_Field__c    &gt;= (0.8 * Total_Actual_Costs__c), Flag__c = FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
