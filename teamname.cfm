<cfparam name="attributes.teamID" default="0">
<cfparam name="attributes.full" default="0">
<cfparam name="attributes.record" default="0">
<cfparam name="attributes.output" default="1">

<cfquery name="qTeam" datasource="lwfa">
	SELECT		t.*,s.win,s.loss
	FROM		teams t join standings s on t.teamID=s.teamID
	WHERE		t.teamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.teamID#" />
</cfquery>

<cfset caller.team = qTeam.name>
<cfif attributes.full>
	<cfset caller.team = caller.team&" "&qTeam.nickname>
</cfif>
<cfif attributes.record>
	<cfset caller.team = caller.team&" ("&qTeam.win&"-"&qTeam.loss&")">
</cfif>
<cfif attributes.output>
<cfoutput>#caller.team#</cfoutput>
</cfif>