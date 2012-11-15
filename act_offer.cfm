<cfset sleep(1000)>

<cfif structKeyExists(form,'thisTradeID')>
	<cfset tradeID = thisTradeID>
</cfif>
<cfquery name="iClaim" datasource="lwfa">
	update trades set statusID=#action# where tradeID=#tradeID#
</cfquery>
<cfif action eq 5>
	<cfquery name="qTradeDetails" datasource="lwfa">
		select 		t.*,p.first,p.last,p.pos,ps.recentPPG,ps.seasonPPG,ps.recentRank,ps.seasonRank,tm.name "team"
		from			trades t 
							join players p on t.playerID=p.playerID 
							join playerstats ps on p.playerID=ps.playerID 
							join teams tm on t.teamID=tm.teamID
		where		t.tradeID = #tradeID# 
		order by 	t.offerTeam DESC
	</cfquery>
	<cfquery name="qUserEmails" datasource="lwfa">
		select distinct email from users where teamID IS NOT NULL AND email IS NOT NULL
	</cfquery>
	<cfloop query="qUserEmails">
		<cfmail from="notifications@lwfa.org" to="#qUserEmails.email[qUserEmails.currentrow]#" subject="LWFA - Trade accepted" server="mail.tallkellys.com" failto="lwfamail@tallkellys.com" password="Wan99ker" username="lwfamail@tallkellys.com" type="html">
		<!--- <cfmail from="notifications@lwfa.org" to="#valuelist(qUserEmails.email)#" subject="LWFA - Trade accepted" server="mail.blue-vellum.com" failto="liam@blue-vellum.com" password="wan99ker" username="liam@blue-vellum.com" type="html">  --->
		<html><head><style>body{font:12px verdana;}</style></head><body>
		<cfset tm = ''>
		<cfloop query="qTradeDetails">
			<cfif team neq tm>
				<P>#team# trades:<P>
				<cfset tm = team>
			</cfif>
			#first# #last#, #pos# <br />
	 	</cfloop>
		<P>This trade will be reviewed and approved or vetoed by the commissioner unless he is involved, in which case it will be reviewed by the trade committee.
		</body></html>
		</cfmail>
	</cfloop>
<cfelseif action eq 4>
	<cfquery name="qTradeDetails" datasource="lwfa">
		select 		t.*,p.first,p.last,p.pos,ps.recentPPG,ps.seasonPPG,ps.recentRank,ps.seasonRank,tm.name "team",u.email,u.fullname
		from			trades t 
							join players p on t.playerID=p.playerID 
							join playerstats ps on p.playerID=ps.playerID 
							join teams tm on t.teamID=tm.teamID
							join users u on t.teamID=u.teamID
		where		t.tradeID = #tradeID# 
		order by 	t.offerTeam DESC
	</cfquery>
	<cfmail from="notifications@lwfa.org" to="#qTradeDetails.email[1]#" subject="LWFA - Trade rejected" server="mail.tallkellys.com" failto="lwfamail@tallkellys.com" password="Wan99ker" username="lwfamail@tallkellys.com" type="html">
		<html><head><style>body{font:12px verdana;}</style></head><body>
		#qTradeDetails.fullname[qTradeDetails.recordcount]# has rejected this offer:
		<cfset tm = ''>
		<cfloop query="qTradeDetails">
			<cfif team neq tm>
				<P>#team# would trade:<P>
				<cfset tm = team>
			</cfif>
			#first# #last#, #pos# <br />
	 	</cfloop>
		</body></html>
	</cfmail>
</cfif>
<cfif structKeyExists(form,'thisTradeID')>
	<cflocation url="dsp_pending.cfm">
</cfif>

<!--- ************************************* --->
<!--- create 'act_approve_trade.cfm --->
<!--- ************************************* --->

<!--- <cfquery name="qTradeSpecs" datasource="lwfa">
	select * from trades where tradeID=#tradeID# 
</cfquery>

<cfset newFromTeamID = toTeamID>
<cfset newToTeamID = fromTeamID>

<cfloop query="qTradeSpecs">
	<cfif waive eq 0>
		<cfif teamID eq toTeamID>
			<cfquery name="qTradeActionWaive" datasource="lwfa">
				UPDATE 	players
				SET			teamID = #newToTeamID#, active = 'N', inj = 'N'
				WHERE		playerID = #playerID#
			</cfquery>
		<cfelse>
			<cfquery name="qTradeActionWaive" datasource="lwfa">
				UPDATE 	players
				SET			teamID = #newFromTeamID#, active = 'N', inj = 'N'
				WHERE		playerID = #playerID#
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="qTradeActionWaive" datasource="lwfa">
			UPDATE 	players
			SET			teamID = 0, active = 'N', inj = 'N'
			WHERE		playerID = #playerID#
		</cfquery>
	</cfif>
</cfloop>
<cfquery name="qTradeActionWaive" datasource="lwfa">
	UPDATE 	trades
	SET			statusID = 5
	WHERE		tradeID = #tradeID#
</cfquery> --->