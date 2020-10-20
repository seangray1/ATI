<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LLR_Approval_Alert</fullName>
        <description>Large Loss Approval Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Large_Loss_Management_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Regional_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Regional_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Large_Loss_Review/Large_Loss_Review_Approved</template>
    </alerts>
    <alerts>
        <fullName>LLR_Rejection_Alert</fullName>
        <description>LLR Rejection Alert</description>
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
        <template>Large_Loss_Review/Large_Loss_Review_Rejected</template>
    </alerts>
    <alerts>
        <fullName>LL_30_Day_Review_Coming_Up</fullName>
        <description>LL - 30-Day Review Coming Up</description>
        <protected>false</protected>
        <recipients>
            <recipient>nat.lee@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sean.gray@atirestoration.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Large_Loss_Review/LARGE_LOSS_30_Day_Review_Coming_Up</template>
    </alerts>
    <alerts>
        <fullName>LL_30_Day_Review_Due</fullName>
        <description>LL - 30-Day Review Due</description>
        <protected>false</protected>
        <recipients>
            <recipient>Large_Loss_Management_Team</recipient>
            <type>group</type>
        </recipients>
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
        <senderType>CurrentUser</senderType>
        <template>Large_Loss_Review/LARGE_LOSS_30_Day_Review_Due</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_LLR_Status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set LLR Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_LLR_Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set LLR Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Approval</fullName>
        <field>Last_NLLS_Approval_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Last Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Approver</fullName>
        <field>Last_NLLS_Approver__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Update Last Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NLL_Reviewer</fullName>
        <field>NLL_Reviewer__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Update NLL Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NLSS_Reviewer</fullName>
        <field>Last_NLLS_Approver__c</field>
        <formula>$User.Id</formula>
        <name>Update NLSS Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Large Loss 30-Day Review Coming Up</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Large_Loss_Review__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <description>i.	Trigger:  Once for each open job where the last NLL review date is 20 days or more.
ii.	Recipients:  Project Director, Project Manager
iii.	Purpose:  Alert project director and manager to begin preparing the 30-day review.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>LL_30_Day_Review_Coming_Up</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Large_Loss_Review__c.CreatedDate</offsetFromField>
            <timeLength>20</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Large Loss 30-Day Review Due</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Large_Loss_Review__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <description>i.	Trigger:  Once for each open job where the last NCLS review date is 25 days or more.
ii.	Recipients:  Project Director, Project Manager, Regional Manager, NCLS
iii.	Purpose:  Alert all parties that the 30-day review is due within one week.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>LL_30_Day_Review_Due</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Large_Loss_Review__c.CreatedDate</offsetFromField>
            <timeLength>25</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
