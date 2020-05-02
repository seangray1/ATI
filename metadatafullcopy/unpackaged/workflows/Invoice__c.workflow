<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Invoice_Reject_Email_Alert</fullName>
        <description>Invoice Reject Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Invoice_Templates/Invoice_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Notify_the_contact_on_National_Account_when_an_Invoice_is_finalized</fullName>
        <description>Notify the contact on National Account when an Invoice is finalized</description>
        <protected>false</protected>
        <recipients>
            <field>ATI_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply@atirestoration.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Invoice_Templates/National_Account</template>
    </alerts>
    <fieldUpdates>
        <fullName>Invoice_Approved_Date_Time</fullName>
        <field>Invoice_Approved_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Invoice Approved Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Invoice_Approver</fullName>
        <description>Field update used in Invoice Approval Process to populated the user that approved the record.</description>
        <field>Approved_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Invoice Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Invoice_Submitted_Date_Time</fullName>
        <field>Invoice_Submitted_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Invoice Submitted Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Invoice_Submitter</fullName>
        <field>Submitted_for_Approval_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Invoice Submitter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_set_to_Final</fullName>
        <description>Upon Approval of the Invoice, the Record Type will switch to Approved Invoice.</description>
        <field>RecordTypeId</field>
        <lookupValue>Final_Invoice</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type set to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Retainage_Held_update</fullName>
        <description>Copies the retainage amount from a formula field into the regular field (for backwards compatibility)</description>
        <field>Retainage_Held__c</field>
        <formula>retainage_amount__c</formula>
        <name>Retainage Held update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Finalized_By</fullName>
        <field>Finalized_By__c</field>
        <formula>$User.Id</formula>
        <name>Set Finalized By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Finalized_By_Name</fullName>
        <field>Finalized_By_Name__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Set Finalized By Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_TL_Sync_Flag</fullName>
        <description>Uncheck Send to Timberline Checkbox</description>
        <field>Send_To_Timberline__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck TL Sync Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Jitterbit_Invoice_OBM</fullName>
        <apiVersion>29.0</apiVersion>
        <endpointUrl>https://ATI69420.jitterbit.net/PROD/InvoiceAPICall</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>OwnerId</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>jitterbit@atirestoration.com</integrationUser>
        <name>Jitterbit Invoice OBM</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Jitterbit Invoice OBM</fullName>
        <actions>
            <name>Jitterbit_Invoice_OBM</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Invoice__c.Send_To_Timberline__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Invoice__c.Status__c</field>
            <operation>equals</operation>
            <value>Final</value>
        </criteriaItems>
        <description>Used in real time sync from Timberline to SFDC.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>National Account Notification on Finalized Invocie</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Invoice__c.ATI_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Invoice Finalized By field</fullName>
        <actions>
            <name>Set_Finalized_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Finalized_By_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Finalized By field to current userID when the status is set to Final</description>
        <formula>AND(OR(ISNEW(),ISCHANGED(Status__c)),  ISPICKVAL(Status__c, &quot;Final&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck TL Sync Flag</fullName>
        <actions>
            <name>Uncheck_TL_Sync_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Uncheck the TL Sync Checkbox once the Last Timberline updated date is changed</description>
        <formula>ISCHANGED( Last_Successful_Timberline_Sync__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Retainage field</fullName>
        <actions>
            <name>Retainage_Held_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Invoice__c.Retainage_Held_percent__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update retainage held with retainage amount</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
