<cfsetting requesttimeout="3600">

<cfparam name="URL.weekNo" default="#application.currwk#">
<cfparam name="URL.date" default="#dateformat(now(),'yyyy-mm-dd')#">
<cfparam name="URL.bypass" default="0">

<cfset currDOW = dayofweek(now())>
<cfset currHour = hour(now())>

<!--- if it's a Tuesday or Wednesday, abort --->
<cfif currDOW eq 3 OR currDOW eq 4>a<cfabort></cfif>

<!--- get the earliest start time for today's games --->
<cfquery name="qGamecount" datasource="lwfa">
	select 	min( hour( scheduleDate ) ) "start"
	from 	nflschedule 
	where 	date(scheduleDate) = '#url.date#'
</cfquery>
<cfquery name="qEndTime" datasource="lwfa">
	select 	max( hour( scheduleDate ) ) "end"
	from 	nflschedule 
	where 	date(scheduleDate) = '#url.date#'
</cfquery>

<!--- if no games today, abort --->
<cfif qGamecount.recordcount eq 0 AND url.bypass eq 0>b<cfabort></cfif>

<!--- if no games have started yet, abort --->
<cfif currHour lt (qGamecount.start-1) AND url.bypass eq 0>c<cfabort></cfif>

<!--- if games are over by now, abort --->
<cfif currHour gt (qEndTime.end+4) AND url.bypass eq 0>d<cfabort></cfif>

