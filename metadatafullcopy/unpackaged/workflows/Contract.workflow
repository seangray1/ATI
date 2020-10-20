<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ERA_Approval_Alert</fullName>
        <description>ERA Approval Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>AE_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contract_Email_Templates/ERA_Approval</template>
    </alerts>
    <alerts>
        <fullName>ERA_Rejected_Alert</fullName>
        <description>ERA Rejected Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contract_Email_Templates/ERA_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>Contract_Activation_upon_Start_Date</fullName>
        <field>Status</field>
        <literalValue>Activated</literalValue>
        <name>Contract Activation upon Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ERA_Approval_Date</fullName>
        <description>When The ERA is approved, it will stamp the approval date.</description>
        <field>Approval_Date__c</field>
        <formula>today()</formula>
        <name>ERA Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ERA_Approval_Process_Status_Update</fullName>
        <field>Status</field>
        <literalValue>In Approval Process</literalValue>
        <name>ERA Approval Process Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ERA_Status_Update</fullName>
        <field>Status</field>
        <literalValue>Expired</literalValue>
        <name>ERA Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ERA_Status_Update_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>ERA Status Update to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ERA_Status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>ERA Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contract Activation upon Start Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Contract_Activation_upon_Start_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contract.StartDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ERA 3 month expiration task reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.EndDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ERA_Expiration_Notice</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Contract.EndDate</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ERA Status Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.EndDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Automatic ERA Status Update to Expired when End Date is today</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ERA_Status_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contract.EndDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>ERA_Expiration_Notice</fullName>
        <assignedToType>owner</assignedToType>
        <description>ERA is expiring in 3 months.  Please follow up with the customer for a new signed agreement.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>ERA Expiration Notice</subject>
    </tasks>
</Workflow>
