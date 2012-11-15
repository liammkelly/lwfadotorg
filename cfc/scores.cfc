<cfcomponent output="false">

	<cffunction name="getScores" access="remote" returnformat="plain">
		<cfargument name="weekNo" required="true">

		<cfquery name="qScores" datasource="lwfa">
			SELECT 		s.*,
						t.name "away", t.divID "awayDivID",t.abbv "awayabbv",
						t2.name "home",t2.divID "homeDivID",t2.abbv "homeabbv"
			FROM 		schedule s 
							join teams t on t.teamID=s.awayTeamID 
							join teams t2 on s.homeTeamID=t2.teamID 
			where		s.week = #arguments.weekNo#
		</cfquery>	

		<cfset sScores = {}>
		<cfset sScores[ 'records'] = []>
	
		<cfset LOCAL.fieldList = qScores.columnlist>
	
		<cfloop query="qScores">
			<cfset sScores[ 'records'][ arraylen(sScores[ 'records']) + 1 ] = {}>
			<cfloop list='#LOCAL.fieldList#' index="col">
				<cfset sScores[ 'records'][ arraylen(sScores[ 'records']) ][ col ] = qScores[col][qScores.currentrow]>
			</cfloop>
		</cfloop>
		
		<cfset json = application.cfc.json.encode( sScores )>
			
		<cfreturn json>		
	</cffunction>

</cfcomponent>