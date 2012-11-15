<cfparam name="LOCAL.debug" default="0">

<cfif structKeyExists(URL,'debug')>
	<cfset LOCAL.debug = url.debug>
</cfif>

<cfquery name="qPlayoffs" datasource="lwfa">
	SELECT			t.name,t.teamID,
						s.winpct,s.win,s.loss,
						d.conference,d.divID,d.division
	FROM			standings s 
							join teams t on s.teamID=t.teamID 
							join divisions d on t.divID=d.divID
	ORDER BY		s.winpct desc, d.conference,t.divID
</cfquery>

<cfset dummyArray = arraynew(1)>
<cfset queryAddColumn(qPlayoffs,'playoffRank','Integer',dummyArray)>

<cfset playoffs = arraynew(1)>
<cfset playoffStruct = structnew()>
<cfset playoffStruct[ 'lombardiBye' ] = {rank=0,teamID=0,seed=0}>
<cfset playoffStruct[ 'rozelleBye' ] = {rank=0,teamID=0,seed=0}>
<cfset playoffStruct[ 'maddenWinner' ] = {rank=0,teamID=0,seed=0}>
<cfset playoffStruct[ 'ditkaWinner' ] = {rank=0,teamID=0,seed=0}>
<cfset playoffStruct[ 'mcmahonWinner' ] = {rank=0,teamID=0,seed=0}>
<cfset playoffStruct[ 'butkusWinner' ] = {rank=0,teamID=0,seed=0}>
<cfset playoffStruct[ 'lombardiWildcard' ] = {rank=0,teamID=0,seed=0}>
<cfset playoffStruct[ 'rozelleWildcard' ] = {rank=0,teamID=0,seed=0}>


<cfif LOCAL.debug>
	<cfdump var="#qPlayoffs#" label="qPlayoffs" expand="false">
</cfif>

