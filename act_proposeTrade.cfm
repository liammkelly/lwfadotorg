<cfif listlen(from) lt listlen(to) AND NOT structKeyExists(form,'waive')>
	<cfset playersOffset = listlen(to) - listlen(from)>
	<cfquery name="qTradeDrops" datasource="lwfa">
		select 	playerID,first,last,pos
		from		players
		where	playerID NOT IN (#from#) AND teamID = #fromTeamID#
	</cfquery>
	<!--- <cf_lwfa_header> --->
		<style>
		div#dropPlayersDiv {
			margin:20px 0 0 20px;
			float:left;
		}
		div#dropPlayersDiv SELECT {
			float:left;
			clear:none;
			margin-top:20px;
		}
		div#dropPlayersDiv INPUT {
			float:left;
			clear:none;
			padding: 15px 5px;
			font:bold 14px verdana;
			margin:100px 0 0 25px;
		}
		</style>
		<cfoutput>
		<form name="waivePlayersForm" action="#cgi.script_name#" method="post">
			<div id="dropPlayersDiv">
				You need to release #playersOffset# player<cfif playersOffset gt 1>s</cfif> to keep your roster under the limit.
				<select  name="waive" class="playerSelect" multiple="true" size="17">
					<cfloop query="qTradeDrops">
					<option value="#playerID#">#first# #last#, #pos#</option>
					</cfloop>
				</select>
				<input type="submit" value="Make offer">
			</div>
			<input type="hidden" name="from" value="#url.from#">
			<input type="hidden" name="fromTeamID" value="#url.fromTeamID#">
			<input type="hidden" name="to" value="#url.to#">
			<input type="hidden" name="toTeamID" value="#url.toTeamID#">
		</form>
		</cfoutput>
	<!--- </cf_lwfa_header> --->
	<cfabort>
</cfif>

<cfquery name="qTradeID" datasource="lwfa">
	select max(tradeID) as maxID from trades
</cfquery>
<cfif qTradeID.maxID eq ''>
	<cfset newID = 1>
<cfelse>
	<cfset newID = qTradeID.maxID+1>
</cfif>
<cfloop list="#from#" index="fromPlyr">
	<cfquery name="iTrade" datasource="lwfa">
		INSERT INTO trades values (#newID#,#fromPlyr#,#fromTeamID#,1,1,0,#now()#)
	</cfquery>
</cfloop>
<cfloop list="#to#" index="toPlyr">
	<cfquery name="iTrade" datasource="lwfa">
		INSERT INTO trades values (#newID#,#toPlyr#,#toTeamID#,0,1,0,#now()#)
	</cfquery>
</cfloop>
<cfif structKeyExists(form,'waive')>
	<cfloop list="#form.waive#" index="waivePlyr">
		<cfquery name="iTrade" datasource="lwfa">
			INSERT INTO trades values (#newID#,#waivePlyr#,#fromTeamID#,1,1,1,#now()#)
		</cfquery>
	</cfloop>
</cfif>
<cfquery name='qUser' datasource="lwfa">
	SELECT 	if(notify=1,email,NULL) "recepientEmail"
	FROM		users
	WHERE		teamID = #toTeamID#
</cfquery>
<cfif qUser.recepientEmail neq ''>
	<cfquery name="qTradeDetails" datasource="lwfa">
		select 		t.*,p.first,p.last,p.pos,ps.recentPPG,ps.seasonPPG,ps.recentRank,ps.seasonRank,tm.name "team"
		from			trades t 
							join players p on t.playerID=p.playerID 
							join playerstats ps on p.playerID=ps.playerID 
							join teams tm on t.teamID=tm.teamID
		where		t.tradeID = #newID# 
		order by 	t.offerTeam DESC
	</cfquery>
	<cfmail from="notifications@lwfa.org" to="#qUser.recepientEmail#" subject="LWFA - Trade offer received " server="mail.tallkellys.com" failto="lwfamail@tallkellys.com" password="Wan99ker" username="lwfamail@tallkellys.com" type="html">
	<html><head><style>body{font:12px verdana;}</style></head><body>
	<cfset tm = ''>
	<cfloop query="qTradeDetails">
		<cfif team neq tm>
			<P>#team# offers:<P>
			<cfset tm = team>
		</cfif>
		#first# #last#, #pos# (Season #pos# rank: #seasonRank# | Recent #pos# rank: #recentRank#)<br />
 	</cfloop>
	</body></html>
	</cfmail>
</cfif>

<cfset URL.tradeID = newID>
<cfset URL.cancel = 0>
<cfinclude template="dsp_offer.cfm">