<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Work_Order_Email</fullName>
        <description>New Work Order Email</description>
        <protected>false</protected>
        <recipients>
            <field>Addiotional_Email_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Email_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Operations_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Work_Order</template>
    </alerts>
    <alerts>
        <fullName>Work_Order_Approved</fullName>
        <description>Work Order Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Addiotional_Email_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Email_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Work_Order_Approved</template>
    </alerts>
    <alerts>
        <fullName>Work_Order_Assignment_Email_Corp</fullName>
        <description>Work Order Assignment Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>lejia.islas@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Work_Order_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Work_Order_Rejection</fullName>
        <description>Work Order Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Work_Order_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Work_Order_Reminder_Email_for_Submission</fullName>
        <description>Work Order Reminder Email for Submission</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Work_Order_Reminder_Email_for_Submission</template>
    </alerts>
    <fieldUpdates>
        <fullName>WO_Approved_By</fullName>
        <field>Approved_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>WO Approved By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WO_Date_Time_Approved</fullName>
        <field>Date_Time_Approved__c</field>
        <formula>NOW()</formula>
        <name>WO Date/Time Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WO_Submittal_Date_Time</fullName>
        <field>Date_Time_Submitted_for_Approval__c</field>
        <formula>NOW()</formula>
        <name>WO Submittal Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WO_Submitted_for_Approval_By</fullName>
        <field>Submitted_for_Approval_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>WO Submitted for Approval By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Additional Email Notification Email Alert</fullName>
        <actions>
            <name>New_Work_Order_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Work_Order__c.Division__c</field>
            <operation>equals</operation>
            <value>Contents,Emergency Svces,Construction,Asbestos,Lead,Health Services,Microbial,Biohazard</value>
        </criteriaItems>
        <criteriaItems>
            <field>Work_Order__c.Additional_Email_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Work_Order__c.Addiotional_Email_2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When any of the Additional Email fields are filled in, this workflow will fire sending them an email notification.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Work Order Assignment - Corp</fullName>
        <actions>
            <name>Work_Order_Assignment_Email_Corp</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Assigned_To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Work_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Construction Work Order</value>
        </criteriaItems>
        <description>Construction will receive this without the approval. All others will receive though approvals.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Work Order Pending for Submission%2E</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Work_Order__c.Date_Time_Submitted_for_Approval__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Work_Order__c.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>2/23/2017</value>
        </criteriaItems>
        <criteriaItems>
            <field>Work_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Restoration Work Order,Environmental Work Order</value>
        </criteriaItems>
        <description>A reminder email alert for user to submit for approval.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Work_Order_Reminder_Email_for_Submission</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Work_Order__c.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
