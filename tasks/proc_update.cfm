<!--- add live stats that are not captured in import --->
<cfquery name="qActives" datasource="lwfa">
	SELECT		first,last,nflteam,playerID
	FROM		players
	WHERE		active='Y'
	order by 	playerid
</cfquery>

<cfset sqlUpdated = ''>

<cfloop query="qActives">
	<cfquery name="qLiveStats" datasource="lwfa">
		SELECT		*
		FROM		livedata
		WHERE		playerID = #qActives.playerID#
	</cfquery>
	<cfquery name="qImportStats" datasource="lwfa">
		SELECT		*
		FROM		playerdata p join weeks w on p.weekno=w.currwk
		WHERE		playerID = #qActives.playerID#  
	</cfquery>
	<cfloop list="passyds,passTD,passint,rushyds,rushtd,recyds,rectd,fumble,defint,ff,fr,inttd,kryds,krtd,pryds,prtd,defintyds" index="LOCAL.statName">
		<cfif qLiveStats[ LOCAL.statname ][1] neq qImportStats[ LOCAL.statname ][1] AND qImportStats[ LOCAL.statname ][1] neq '' AND qLiveStats[ LOCAL.statname ][1] neq ''>
			<cfquery name="qProposal" datasource="#application.dsn#" result="sResult">
				UPDATE 	playerdata
				SET		#LOCAL.statName# = #qLiveStats[ LOCAL.statname ][1]#
				WHERE	playerID = #qActives.playerID#  AND weekno = #application.currwk#
			</cfquery>
			<cfinvoke component="2012.cfc.functions" method="updatePlayerLine" playerID="#qActives.playerID#">
			<cfset temp = application.cfc.functions.updatePlayerLine( qActives.playerID )>
			<cfset sqlUpdated = sqlUpdated & sResult.sql & "<br>">
		</cfif>
	</cfloop>		
</cfloop>

<!--- send confirmation email --->
<cfset LOCAL.mailAttr = application.mailAttributes>
<cfset LOCAL.mailAttr.from="claims@lwfa.org">
<cfset LOCAL.mailAttr.to="liammkelly@gmail.com">
<cfset LOCAL.mailAttr.subject="Live stat updates">

<cftry>
	<cfmail attributecollection="#LOCAL.mailAttr#">
		#sqlUpdated#
	</cfmail>
	<cfcatch></cfcatch>
</cftry>

<cfif dayOfWeek( now() ) eq 3>
	
	<!--- COMPILE STATS --->
	<cfinclude template="../admin/act_compileStats.cfm">
	
	<!--- UPDATE SCORES --->
	<cfinclude template="../admin/act_updateScores.cfm">
	
	<!--- UPDATE STANDINGS --->
	<cfinclude template="../admin/standadmin.cfm">
	
	<!--- UPDATE MVP --->
	<cfinclude template="../admin/act_updateWeekMVP.cfm">
	
	<!--- ADVANCE WEEK --->
	<cfinclude template="../admin/act_advanceWeek.cfm">
	
	<!--- UPDATE MVP --->
	<cfinclude template="../admin/act_updateRanks.cfm">

</cfif>