<cfif structKeyExists(form,'runProcess')>

	<!--- update recentPPG and seasonPPG --->
	<cfset msg1 = "Updated recent and season PPG.">
	<cftry>
	<cfstoredproc datasource="lwfa" procedure="sp_updateFPPG"></cfstoredproc>
		<cfcatch type="any"><cfset msg1 = "There was a problem with the updateFPPG procedure."><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
	<cfoutput>#msg1#</cfoutput><P>
	
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

	<!--- update star player 
	<cfset msg3 = "Updated weekly MVP.">
	<cftry>
	<cfquery name="qStarPlayer" datasource="lwfa">
		INSERT INTO starPlayer 
		SELECT p.playerID,pd.weekNo from players p join playerdata pd on p.playerID=pd.playerID join standings s on p.teamID=s.teamID where left(s.streak,1)='W' AND pd.weekNo=#prevwk# AND pd.active='Y' AND pd.teamID > 0 order by pd.total desc limit 1
	</cfquery>
	<cfcatch type="any"><cfset msg3 = "There was a problem with updating the weekly MVP."><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
	<cfoutput>#msg3#</cfoutput><P>
	
	<!--- update stats --->
	<cfset msg4 = "Updated player totals.">
	<cftry>
	<cfquery name="qPlayers" datasource="lwfa">
		select distinct playerID from playerdata where weekNo = #application.currwk#
	</cfquery>	
	<cfloop query="qPlayers">
		<cfstoredproc datasource="lwfa" procedure="sp_compile">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#playerID#" />
		</cfstoredproc>
	</cfloop>
	<cfcatch type="any"><cfset msg4 = "There was a problem with updating the totals."></cfcatch>
	</cftry>
	<cfoutput>#msg4#</cfoutput><P>--->
	
<cfelse>

	<form action="<cfoutput>#cgi.script_name#</cfoutput>" method=post>
	<input type="submit" value="Run Process">
	<input type="hidden" name="runProcess" value="1">
	</form>

</cfif>