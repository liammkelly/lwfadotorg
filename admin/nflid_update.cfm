<cfset currwk=6>
<CFPARAM name="requestTimeout" default="3600">
<CFPARAM name="useStored" default="1">

<CFIF useStored eq "0">
<!--- using query, create structure of NFLIDs by active/inactive and then by team --->
<CFQUERY name="getPlayers" datasource="lwfa">
	SELECT		nflid,team,active
	FROM		players
	WHERE 		team<>'None'
	ORDER BY	team,active
</CFQUERY>

<CFSET existingPlayers=structnew()>
<CFSET existingPlayers.nflid=ArrayNew(1)>
<CFSET existingPlayers.team=ArrayNew(1)>
<CFSET existingPlayers.active=ArrayNew(1)>
<CFLOOP query="getPlayers">
<CFSCRIPT>
	existingPlayers.nflid[#currentrow#]=#trim(nflid)#;
	existingPlayers.team[#currentrow#]=#trim(team)#;
	existingPlayers.active[#currentrow#]=#trim(active)#;
</CFSCRIPT>
</CFLOOP>

<!--- <CFDUMP var="#existingPlayers#"><br> --->
arraylen(existingPlayers.nflid)=<cfoutput>#arraylen(existingPlayers.nflid)#</cfoutput>

<!--- serialize and insert structure of players into database --->
<CFWDDX action="CFML2WDDX" input="#existingPlayers#" output="existingPlayers">
<CFQUERY name="storePlayers" datasource="lwfa">
	INSERT INTO	
				storage
				(
				StorageID,
				Object,
				creation_date
				)
				values
				(
				'1',
				'#existingPlayers#',
				#now()#
				)
</CFQUERY>
</CFIF>
<!--- delete all players --->
<CFQUERY name="killPlayers" datasource="lwfa">
	delete 		* 
	from 		players
</CFQUERY>

<!--- re-import all players from NFL.com --->
<CFSET positionsList="RB,QB,WR,TE,LB,DE,DT,CB,S,NT,K">
<CFLOOP list="#positionsList#" index="py">
	<CFSET searchPos=py>
	<CFINCLUDE template="../scoring/playersort_test.cfm">
	<cfset wait_time = 15>
	<cfscript>
		thread = createObject("java", "java.lang.Thread");
		thread.sleep(javaCast("long", 500*wait_time));
	</cfscript>
</CFLOOP>

<cfabort>
<!--- update players table with team and active information --->
<CFQUERY name="resetPlayers" datasource="lwfa">
	select top 1 * from storage order by creation_date
</CFQUERY>
<CFSET existingPlayers=resetPlayers.object>
<CFWDDX action="WDDX2CFML" input="#existingPlayers#" output="existingPlayers">
<CFLOOP from="1" to="#arraylen(existingPlayers.nflid)#" index="oc">
	<CFQUERY name="updatePlayers" datasource="lwfa">
		UPDATE	players
		SET		active='#trim(existingPlayers.active[oc])#',team='#trim(existingPlayers.team[oc])#'
		WHERE 	nflid=#trim(existingPlayers.nflid[oc])#
	</CFQUERY>
</CFLOOP>
