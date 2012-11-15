<cfif structKeyExists(form,'runProcess')>

	<!--- update stats --->
	<cfset msg4 = "Updated player totals.">
	<cftry>
	<cfquery name="qPlayers" datasource="lwfa">
		TRUNCATE TABLE playerstats
	</cfquery>	
	<cfquery name="qPlayers" datasource="lwfa">
		select distinct playerID from playerdata where weekNo = #application.currwk#
	</cfquery>	
	<cfloop query="qPlayers">
		<cfquery name="q1" datasource="lwfa">
			CALL sp_compile(#qPlayers.playerID#);
		</cfquery>	
	</cfloop>
	<cfquery name="q2" datasource="lwfa">
		INSERT INTO playerstats (playerID) 
		select 	playerID
		from 	players
		where 	playerID not in (select distinct playerID from playerstats) 
	</cfquery>		
	<cfcatch type="any"><cfset msg4 = "There was a problem with updating the totals."><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
	<cfoutput>#msg4#</cfoutput><P>

	<cfset sleep(2000)>

	<!--- update recentPPG and seasonPPG --->
	<cfset msg1 = "Updated recent and season PPG.">
	<cftry>
	<cfstoredproc datasource="lwfa" procedure="sp_updateFPPG"></cfstoredproc>
		<cfcatch type="any"><cfset msg1 = "There was a problem with the updateFPPG procedure."></cfcatch>
	</cftry>
	<cfoutput>#msg1#</cfoutput><P>
	
	<cfset sleep(2000)>

	<!--- update posRank --->
	<cfset msg2 = "Updated recent and season ranks.">
	<cftry>
	<cfloop list="recent,season" index="s">
		<cfloop list="QB,RB,WR,TE,K,D" index="r">
			<cfquery name="qRanks" datasource="lwfa">
				select 	ps.playerID
				from		playerstats ps join players p on ps.playerID=p.playerID
				where	p.pos = '#r#'
				order by ps.#s#FP desc
			</cfquery>
			<cfloop query="qRanks">
				<cfquery name="uRanks" datasource="lwfa">
					update 	playerstats 
					set		#s#Rank=#qRanks.currentrow#
					where	playerID=#qRanks.playerID#
				</cfquery>
			</cfloop>
		</cfloop>
	</cfloop>
	<cfcatch type="any"><cfset msg2 = "There was a problem with the update ranks process."></cfcatch>
	</cftry>
	<cfoutput>#msg2#</cfoutput><P>
	
	<cfset sleep(2000)>

	<!--- UPDATE SCORES --->
	<cfset msg5 = "Updated scores.">
	<cftry>
	<cfquery name="qWeekGames" datasource="lwfa">
		select 	*
		from	schedule
		where 	week=#application.currwk#
	</cfquery>
	<cfloop query="qWeekGames">
		<cfquery name="qHomeTotal" datasource="lwfa">
			select 	sum(total) as tmPoints 
			from		playerdata
			where 	teamID=#homeTeamID# and weekno=#application.currwk# and active='Y'
		</cfquery>
		<cfset homeTotal=qHomeTotal.tmPoints> 
		<cfquery name="qAwayTotal" datasource="lwfa">
			select 	sum(total) as tmPoints 
			from		playerdata
			where 	teamID=#awayTeamID# and weekno=#application.currwk# and active='Y'
		</cfquery>
		<cfset awayTotal=qAwayTotal.tmPoints>
		<cfquery name="uScore" datasource="lwfa">
			update	schedule
			set 		homescore=#numberformat(homeTotal,"0.00")#,awayscore=#numberformat(awayTotal,"0.00")#
			where 	gameID=#gameID#
		</cfquery>
	</cfloop>
	<cfcatch type="any"><cfset msg5 = "There was a problem with the update scores process."></cfcatch>
	</cftry>
	<cfoutput>#msg5#</cfoutput><P>
	
	<cfset sleep(2000)>

	<!--- UPDATE STANDINGS --->
	<cfinclude template="standadmin.cfm">
	
	<cfset sleep(2000)>

	<!--- update star player --->
	<cfset msg3 = "Updated weekly MVP.">
	<cftry>
	<cf_query name="qStarPlayer" datasource="lwfa">
		DELETE FROM starPlayer WHERE weekNo = #application.currwk#;
		INSERT INTO starPlayer 
			SELECT 	p.playerID,pd.weekNo 
			from 		players p 
							join playerData pd on p.playerID=pd.playerID 
							join standings s on p.teamID=s.teamID 
			where 		left(s.streak,1)='W' AND 
							pd.weekNo=#application.currwk# AND 
							pd.active='Y' AND 
							pd.teamID > 0 
			order by 	pd.total desc 
			limit 1;
	</cf_query>
	<cfcatch type="any"><cfset msg3 = "There was a problem with updating the weekly MVP."></cfcatch>
	</cftry>
	<cfoutput>#msg3#</cfoutput><P>
	

	<!--- UPDATE WEEK --->
	<cfquery name="qAdvanceWeek" datasource="lwfa">
		UPDATE	weeks	
		SET			currwk = currwk + 1
	</cfquery>

<cfelse>

	<form action="<cfoutput>#cgi.script_name#</cfoutput>" method=post>
	<input type="submit" value="Run Process">
	<input type="hidden" name="runProcess" value="1">
	</form>

</cfif>