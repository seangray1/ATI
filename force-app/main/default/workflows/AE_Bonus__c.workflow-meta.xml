<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Extra_Credit_Bonus_Billed_Rev_Quota</fullName>
        <field>Extra_Cred_Bonus_Billed_Rev_Quota3__c</field>
        <formula>IF((Extra_Cred_Bonus_Billed_Rev_Quota__c *  Billed_Rev_Over_Quota_This_Quarter__c)&gt; (Total_Bonus_earned_this_Quarter__c-  Total_Base_Bonus__c), (Total_Bonus_earned_this_Quarter__c- Total_Base_Bonus__c),
Extra_Cred_Bonus_Billed_Rev_Quota__c *  Billed_Rev_Over_Quota_This_Quarter__c)</formula>
        <name>Extra Credit Bonus Billed Rev/Quota $</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_Base_Bonus_Commission_Population</fullName>
        <field>Total_Base_Bonus__c</field>
        <formula>IF(AND( Rev_Quota__c &gt;=1.0,
ISPICKVAL( Owner:User.AE_Type__c,&quot;Local&quot;)),
35 * Total_Base_Bonus_Points__c,
IF(AND( Rev_Quota__c&gt;=1.0,
ISPICKVAL( Owner:User.AE_Type__c,&quot;Regional&quot;)),
45 * Total_Base_Bonus_Points__c,
IF(AND( Rev_Quota__c&gt;=1.0,
ISPICKVAL( Owner:User.AE_Type__c,&quot;National&quot;)),
55 * Total_Base_Bonus_Points__c,0)))</formula>
        <name>Total Base Bonus Commission $ Population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Extra Credit Bonus Billed Rev%2FQuota %24</fullName>
        <actions>
            <name>Extra_Credit_Bonus_Billed_Rev_Quota</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Total_Base_Bonus__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Total Base Bonus Commission %24 Population</fullName>
        <actions>
            <name>Total_Base_Bonus_Commission_Population</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AE_Bonus__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
