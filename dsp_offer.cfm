<script language="javascript" src="/scripts/jquery-1.4.2.min.js"></script>
<script language="javascript" src="/scripts/jquery-ui-1.8.2.custom.min.js"></script>
<link rel="stylesheet" type="text/css" href="/styles/jquery-ui.css" />
<cfif structKeyExists(form,'tradeID')>
	<!--- if a trade was accepted and the player count is uneven, show this form --->
	<cfquery name="qTradeDrops" datasource="lwfa">
		select 	playerID,first,last,pos
		from		players
		where	playerID NOT IN (#from#) AND teamID = #fromTeamID#
	</cfquery>
	<style>
		form {
			font:11px verdana;
		}
	</style>
	<cfoutput>
	<form name="waivePlayersForm" action="#cgi.script_name#" method="post">
		<cfset playersOffset = listlen(to)-listlen(from)>
		<div id="dropPlayersDiv">
			You need to release <b>#playersOffset# player</b><cfif playersOffset gt 1>s</cfif> to keep your roster under the limit.<br/>
			<select  name="waive" class="playerSelect" multiple="true" size="17">
				<cfloop query="qTradeDrops">
				<option value="#playerID#">#first# #last#, #pos#</option>
				</cfloop>
			</select>
			<input type="submit" value="Accept Trade">
		</div>
		<input type="hidden" name="action" value="5">
		<input type="hidden" name="from" value="#form.from#">
		<input type="hidden" name="fromTeamID" value="#form.fromTeamID#">
		<input type="hidden" name="to" value="#form.to#">
		<input type="hidden" name="toTeamID" value="#form.toTeamID#">
		<input type="hidden" name="thisTradeID" value="#form.tradeID#">
	</form>
	</cfoutput>
<cfelseif structKeyExists(form,'toTeamID')>
	<cfloop list="#form.waive#" index="waivePlyr">
		<cfquery name="iTrade" datasource="lwfa">
			INSERT INTO trades values (#thisTradeID#,#waivePlyr#,#fromTeamID#,0,1,1,now())
		</cfquery>
	</cfloop>
	<cfinclude template="act_offer.cfm">
</cfif>

<cfparam name="url.tradeID" default="0">
<cfparam name="url.cancel" default="1">
<cfquery name="qTradeDetails" datasource="lwfa">
	select 		t.*,p.first,p.last,p.pos,ps.recentPPG,ps.seasonPPG,ps.recentRank,ps.seasonRank,tm.name "team"
	from			trades t 
						join players p on t.playerID=p.playerID 
						join playerstats ps on p.playerID=ps.playerID 
						join teams tm on t.teamID=tm.teamID
	where		t.tradeID = #url.tradeID# 
	order by 	t.offerTeam DESC
</cfquery>
<script src="/scripts/jquery-1.4.2.min.js" language="javascript"></script>
<script>
$().ready( function() {
	$('div#loadingDiv')
		.ajaxStart( function() {
			$(this).show();
		})
		.ajaxStop( function() {
			$(this).hide();
		})
		;
	
	$('input#acceptBtn').click( function() {
		$.ajax({
			type:		"POST",
			url:		"act_offer.cfm",
			data:		{
				tradeID:<cfoutput>#qTradeDetails.tradeID[1]#</cfoutput>,
				action:5
			},
			success:	function(data) {
				parent.tb_remove();
			}
		})
	})
	$('input#rejectBtn').click( function() {
		$('span#ajaxText').html('Cancelling trade...');
		$.ajax({
			type:		"POST",
			url:		"act_offer.cfm",
			data:		{
				tradeID:<cfoutput>#qTradeDetails.tradeID[1]#</cfoutput>,
				action:4
			},
			success:	function(data) {
				parent.tb_remove();
			}
		})
	})
})
</script>
<style>
h1,h2,h3,h4 {
	font-family:verdana;
}
DIV#offerOptionsDiv {
	margin:0 auto;
	width:300px;
}
DIV.offerPlayerDiv {
	font:12px verdana;
}
DIV.offerPlayerDiv IMG {
	width:25px;
	height:30px;
}
div#loadingDiv {
	display:none;
	width:165px;
	margin:20px auto;
	font:bold 12px verdana;
}
</style>


