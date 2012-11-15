<cfcomponent output="false">

	<cffunction name="getTeams" access="public" returntype="query">
		<cfargument name="divID" default="0">
		
		<cfquery name="qTeams" datasource="lwfa">
			SELECT		*
			FROM		teams
			<cfif arguments.divID gt 0>
			WHERE		divID = #arguments.divID#
			</cfif>
			ORDER BY 	name
		</cfquery>
		
		<cfreturn qTeams>
	</cffunction>

	<cffunction name="getPlayers" access="remote" returnformat="plain">
		<cfargument name="teamID" default="0">
		<cfargument name="pos" default="">
		
		<cfquery name="qPlayers" datasource="lwfa">
			SELECT		playerID,concat(pos," ",last,", ",first) "fullname",active,inj
			FROM		players
			WHERE 		1=1
			<cfif arguments.teamID gt 0>
				AND teamID = #arguments.teamID#
			</cfif>
			<cfif arguments.pos neq ''>
				AND pos = '#arguments.pos#'
			</cfif>
			ORDER BY view,	last,first
		</cfquery>

		<cfset aPlayers = []>
		<cfloop query="qPlayers">
			<cfset aPlayers[ arraylen(aPlayers)+1 ] = {playerID=playerID,name=fullname,active=(active eq 'Y'),inj=(inj eq 'Y')}>
		</cfloop>
		
		<cfreturn serializeJson(aPlayers)>
	</cffunction>

	<cffunction name="saveLineup" access="remote" returntype="void">
		<cfquery name="updTeam" datasource="lwfa">
			UPDATE 	players
			SET			active='N'
			WHERE		teamID = #arguments.teamID#
		</cfquery>
		
		<cfloop list='#arguments.lineupBox#' index="playerID">
			<cfquery name="updTeam" datasource="lwfa">
				UPDATE 	players
				SET			active='Y'
				WHERE		playerID = #playerID#
			</cfquery>			
		</cfloop>
	</cffunction>

</cfcomponent>