<cfloop from=1 to=28 index="a">

	<cfset aGameID = arraynew(1)>
	<cfhttp url="http://sports.yahoo.com/nfl/scoreboard?w=#URL.weekNo#"></cfhttp>
	
	<!--- <cfquery name="kData" datasource="lwfa">
		delete
		from		liveData
	</cfquery> --->
	
	<cfset scoreboardCode = cfhttp.FileContent>
	<cfset scoreboardCode = mid(scoreboardCode,1500,len(scoreboardCode))>
	
	<cfloop from=1 to=30 index="c">
	
		<cfset loc = refindnocase('boxscore\?gid=',scoreboardCode)>
			<cfif loc eq 0><cfbreak></cfif>
		<cfset loc2 = find('" class',scoreboardCode,loc)>
		
		<cfset temp = arrayAppend(aGameID,mid(scoreboardCode,loc+13,loc2-loc-13))>
		<cfset scoreboardCode = mid(scoreboardCode,loc2+1,len(scoreboardCode))>
	</cfloop>

	<cfquery name="qTeams" datasource="lwfa">
		select distinct city from teamnames
	</cfquery>
	<cfset teamList = valueList(qTeams.city)>
	
	<!--- <cfdump var="#aGameID#"><cfabort>  --->
	
	<cfset twoPtConv = []>
	<cfset frtd = []>
	
	<cftry>
	<cfloop array="#aGameID#" index="f">
		<cfset checkForStats = 0>
		<cfset players = structnew()>
		<cfset currentTeam = ''>
		<cfset currentPlayer = ''>
		<cfset currentPlayerStats = structnew()>
		<cfset teamADetails[ '#f#' ] = structnew()>
		<cfset teamADetails[ '#f#' ][ 'passing' ] = structnew()>
		<cfset teamADetails[ '#f#' ][ 'passing' ][ 'name' ] = arraynew(1)>
		<cfset teamADetails[ '#f#' ][ 'passing' ][ 'stats' ] = arraynew(1)>
		<cfhttp url="http://sports.yahoo.com/nfl/boxscore?gid=#f#&old_bs=1"></cfhttp>
		<cfset boxscoreCode = cfhttp.FileContent>
		<cfset boxscoreCode = rereplacenocase(boxscoreCode,'<[^>]*>',',','ALL')>
		<cfset boxscoreCode = replacenocase(boxscoreCode,'&nbsp;','','ALL')>
		<cfset boxscoreArray = listToArray(boxscoreCode)>
		<cfloop from="#arraylen(boxscoreArray)#" to="1" step="-1" index="c">
			<cfif trim(boxscoreArray[c]) eq ''>
				<cfset arrayDeleteAt(boxscoreArray,c)>
			</cfif>
		</cfloop>
		<cfloop from=2 to="#arraylen(boxscoreArray)#" index="t">
			<cfif boxscoreArray[t] contains "2pt attempt converted">
				<cfset twoPtDataString = boxscoreArray[t+1]>
				<cfif twoPtDataString contains "pass">
					<cfset twoPtDataString = replace(twoPtDataString,"pass to",",")>
					<cfset twoPtDataString = replace(twoPtDataString,"run",",")>
					<cfset twoPtConv[ arraylen(twoPtConv)+1 ] = {}>
					<cfset twoPtConv[ arraylen(twoPtConv) ][ 'name' ] = trim(listGetAt(twoPtDataString,1))>
					<cfset twoPtConv[ arraylen(twoPtConv) ][ 'type' ] = 'pass'>
					<cfset twoPtConv[ arraylen(twoPtConv)+1 ] = {}>
					<cfset twoPtConv[ arraylen(twoPtConv) ][ 'name' ] = replace(trim(listGetAt(twoPtDataString,2)),")","")>
					<cfset twoPtConv[ arraylen(twoPtConv) ][ 'type' ] = 'rec'>
				<cfelse>
					<cfset twoPtDataString = replace(twoPtDataString,"pass to",",")>
					<cfset twoPtDataString = replace(twoPtDataString,"run",",")>
					<cfset twoPtConv[ arraylen(twoPtConv)+1 ] = {}>
					<cfset twoPtConv[ arraylen(twoPtConv) ][ 'name' ] = trim(listGetAt(twoPtDataString,1))>
					<cfset twoPtConv[ arraylen(twoPtConv) ][ 'type' ] = 'rush'>				
				</cfif>
			<cfelseif boxscoreArray[t] contains "recovered fumble">
				<cfset frtdDataString = boxscoreArray[t]>
				<cfset frtdDataString = replace(frtdDataString,"fumbled. ",",")>
				<cfset frtdDataString = replace(frtdDataString," recovered fumble",",")>
				<cfset frtd[ arraylen(frtd)+1 ] = trim(listGetAt(frtdDataString,2))>
			</cfif>
			<cfif boxscoreArray[t] eq "Fumbles Lost">
				<cfset checkForStats = 1>
			<cfelseif boxscoreArray[t] eq "Top performers">
				<cfbreak>
			</cfif>
			<cfif listFind(teamList,boxscoreArray[t]) gt 0>
				<cfset currentTeam = boxscoreArray[t]>
			</cfif>
			<cfif checkForStats eq 1>
				<cfif boxscoreArray[t] eq 'Passing'>
					<cfset currentPos = 'QB'>
				<cfelseif boxscoreArray[t] eq 'Rushing'>
					<cfset currentPos = 'RB'>
				<cfelseif boxscoreArray[t] eq 'Receiving'>
					<cfset currentPos = 'WR'>
				<cfelseif boxscoreArray[t] eq 'Kicking'>
					<cfset currentPos = 'K'>
				<cfelseif boxscoreArray[t] eq 'Kick/Punt Returns'>
					<cfset currentPos = 'KR'>
				<cfelseif boxscoreArray[t] eq 'Defense'>
					<cfset currentPos = 'D'>
				</cfif>
				<cfif refind('[A-Z]\. [A-Za-z]+',boxscoreArray[t]) gt 0>
					<cfif structKeyExists(players,'#boxscoreArray[t]#')>
					<cfelse>
						<cfset players[ boxscoreArray[t] ] = structnew()>
						<cfset players[ boxscoreArray[t] ].passYds = 0>			
						<cfset players[ boxscoreArray[t] ].passTD = 0>			
						<cfset players[ boxscoreArray[t] ].passINT = 0>			
						<cfset players[ boxscoreArray[t] ].rushYds = 0>			
						<cfset players[ boxscoreArray[t] ].rushTD = 0>			
						<cfset players[ boxscoreArray[t] ].fumble = 0>			
						<cfset players[ boxscoreArray[t] ].recYds = 0>			
						<cfset players[ boxscoreArray[t] ].recTD = 0>			
						<cfset players[ boxscoreArray[t] ].tack = 0>			
						<cfset players[ boxscoreArray[t] ].asstack = 0>			
						<cfset players[ boxscoreArray[t] ].sack = 0>			
						<cfset players[ boxscoreArray[t] ].ff = 0>			
						<cfset players[ boxscoreArray[t] ].fr = 0>			
						<cfset players[ boxscoreArray[t] ].frtd = 0>			
						<cfset players[ boxscoreArray[t] ].defint = 0>			
						<cfset players[ boxscoreArray[t] ].defintyds = 0>			
						<cfset players[ boxscoreArray[t] ].defintTD = 0>			
						<cfset players[ boxscoreArray[t] ].fg = 0>			
						<cfset players[ boxscoreArray[t] ].xp = 0>			
						<cfset players[ boxscoreArray[t] ].kryds = 0>			
						<cfset players[ boxscoreArray[t] ].krtd = 0>			
						<cfset players[ boxscoreArray[t] ].pryds = 0>			
						<cfset players[ boxscoreArray[t] ].prtd = 0>			
						<cfset players[ boxscoreArray[t] ].rush2PC = 0>			
						<cfset players[ boxscoreArray[t] ].rec2PC = 0>			
						<cfset players[ boxscoreArray[t] ].pass2PC = 0>			
					</cfif>
					<cfset players[ boxscoreArray[t] ].nflteam = currentTeam>			
					<cfif currentPos eq 'QB'>
						<cfset players[ boxscoreArray[t] ].passYds = boxscoreArray[t+3]>			
						<cfset players[ boxscoreArray[t] ].passTD = boxscoreArray[t+8]>			
						<cfset players[ boxscoreArray[t] ].passINT = boxscoreArray[t+9]>			
					<cfelseif currentPos eq 'RB'>
						<cfset players[ boxscoreArray[t] ].rushYds = boxscoreArray[t+2]>			
						<cfset players[ boxscoreArray[t] ].rushTD = boxscoreArray[t+5]>			
						<cfset players[ boxscoreArray[t] ].fumble = boxscoreArray[t+6]>			
					<cfelseif currentPos eq 'WR'>
						<cfset players[ boxscoreArray[t] ].recYds = boxscoreArray[t+2]>			
						<cfset players[ boxscoreArray[t] ].recTD = boxscoreArray[t+5]>			
						<cfset players[ boxscoreArray[t] ].fumble = boxscoreArray[t+6]>			
					<cfelseif currentPos eq 'KR'>
						<cfset players[ boxscoreArray[t] ].krYds = boxscoreArray[t+2]>			
						<cfset players[ boxscoreArray[t] ].krTD = boxscoreArray[t+5]>			
						<cfset players[ boxscoreArray[t] ].prYds = boxscoreArray[t+7]>			
						<cfset players[ boxscoreArray[t] ].prTD = boxscoreArray[t+10]>			
					<cfelseif currentPos eq 'K'>
						<cfset players[ boxscoreArray[t] ].fg = boxscoreArray[t+3]>			
						<cfset players[ boxscoreArray[t] ].xp = boxscoreArray[t+1]>			
					<cfelseif currentPos eq 'D'>
						<cfset players[ boxscoreArray[t] ].tack = boxscoreArray[t+1]>			
						<cfset players[ boxscoreArray[t] ].asstack = boxscoreArray[t+2]>			
						<cfset players[ boxscoreArray[t] ].sack = listGetAt(boxscoreArray[t+3],1)>			
						<cfset players[ boxscoreArray[t] ].ff = boxscoreArray[t+5]>			
						<cfset players[ boxscoreArray[t] ].fr = boxscoreArray[t+6]>			
						<cfset players[ boxscoreArray[t] ].defint = boxscoreArray[t+8]>			
						<cfset players[ boxscoreArray[t] ].defintyds = boxscoreArray[t+9]>			
						<cfset players[ boxscoreArray[t] ].defintTD = boxscoreArray[t+10]>			
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
				
		<cfif arraylen(twoPtConv)>
			<cftry>
				<cfloop from=1 to="#arraylen(twoPtConv)#" index="two">
					<cfset namekey = left( trim(twoPtConv[two]['name']),1 ) & ". " & listGetAt(trim(twoPtConv[two]['name']),2,' ')>
					<cfif structKeyExists(players,namekey)>
						<cfset players[ namekey ][ twoPtConv[two]['type'] & '2PC' ]++>
					</cfif>
				</cfloop>		
				<cfcatch><cfdump var="#twoPtConv#"><cfdump var="#boxscoreArray#" expand="0"><cfabort></cfcatch>
			</cftry>
		</cfif>
		<cfif arraylen(frtd)>
			<cftry>
				<cfloop from=1 to="#arraylen(frtd)#" index="two">
					<cfset namekey = left( trim(frtd[two]),1 ) & ". " & listGetAt(trim(frtd[two]),2,' ')>
					<cfif structKeyExists(players,namekey)>
						<cfset players[ namekey ][ 'frtd' ]++>
					</cfif>
				</cfloop>		
				<cfcatch><cfdump var="#twoPtConv#"><cfdump var="#boxscoreArray#" expand="0"><cfabort></cfcatch>
			</cftry>
		</cfif>
								
		<cfset allPlayers=structKeyList(players)>
		<cfloop list="#allPlayers#" index="y">
			<cfquery name="qPlayerInfo" datasource="lwfa">
				select playerID AS playerID,nflteam,pos from players 
				where left(first,1) = '#left(y,1)#' AND last = '#trim(listGetAt(y,2,"."))#' AND nflteam = (select nflteam from teamNames where city = '#players[ y ].nflteam#')
			</cfquery>
			<cftry>
			<cfif qPlayerInfo.pos neq 'D'>
				<cfset players[y].tack = 0>
				<cfset players[y].asstack = 0>
				<cfset players[y].frtd = 0>
				<cfset players[y].fr = 0>
				<cfset players[y].sack = 0>
				<cfset players[y].defint = 0>
				<cfset players[y].definttd = 0>
				<cfset players[y].defintyds = 0>
			</cfif>
			<CF_STAT_COMPILE_NEW
				passyds=#players[y].passyds#
				passTD=#players[y].passTD#
				passINT=#players[y].passINT#
				rushTD=#players[y].rushTD#
				rushyds=#players[y].rushyds#
				recyds=#players[y].recyds#
				recTD=#players[y].recTD#
				totalfum=#players[y].fumble#
				tackles=#players[y].tack#
				sacks=#players[y].sack#
				defint=#players[y].defint#
				inttd=#players[y].definttd#
				fumrec=#players[y].fr#
				fumtd=0
				forced=#players[y].ff#
				lfgoal=0
				fgoal=#players[y].fg#
				sfgoal=0
				frtd=#players[y].frtd#
				xpts=#players[y].xp#
				kryds=#players[y].kryds#
				krtd=#players[y].krtd#
				pryds=#players[y].pryds#
				prtd=#players[y].prtd#
				pass2pc=#players[y].pass2pc#
				rec2pc=#players[y].rec2pc#
				rush2pc=#players[y].rush2pc#
				asstack=#players[y].asstack# 
				defintyds=#players[y].defintyds# 
				>
			<cfif qPlayerInfo.recordcount>
				<cfquery name="iPlayer" datasource="lwfa">
					insert into liveData (
									passyds, 
									passTD, 
									passint, 
									rushyds, 
									rushtd, 
									recyds, 
									rectd, 
									fumble, 
									fg, 
									xp, 
									tackle, 
									sack, 
									defint, 
									ff, 
									fr, 
									frtd, 
									inttd, 
									kryds, 
									krtd, 
									pryds, 
									prtd, 
									pass2PC, 
									rec2PC, 
									rush2PC, 
									asstack,
									defintyds,
									playerID,
									line,
									total,
									nflteam
								)
								values 
								(
								#players[y].passyds#,
								#players[y].passTD#,
								#players[y].passINT#,
								#players[y].rushyds#,
								#players[y].rushTD#,
								#players[y].recyds#,
								#players[y].recTD#,
								#players[y].fumble#,
								#players[y].fg#,
								#players[y].xp#,
								#players[y].tack#,
								#players[y].sack#,
								#players[y].defint#,
								#players[y].ff#,
								#players[y].fr#,
								#players[y].frtd#,
								#players[y].definttd#,
								#players[y].kryds#,
								#players[y].krtd#,
								#players[y].pryds#,
								#players[y].prtd#,
								#players[y].pass2PC#,
								#players[y].rec2PC#,
								#players[y].rush2PC#,
								#players[y].asstack#,
								#players[y].defintyds#,
								 #qPlayerInfo.playerID#,
								 '#scoredetail#',
								 '#scoreline#',
								 '#qPlayerInfo.nflteam#'
								)				
						ON DUPLICATE KEY UPDATE 		passyds=#players[y].passyds#, 
									passTD=#players[y].passTD#, 
									passint=#players[y].passint#, 
									rushyds=#players[y].rushyds#, 
									rushtd=#players[y].rushtd#, 
									recyds=#players[y].recyds#, 
									rectd=#players[y].rectd#, 
									fumble=#players[y].fumble#, 
									fg=#players[y].fg#, 
									xp=#players[y].xp#, 
									tackle=#players[y].tack#, 
									sack=#players[y].sack#, 
									defint=#players[y].defint#, 
									ff=#players[y].ff#, 
									fr=#players[y].fr#, 
									frtd=#players[y].frtd#, 
									pass2pc=#players[y].pass2pc#, 
									rec2pc=#players[y].rec2pc#, 
									rush2pc=#players[y].rush2pc#, 
									inttd=#players[y].definttd#, 
									kryds=#players[y].kryds#, 
									krtd=#players[y].krtd#, 
									pryds=#players[y].pryds#, 
									prtd=#players[y].prtd#, 
									asstack=#players[y].asstack#,
									defintyds=#players[y].defintyds#,
									line='#scoredetail#',
									total=#scoreline#
				</cfquery>
			</cfif>
			<cfcatch type="any">
				<cfmail from="liam@blue-vellum.com" to="liammkelly@gmail.com" subject="live scoring problem" server="mail.blue-vellum.com" failto="liam@blue-vellum.com" password="wan99ker" username="liam@blue-vellum.com" type="html">
				<cfdump var="#cfcatch#">
				</cfmail>
			</cfcatch>
			</cftry>
		</cfloop>
	</cfloop>
	<cfcatch type="any"><cfdump var="#teamADetails#"><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
	
	<cfquery name="insQuery" datasource="lwfa">
		UPDATE 	liveUpdate
		SET  			updateTime=#now()#
	</cfquery>
	
	<cfabort>

</cfloop>


<cfmail from="web@lwfa.org" to="liammkelly@gmail.com" subject="Live update ran" server="mail.tallkellys.com" username="web@tallkellys.com" password="waj4Gani">
	Live update ran.
</cfmail>