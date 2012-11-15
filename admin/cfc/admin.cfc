<cfcomponent>

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
				<cfset aPlayers[ qPlayers.currentrow ] = {playerID=playerID,name=fullname,active=(active eq 'Y'),inj=(inj eq 'Y')}>
			</cfloop>
		
		<cfreturn serializeJson(aPlayers)>
	</cffunction>

	<cffunction name="updateDraftPlayer" access="remote">
		<cfargument name="teamID" required="true">
		<cfargument name="playerID" required="true">

			<cfquery datasource="lwfa">
				UPDATE 	draft d, players_copy p
				SET		 	d.playerID=p.playerID
				where		d.overallPos = #r# AND
								p.last = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(listgetAt(form['selection_'&r],1))#"> AND
								p.first = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(listgetAt(form['selection_'&r],2))#">
			</cfquery>
			<cfquery datasource="lwfa">
				UPDATE 	players_copy p
				SET			teamID = #form['team_'&r]#
				WHERE		p.last = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(listgetAt(form['selection_'&r],1))#"> AND
								p.first = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(listgetAt(form['selection_'&r],2))#">
			</cfquery>			

	</cffunction>

	<cffunction name="updateLiveStats" access="remote">
		<cfargument name="playerID" required="true">
		<cfargument name="stat" required="true">
		<cfargument name="value" required="true">
		<cfargument name="currwk" required="true">

		<cfquery name="updStats" datasource="lwfa">
			UPDATE playerdata 
			SET #stat#=#value# 
			WHERE playerID=#playerID# AND weekno=#application.currwk#
		</cfquery>

		<cfquery name="qUpdStats" datasource="lwfa">
			SELECT		*
			FROM		playerdata
			WHERE 		playerID=#playerID# AND weekno=#application.currwk#
		</cfquery>
		
		<cfmodule 
				template="/CustomTags/stat_compile_new.cfm"
				passyds=#qUpdStats.passyds#
				passTD=#qUpdStats.passTD#
				passINT=#qUpdStats.passINT#
				rushTD=#qUpdStats.rushTD#
				rushyds=#qUpdStats.rushyds#
				recyds=#qUpdStats.recyds#
				recTD=#qUpdStats.recTD#
				totalfum=#qUpdStats.fumble#
				tackles=#qUpdStats.tackle#
				sacks=#qUpdStats.sack#
				defint=#qUpdStats.defint#
				inttd=#qUpdStats.inttd#
				fumrec=#qUpdStats.fr#
				fumtd=#qUpdStats.frtd#
				forced=#qUpdStats.ff#
				lfgoal=#qUpdStats.lfg#
				fgoal=#qUpdStats.fg#
				sfgoal=#qUpdStats.sfg#
				xpts=#qUpdStats.xp#
				kryds=#qUpdStats.kryds#
				krtd=#qUpdStats.krtd#
				pryds=#qUpdStats.pryds#
				prtd=#qUpdStats.prtd#
				pass2pc=#qUpdStats.pass2pc#
				rec2pc=#qUpdStats.rec2pc#
				rush2pc=#qUpdStats.rush2pc#
				asstack=#qUpdStats.asstack# 
				defintyds=#qUpdStats.defintyds# 
				>
				
		<cfquery name="updStats" datasource="lwfa">
			UPDATE playerdata 
			SET 		total='#scoreline#', line='#scoredetail#'
			WHERE playerID=#playerID# AND weekno=#application.currwk#
		</cfquery>

	</cffunction>

	<cffunction name="loadPlayer" access="remote" returnformat="plain">
		<cfargument name="playerID" required="true">
	
		<cfhttp
		  	url="http://sports.yahoo.com/nfl/players/#arguments.playerID#/gamelog"
		  	resolveurl=1
		  	throwOnError="Yes"
			>
		<cfset content = cfhttp.filecontent>
		<cfset pos1 = findnocase("<title>",content) + 7>
		<cfset pos2 = findnocase("</title>",content,pos1) - 1>
		<cfset playerList = mid(content,pos1,50)>
		<cfset aPlayerData = listToArray(playerList,'-')>
		<cfset playerLastName = listGetAt(aPlayerData[1],listlen(aPlayerData[1]," ")," ")>
		<cfset playerFirstName = listDeleteAt(aPlayerData[1],listlen(aPlayerData[1]," ")," ")>
		<cfset playerTeam = ucase(replace(aPlayerData[2],".","","ALL"))>
		<cfset playerTeam = replace(playerTeam," ","","ALL")>
		<cfset playerNflTeam = left(playerTeam,3)>
		<cfif findnocase("Quarter",content)>
			<cfset pos = "QB">
			<cfset view = "A">
		<cfelseif findnocase("Running",content)>
			<cfset pos = "RB">
			<cfset view = "B">
		<cfelseif findnocase("Wide Receiver",content)>
			<cfset pos = "WR">
			<cfset view = "C">
		<cfelseif findnocase("Tight",content)>
			<cfset pos = "TE">
			<cfset view = "D">
		<cfelseif findnocase("Kicker",content)>
			<cfset pos = "K">
			<cfset view = "E">
		<cfelse>
			<cfset pos = "D">
			<cfset view = "F">
		</cfif>		
		
		<cfquery name="qDupe" datasource="lwfa">
			select * from players where playerID = #arguments.playerID#
		</cfquery>
		<cfif qDupe.recordcount eq 0>
			<cfquery name="insQuery" datasource="lwfa">
				INSERT INTO
					players
					(
						playerID,
						first,
						last,
						pos,
						nflteam,
						view,
						active,
						inj,
						teamID
					)
					values
					(
						#arguments.playerID#,
						'#playerFirstName#',
						'#playerLastName#',
						'#pos#',
						'#playerNflTeam#',
						'#view#',
						'N',
						'N',
						0
					)
			</cfquery>
			<cfquery name="insQuery" datasource="lwfa">
				INSERT INTO
					playerstats
					(playerID)
					values
					(#arguments.playerID#)
			</cfquery>
		</cfif>
		
		<cfinvoke method="reimportPlayer" playerName="#playerLastName#, #playerFirstName#">
		
		<cfoutput>
			<a href="/2012/playerpage.cfm?playerID=#arguments.playerID#">#playerFirstName# #playerLastName#</a>
		</cfoutput>
		
	</cffunction>

	<cffunction name="reimportPlayer" access="remote">
		<cfargument name="playerName" required="true">
		
		<cfset updFirstName = listGetAt(arguments.playerName,2)>
		<cfset updLastName = listGetAt(arguments.playerName,1)>
			
		<cfquery name="qweekno" datasource="lwfa">
			select currwk 
			from weeks 
		</cfquery>
		<cfset currwk=qweekno.currwk>
		<cfset prevwk=currwk-1>	
		
		<cfquery name="qUpdatePlayer" datasource="lwfa">
			select 	p.playerID,p.pos,p.nflteam,p.teamID,n.gamedate,n.weekNo
			from		players p left join nflschedule n on p.nflteam=n.nfltm left join playerdata d on p.playerID=d.playerID
			where	p.first='#updFirstName#' AND
						p.last = '#updLastName#' AND
						d.weekNo=n.weekNo AND
						n.gamedate <= #now()#
			order by n.gamedate
		</cfquery>

		<cfloop from=1 to="#application.currwk#" index="wk">
			<cfif listfind(valuelist(qUpdatePlayer.weekNo),wk) eq 0>
				<CF_getline_new 
					SelectedID="#qUpdatePlayer.playerID#"
					pos="#qUpdatePlayer.pos#"
					targetDate="#qUpdatePlayer.gamedate#"
					active="N"
					teamID="#qUpdatePlayer.teamID#"
					nflteam="#qUpdatePlayer.nflteam#"
					week="#wk#"
					>
				<cfoutput>
					Importing week #wk#...<br />
					<strong>#scoreline#</strong> - #scoredetail#<br />
				</cfoutput>
				<cfset sleep(2500)>
			</cfif>
		</cfloop>		
		
	</cffunction>


</cfcomponent>