<cfquery name="qClaimInfo" datasource="lwfa">
	select * from claims where claimID = #claimID#
</cfquery>

<!--- set claimed player back to FA --->
<cfquery datasource="lwfa">
	UPDATE players SET teamID = 0 WHERE playerID = #qClaimInfo.dmpid#
</cfquery>

<!--- return dropped player to team --->
<cfquery datasource="lwfa">
	UPDATE players SET teamID = #qClaimInfo.teamID# WHERE playerID = #qClaimInfo.clmid#
</cfquery>

<!--- change claim from approved to rejected --->
<cfquery datasource="lwfa">
	UPDATE claims SET statusID = 3 where claimID = #claimID#
</cfquery>
