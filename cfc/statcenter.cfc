<cfcomponent output="false">

	<cffunction name="getNFLTeams" access="remote" returnformat="plain">
		<cfquery name="qTeams" datasource="lwfa">
			SELECT 		nickname
			FROM		teamnames
			ORDER BY	nickname
		</cfquery>
		
		<cfset aTeams = {}>		
		<cfset aTeams[ 'teams' ] = []>
		<cfset aTeams[ 'teams' ][1][ 'name' ] = "All teams">
		<cfloop query="qTeams">
			<cfset aTeams[ 'teams' ][currentrow+1] = {}>
			<cfset aTeams[ 'teams' ][currentrow+1][ 'name' ] = nickname>
		</cfloop>
		
		<cfset jsonTeamData = application.cfc.json.encode( aTeams )>
		
		<cfreturn jsonTeamData>
	</cffunction>

	<cffunction name="getTeams" access="remote" returnformat="plain">
		<cfquery name="qTeams" datasource="lwfa">
			SELECT 		*
			FROM		teams
			ORDER BY	name
		</cfquery>
		
		<cfset aTeams = {}>		
		<cfset aTeams[ 'teams' ] = []>
		<cfset aTeams[ 'teams' ][1][ 'name' ] = "All teams">
		<cfset aTeams[ 'teams' ][1][ 'teamID' ] = 0>
		<cfloop query="qTeams">
			<cfset aTeams[ 'teams' ][currentrow+1] = {}>
			<cfset aTeams[ 'teams' ][currentrow+1][ 'name' ] = name & " " & nickname>
			<cfset aTeams[ 'teams' ][currentrow+1][ 'teamID' ] = teamID>
		</cfloop>
		
		<cfset jsonTeamData = application.cfc.json.encode( aTeams )>
		
		<cfreturn jsonTeamData>
	</cffunction>

</cfcomponent>