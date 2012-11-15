<cfquery name="qClaimInfo" datasource="lwfa">
	select * from claims where claimID = #claimID#
</cfquery>

<!--- set claimed player back to FA --->
<cfquery datasource="lwfa">
	UPDATE players SET teamID = 0 WHERE playerID = #qClaimInfo.clmid#
</cfquery>

<!--- return dropped player to team --->
<cfquery datasource="lwfa">
	UPDATE players SET teamID = #qClaimInfo.teamID# WHERE playerID = #qClaimInfo.dmpid#
</cfquery>

<!--- change claim from approved to rejected --->
<cfquery datasource="lwfa">
	UPDATE claims SET statusID = 2 where claimID = #claimID#
</cfquery>
