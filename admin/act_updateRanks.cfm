<cfset msg1 = "Updated recent and season PPG.">
<cftry>
<cfstoredproc datasource="lwfa" procedure="sp_updateFPPG">
	<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#application.currwk#" type="in">
</cfstoredproc>
	<cfcatch type="any"><cfset msg1 = "There was a problem with the updateFPPG procedure."></cfcatch>
</cftry>
<cfoutput>#msg1#</cfoutput><P>

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

<cfinclude template="../tasks/proc_waiver_order.cfm">