<cfoutput>
<cfloop query="qPlayoffs">
	<cfset action = ''>  
	<!--- if conference bye is blank, current team gets it --->
	<cfif playoffStruct[ conference&'Bye' ][ 'teamID' ] eq 0>
		<cfset playoffStruct[ conference&'Bye' ][ 'teamID' ] = qPlayoffs.teamID>
		<cfset playoffStruct[ conference&'Bye' ][ 'rank' ] = qPlayoffs.winpct>
		<cfset playoffStruct[ division&'Winner' ][ 'teamID' ] = qPlayoffs.teamID>
		<cfset playoffStruct[ division&'Winner' ][ 'rank' ] = qPlayoffs.winpct>
		<cfset action = listAppend(action,'a ')>
	<!--- if conference bye is not blank, check tiebreaker --->
	<cfelseif playoffStruct[ conference&'Bye' ][ 'rank' ] eq qPlayoffs.winpct>
		<cf_compare teamID="#playoffStruct[ conference&'Bye' ]['teamID' ]#" compTeamID="#qPlayoffs.teamID#">
		<!--- if tiebreak winner not old conference bye, set new conference bye --->
		<cfset action = listAppend(action,'b ')>
		<cfif tbWinnerTeamID neq playoffStruct[ conference&'Bye' ][ 'teamID' ]>
			<cfset playoffStruct[ conference&'Bye' ][ 'teamID' ] = tbWinnerTeamID>
			<cfset action = listAppend(action,'c ')>
			<!--- if old conference bye was also div winner, set new div winner and bump old div winner to conference WC --->
			<cfif playoffStruct[ division&'Winner' ][ 'teamID' ] neq 0>
				<cfset playoffStruct[ conference&'Wildcard' ][ 'teamID' ] = tbLoserTeamID>
				<cfset playoffStruct[ conference&'Wildcard' ][ 'rank' ] = qPlayoffs.winpct>
				<cfset action = listAppend(action,'d ')>
			</cfif>
			<cfset playoffStruct[ division&'Winner' ][ 'teamID' ] = tbWinnerTeamID>				
		<!--- if tiebreak winner is old conference bye and div winner is blank, set new div winner --->
		<cfelseif playoffStruct[ division&'Winner' ][ 'teamID' ] eq 0>
			<cfset playoffStruct[ division&'Winner' ][ 'teamID' ] = qPlayoffs.teamID>						
			<cfset playoffStruct[ division&'Winner' ][ 'rank' ] = qPlayoffs.winpct>
			<cfset action = listAppend(action,'e ')>
		<!--- if tiebreak winner is old conference bye and div winner is not blank, set new conference WC--->
		<cfelseif playoffStruct[ conference&'Wildcard' ][ 'teamID' ] eq 0>
			<cfset playoffStruct[ conference&'Wildcard' ][ 'teamID' ] = qPlayoffs.teamID>
			<cfset playoffStruct[ conference&'Wildcard' ][ 'rank' ] = qPlayoffs.winpct>		
			<cfset action = listAppend(action,'f ')>
		</cfif>
	</cfif>
	
	<!--- if div winner is blank, set new div winner --->	
	<cfif playoffStruct[ division&'Winner' ][ 'teamID' ] eq 0>
		<cfset playoffStruct[ division&'Winner' ][ 'teamID' ] = qPlayoffs.teamID>
		<cfset playoffStruct[ division&'Winner' ][ 'rank' ] = qPlayoffs.winpct>
		<cfset action = listAppend(action,'g ')>
	<!--- if div winner is not blank, check tiebreaker --->
	<cfelseif playoffStruct[ division&'Winner' ][ 'rank' ] eq qPlayoffs.winpct AND playoffStruct[ division&'Winner' ][ 'teamID' ] neq qPlayoffs.teamID>
		<cf_compare teamID="#playoffStruct[ division&'Winner' ]['teamID' ]#" compTeamID="#qPlayoffs.teamID#">
		<cfset action = listAppend(action,'h ')>
		<!--- if tiebreak winner not old div winner, set new div winner and bump old div winner to wildcard--->
		<cfif playoffStruct[ division&'Winner' ][ 'teamID' ] neq tbWinnerTeamID>
			<cfset action = listAppend(action,'i ')>
			<cfif playoffStruct[ conference&'Wildcard' ][ 'teamID' ] eq 0>
				<cfset playoffStruct[ conference&'Wildcard' ][ 'teamID' ] = tbLoserTeamID>
				<cfset playoffStruct[ conference&'Wildcard' ][ 'rank' ] = qPlayoffs.winpct>		
				<cfset action = listAppend(action,'j ')>
			</cfif>
			<cfset playoffStruct[ division&'Winner' ][ 'teamID' ] = tbWinnerTeamID>
			<cfset playoffStruct[ division&'Winner' ][ 'rank' ] = qPlayoffs.winpct>		
		</cfif>
	</cfif>
	
	<!--- if conference WC is blank, set new conference WC  --->
	<cfif playoffStruct[ conference&'Wildcard' ][ 'teamID' ] eq 0 AND qPlayoffs.teamID neq playoffStruct[ division&'Winner' ][ 'teamID' ]>
		<cfset playoffStruct[ conference&'Wildcard' ][ 'teamID' ] = qPlayoffs.teamID>
		<cfset playoffStruct[ conference&'Wildcard' ][ 'rank' ] = qPlayoffs.winpct>
		<cfset action = listAppend(action,'k ')>
	<!--- if conference WC is not blank, check tiebreaker --->
	<cfelseif playoffStruct[ conference&'Wildcard' ][ 'rank' ] eq qPlayoffs.winpct AND qPlayoffs.teamID neq playoffStruct[ division&'Winner' ][ 'teamID' ]>
		<cf_compare teamID="#playoffStruct[ conference&'Wildcard' ]['teamID' ]#" compTeamID="#qPlayoffs.teamID#">
		<!--- if tiebreak winner is not old conference WC, set new conference WC --->
		<cfset playoffStruct[ conference&'Wildcard' ][ 'teamID' ] = tbWinnerTeamID>
		<cfset action = listAppend(action,'l ')>
	</cfif>
	<cfif LOCAL.debug>
		<cfdump var="#playoffStruct#" label="#qPlayoffs.name# (#qPlayoffs.teamID#) #qPlayoffs.division#: #action#" expand="false">
	</cfif>