<div id="offerDiv">

<cfoutput>

<cfset offeringTeam = qTradeDetails.teamID[1]>
<cfif structKeyExists(url,'viewOnly')>
	<cfset acceptingTeam = qTradeDetails.teamID[ qTradeDetails.recordcount ]>
	<h4>#application.aTeams[ offeringTeam ]# gives:</h4>
<cfelse>
	<cfif structKeyExists(url,'latestTrade')>
		<h4>#url.team1# gives:</h4>
	<cfelse>
		<h2>Trade offer from #qTradeDetails.team#</h2>
	</cfif>
</cfif>


<cfset waived = 0>
<cfset toPlayers = ''>
<cfset toPlayerCt = 0>
<cfset fromPlayers = ''>
<cfset fromPlayerCt = 0>
<cfloop query="qTradeDetails">
	<cfif waive eq 0>
		<cfif structKeyExists(cookie,'teamID') AND teamID eq cookie.teamID>
			<cfset fromPlayerCt += 1>
			<cfset fromPlayers = listAppend(fromPlayers,playerID)>
		<cfelse>
			<cfset toPlayerCt += 1>
			<cfset toPlayers = listAppend(toPlayers,playerID)>
			<cfset toTeam = teamID>
		</cfif>
		<cfif qTradeDetails.currentrow gt 1 AND qTradeDetails.offerTeam neq qTradeDetails.offerTeam[currentrow-1]>
			<cfif structKeyExists(url,'latestTrade')>
				<h4>#url.team2# gives:</h4>
			<cfelseif structKeyExists(url,'viewOnly')>
				<h4>#application.aTeams[ acceptingTeam ]# gives:</h4>
			<cfelse>
				<h4>FOR</h4>
			</cfif>
		</cfif>
		<div class="offerPlayerDiv">
		<img align="absmiddle" src="images/players/#playerID#.jpg" height="60" width="50"> <b>#pos# #first# #last#</b> [Season #pos# rank: #seasonRank# | Recent #pos# rank: #recentRank#]
		</div>
	<cfelse>
		<cfset waived = 1>
	</cfif>
</cfloop>
<cfif ( NOT structKeyExists(cookie,'teamID') OR offeringTeam eq cookie.teamID ) AND waived>
<h4>RELEASED:</h4>
<cfloop query="qTradeDetails">
	<cfif waive eq 1>
		<div class="offerPlayerDiv">
		<img align="absmiddle" src="images/players/#playerID#.jpg" height="60" width="50"> <b>#pos# #first# #last#</b> [Season #pos# rank: #seasonRank# | Recent #pos# rank: #recentRank#]
		</div>
	</cfif>
</cfloop>	
</cfif>
<cfif NOT structKeyExists(url,'latestTrade') AND NOT structKeyExists(url,'viewOnly')>
<div id="offerOptionsDiv">
<!--- <input type="button" name="cancel" value="<< Back" onclick="history.back()"> --->
<cfif offeringTeam eq cookie.teamID>
	<cfif URL.cancel eq 1>
		<input type="button" class="submitBtn" id="rejectBtn" value="Cancel offer">
	</cfif>
<cfelse>
	<cfif fromPlayerCt lt toPlayerCt>
		<form action="#cgi.script_name#" method="post">
			<input type="hidden" name="tradeID" value="#url.tradeID#">
			<input type="submit" class="submitBtn" id="acceptBtn" value="Accept trade">
			<input type="button" class="submitBtn" id="rejectBtn" value="Reject trade">
			<input type="hidden" name="from" value="#fromPlayers#">
			<input type="hidden" name="fromTeamID" value="#cookie.teamID#">
			<input type="hidden" name="to" value="#toPlayers#">
			<input type="hidden" name="toTeamID" value="#toTeam#">			
		</form>
	<cfelse>	
		<input type="button" class="submitBtn" id="acceptBtn" value="Accept trade">
		<input type="button" class="submitBtn" id="rejectBtn" value="Reject trade">
	</cfif>
</cfif>
</cfif>
</div>
</cfoutput>
<div id="loadingDiv">
	<img src="images/loading.gif" align="absmiddle"> <span id="ajaxText">Processing trade...</span>
</div>
</div>