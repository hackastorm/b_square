<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Sending_succsful_payment_reciept</fullName>
        <ccEmails>shubham_bangad@yahoo.com</ccEmails>
        <ccEmails>barkhapatel1902@gmail.com</ccEmails>
        <description>Sending succsful payment reciept</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>shubham_bangad@yahoo.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Reciept</template>
    </alerts>
    <rules>
        <fullName>Send reciept</fullName>
        <actions>
            <name>Sending_succsful_payment_reciept</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Receipt_URL__c ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