</cfloop>
</cfoutput>


<cfif playoffStruct[ 'rozelleWildcard' ][ 'rank' ] gt playoffStruct[ 'lombardiWildcard' ][ 'rank' ]>
	<cfset playoffs[6] = playoffStruct[ 'lombardiWildcard' ][ 'teamID' ]>
	<cfset playoffs[5] = playoffStruct[ 'rozelleWildcard' ][ 'teamID' ]>
<cfelseif playoffStruct[ 'rozelleWildcard' ][ 'rank' ] lt playoffStruct[ 'lombardiWildcard' ][ 'rank' ]>
	<cfset playoffs[5] = playoffStruct[ 'lombardiWildcard' ][ 'teamID' ]>
	<cfset playoffs[6] = playoffStruct[ 'rozelleWildcard' ][ 'teamID' ]>
<cfelse>
	<cf_compare teamID="#playoffStruct[ 'rozelleWildcard' ]['teamID' ]#" compTeamID="#playoffStruct[ 'lombardiWildcard' ]['teamID' ]#">
	<cfif playoffStruct[ 'lombardiWildcard' ][ 'teamID' ] eq tbWinnerTeamID>
		<cfset playoffs[5] = playoffStruct[ 'lombardiWildcard' ][ 'teamID' ]>
		<cfset playoffs[6] = playoffStruct[ 'rozelleWildcard' ][ 'teamID' ]>	
	<cfelseif playoffStruct[ 'rozelleWildcard' ][ 'teamID' ] eq tbWinnerTeamID>
		<cfset playoffs[6] = playoffStruct[ 'lombardiWildcard' ][ 'teamID' ]>
		<cfset playoffs[5] = playoffStruct[ 'rozelleWildcard' ][ 'teamID' ]>	
	</cfif>
</cfif>

<cfif playoffStruct[ 'maddenWinner' ][ 'rank' ] gt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>

	<!--- compare ditka and.. --->
	<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'butkusWinner' ][ 'rank' ]>
		<!--- compare ditka and butkus for seeds 3 and 4 --->
		<cfif playoffStruct[ 'butkusWinner' ][ 'rank' ] gt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
			<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
			<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
		<cfelseif playoffStruct[ 'butkusWinner' ][ 'rank' ] lt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
			<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
			<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
		<cfelse>
			<cf_compare teamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'ditkaWinner' ]['teamID' ]#">
			<cfif playoffStruct[ 'butkusWinner' ][ 'teamID' ] eq tbWinnerTeamID>
				<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>				
			<cfelse>
				<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
			</cfif>
		</cfif>
	<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'butkusWinner' ][ 'rank' ]>
		<!--- compare ditka and mcmahon for seeds 3 and 4 --->
		<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
			<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
			<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
		<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
			<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
			<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
		<cfelse>
			<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'ditkaWinner' ]['teamID' ]#">
			<cfif playoffStruct[ 'mcmahonWinner' ][ 'teamID' ] eq tbWinnerTeamID>
				<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>				
			<cfelse>
				<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
			</cfif>
		</cfif>
	<cfelse>
		<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#">
		<cfif playoffStruct[ 'mcmahonWinner' ]['teamID' ] eq tbWinnerTeamID>
			<!--- compare ditka and butkus for seeds 3 and 4 --->
			<cfif playoffStruct[ 'butkusWinner' ][ 'rank' ] gt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
				<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
			<cfelseif playoffStruct[ 'butkusWinner' ][ 'rank' ] lt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
				<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
			<cfelse>
				<cf_compare teamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'ditkaWinner' ]['teamID' ]#">
				<cfif playoffStruct[ 'butkusWinner' ][ 'teamID' ] eq tbWinnerTeamID>
					<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>				
				<cfelse>
					<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
				</cfif>
			</cfif>		
		<cfelse>
			<!--- compare ditka and mcmahon for seeds 3 and 4 --->
			<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
				<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
			<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
				<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
			<cfelse>
				<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'ditkaWinner' ]['teamID' ]#">
				<cfif playoffStruct[ 'mcmahonWinner' ][ 'teamID' ] eq tbWinnerTeamID>
					<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>				
				<cfelse>
					<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
				</cfif>
			</cfif>		
		</cfif>	
	</cfif>
	
