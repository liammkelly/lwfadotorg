<cfcomponent>

	<cffunction name="changeCoach" access="remote" returnformat="plain">
		<cfargument name="teamID" 	required="true">
		<cfargument name="coachID" 	required="true">
	
		<cfquery datasource="#application.dsn#">
			UPDATE	coaches
			SET		teamID = NULL
			WHERE	teamID = #arguments.teamID#
		</cfquery>
		<cfquery datasource="#application.dsn#">
			UPDATE	coaches
			SET		teamID = #arguments.teamID#
			WHERE	coachID = #arguments.coachID#
		</cfquery>
		
	</cffunction>

	<cffunction name="getWeek" access="remote" returnformat="plain">
		<cfargument name="date" default="#now()#">
		
		<!--- <cfset LOCAL.firstSundayDate = createDate(2012,9,11)>
		<cfquery name="qGetWeek" datasource="lwfa">
			SELECT 		ceiling( datediff('#dateformat(arguments.date,"yyyy-mm-dd")#','#dateformat(LOCAL.firstSundayDate,"yyyy-mm-dd")#') / 7 )+1 "wk"
		</cfquery> --->
		
		<cfquery name="qGetWeek" datasource="lwfa">
			SELECT 		currwk
			FROM		weeks
		</cfquery>
		
		<cfif qGetWeek.currwk lt 1>
			<cfset LOCAL.weekNo = 1>
		<cfelse>
			<cfset LOCAL.weekNo = qGetWeek.currwk>
		</cfif>
		
		<cfreturn LOCAL.weekNo>
	</cffunction>

	<cffunction name="getPlayersJSON" access="remote" returnformat="json">
		<cfargument name="q" default="">
		<cfargument name="page" default="0">
		<cfargument name="rows" default="20">
		<cfargument name="sidx" default="playerID">
		<cfargument name="sord" default="asc">
		<cfargument name="isFA" default="0">
		
		<cfsetting enablecfoutputonly="true">
		<cfif arguments.page gt 1>
			<cfset startRow = (arguments.page-1) * arguments.rows>
		<cfelse>
			<cfset startRow = 0>		
		</cfif>

		<cfset myList = "playerID,first,last,pos,nflteam,name,recentppg,recentrank,seasonppg,seasonrank">		

		<cfset LOCAL.searchString = '0=0'>

		<cfif structKeyExists(arguments,'filters')>
			<cfset sFilters = deserializeJSON( arguments.filters )>
			<cfloop array="#sFilters.rules#" index="arr">
				<cfif arr.data eq "FA">
					<cfset LOCAL.searchString = LOCAL.searchString & " AND p.teamID = 0 ">			
				<cfelseif arr.data eq "owned">
					<cfset LOCAL.searchString = LOCAL.searchString & " AND p.teamID > 0 ">			
				<cfelse>				
					<cfset LOCAL.searchString = LOCAL.searchString & " AND " & arr.field>
					<cfif arr.op eq "bw">
						<cfset LOCAL.searchString = LOCAL.searchString & " LIKE '" & arr.data & "%'">			
					<cfelseif arr.op eq "eq">
						<cfset LOCAL.searchString = LOCAL.searchString & " = '" & arr.data & "'">			
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfloop list="#myList#" index="t">
			<cfif structKeyExists(arguments,t)>
				<cfif t eq "name" AND arguments[ t ] eq "FA">
					<cfset LOCAL.searchString = LOCAL.searchString & " AND name IS NULL">				
					<cfset arguments.isFA = true>
				<cfelseif t eq "name" AND arguments[ t ] eq "owned">
					<cfset LOCAL.searchString = LOCAL.searchString & " AND name IS NOT NULL">				
				<cfelse>
					<cfset LOCAL.searchString = LOCAL.searchString & " AND #t# LIKE '%#arguments[ t ]#%'">
				</cfif>
			</cfif>
		</cfloop>	
		
		<cfquery name="qPlayerList" datasource="lwfa">
			<!--- select 		p.first,p.last,p.teamID "hisTeamID",p.pos "position",p.nflteam "nfltm",
							s.*,
							if(t.name IS NULL,'FA',t.name) "lwfaTeam" --->
			select		SQL_CALC_FOUND_ROWS p.first,p.last,p.teamID,p.pos,p.nflteam,p.playerID,
							s.seasonRank,s.seasonPPG,s.recentRank,s.recentPPG,
							if(t.name IS NULL,'FA',t.name) "name",
							(select count(*) from playerdata where playerID=p.playerID) "games"	 
			from			players p 
								join playerstats s on p.playerID=s.playerID 
								left join teams t on p.teamID=t.teamID
			where 		p.current=1 AND
						<cfif arguments.isFA>p.teamID = 0 AND <cfelseif arguments.isFA eq -1>p.teamID > 0 AND </cfif>
							#preservesinglequotes(LOCAL.searchString)#
			order by 	#arguments.sidx# #arguments.sord#
			limit			#startRow#,#arguments.rows#
		</cfquery>
		
		<cfquery name="qCountQuery" datasource="lwfa">
			SELECT FOUND_ROWS() as ct
		</cfquery>

		<cfset searchDataJSON = '{"page":"' & arguments.page & '",'>
		<cfset searchDataJSON = searchDataJSON & '"total":' & ceiling(qCountQuery.ct/arguments.rows) & ','>
		<cfset searchDataJSON = searchDataJSON & '"records":"' & qCountQuery.ct & '",'>
		<cfset searchDataJSON = searchDataJSON & '"rows": ['>
		<cfif qPlayerList.recordcount eq 0>
			<cfset searchDataJSON = searchDataJSON & ']}'>
		</cfif>
		<!--- <span id='ct-#qPlayerList.currentrow#'>#qPlayerList.games#</span> --->
		<cfloop query="qPlayerList">
			<!--- <cfset links = jsStringFormat("<A href='playerpage.cfm?playerID=#qPlayer.qPlayerList.playerID#'><img src='/2012/images/info.png' alt='info' border=0 target='_blank'></A>")> --->
			<cfset searchDataJSON = searchDataJSON & ' {"id":"#qPlayerList.currentrow#","cell":['>
			<!--- <cfset searchDataJSON = searchDataJSON & '"' & links & '",'> --->
			<cfloop list="#myList#" index="i">
				<cfif i eq 'first' OR i eq 'last'>
					<cfset searchDataJSON = searchDataJSON & '"<A href=playerpage.cfm?playerID=' & qPlayerList[ 'playerID' ][ qPlayerList.currentrow ] & '>' & qPlayerList[ i ][ qPlayerList.currentrow ]& '</a>"'>				
				<cfelse>
					<cfset searchDataJSON = searchDataJSON & '"' & qPlayerList[ i ][ qPlayerList.currentrow ]& '"'>
				</cfif>
				<cfif i eq listGetAt(myList,listlen(myList))>
					<cfset searchDataJSON = searchDataJSON & ']}'>
					<cfif qPlayerList.recordcount gt qPlayerList.currentrow>
						<cfset searchDataJSON = searchDataJSON & ','>					
					<cfelse>
						<cfset searchDataJSON = searchDataJSON & ']}'>					
					</cfif>
				<cfelse>
						<cfset searchDataJSON = searchDataJSON & ','>					
				</cfif>
			</cfloop>
		</cfloop>

		<cfoutput>#searchDataJSON#</cfoutput>
		
	</cffunction>

	<cffunction name="getPlayerData" access="remote">
		<cfargument name="playerID" required="true">
		
		<cfquery name="qPlayer" datasource="lwfa">
			SELECT		s.*,p.pos "position"
			FROM		playerstats s join players p using (playerID)
			WHERE		playerID = #arguments.playerID#
		</cfquery>
		
		<cfif qPlayer.position eq 'QB'>
			<cfset str = "#qPlayer.passyds# pass yds, #qPlayer.passTD# pass TD, #qPlayer.passint# INT, #qPlayer.rushyds# rush yds">
			<cfif qPlayer.rushTD>
				<cfset str = str & "#qPlayer.rushTD# rush TD">
			</cfif>
		<cfelseif qPlayer.position eq 'RB'>

		<cfelseif qPlayer.position eq 'WR'>

		<cfelseif qPlayer.position eq 'TE'>

		<cfelseif qPlayer.position eq 'K'>

		<cfelseif qPlayer.position eq 'D'>

		</cfif>
	
		<cfset arrPlayer = ['stats',str]>
		<cfset jsonPlayer = encodeJSON(arrPlayer)>
		
		<cfreturn jsonPlayer>
	</cffunction>

	<cffunction name="alterLineup" access="remote" returntype="void">
		<cfargument name="active" required="true">
		<cfargument name="inactive" required="true">
		<cfargument name="inj" required="true">
		
		<cfquery datasource="lwfa">
			UPDATE		players
			SET			<cfif arguments.inj>inj='Y',</cfif>active='N'
			WHERE		playerID=#arguments.inactive#
		</cfquery>
		<cfquery datasource="lwfa">
			UPDATE		players
			SET			<cfif arguments.inj>inj='N',active='N'<cfelse>active='Y'</cfif>
			WHERE		playerID=#arguments.active#
		</cfquery>
		<cfquery datasource="lwfa">
			INSERT INTO 
				lineupchanges
				(
					teamID,
					playerID,
					status,
					changeDate
				)
				VALUES
				(
					#teamID#,
					#arguments.inactive#,
					'<cfif arguments.inj>to DL<cfelse>bench</cfif>',
					#now()#
				),
				(
					#teamID#,
					#arguments.active#,
					'<cfif arguments.inj>bench<cfelse>start</cfif>',
					#now()#
				)
		</cfquery>
		
	</cffunction>
	
	<cffunction name="postComment" access="remote" returnformat="plain">
		<cfargument name="postTypeID" 	required="true">
		<cfargument name="postType" 	required="true">
		<cfargument name="comment" 		required="true">
	
		<cfset isSuccess = true>
		<cfif arguments.comment neq ''>
			<cftry>
				<cfquery datasource="#application.dsn#">
					INSERT INTO posts 
						(
							itemType
							, itemID
							, userID
							, comment
							, commentDate
						)
						values
						(
							'#arguments.postType#'
							, #arguments.postTypeID#
							, #cookie.userID#
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">
							, now()
						)
				</cfquery>
				<cfcatch><cfset isSuccess = false></cfcatch>
			</cftry>
		</cfif>
		
		<cfreturn '{"success":#isSuccess#}'>
	</cffunction>
	
	<cffunction name="deletePost" access="remote" returnformat="plain">
		<cfargument name="postID" required="true">
	
		<cfquery name="qProposal" datasource="lwfa">
			DELETE
			FROM		posts
			WHERE		postID = #arguments.postID#
		</cfquery>
	
	</cffunction>
	
	<cffunction name="proposeTrade" access="remote" returnformat="plain">
		<cfargument name="toTeamID" required="true">
		<cfargument name="toPlayerList" required="true">
		<cfargument name="fromTeamID" default="#cookie.teamID#">
		<cfargument name="fromPlayerList" required="true">
		<cfargument name="cutPlayerList" required="true">

		
		<cfquery name="qTradeID" datasource="lwfa">
			select max(tradeID) as maxID from trades
		</cfquery>
		<cfif qTradeID.maxID eq ''>
			<cfset newID = 1>
		<cfelse>
			<cfset newID = qTradeID.maxID+1>
		</cfif>
		<cfloop list="#fromPlayerList#" index="fromPlyr">
			<cfquery name="iTrade" datasource="lwfa">
				INSERT INTO trades values (#newID#,#fromPlyr#,#fromTeamID#,1,1,0,#now()#)
			</cfquery>
		</cfloop>
		<cfloop list="#toPlayerList#" index="toPlyr">
			<cfquery name="iTrade" datasource="lwfa">
				INSERT INTO trades values (#newID#,#toPlyr#,#toTeamID#,0,1,0,#now()#)
			</cfquery>
		</cfloop>
		<cfloop list="#cutPlayerList#" index="waivePlyr">
			<cfquery name="iTrade" datasource="lwfa">
				INSERT INTO trades values (#newID#,#waivePlyr#,#fromTeamID#,1,1,1,#now()#)
			</cfquery>
		</cfloop>
		<cfquery name="qFrom" datasource="lwfa" result="rFrom">
			SELECT		u.*
			FROM		trades t join users u using (teamID)
			WHERE		tradeID = #newID# AND offerTeam = 1
		</cfquery>
		<cfquery name="qTo" datasource="lwfa">
			SELECT		u.*
			FROM		trades t join users u using (teamID)
			WHERE		tradeID = #newID# AND offerTeam =0
		</cfquery>
		<cfquery name="qTradeDetails" datasource="lwfa">
			select 		t.*,p.first,p.last,p.pos,ps.recentPPG,ps.seasonPPG,ps.recentRank,ps.seasonRank,tm.name "team"
			from			trades t 
								join players p on t.playerID=p.playerID 
								join playerstats ps on p.playerID=ps.playerID 
								join teams tm on t.teamID=tm.teamID
			where		t.tradeID = #newID# 
			order by 	t.offerTeam DESC
		</cfquery>

		<cfmail from="notifications@lwfa.org" to="#qTo.email#" cc="#qFrom.email#" subject="LWFA - Trade offer received" server="mail.tallkellys.com" failto="lwfamail@tallkellys.com" password="Wan99ker" username="lwfamail@tallkellys.com" type="html">
			<html><head><style>body{font:12px verdana;}</style></head><body>
			<cfset tm = ''>
			<cfloop query="qTradeDetails">
				<cfif team neq tm>
					<P>#team# would trade:<P>
					<cfset tm = team>
				</cfif>
				#first# #last#, #pos# <br />
		 	</cfloop>		
		 	<P>Go to your <a href="http://www.lwfa.org/2012/teampage.cfm?teamID=#qTo.teamID#">team page</a> and click on "Pending Moves" to respond to this offer.
		</cfmail>


	</cffunction>

	<cffunction name="saveTradeBlock" access="remote" returnformat="plain">
		<cfargument name="needs" default="">
		<cfargument name="blockPlayers" default="">
		<cfargument name="notes" default="">
		<cfargument name="teamID" default="">
		
		<cfquery name="updTradeBlock" datasource="lwfa">
			UPDATE 	tradeblock
			SET			needs = '#arguments.needs#',
							notes = '#trim(urldecode(arguments.notes))#'
			WHERE		teamID = #arguments.teamID#
		</cfquery>
		<cfquery name="updTradeBlock" datasource="lwfa">
			DELETE 
			FROM 		tradeblock_players
			WHERE		teamID = #arguments.teamID#
		</cfquery>
		<cfquery name="updTradeBlock" datasource="lwfa">
			INSERT INTO tradeblock_players 
				(playerID,teamID)
			VALUES
			<cfloop list="#arguments.blockPlayers#" index="playerID">
				(#playerID#,#arguments.teamID#)
				<cfif playerID neq listGetAt(arguments.blockPlayers,listlen(arguments.blockPlayers))>,</cfif>
			</cfloop>
		</cfquery>
		
		
		
		
	</cffunction>


</cfcomponent>