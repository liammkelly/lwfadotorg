<cfcomponent output="false">
	
	<cffunction name="getAvailablePlayers" access="remote" returnformat="plain">
		<cfargument name="sort" default="first">
		<cfargument name="pos" 	default="QB">
		
		<cfquery name="qPlayers" datasource="lwfa">
			SELECT 		first,last,pos,nflteam,playerID,byeweek
			FROM		players
			WHERE		pos = '#arguments.pos#' AND
						playerID NOT IN (
							SELECT 	DISTINCT playerID
							FROM	draft	
						) 
		</cfquery>
		
		<cfset sPlayers = {}>
		<cfset sPlayers[ 'success'] = true>
		<cfset sPlayers[ 'records'] = []>
	
		<cfset LOCAL.fieldList = qPlayers.columnlist>
	
		<cfloop query="qPlayers">
			<cfset sPlayers[ 'records' ][ arraylen(sPlayers[ 'records']) + 1 ] = {}>
			<cfloop list='#LOCAL.fieldList#' index="col">
				<cfset sPlayers[ 'records' ][ arraylen(sPlayers[ 'records' ]) ][ col ] = qPlayers[col][qPlayers.currentrow]>
			</cfloop>
		</cfloop>
				
		<cfinvoke component="json" method="encode" data="#sPlayers#" returnvariable="json" />
			
		<cfreturn json>	
	</cffunction>

	<cffunction name="getLeagueHistory" access="remote" returnformat="plain">
		<cfquery name="qLWFAHistory" datasource="lwfa">
			SELECT 		(s.win+o.win) AS wins, 
						(s.loss+o.loss) AS losses, 
						(s.tie+o.tie) AS ties, 
						((s.win+o.win)+(s.loss+o.loss)+(s.tie+o.tie)) "games",
						ceiling(((s.win+o.win)+(s.loss+o.loss)+(s.tie+o.tie)) / 13) "years",
						((s.win+o.win)/((s.win+o.win)+(s.loss+o.loss))) "winpct",
						u.fullname
			FROM 		users u 
							INNER JOIN owners o ON u.userid=o.userid
							INNER JOIN teams t ON u.teamID=t.teamID
							INNER JOIN standings s ON t.teamID=s.teamID
			order by 		6 desc;
		</cfquery>

		<cfreturn qLWFAHistory>	
	</cffunction>

	<cffunction name="getOwner" access="remote" returnformat="plain">
		<cfargument name="teamID" required="true">
		
		<cfquery name="qOwner" datasource="lwfa">
			SELECT		fullname,email
			FROM		users
			WHERE		teamID = #arguments.teamID#
		</cfquery>

		<cfreturn { fullname = qOwner.fullname, email = qOwner.email }>	
	</cffunction>
	
	<cffunction name="getPlayerData" access="remote" returnformat="plain">
		<cfargument name="playerID" required="true">

		<cfquery name="qPlayerData" datasource="lwfa">
			SELECT 	p.first,p.last,p.pos,p.playerID,
							tn.city,tn.nickname,tn.color,
							ps.*,
							group_concat(cast(m.weekNo AS CHAR)) "mvpList",
							pd.weekNo,
							d.round,d.selection,d.overallPos,
							t2.name "draftTeam",
							pd.passyds "weekPassYds",pd.passtd "weekPassTD",pd.passint "weekPassINT",pd.rushyds "weekRushYds",pd.rushtd "weekRushTD",pd.recyds "weekRecYds",pd.rectd "weekRecTD",pd.fumble "weekFumble",pd.sfg "weekSFG",pd.fg "weekFG",pd.lfg "weekLFG",pd.xp "weekXP",pd.tackle "weekTackle",pd.sack "weekSack",pd.defint "weekDefINT",pd.ff "weekFF",pd.fr "weekFR",pd.frtd "weekFRTD",pd.inttd "weekINTTD",pd.kryds "weekKRYds",pd.krtd "weekKRTD",pd.pryds "weekPRYds",pd.prtd "weekPRTD",pd.pass2pc "weekPass2PC",pd.rush2pc "weekRush2PC",pd.rec2pc "weekRec2PC",pd.asstack "weekAssTack",pd.defintyds "weekDefIntYds",
							rps.passyds "recentPassYds",rps.passtd "recentPassTD",rps.passint "recentPassINT",rps.rushyds "recentRushYds",rps.rushtd "recentRushTD",rps.recyds "recentRecYds",rps.rectd "recentRecTD",rps.fumble "recentFumble",rps.sfg "recentSFG",rps.fg "recentFG",rps.lfg "recentLFG",rps.xp "recentXP",rps.tackle "recentTackle",rps.sack "recentSack",rps.defint "recentDefINT",rps.ff "recentFF",rps.fr "recentFR",rps.frtd "recentFRTD",rps.inttd "recentINTTD",rps.kryds "recentKRYds",rps.krtd "recentKRTD",rps.pryds "recentPRYds",rps.prtd "recentPRTD",rps.pass2pc "recentPass2PC",rps.rush2pc "recentRush2PC",rps.rec2pc "recentRec2PC",rps.asstack "recentAssTack",rps.defintyds "recentDefIntYds",
							t.name  "lwfaTeam",
							(select concat(p2.first,' ',p2.last) from players p2 join playerstats ps2 on p2.playerID=ps2.playerID where p2.pos=p.pos AND ps2.recentRank = (ps.recentRank-1) LIMIT 1) "recentHigherPlayer",
							(select concat(p3.first,' ',p3.last) from players p3 join playerstats ps3 on p3.playerID=ps3.playerID where p3.pos=p.pos AND ps3.recentRank = (ps.recentRank+1) LIMIT 1) "recentLowerPlayer",
							(select concat(p4.first,' ',p4.last) from players p4 join playerstats ps4 on p4.playerID=ps4.playerID where p4.pos=p.pos AND ps4.seasonRank = (ps.seasonRank-1) LIMIT 1) "seasonHigherPlayer",
							(select concat(p5.first,' ',p5.last) from players p5 join playerstats ps5 on p5.playerID=ps5.playerID where p5.pos=p.pos AND ps5.seasonRank = (ps.seasonRank+1) LIMIT 1) "seasonLowerPlayer"
			FROM 		players p
							JOIN playerstats ps on p.playerID=ps.playerID
							LEFT JOIN recentplayerstats rps on p.playerID=rps.playerID
							LEFT JOIN playerdata pd on p.playerID=pd.playerID
							LEFT JOIN draft d on p.playerID=d.playerID
							LEFT JOIN  teams t on p.teamID=t.teamID
							LEFT JOIN  teams t2 on d.teamID=t2.teamID
							JOIN teamnames tn on p.nflteam=tn.nflteam
							LEFT JOIN starplayer m on m.playerID=p.playerID
			WHERE		p.playerID=#arguments.playerID#
			GROUP BY 	m.playerID 
			ORDER BY	pd.weekNo DESC
			LIMIT 1
		</cfquery>
		
		<cfreturn qPlayerData>
	</cffunction>
	
	<cffunction name="getPlayerGamelog" access="remote" returnformat="plain">
		<cfargument name="playerID" required="true">

		<cfquery name="qPlayer" datasource="lwfa">
			SELECT		line,total,weekno
			FROM		playerdata
			WHERE		playerID = #arguments.playerID#
			ORDER BY weekno
		</cfquery>
				
		<cfset jsonString = '{"rows":[{'>
		<cfif qPlayer.recordcount eq 0> 
			<cfset queryAddRow(qPlayer,1)>
			<cfset querySetCell(qPlayer,'line','No stats yet this year')>
			<cfset querySetCell(qPlayer,'total','0')>
			<cfset querySetCell(qPlayer,'weekno','0')>
		</cfif>
		<cfloop query="qPlayer">
			<cfset jsonString = jsonString & '"id":"#currentrow#","cell":["#weekno#","#total#","#line#"]'>
			<cfset jsonString = jsonString & "}">
			<cfif currentrow neq recordcount>
				<cfset jsonString = jsonString & ",{">
			</cfif>
		</cfloop>
		<cfset jsonString = jsonString & "]}">

		<cfreturn jsonString>
	</cffunction>

	<cffunction name="getPlayerTransactions" access="remote" returnformat="plain">
		<cfargument name="playerID" required="true">

		<cfquery name="qTransHistory" datasource="lwfa">
			select 		'claimed by' as act,t.name "team",c.dt "transDate"
			from		claims c join teams t on c.teamID=t.teamID
			where 		c.clmID = #arguments.playerID# AND c.statusID=3
			UNION 
			select 		'waived by' as act,t.name "team",c.dt "transDate"
			from		claims c join teams t on c.teamID=t.teamID
			where 		c.dmpID = #arguments.playerID# AND c.statusID=3
			UNION
			select 		'traded to' as act,t.name "team",tr.last_updated_date "transDate"
			from		trades tr join teams t on (select distinct teamID from trades where tradeID=tr.tradeID AND offerTeam<>tr.offerTeam)=t.teamID
			where 		tr.playerID = #arguments.playerID# AND tr.statusID=3
			order by 	transDate
		</cfquery>
	
		<cfreturn qTransHistory>
	</cffunction>

	<cffunction name="getPosts" access="remote" returnformat="plain">
		<cfargument name="teamID" 		default="0">
		<cfargument name="playerID" 	default="0">
		<cfargument name="tradeID" 		default="0">
		<cfargument name="claimID" 		default="0">
		<cfargument name="postID" 		default="0">
	
		<cfquery name="qPosts" datasource="#application.dsn#">
			SELECT 		*
			FROM		table
		</cfquery>
	
	</cffunction>

	<cffunction name="getPendingTrades" access="remote" returnformat="plain">

		<cfquery name="qPendingTrades" datasource="lwfa">
			SELECT 		DISTINCT t.tradeID,t.teamID,
						t2.teamID "targetTeamID",
						tm.name "targetTeam",
						tm2.name "offerTeam"
			FROM		trades t 
							join trades t2 on t.tradeID=t2.tradeID 
							join teams tm on tm.teamID=t2.teamID 
							join teams tm2 on tm2.teamID=t.teamID
			WHERE		t.offerTeam=1 AND 
						t2.offerTeam=0 AND 
						t.teamID <> t2.teamID AND
						t.statusID = 5
			ORDER BY 	t.last_updated_date desc
		</cfquery>

		<cfset sPendingTrades = {}>
		<cfset sPendingTrades[ 'records'] = []>
	
		<cfset LOCAL.fieldList = qPendingTrades.columnlist>
	
		<cfloop query="qPendingTrades">
			<cfset sPendingTrades[ 'records'][ arraylen(sPendingTrades[ 'records']) + 1 ] = {}>
			<cfloop list='#LOCAL.fieldList#' index="col">
				<cfset sPendingTrades[ 'records'][ arraylen(sPendingTrades[ 'records']) ][ col ] = qPendingTrades[col][qPendingTrades.currentrow]>
			</cfloop>
		</cfloop>
		
		<cfset json = application.cfc.json.encode( sPendingTrades )>
			
		<cfreturn json>	
	</cffunction>
	
	<cffunction name="getRosters" access="remote" returnformat="plain">
		<cfargument name="teamID" default="0">
		<cfargument name="json" default="0">
		
		<cfquery name="qRosters" datasource="lwfa">
			select 	p.*,t.name "team",t.nickname,ps.recentPPG
			from 	players p 
						join teams t on p.teamID=t.teamID 
						join playerstats ps on p.playerID=ps.playerid
			<cfif arguments.teamID>
				where p.teamID = #arguments.teamID#
			</cfif>
			order by t.name,p.view,ps.recentPPG desc
		</cfquery>	

		<cfif arguments.json>
			<cfset aTeam = []>
			<cfloop query="qRosters">
				<cfset aTeam[ arraylen(aTeam)+1 ] = "#pos# #first# #last#, #nflteam#">
			</cfloop>			
			<cfset jsonPlayers = serializeJson( aTeam )>	
			<cfreturn jsonPlayers>
		<cfelse>
			<cfreturn qRosters>
		</cfif>
	</cffunction>
	
	<cffunction name="getTrades" access="remote" returnformat="plain">

		<cfquery name="qTrades" datasource="#application.dsn#">
			SELECT 		group_concat((concat(p.pos,' ',p.first,' ',p.last)) SEPARATOR '<br>') "players",
						t.offerTeam,t.tradeID,t.teamID,t.last_updated_date "tradeDate", 0 as pending
			FROM 		trades t join players p on t.playerID=p.playerID
			WHERE 		t.statusID = 3 AND
						t.waive = 0
			GROUP BY 	t.tradeID,t.offerTeam
			UNION
			SELECT 		group_concat((concat(p.pos,' ',p.first,' ',p.last)) SEPARATOR '<br>') "players",
						t.offerTeam,t.tradeID,t.teamID,t.last_updated_date "tradeDate", 1 as pending
			FROM 		trades t join players p on t.playerID=p.playerID
			WHERE 		t.statusID = 5 AND
						t.waive = 0
			GROUP BY 	t.tradeID,t.offerTeam
			ORDER BY	pending DESC, tradeID DESC
		</cfquery>
	
		<cfset aTrades = []>
		
		<cfloop query="qTrades">
			<cfif qTrades.currentrow MOD 2 GT 0>
				<cfset aTrades[ arraylen(aTrades)+1 ] = { fromTeamID = qTrades.teamID,tradeID = qTrades.tradeID,fromTeamPlayers = qTrades.players, toTeamPlayers = '',isPending = pending }>
			<cfelse>
				<cfset aTrades[ arraylen(aTrades) ][ 'toTeamID' ] = qTrades.teamID>
				<cfset aTrades[ arraylen(aTrades) ][ 'toTeamPlayers' ] = qTrades.players>
			</cfif>			
		</cfloop>
		
		<cfreturn serializeJSON( aTrades )>
	</cffunction>
	
	<cffunction name="getTeamPoints" access="remote" returnformat="plain">
	
		<cfquery name="qTeamPoints" datasource="lwfa">
			select 	t.name,t.nickname,s.pf,t.teamID,if(#application.prevwk# > 0,(s.pf/#application.prevwk#),0) "ppg"
			from 	teams t join standings s on t.teamID=s.teamID
			order by s.pf desc	
		</cfquery>
		
		<cfset sTeamPoints = {}>
		<cfset sTeamPoints[ 'records'] = []>
	
		<cfset LOCAL.fieldList = qTeamPoints.columnlist>
	
		<cfloop query="qTeamPoints">
			<cfset sTeamPoints[ 'records' ][ arraylen(sTeamPoints[ 'records']) + 1 ] = {}>
			<cfloop list='#LOCAL.fieldList#' index="col">
				<cfset sTeamPoints[ 'records' ][ arraylen(sTeamPoints[ 'records' ]) ][ col ] = qTeamPoints[col][qTeamPoints.currentrow]>
			</cfloop>
		</cfloop>
				
		<cfinvoke component="json" method="encode" data="#sTeamPoints#" returnvariable="json" />
			
		<cfreturn json>	
	</cffunction>

	<cffunction name="getSchedule" access="remote" returnformat="plain">
		<cfargument name="teamID" default="0"/>
		<cfargument name="weekNo" default="0"/>
	
		<cfquery name="qSchedule" datasource="lwfa">
			SELECT 		s.*
						, t.name "awayteam"
						, t2.name "hometeam"
						<cfif arguments.teamID>
							,if(s.awayTeamID=#arguments.teamID#,'away','home') "location"
							,if(s.awayTeamID=#arguments.teamID#,
								if(s.awayscore>s.homescore,'W','L'),
								if(s.homescore>s.awayscore,'W','L')
							) "result"
							,s.gameID
							,p.first,p.last,p.pos
							,str.total
						</cfif>
			FROM		schedule s
							join teams t on s.awayTeamID=t.teamID
							join teams t2 on s.homeTeamID=t2.teamID
							<cfif arguments.teamID>
							left join (
								select 		max(total) "total",weekNo
								from 		playerdata
								where 		teamID=#arguments.teamID# AND active='Y' 
								group by 	weekNo
							) str on s.week=str.weekNo 
							left join playerdata pd on (pd.teamID=#arguments.teamID# AND pd.weekNo=str.weekNo AND pd.total=str.total)
							left join players p USING (playerID)
							</cfif>
			WHERE		0=0
						<cfif arguments.teamID gt 0>
							AND s.homeTeamID=#arguments.teamID# OR s.awayTeamID=#arguments.teamID#
						<cfelseif arguments.weekNo gt 0>
							AND s.week = #arguments.weekNo#
						</cfif>
			ORDER BY	gameID
		</cfquery>
		
		<cfset sSchedule = {}>
		<cfset sSchedule[ 'records'] = []>
	
		<cfset LOCAL.fieldList = qSchedule.columnlist>
	
		<cfloop query="qSchedule">
			<cfset sSchedule[ 'records'][ arraylen(sSchedule[ 'records']) + 1 ] = {}>
			<cfloop list='#LOCAL.fieldList#' index="col">
				<cfset sSchedule[ 'records'][ arraylen(sSchedule[ 'records']) ][ col ] = qSchedule[col][qSchedule.currentrow]>
			</cfloop>
		</cfloop>
		
		<cfset jsonSchedule = application.cfc.json.encode(sSchedule)>

		<cfreturn jsonSchedule>
	</cffunction>

	<cffunction name="getTeamTotals" access="remote" returnformat="plain">
		<cfargument name="startweek" required="true">
		<cfargument name="endweek" required="true">
		<cfargument name="lTeamIDs" default="">
		
		<cfquery name="qPoints" datasource="lwfa">
			select 		sum(pd.total) "totalpts",t.name "team", pd.weekNo
			from 		playerdata pd 
							join players p using (playerID)
							join teams t on (t.teamID=pd.teamID)
			where 		( weekNo >= #arguments.startweek# AND weekNo <= #arguments.endweek# ) AND
						<cfif arguments.lTeamIDs neq ''>
							t.teamID IN (#arguments.lTeamIDs#) AND
						<cfelse>
							t.teamID > 0 AND 
						</cfif>
						pd.active='Y'
			group by 	t.teamID, pd.weekNo
		</cfquery>
		
		<cfset aData = []>
		<cfloop query="qPoints">
			<cfset aData[ qPoints.currentrow ] = {}>
			<cfset aData[ qPoints.currentrow ]['team'] = team>
			<cfset aData[ qPoints.currentrow ]['totalpts'] = totalpts>
			<cfset aData[ qPoints.currentrow ]['weekNo'] = weekNo>
		</cfloop>
		
		<cfset jsonData = application.cfc.json.encode( aData )>
		
		<cfreturn jsonData>
	</cffunction>

	<cffunction name="getWeekMVP" access="remote" returnformat="plain">
		<cfargument name="weekNo" required="true">
	
		<cfquery name="qWeekStar" datasource="lwfa">
			select 	p.playerID,p.first,p.last,p.pos,
					t.name "lwfaTeam",t.abbv,
					sp.weekNo,
					pd.total,pd.line
			from	players p 
						join starplayer sp on p.playerID=sp.playerID 
						join teams t on p.teamID=t.teamID
						join playerdata pd on p.playerID=pd.playerID AND pd.weekNo=sp.weekNo
			where	sp.weekNo=#arguments.weekNo#
		</cfquery>
	
		<cfset sWeekStar = {}>
		<cfset LOCAL.fieldList = qWeekStar.columnlist>
	
		<cfloop query="qWeekStar">
			<cfloop list='#LOCAL.fieldList#' index="col">
				<cfset sWeekStar[ col ] = qWeekStar[col][qWeekStar.currentrow]>
			</cfloop>
		</cfloop>
			
		<cfset jsonWeekMVP = application.cfc.json.encode( sWeekStar )>
		
		<cfreturn jsonWeekMVP>	
	</cffunction>

	<cffunction name="loadStandings" access="remote" returnformat="plain">
	
		<cfquery name="qStandings" datasource="lwfa">
			select 		s.*,
						d.division,d.conference,
						t.name,t.abbv 
			from		standings s
							 join teams t on s.teamID=t.teamID
							 join divisions d on t.divID=d.divID
			order by 	d.conference,t.divID,s.winpct desc
		</cfquery>
		<cfset session.qStandings = qStandings>
		
	</cffunction>

</cfcomponent>