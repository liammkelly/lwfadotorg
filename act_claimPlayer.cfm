<cfparam name="deactivate" default="0">
<cfset sleep(1000)>
<cfif deactivate eq "true">
	<cfset inj = 1>
<cfelse>
	<cfset inj = 0>
</cfif>
<cfquery name="iClaim" datasource="lwfa">
	insert into claims (deactivate,clmid<cfif dropID neq ''>,dmpid</cfif>,teamID,statusID,priority,dt) VALUES (#inj#,#addID#<cfif dropID neq ''>,#dropID#</cfif>,#cookie.teamID#,1,99,#now()#)
</cfquery>