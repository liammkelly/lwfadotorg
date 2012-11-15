<cfif NOT structKeyExists(cookie,'lwfaadmin') OR cookie.lwfaadmin eq 0>
	<cflocation url="../index.cfm" />
</cfif>

<cfquery name="qweekno" datasource="lwfa">
	select currwk 
	from weeks 
</cfquery>
<cfset currwk=qweekno.currwk>
<cfset prevwk=currwk-1>	