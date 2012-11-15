<link rel="stylesheet" type="text/css" href="css/schedule.css">

<CFQUERY name="showSched" datasource="lwfa">
	SELECT s.*,t.name "away", t2.name "home",t.divID "awayDivID",t2.divID "homeDivID" 
	FROM schedule s join teams t on t.teamID=s.awayTeamID join teams t2 on s.homeTeamID=t2.teamID 
	order by s.gameID
</CFQUERY>

<CFSET weekList="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16">

<script language="javascript" type="text/javascript">
	$().ready( function() {
		$('A#myGames').click( function() {
			$('.games A').css({'font-weight':'normal'});
			$('.games A.mygame').css({'font-weight':'bold'});
		})
		$('A#allGames').click( function() {
			$('.games A').css({'font-weight':'normal'});
		})
		$('A#divGames').click( function() {
			$('.games A').css({'font-weight':'normal'});
			$('.games A.divgame').css({'font-weight':'bold'});
		})
	})
</script>


<center>
<div class="games">
<h3>2012 SCHEDULE</h3>
	<cfif structKeyExists(cookie,'divID')>
		<table cellspacing=0 cellpadding=0 border=0 id="actionTbl">
			<tr>
				<td><A href="javascript:;" id="allGames">Entire Schedule</A></td>
				<td><A href="javascript:;" id="myGames">My Team</A></td>
				<td><A href="javascript:;" id="divGames">My Division</A></td>
				<td><A href="grid.cfm">Grid</A></td>
			</tr>
		</table>
	</cfif>
	<div id="weekListing">
	<CFLOOP list="#weekList#" index="thiswk">
	<CFIF thiswk lte 13>
		<h2>Week <cfoutput>#thiswk#</cfoutput></h2>
	<CFELSEIF thiswk eq 14>
		<h2>Wildcard Round</h2>
	<CFELSEIF thiswk eq 15>
		<h2>Semifinal Round</h2>
	<CFELSEIF thiswk eq 16>
		<h2>L.W. Bowl XV</h2><p style="font-style:italic;font-size:11px;">Soccer City, Johannesburg</p>
	</CFIF>
	<CFOUTPUT query="showSched">
	<CFIF week eq thiswk>
	<A href="box.cfm?showheader=false&gameID=#gameID#&width=600&height=400" class="thickbox<cfif structKeyExists(cookie,'divID')><cfif awayDivID eq cookie.divID OR homeDivID eq cookie.divID> divgame</cfif><cfif awayTeamID eq cookie.TeamID OR homeTeamID eq cookie.TeamID> mygame</cfif></cfif>"><cfif awayscore gt 0>#numberformat(awayscore,'0.00')# </cfif>#away# at #home#<cfif homescore gt 0> #numberformat(homescore,'0.00')#</cfif></A><BR>
	</CFIF> 
	</CFOUTPUT>
	<P>
	</CFLOOP>
	</div>
</div>
</center>