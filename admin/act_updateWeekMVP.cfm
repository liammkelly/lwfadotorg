
	<!--- update star player --->
	<cfset msg3 = "Updated weekly MVP.">
	<cftry>
	<cfquery name="qStarPlayer" datasource="lwfa">
			insert into starPlayer (playerID,weekNo)
			SELECT 	p.playerID,pd.weekNo 
			from 		players p 
							join playerdata pd on p.playerID=pd.playerID 
							join standings s on p.teamID=s.teamID 
			where 		left(s.streak,1)='W' AND 
							pd.weekNo=#application.currwk# AND 
							pd.active='Y' AND 
							pd.teamID > 0 AND
							s.teamID in (select hometeamid 'teamid' from schedule where week=#application.currwk# union select awayteamid 'teamid' from schedule where week=#application.currwk#)
			order by 	pd.total desc 
			limit 1;
	</cfquery>
	<cfcatch type="any"><cfset msg3 = "There was a problem with updating the weekly MVP."><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
	<cfoutput>#msg3#</cfoutput><P>
	