<cfcomponent output="false">

	<!--- Obtain scheduled tasks details --->
	<cffunction name="getScheduledTasks" returntype="query" output="no">
	
	    <!--- Local vars --->
	    <cfset var tasks="">
	    <cfset var result=QueryNew('path,file,resolveurl,url,publish,password,operation,username,interval,start_date,http_port,task,http_proxy_port,proxy_server,disabled,start_time,request_time_out,paused,last_run,end_time')>
	    <cfset var OuterStart="">
	    <cfset var InnerStart="">
	    <cfset var qRETest="">
	    <cfset var qRETestinner="">
	    <cfset var ScheduleItem="">
	
	    <!--- This call is undocumented --->
	    <cfsavecontent variable="tasks">
	        <cfschedule action="run" task="__list">
	    </cfsavecontent>
	
	    <!--- The start for each schedule entry --->
	    <cfset OuterStart=1>
	
	    <!--- Be super careful when using an infinite loop in this manner.
	        Actually, never use an infinite loop in this manner. --->
	    <cfloop condition="OuterStart">
	        <!--- Each schedule item is a text string followed by an = followed by a double {.
	            The end of the item also has a double } 
	            Getting only the elements in an item removed the need for a negative lookahead later --->
	        <cfset qRETest=REFind('\w+={{(.+?})}}', tasks, OuterStart, 1)>
	        <!--- If there is a result, use it.
	            Otherwise break out of the loop. VERY IMPORTANT!!! --->
	        <cfif qRETest.Pos[1]>
	            <!--- This is the string containing all of the
	                elements in a schedule item --->
	            <cfset ScheduleItem=Mid(tasks, qRETest.Pos[2], qRETest.len[2])>
	            <!--- Set the start past the schedule item found --->
	            <cfset OuterStart=qRETest.Pos[2]+qRETest.len[2]>
	
	            <!--- The start for each element of a schedule item --->
	            <cfset InnerStart=1>
	            <!--- Add a row. We don't have so specify as we'll be
	                adding 1 per schedule item --->
	            <cfset QueryAddRow(result)>
	        
	            <!--- Be super careful when using an infinite loop in this manner.
	                Actually, never use an infinite loop in this manner. --->
	            <cfloop condition="InnerStart">
	                <!--- A schedule element is text followed by an = followed by
	                    a value inside of {}. Even though the schedule item string
	                    can be seen as a list, we don't know if there will be a
	                    comma inside one of the elements so we're doing it the
	                    hard but safe way. --->
	                <cfset qRETestinner=REFind('(\w+)={([^}]*)}', ScheduleItem, InnerStart, 1)>
	    
	                <!--- If there is a result, use it.
	                    Otherwise break out of the loop. VERY IMPORTANT!!! --->
	                <cfif qRETestinner.Pos[1]>
	                    <!--- The QuerySetCell will automatically assign the value to the last row added so no need to specify row. The second element of the RegEx return is the column name and the third is the value--->
	                    <cfset QuerySetCell(result,
	                                        Mid(ScheduleItem, qRETestinner.Pos[2], qRETestinner.len[2]),
	                                        Mid(ScheduleItem, qRETestinner.Pos[3], qRETestinner.len[3]))>
	                    <!--- Set the start past the schedule element found --->
	                    <cfset InnerStart=qRETestinner.Pos[1]+qRETestinner.len[1]>
	                <cfelse>
	                    <!--- Break out of our inner infinite loop --->
	                    <cfbreak>
	                </cfif>
	            </cfloop>
	        <cfelse>
	            <!--- Break out of our inner infinite loop --->
	            <cfbreak>
	        </cfif>
	    </cfloop>
	
	    <cfreturn result>
	
	</cffunction>

	<cffunction name="getAbbreviations" access="remote" returnformat="plain">
		<cfquery name="qAbbv" datasource="lwfa">
			SELECT 		teamID,abbv
			FROM		teams
		</cfquery>	
		
		<cfset aAbbv = []>
		<cfloop query="qAbbv">
			<cfset aAbbv[teamID] = abbv>
		</cfloop>
		
		<cfreturn serializeJson( aAbbv )>
	</cffunction>

	<cffunction name="getTeams" access="remote" returnformat="plain">
		<cfargument name="teamID" 	required="false">
		<cfargument name="isArray" 	default="0">

		<cfquery name="qTeams" datasource="lwfa">
			SELECT		*
			FROM		teams
			<cfif structKeyExists(arguments,'teamID')>
				WHERE teamID = #arguments.teamID#
			</cfif>
			ORDER BY	abbv
		</cfquery>
		
		<cfif arguments.isArray>
			<cfset aTeams = []>
			<cfloop query="qTeams">
				<cfset aTeams[teamID] = name>
			</cfloop>
			<cfset json = serializeJSON( aTeams )>
		<cfelse>
			<cfset sTeams = {}>
			<cfset sTeams[ 'records'] = []>
		
			<cfset LOCAL.fieldList = qTeams.columnlist>
		
			<cfloop query="qTeams">
				<cfset sTeams[ 'records'][ arraylen(sTeams[ 'records']) + 1 ] = {}>
				<cfloop list='#LOCAL.fieldList#' index="col">
					<cfset sTeams[ 'records'][ arraylen(sTeams[ 'records']) ][ col ] = qTeams[col][qTeams.currentrow]>
				</cfloop>
			</cfloop>
			
			<cfset json = application.cfc.json.encode( sTeams )>
		</cfif>
			
		<cfreturn json>	
	</cffunction>

	<cffunction name="getTeamAbbv" access="remote" returnformat="plain">
		<cfargument name="teamname" required="true">

		<cfoutput>#left(rereplace(ucase(arguments.teamname),'[^A-Z]','','ALL'),3)#</cfoutput>
	</cffunction>

	<cffunction name="updatePlayerLine" access="remote" returnformat="plain">
		<cfargument name="playerID" required="true">
		
		<cfquery name="qPlayer" datasource="#application.dsn#">
			SELECT 		*
			FROM		playerdata
			WHERE		weekNo = #application.currwk# AND
						playerID = #arguments.playerID#
		</cfquery>
		
		<CF_STAT_COMPILE_NEW
			passyds=#qPlayer.passyds#
			passTD=#qPlayer.passTD#
			passINT=#qPlayer.passINT#
			rushTD=#qPlayer.rushTD#
			rushyds=#qPlayer.rushyds#
			recyds=#qPlayer.recyds#
			recTD=#qPlayer.recTD#
			totalfum=#qPlayer.fumble#
			tackles=#qPlayer.tackle#
			sacks=#qPlayer.sack#
			defint=#qPlayer.defint#
			inttd=#qPlayer.inttd#
			fumrec=#qPlayer.fr#
			fumtd=#qPlayer.frtd#
			forced=#qPlayer.ff#
			lfgoal=#qPlayer.lfg#
			sfgoal=#qPlayer.sfg#
			fgoal=#qPlayer.fg#
			xpts=#qPlayer.xp#
			kryds=#qPlayer.kryds#
			krtd=#qPlayer.krtd#
			pryds=#qPlayer.pryds#
			prtd=#qPlayer.prtd#
			pass2pc=#qPlayer.pass2pc#
			rec2pc=#qPlayer.rec2pc#
			rush2pc=#qPlayer.rush2pc# 
			asstack=#qPlayer.asstack# 
			defintyds=#qPlayer.defintyds# 
			>
		
		<cfquery datasource="#application.dsn#">
			UPDATE 		playerdata
			SET 		total = #scoreline#, line = '#scoredetail#'
			WHERE		weekNo = #application.currwk# AND
						playerID = #arguments.playerID#
		</cfquery>
		
	</cffunction>
</cfcomponent>