<cfelseif playoffStruct[ 'maddenWinner' ][ 'rank' ] lt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>

	<!--- compare madden and.. --->
	<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'butkusWinner' ][ 'rank' ]>
		<!--- compare madden and butkus for seeds 3 and 4 --->
		<cfif playoffStruct[ 'butkusWinner' ][ 'rank' ] gt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
			<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
			<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
		<cfelseif playoffStruct[ 'butkusWinner' ][ 'rank' ] lt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
			<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
			<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
		<cfelse>
			<cf_compare teamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'maddenWinner' ]['teamID' ]#">
			<cfif playoffStruct[ 'butkusWinner' ][ 'teamID' ] eq tbWinnerTeamID>
				<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>				
			<cfelse>
				<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
			</cfif>
		</cfif>
	<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'butkusWinner' ][ 'rank' ]>
		<!--- compare madden and mcmahon for seeds 3 and 4 --->
		<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
			<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
			<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
		<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
			<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
			<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
		<cfelse>
			<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'maddenWinner' ]['teamID' ]#">
			<cfif playoffStruct[ 'mcmahonWinner' ][ 'teamID' ] eq tbWinnerTeamID>
				<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>				
			<cfelse>
				<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
			</cfif>
		</cfif>
	<cfelse>
		<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#">
		<cfif playoffStruct[ 'mcmahonWinner' ]['teamID' ] eq tbWinnerTeamID>
			<!--- compare madden and butkus for seeds 3 and 4 --->
			<cfif playoffStruct[ 'butkusWinner' ][ 'rank' ] gt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
				<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
			<cfelseif playoffStruct[ 'butkusWinner' ][ 'rank' ] lt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
				<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
			<cfelse>
				<cf_compare teamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'maddenWinner' ]['teamID' ]#">
				<cfif playoffStruct[ 'butkusWinner' ][ 'teamID' ] eq tbWinnerTeamID>
					<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>				
				<cfelse>
					<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
				</cfif>
			</cfif>		
		<cfelse>
			<!--- compare madden and mcmahon for seeds 3 and 4 --->
			<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
				<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
			<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
				<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
			<cfelse>
				<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'maddenWinner' ]['teamID' ]#">
				<cfif playoffStruct[ 'mcmahonWinner' ][ 'teamID' ] eq tbWinnerTeamID>
					<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>				
				<cfelse>
					<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>	
				</cfif>
			</cfif>		
		</cfif>	
	</cfif>

