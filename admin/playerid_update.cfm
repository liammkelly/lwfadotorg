<CFPARAM name="useStored" default="0">

<cfsetting requesttimeout="3000000">

<CFIF useStored eq "0">
<!--- using query, create structure of NFLIDs by active/inactive and then by team --->
<CFQUERY name="getPlayers" datasource="lwfa">
	SELECT		playerid,teamID,active
	FROM		players
	WHERE 		teamID<>0
	ORDER BY	teamID,active
</CFQUERY>

<CFSET existingPlayers=structnew()>
<CFSET existingPlayers.playerid=ArrayNew(1)>
<CFSET existingPlayers.teamID=ArrayNew(1)>
<CFSET existingPlayers.active=ArrayNew(1)>
<CFLOOP query="getPlayers">
<CFSCRIPT>
	existingPlayers.playerID[#currentrow#]=#trim(playerID)#;
	existingPlayers.teamID[#currentrow#]=#trim(teamID)#;
	existingPlayers.active[#currentrow#]=#trim(active)#;
</CFSCRIPT>
</CFLOOP>

<!--- <CFDUMP var="#existingPlayers#"><br> --->
arraylen(existingPlayers.playerID)=<cfoutput>#arraylen(existingPlayers.playerID)#</cfoutput>

<!--- serialize and insert structure of players into database --->
<CFWDDX action="CFML2WDDX" input="#existingPlayers#" output="v_existingPlayers">

<CFQUERY name="storePlayers" datasource="lwfa">
	INSERT INTO	
				storage
				(
				Object,
				creation_date
				)
				values
				(
				'#v_existingPlayers#',
				#now()#
				)
</CFQUERY>
</CFIF>

<!--- delete all players --->
<CFQUERY name="killPlayers" datasource="lwfa">
	truncate	players
</CFQUERY>

<!--- re-import all players from NFL.com --->
<CFSET positionsList="RB,QB,WR,TE,LB,DE,DT,CB,S,NT,K">
<CFLOOP list="#positionsList#" index="py">
	<CFSET searchPos=py>
	<CFINCLUDE template="act_playerImport.cfm">
	<cfset wait_time = 15>
	<cfscript>
		thread = createObject("java", "java.lang.Thread");
		thread.sleep(javaCast("long", 500*wait_time));
	</cfscript>
</CFLOOP>

<!--- update players table with team and active information --->
<CFQUERY name="resetPlayers" datasource="lwfa">
	select * from storage order by creation_date limit 1
</CFQUERY>
<CFSET existingPlayers=resetPlayers.object>
<CFWDDX action="WDDX2CFML" input="#existingPlayers#" output="existingPlayers">
<CFLOOP from="1" to="#arraylen(existingPlayers.playerID)#" index="oc">
	<CFQUERY name="updatePlayers" datasource="lwfa">
		UPDATE	players
		SET		active='#trim(existingPlayers.active[oc])#',teamID=#trim(existingPlayers.teamID[oc])#
		WHERE 	playerID=#trim(existingPlayers.playerID[oc])#
	</CFQUERY>
</CFLOOP>
