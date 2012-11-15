<cfset counter = 1>
<cftry>
<cfloop list="#form.neworder#" index="n">
	<cfquery name="qPendingDeal" datasource="lwfa">
		UPDATE claims SET priority=#counter# WHERE claimID = #n#
	</cfquery>
	<cfset counter += 1>
</cfloop>
<cfcatch type="any">An error occurred</cfcatch>
</cftry>