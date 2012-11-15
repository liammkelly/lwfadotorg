<cfparam name="attributes.teamID" default="1">
<cfparam name="attributes.compTeamID" default="4">
<cfparam name="attributes.returnObj" default="sCompare">
<cfparam name="debug" default="0">

<cfif structKeyExists(url,'teamID')><cfset attributes.teamID=url.teamID></cfif>
<cfif structKeyExists(url,'compTeamID')><cfset attributes.compteamID=url.compteamID></cfif>


<cfset tmOpponentList = structnew()>
<cfset compTmOpponentList = structnew()>
<cfset comparison = structnew()>
<cfset comparison[ 'commonOpponents' ] = ''>
<cfset comparison[ 'tmDiv' ] = 0>
<cfset comparison[ 'compTmDiv' ] = 0>
<cfset comparison[ 'tmDivPts' ] = 0>
<cfset comparison[ 'compTmDivPts' ] = 0>
<cfset comparison[ 'tmPts' ] = 0>
<cfset comparison[ 'compTmPts' ] = 0>
<!--- head to head record --->
<cfset comparison[ 'tmH2HWinPct' ] = 0>
<cfset comparison[ 'tmH2HWin' ] = 0>
<cfset comparison[ 'tmH2HLoss' ] = 0>
<cfset comparison[ 'compTmH2HWinPct' ] = 0>
<cfset comparison[ 'compTmH2HWin' ] = 0>
<cfset comparison[ 'compTmH2HLoss' ] = 0>
<!--- divisional record --->
<cfset comparison[ 'tmDivWinPct' ] = 0>
<cfset comparison[ 'tmDivWin' ] = 0>
<cfset comparison[ 'tmDivLoss' ] = 0>
<cfset comparison[ 'compTmDivWinPct' ] = 0>
<cfset comparison[ 'compTmDivWin' ] = 0>
<cfset comparison[ 'compTmDivLoss' ] = 0>
<!--- common opponents record --->
<cfset comparison[ 'tmCommonWinPct' ] = 0>
<cfset comparison[ 'tmCommonWin' ] = 0>
<cfset comparison[ 'tmCommonLoss' ] = 0>
<cfset comparison[ 'compTmCommonWinPct' ] = 0>
<cfset comparison[ 'compTmCommonWin' ] = 0>
<cfset comparison[ 'compTmCommonLoss' ] = 0>

<cfset loc = { tbWinnerTeamID = 0, tiebreaker = 'x' }>