<cfelse>

	<cf_compare teamID="#playoffStruct[ 'maddenWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'ditkaWinner' ]['teamID' ]#">
	<cfif playoffStruct[ 'maddenWinner' ]['teamID' ] eq tbWinnerTeamID>

		<!--- compare ditka and.. --->
		<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'butkusWinner' ][ 'rank' ]>
			<!--- compare ditka and butkus for seeds 3 and 4 --->
			<cfif playoffStruct[ 'butkusWinner' ][ 'rank' ] gt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
				<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
			<cfelseif playoffStruct[ 'butkusWinner' ][ 'rank' ] lt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
				<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
			<cfelse>
				<cf_compare teamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'ditkaWinner' ]['teamID' ]#">
				<cfif playoffStruct[ 'butkusWinner' ] eq tbWinnerTeamID>
					<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>				
				<cfelse>
					<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
				</cfif>
			</cfif>
		<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'butkusWinner' ][ 'rank' ]>
			<!--- compare ditka and mcmahon for seeds 3 and 4 --->
			<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
				<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
			<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
				<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
			<cfelse>
				<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'ditkaWinner' ]['teamID' ]#">
				<cfif playoffStruct[ 'mcmahonWinner' ] eq tbWinnerTeamID>
					<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>				
				<cfelse>
					<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
				</cfif>
			</cfif>
		<cfelse>
			<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#">
			<cfif playoffStruct[ 'mcmahonWinner' ]['teamID' ] eq tbWinnerTeamID>
				<!--- compare ditka and butkus for seeds 3 and 4 --->
				<cfif playoffStruct[ 'butkusWinner' ][ 'rank' ] gt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
					<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
				<cfelseif playoffStruct[ 'butkusWinner' ][ 'rank' ] lt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
					<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
				<cfelse>
					<cf_compare teamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'ditkaWinner' ]['teamID' ]#">
					<cfif playoffStruct[ 'butkusWinner' ] eq tbWinnerTeamID>
						<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
						<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>				
					<cfelse>
						<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
						<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
					</cfif>
				</cfif>		
			<cfelse>
				<!--- compare ditka and mcmahon for seeds 3 and 4 --->
				<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
					<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
				<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'ditkaWinner' ][ 'rank' ]>
					<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
				<cfelse>
					<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'ditkaWinner' ]['teamID' ]#">
					<cfif playoffStruct[ 'mcmahonWinner' ] eq tbWinnerTeamID>
						<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
						<cfset playoffs[4] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>				
					<cfelse>
						<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
						<cfset playoffs[3] = playoffStruct[ 'ditkaWinner' ][ 'teamID' ]>	
					</cfif>
				</cfif>		
			</cfif>	
		</cfif>

	<cfelse>

		<!--- compare madden and.. --->
		<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'butkusWinner' ][ 'rank' ]>
			<!--- compare madden and butkus for seeds 3 and 4 --->
			<cfif playoffStruct[ 'butkusWinner' ][ 'rank' ] gt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
				<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
			<cfelseif playoffStruct[ 'butkusWinner' ][ 'rank' ] lt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
				<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
			<cfelse>
				<cf_compare teamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'maddenWinner' ]['teamID' ]#">
				<cfif playoffStruct[ 'butkusWinner' ] eq tbWinnerTeamID>
					<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
				<cfelse>
					<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
				</cfif>
			</cfif>
		<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'butkusWinner' ][ 'rank' ]>
			<!--- compare madden and mcmahon for seeds 3 and 4 --->
			<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
				<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
				<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
			<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
				<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
				<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
			<cfelse>
				<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'maddenWinner' ]['teamID' ]#">
				<cfif playoffStruct[ 'mcmahonWinner' ] eq tbWinnerTeamID>
					<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				<cfelse>
					<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
				</cfif>
			</cfif>
		<cfelse>
			<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#">
			<cfif playoffStruct[ 'mcmahonWinner' ]['teamID' ] eq tbWinnerTeamID>
				<!--- compare madden and butkus for seeds 3 and 4 --->
				<cfif playoffStruct[ 'butkusWinner' ][ 'rank' ] gt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
					<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
				<cfelseif playoffStruct[ 'butkusWinner' ][ 'rank' ] lt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
					<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
				<cfelse>
					<cf_compare teamID="#playoffStruct[ 'butkusWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'maddenWinner' ]['teamID' ]#">
					<cfif playoffStruct[ 'butkusWinner' ] eq tbWinnerTeamID>
						<cfset playoffs[3] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
						<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
					<cfelse>
						<cfset playoffs[4] = playoffStruct[ 'butkusWinner' ][ 'teamID' ]>
						<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
					</cfif>
				</cfif>		
			<cfelse>
				<!--- compare madden and mcmahon for seeds 3 and 4 --->
				<cfif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] gt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
					<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
					<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
				<cfelseif playoffStruct[ 'mcmahonWinner' ][ 'rank' ] lt playoffStruct[ 'maddenWinner' ][ 'rank' ]>
					<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
					<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
				<cfelse>
					<cf_compare teamID="#playoffStruct[ 'mcmahonWinner' ]['teamID' ]#" compTeamID="#playoffStruct[ 'maddenWinner' ]['teamID' ]#">
					<cfif playoffStruct[ 'mcmahonWinner' ] eq tbWinnerTeamID>
						<cfset playoffs[3] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
						<cfset playoffs[4] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
					<cfelse>
						<cfset playoffs[4] = playoffStruct[ 'mcmahonWinner' ][ 'teamID' ]>
						<cfset playoffs[3] = playoffStruct[ 'maddenWinner' ][ 'teamID' ]>
					</cfif>
				</cfif>		
			</cfif>	
		</cfif>

	</cfif>
