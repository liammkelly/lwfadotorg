<cfquery name="qCancel" datasource="lwfa">
	update claims
	set		statusID=6
	where	claimID=#cancelID#
</cfquery>