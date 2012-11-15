<cfquery name="qRounds" datasource="lwfa">
	SELECT			d.round,d.selection,
						t.name,
						p.pos
					
	FROM			draft d 
							join teams t using (teamID)
							left join players p using (playerID)

	ORDER BY 	d.round,d.selection
</cfquery>

<cfquery name="qCounts" datasource="lwfa">
	SELECT		count(1) "ttl",p.pos "countpos",t.name "team",t.teamID
	FROM		draft d 
						join teams t using (teamID)
						left join players p using (playerID)
	WHERE		p.playerID IS NOT NULL
	GROUP BY	p.pos,t.teamID
</cfquery>

<cfquery name="qTeams" datasource="lwfa">
	SELECT 		*
	FROM		teams
	ORDER BY	draftSlot
</cfquery>

<cfquery name="qOnTheClock"  datasource="lwfa">
	select 	teamID,round
	from 	draft
	where	playerID = 0
	order by overallpos
	limit 1 
</cfquery>


<cfset lPositions = "QB,RB,WR,TE,K,D">
<cfset sPosBreakdown = {}>
<cfloop query="qTeams">		
	<cfset sPosBreakdown[ qTeams.teamID ] = {}>
	<cfloop list="#lPositions#" index="pos">
		<cfset sPosBreakdown[ qTeams.teamID ][ pos ] = 0>	
	</cfloop>
</cfloop>
<cfloop query="qCounts">
	<cfset sPosBreakdown[ teamID ][ countpos ] = ttl>		
</cfloop>

<cfset teamList = ''>
		
<cfset arrOrder = []>
<cfloop query="qRounds" endrow="16">
	<cfset arrOrder = arraynew(2)>
	<cfset teamList = listAppend(teamList,name)>
</cfloop>

<cfloop query="qRounds">
	<cfset arrOrder[ round ][ selection] = structnew()>
	<cfset arrOrder[ round ][ selection][ 'pos' ] = pos>
	<cfif round mod 2 eq 0>
		<cfset teamIndex = 17 - selection>
	<cfelse>
		<cfset teamIndex = selection>
	</cfif>
	<cfset arrOrder[ round ][ selection][ 'origTeam' ] = "#name eq listGetAt(teamList,teamIndex)#">		
</cfloop>

<style>
	#draftTbl {
		border:1px solid black;
		border-width:1px 0 0 1px;
		float:left;
	}
	#draftTbl TD {
		border:1px solid black;
		border-width:0 1px 1px 0;
		width:30px;
		height:30px;
		font:bold 18px arial;
	}
	.traded {
		background-color:#80FF00;
	}
	#summaryArea,#summaryArea2 {
		width:160px;
		float:left;
	}
	.teamSummaryDiv {
		font: 12px arial;
		width:150px;
		float:left;
		margin:0 0 15px;
	}
	.teamname {
		font:bold 18px arial;
	}
	.myDiv {
		color:#900;
	}
	.lmk {
		background-color:silver;
	}
	.posblock {
		width:45px;
		float:left;
	}
	.otc {
		background-color:yellow;
	}
</style>

<link type="text/css" rel="stylesheet" href="/css/jquery-ui-1.8.16.custom.css">
<script language="javascript" src="/scripts/jquery-1.4.2.min.js"></script>
<script language="javascript" src="/scripts/jquery-ui-1.8.16.custom.min.js"></script>
<script language="javascript">
	$().ready( function() {
		$('#teamDetailDialog').dialog({
			autoOpen	: false,
			modal		: true	
		})
		
		$('.teamname').click( function() {
			$('#teamDetailDialog').html('');
			that = $(this);
			console.log(that.text());
			$.ajax({
				url		: '/2012/cfc/data.cfc',
				data	: {
					method 		: 'getRosters',
					showheader 	: false,
					json 		: 1,
					teamID 		: that.attr('tmID')			
				},
				success	: function(r) {
					aTeam = eval( "(" + r + ")" );		
					for(var i = 0;i<aTeam.length;i++) {
						$('#teamDetailDialog').html( $('#teamDetailDialog').html() + '<li>' + aTeam[i] + '</li>'  )												
					}	
					$('#teamDetailDialog').dialog('option','title',that.text());
					$('#teamDetailDialog').dialog('open');
				}	
			})	
		})
	})
</script>

<cfoutput>
	
	<div id="summaryArea">
	<cfloop query="qTeams" startrow="1" endrow="8">
		<cfif qTeams.teamID eq qOnTheClock.teamID>
			<cfset cls = "teamSummaryDiv otc">
		<cfelse>
			<cfset cls = "teamSummaryDiv">
		</cfif>
		<div class="#cls#<cfif teamID eq 1> lmk</cfif>">
			<span tmID="#teamID#" class="teamname<cfif qTeams.divID eq 3> myDiv</cfif>">#draftSlot#) #abbv#<cfif qTeams.teamID eq qOnTheClock.teamID><cfif qOnTheClock.round mod 2 eq 0><img src="/2012/images/up_arrow.png"><cfelse><img src="/2012/images/down_arrow.png"></cfif></cfif></span><br />
			<div class="posblock">QB: #sPosBreakdown[qTeams.teamID]['QB']#</div>
			<div class="posblock">RB: #sPosBreakdown[qTeams.teamID]['RB']#</div>
			<div class="posblock">WR: #sPosBreakdown[qTeams.teamID]['WR']#</div>
			<div class="posblock">TE: #sPosBreakdown[qTeams.teamID]['TE']#</div>
			<div class="posblock">K: #sPosBreakdown[qTeams.teamID]['K']#</div>
			<div class="posblock">D: #sPosBreakdown[qTeams.teamID]['D']#</div>
		</div>
	</cfloop>
	</div>
	
	<div id="summaryArea2">
	<cfloop query="qTeams" startrow="9" endrow="16">
		<cfif qTeams.teamID eq qOnTheClock.teamID>
			<cfset cls = "teamSummaryDiv otc">
		<cfelse>
			<cfset cls = "teamSummaryDiv">
		</cfif>
		<div class="#cls#<cfif teamID eq 1> lmk</cfif>">
			<span tmID="#teamID#" class="teamname<cfif qTeams.divID eq 3> myDiv</cfif>">#draftSlot#) #abbv#</span><br />
			<div class="posblock">QB: #sPosBreakdown[qTeams.teamID]['QB']#</div>
			<div class="posblock">RB: #sPosBreakdown[qTeams.teamID]['RB']#</div>
			<div class="posblock">WR: #sPosBreakdown[qTeams.teamID]['WR']#</div>
			<div class="posblock">TE: #sPosBreakdown[qTeams.teamID]['TE']#</div>
			<div class="posblock">K: #sPosBreakdown[qTeams.teamID]['K']#</div>
			<div class="posblock">D: #sPosBreakdown[qTeams.teamID]['D']#</div>
		</div>
	</cfloop>
	</div>
	
	<table id="draftTbl" cellspacing="0">
		<cfloop from=1 to=16 index="r">
		<tr>
			<td style="width:140px;">
				#listGetAt(teamList,r)#
			</td>
			<cfloop from=1 to=16 index="s">
				<cfif s mod 2 eq 0>
					<cfset roundPos = 17 - r>
				<cfelse>
					<cfset roundPos = r>
				</cfif>
				<td <cfif NOT arrOrder[ s ][ roundPos ][ 'origTeam' ]> class="traded"</cfif>>#arrOrder[ s ][ roundPos ][ 'pos' ]#</td>
			</cfloop>
		</tr>
		</cfloop>
		</cfoutput>
	</table>

<div id="teamDetailDialog"></div>