</cfif>

<cfif playoffStruct[ 'rozelleBye' ][ 'rank' ] gt playoffStruct[ 'lombardiBye' ][ 'rank' ]>
	<cfset playoffs[2] = playoffStruct[ 'lombardiBye' ][ 'teamID' ]>
	<cfset playoffs[1] = playoffStruct[ 'rozelleBye' ][ 'teamID' ]>
<cfelseif playoffStruct[ 'rozelleBye' ][ 'rank' ] lt playoffStruct[ 'lombardiBye' ][ 'rank' ]>
	<cfset playoffs[1] = playoffStruct[ 'lombardiBye' ][ 'teamID' ]>
	<cfset playoffs[2] = playoffStruct[ 'rozelleBye' ][ 'teamID' ]>
<cfelse>
	<cf_compare teamID="#playoffStruct[ 'rozelleBye' ]['teamID' ]#" compTeamID="#playoffStruct[ 'lombardiBye' ]['teamID' ]#">
	<cfif playoffStruct[ 'lombardiBye' ][ 'teamID' ] eq tbWinnerTeamID>
		<cfset playoffs[1] = playoffStruct[ 'lombardiBye' ][ 'teamID' ]>
		<cfset playoffs[2] = playoffStruct[ 'rozelleBye' ][ 'teamID' ]>	
	<cfelseif playoffStruct[ 'rozelleBye' ][ 'teamID' ] eq tbWinnerTeamID>
		<cfset playoffs[2] = playoffStruct[ 'lombardiBye' ][ 'teamID' ]>
		<cfset playoffs[1] = playoffStruct[ 'rozelleBye' ][ 'teamID' ]>	
	</cfif>
</cfif>

<cfif LOCAL.debug>
	<cfdump var="#playoffStruct#" expand="false">
	<cfdump var="#playoffs#">
</cfif>

<cffunction name="getBerth" access="public" returntype="string">
	<cfargument name="teamID" required="true" default="0">
	
	<cfset myBerth = ''>
	<cfloop list="#structKeyList(playoffStruct)#" index="u">
		<cfif playoffStruct[ u ][ 'teamID' ] eq arguments.teamID>
			<cfset myBerth = lcase(u)>
		</cfif>		
	</cfloop>

	<cfset myBerth = rereplace(myBerth,'(winner|bye|wildcard)',' \1')>

	<cfreturn myBerth>
</cffunction>


<style>
	#playoffProjectionsDiv {
		margin:20px 0 0 20px;
		padding:20px 0 20px 2px;
		background-color:#EADC9F;
		width:320px;
	}
	#playoffProjectionsDiv OL {
		margin-left:30px;
	}
</style>
<div id="playoffProjectionsDiv">
	<h2>Current Playoff Picture</h2>
	<ol>
	<cfset counter = 1>
	<cfoutput>
	<cfloop array="#playoffs#" index="r">
		<li>
			<cf_teamname teamID="#r#" full="1" record="1" output="1"><br /> 
			<cfinvoke method="getBerth" returnvariable="myBerth" teamID="#r#" />
			<em>#myBerth#</em>
		</li>
		<cfset counter += 1>
	</cfloop>
	</cfoutput>
	</ol>
	<P style="margin:20px 0 0 30px;"><a href="teamCompare.cfm">compare tiebreakers</a></P>
</div>
