<cfquery name="qGetorder" datasource="lwfa">
	select 		teamID
	from		standings
	order by 	winpct,pf
</cfquery>

<cfloop query="qGetorder">
	<cfquery datasource="lwfa">
		UPDATE 	standings
		SET		claimsrank=#currentrow#
		WHERE 	teamID=#qGetorder.teamID#
	</cfquery>
</cfloop>