<cfquery name="qCompare" datasource="lwfa">
	select 	s.*,t.divID "awayDivID",t2.divID "homeDivID",d.conference "awayConf",d2.conference "homeConf"
	from 	schedule s 
					join teams t on s.awayTeamID=t.teamID 
					join teams t2 on s.homeTeamID=t2.teamID 
					join standings st on s.awayTeamID=st.teamID 
					join standings st2 on s.homeTeamID=st2.teamID 
					join divisions d on t.divID=d.divID
					join divisions d2 on t2.divID=d2.divID
	where 	(s.awayTeamID=#attributes.teamID# OR s.homeTeamID=#attributes.teamID#) AND week < 14
</cfquery>

<cfloop query="qCompare">
	<cfif awayTeamID eq attributes.teamID>
		<cfset tmOpponentList[homeTeamID] = ''>
	<cfelse>
		<cfset tmOpponentList[awayTeamID] = ''>
	</cfif>
</cfloop>
<cfloop query="qCompare" endrow="1">
	<cfif awayTeamID eq attributes.teamID>
		<cfset comparison[ 'tmDiv' ] = awayDivID>
	<cfelse>
		<cfset comparison[ 'tmDiv' ] = homeDivID>
	</cfif>
</cfloop>
	
<cfset tmOpponentList = structKeyList(tmOpponentList)>

<cfquery name="qCompare2" datasource="lwfa">
	select 	s.*,t.divID "awayDivID",t2.divID "homeDivID",d.conference "awayConf",d2.conference "homeConf"
	from 	schedule s 
					join teams t on s.awayTeamID=t.teamID 
					join teams t2 on s.homeTeamID=t2.teamID 
					join standings st on s.awayTeamID=st.teamID 
					join standings st2 on s.homeTeamID=st2.teamID 
					join divisions d on t.divID=d.divID
					join divisions d2 on t2.divID=d2.divID
	where 	(s.awayTeamID=#attributes.compteamID# OR s.homeTeamID=#attributes.compteamID#) AND week < 14
</cfquery>

<cfloop query="qCompare2">
	<cfif awayTeamID eq attributes.compTeamID>
		<cfset compTmOpponentList[homeTeamID] = ''>
	<cfelse>
		<cfset compTmOpponentList[awayTeamID] = ''>
	</cfif>
</cfloop>
<cfloop query="qCompare2" endrow="1">
	<cfif awayTeamID eq attributes.compTeamID>
		<cfset comparison[ 'compTmDiv' ] = awayDivID>
	<cfelse>
		<cfset comparison[ 'compTmDiv' ] = homeDivID>
	</cfif>
</cfloop>

<cfset compTmOpponentList = structKeyList(compTmOpponentList)>

<cfloop list="#tmOpponentList#" index="x">
	<cfif listFind(compTmOpponentList,x) gt 0>
		<cfset comparison[ 'commonOpponents' ] = listAppend(comparison[ 'commonOpponents' ],x)>
	</cfif>
</cfloop>

<cfloop query="qCompare">
	<cfif isNumeric(homescore) AND homescore gt 0>
		<cfif homeTeamID eq attributes.teamID AND awayTeamID eq attributes.compTeamID>
			<cfif homescore gt awayscore>
				<cfset comparison[ 'tmH2HWin' ] += 1>			
				<cfset comparison[ 'compTmH2HLoss' ] += 1>					
			<cfelseif homescore lt awayscore>
				<cfset comparison[ 'tmH2HLoss' ] += 1>					
				<cfset comparison[ 'compTmH2HWin' ] += 1>			
			</cfif>			
		<cfelseif homeTeamID eq attributes.compTeamID AND awayTeamID eq attributes.teamID>
			<cfif homescore lt awayscore>
				<cfset comparison[ 'tmH2HWin' ] += 1>			
				<cfset comparison[ 'compTmH2HLoss' ] += 1>					
			<cfelseif homescore gt awayscore>
				<cfset comparison[ 'tmH2HLoss' ] += 1>					
				<cfset comparison[ 'compTmH2HWin' ] += 1>			
			</cfif>			
		<cfelseif homeTeamID eq attributes.teamID AND listFind(comparison[ 'commonOpponents' ],awayTeamID) gt 0>
			<cfif homescore gt awayscore>
				<cfset comparison[ 'tmCommonWin' ] += 1>			
			<cfelseif homescore lt awayscore>
				<cfset comparison[ 'tmCommonLoss' ] += 1>					
			</cfif>
		<cfelseif awayTeamID eq attributes.teamID AND listFind(comparison[ 'commonOpponents' ],homeTeamID) gt 0>
			<cfif homescore gt awayscore>
				<cfset comparison[ 'tmCommonLoss' ] += 1>			
			<cfelseif homescore lt awayscore>
				<cfset comparison[ 'tmCommonWin' ] += 1>					
			</cfif>	
		</cfif>
		<cfif comparison[ 'tmDiv' ] eq comparison[ 'compTmDiv' ]>
			<cfif homeTeamID eq attributes.teamID AND awayDivID eq comparison[ 'tmDiv' ]>
				<cfif homescore gt awayscore>
					<cfset comparison[ 'tmDivWin' ] += 1>			
				<cfelse>
					<cfset comparison[ 'tmDivLoss' ] += 1>					
				</cfif>
				<cfset comparison[ 'tmDivPts' ] += homescore>
			<cfelseif awayTeamID eq attributes.teamID AND homeDivID eq comparison[ 'tmDiv' ]>
				<cfif homescore lt awayscore>
					<cfset comparison[ 'tmDivWin' ] += 1>			
				<cfelse>
					<cfset comparison[ 'tmDivLoss' ] += 1>					
				</cfif>
				<cfset comparison[ 'tmDivPts' ] += awayscore>
			</cfif>
		</cfif>
		<cfif awayTeamID eq attributes.teamID>
			<cfset comparison[ 'tmPts' ]  += awayscore>
		<cfelse>
			<cfset comparison[ 'tmPts' ]  += homescore>
		</cfif>
	</cfif>
</cfloop>
<cfloop query="qCompare2">
	<cfif isNumeric(homescore) AND homescore gt 0>
		<cfif homeTeamID eq attributes.compTeamID AND listFind(comparison[ 'commonOpponents' ],awayTeamID) gt 0>
			<cfif homescore gt awayscore>
				<cfset comparison[ 'compTmCommonWin' ] += 1>			
			<cfelseif homescore lt awayscore>
				<cfset comparison[ 'compTmCommonLoss' ] += 1>					
			</cfif>
		<cfelseif awayTeamID eq attributes.compTeamID AND listFind(comparison[ 'commonOpponents' ],homeTeamID) gt 0>
			<cfif homescore gt awayscore>
				<cfset comparison[ 'compTmCommonLoss' ] += 1>			
			<cfelseif homescore lt awayscore>
				<cfset comparison[ 'compTmCommonWin' ] += 1>					
			</cfif>	
		</cfif>
		<cfif comparison[ 'tmDiv' ] eq comparison[ 'compTmDiv' ]>
			<cfif homeTeamID eq attributes.compTeamID AND awayDivID eq comparison[ 'compTmDiv' ]>
				<cfif homescore gt awayscore>
					<cfset comparison[ 'compTmDivWin' ] += 1>			
				<cfelseif homescore lt awayscore>
					<cfset comparison[ 'compTmDivLoss' ] += 1>					
				</cfif>
				<cfset comparison[ 'compTmDivPts' ] += homescore>
			<cfelseif awayTeamID eq attributes.compTeamID AND homeDivID eq comparison[ 'tmDiv' ]>
				<cfif homescore lt awayscore>
					<cfset comparison[ 'compTmDivWin' ] += 1>			
				<cfelseif homescore gt awayscore>
					<cfset comparison[ 'compTmDivLoss' ] += 1>					
				</cfif>
				<cfset comparison[ 'compTmDivPts' ] += awayscore>
			</cfif>
		</cfif>
		<cfif awayTeamID eq attributes.compTeamID>
			<cfset comparison[ 'compTmPts' ]  += awayscore>
		<cfelse>
			<cfset comparison[ 'compTmPts' ] += homescore>
		</cfif>
	</cfif>
</cfloop>
<cfif comparison[ 'tmH2HWin' ] gt 0>
	<cfset comparison[ 'tmH2HWinPct' ] = comparison[ 'tmH2HWin' ] / (comparison[ 'tmH2HWin' ] + comparison[ 'tmH2HLoss' ])>
<cfelse>
	<cfset comparison[ 'tmH2HWinPct' ] = 0>
</cfif>
<cfif comparison[ 'tmDivWin' ] gt 0>
	<cfset comparison[ 'tmDivWinPct' ] = comparison[ 'tmDivWin' ] / (comparison[ 'tmDivWin' ] + comparison[ 'tmDivLoss' ])>
<cfelse>
	<cfset comparison[ 'tmDivWinPct' ] = 0>
</cfif>
<cfif comparison[ 'tmCommonWin' ] gt 0>
	<cfset comparison[ 'tmCommonWinPct' ] = comparison[ 'tmCommonWin' ] / (comparison[ 'tmCommonWin' ] + comparison[ 'tmCommonLoss' ])>
<cfelse>
	<cfset comparison[ 'tmCommonWinPct' ] = 0>
</cfif>
<cfif comparison[ 'compTmH2HWin' ] gt 0>
	<cfset comparison[ 'compTmH2HWinPct' ] = comparison[ 'compTmH2HWin' ] / (comparison[ 'compTmH2HWin' ] + comparison[ 'compTmH2HLoss' ])>
<cfelse>
	<cfset comparison[ 'compTmH2HWinPct' ] = 0>
</cfif>
<cfif comparison[ 'compTmDivWin' ] gt 0>
	<cfset comparison[ 'compTmDivWinPct' ] = comparison[ 'compTmDivWin' ] / (comparison[ 'compTmDivWin' ] + comparison[ 'compTmDivLoss' ])>
<cfelse>
	<cfset comparison[ 'compTmDivWinPct' ] = 0>
</cfif>
<cfif comparison[ 'compTmCommonWin' ] gt 0>
	<cfset comparison[ 'compTmCommonWinPct' ] = comparison[ 'compTmCommonWin' ] / (comparison[ 'compTmCommonWin' ] + comparison[ 'compTmCommonLoss' ])>
<cfelse>
	<cfset comparison[ 'compTmCommonWinPct' ] = 0>
</cfif>
<cfset comparison[ 'sameDiv' ] = comparison[ 'tmDiv' ] - comparison[ 'compTmDiv' ]>

<cfif cookie.teamID eq 1 AND debug eq 1>
	<cfdump var="#comparison#">
</cfif>

<cfset loc.tbWinnerTeamID = 0>
<cfif comparison[ 'sameDiv' ] eq 0>
	<!--- TIEBREAKER 1, SAME DIV: head to head --->
	<cfif comparison[ 'tmH2HWinPct' ] gt comparison[ 'compTmH2HWinPct' ]>
		<cfset loc.tbWinnerTeamID = attributes.teamID>
		<cfset loc.tiebreaker = "H2H">
	<cfelseif comparison[ 'tmH2HWinPct' ] lt comparison[ 'compTmH2HWinPct' ]>
		<cfset loc.tbWinnerTeamID = attributes.compTeamID>
		<cfset loc.tiebreaker = "H2H">
	</cfif>
	<!--- TIEBREAKER 2, SAME DIV: div record --->
	<cfif comparison[ 'tmDivWinPct' ] gt comparison[ 'compTmDivWinPct' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.teamID>
		<cfset loc.tiebreaker = "winpct">
	<cfelseif comparison[ 'tmDivWinPct' ] lt comparison[ 'compTmDivWinPct' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.compTeamID>
		<cfset loc.tiebreaker = "winpct">
	</cfif>
	<!--- TIEBREAKER 3, SAME DIV: record vs common opponents --->
	<cfif comparison[ 'tmCommonWinPct' ] gt comparison[ 'compTmCommonWinPct' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.teamID>
		<cfset loc.tiebreaker = "commonopp">
	<cfelseif comparison[ 'tmCommonWinPct' ] lt comparison[ 'compTmCommonWinPct' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.compTeamID>
		<cfset loc.tiebreaker = "commonopp">
	</cfif>
	<!--- TIEBREAKER 4, SAME DIV: net points, div games --->
	<cfif comparison[ 'tmDivPts' ] gt comparison[ 'compTmDivPts' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.teamID>
		<cfset loc.tiebreaker = "netdivpts">
	<cfelseif comparison[ 'tmDivPts' ] lt comparison[ 'compTmDivPts' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.compTeamID>
		<cfset loc.tiebreaker = "netdivpts">
	</cfif>
	<!--- TIEBREAKER 5, SAME DIV: net points, all games --->
	<cfif comparison[ 'tmPts' ] gt comparison[ 'compTmPts' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.teamID>
		<cfset loc.tiebreaker = "netpts">
	<cfelseif comparison[ 'tmPts' ] lt comparison[ 'compTmPts' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.compTeamID>
		<cfset loc.tiebreaker = "netpts">
	</cfif>
<cfelse>
	<!--- TIEBREAKER 1, DIFFERENT DIV: head to head --->
	<cfif comparison[ 'tmH2HWinPct' ] gt comparison[ 'compTmH2HWinPct' ]>
		<cfset loc.tbWinnerTeamID = attributes.teamID>
		<cfset loc.tiebreaker = "H2H">
	<cfelseif comparison[ 'tmH2HWinPct' ] lt comparison[ 'compTmH2HWinPct' ]>
		<cfset loc.tbWinnerTeamID = attributes.compTeamID>
		<cfset loc.tiebreaker = "H2H">
	</cfif>
	<!--- TIEBREAKER 2, DIFFERENT DIV: record vs common opponents --->
	<cfif comparison[ 'tmCommonWinPct' ] gt comparison[ 'compTmCommonWinPct' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.teamID>
		<cfset loc.tiebreaker = "commonopp">
	<cfelseif comparison[ 'tmCommonWinPct' ] lt comparison[ 'compTmCommonWinPct' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.compTeamID>
		<cfset loc.tiebreaker = "commonopp">
	</cfif>
	<!--- TIEBREAKER 3, DIFFERENT DIV: net points, all games --->
	<cfif comparison[ 'tmPts' ] gt comparison[ 'compTmPts' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.teamID>
		<cfset loc.tiebreaker = "netpts">
	<cfelseif comparison[ 'tmPts' ] lt comparison[ 'compTmPts' ] AND loc.tbWinnerTeamID eq 0>
		<cfset loc.tbWinnerTeamID = attributes.compTeamID>
		<cfset loc.tiebreaker = "netpts">
	</cfif>
</cfif>


<cfset caller.tiebreaker = loc.tiebreaker>
<cfset caller.comparison = comparison>
<cfset caller.tbWinnerTeamID = loc.tbWinnerTeamID>
<cfif attributes.teamID eq loc.tbWinnerTeamID>
	<cfset tbLoserTeamID = attributes.compTeamID>
<cfelse>
	<cfset tbLoserTeamID = attributes.teamID>
</cfif>

<cfset caller[ attributes.returnObj ] = { winnerID = loc.tbWinnerTeamID, loserID = tbLoserTeamID, tiebreaker = loc.tiebreaker }>

<cfif debug gt 0>
<cfoutput>
<cfdump var="#comparison#">
caller.tiebreaker = #caller.tiebreaker#<br />
attributes.teamID = #attributes.teamID#<br />
attributes.compTeamID = #attributes.compTeamID#<br />
loc.tbWinnerTeamID = #loc.tbWinnerTeamID#<br />
tbLoserTeamID = #caller.tbLoserTeamID#<br />
</cfoutput> 
</cfif>