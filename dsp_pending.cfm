<cfquery name="qClaims" datasource="lwfa">
	select c.claimID,concat(p.pos,' ',p.first,' ',p.last) as claimed,concat(p2.pos,' ',p2.first,' ',p2.last) as waived,c.deactivate
	from claims c join players p on c.clmid=p.playerID left join players p2 on c.dmpid=p2.playerID
	where c.statusID=1 AND c.teamID=#cookie.teamID#
	order by c.priority
</cfquery>
<cfquery name="qTrades" datasource="lwfa">
	select 	distinct t.tradeID,t.teamID,t2.teamID "targetTeamID",tm.name "targetTeam",tm2.name "offerTeam"
	from		trades t join trades t2 on t.tradeID=t2.tradeID join teams tm on tm.teamID=t2.teamID join teams tm2 on tm2.teamID=t.teamID
	where	(t.teamID=#cookie.teamID# OR
				t2.teamID=#cookie.teamID#) AND 
				t.offerTeam=1 AND 
				t2.offerTeam=0 AND 
				t.teamID <> t2.teamID AND
				t.statusID = 1
</cfquery>

<script src="/scripts/jquery-1.2.3.pack.js" language="javascript"></script>
<link href="/scripts/jQueryUI/css/jQuery.SortList.css" rel="stylesheet" type="text/css" />
<script src="/scripts/jQueryUI/jquery.dimensions.js"></script>
<script src="/scripts/jQueryUI/ui.mouse.js"></script>
<script src="/scripts/jQueryUI/ui.draggable.js"></script>
<script src="/scripts/jQueryUI/ui.droppable.js"></script>
<script src="/scripts/jQueryUI/ui.sortable.js"></script>
<script language="javascript" src="/scripts/jQueryUI/jQuery.SortList.js"></script>
<link type="text/css" rel="stylesheet" href="/scripts/jQueryUI/css/thickbox.css">
<script language="javascript" src="/scripts/jQueryUI/ui.thickbox.js"></script>
<script>
$().ready( function() {
	$('a.cancelLnk').click( function() {
		var $cancelID = $(this).attr('id');
		$.get('act_cancelClaim.cfm',{cancelID:$cancelID},function(data) {
			$('LI#'+$cancelID).hide();
		})
	})
	$('input#submitSort').click( function() {
		var $claims = $('input#itemIds').val();
		$.post('act_reorderClaims.cfm',{neworder:$claims}, function(data) {
			var response = $.trim(data);
			if (response.length > 0)  $('img#sortIcon').attr('src','images/error.gif').show()
			if (response.length == 0)  $('img#sortIcon').attr('src','images/check.gif').show()	
		})
	})
})
</script>
<style>
	span.cancelLnk:hover {
		cursor:pointer;
	}
	B {
		font:bold 12px verdana;
	}
	LI {
		font:11px verdana;
	}
	div#pendingMovesDiv {
		float:left;
	}
	div#claimsDiv,div#tradesDiv {
		float:left;
		clear:none;
		width:280px;
	}
	div#claimsDiv {
		padding:0 15px;
		margin-left:20px;
	}
</style>

<div id="pendingMovesDiv">
	<div id="claimsDiv">
		<b>CLAIMS:</b>
		<OL id="sortableList">
			<cfoutput query="qClaims">
			<LI id="#claimID#" class="sortableItem"><cfif waived neq ''><cfif deactivate gt 0>#claimed# (#waived# to D.L.)<cfelse>#claimed# for #waived#</cfif><cfelse>add #claimed#</cfif> <A href="javascript:;" class="cancelLnk" id="#claimID#">[ x ]</a></LI>
			</cfoutput>
		</OL>
		<cfif qClaims.recordcount>
		<form name="sortForm" method="post" action="act_reorderClaims.cfm">
			<input type="hidden" name="itemIds" id="itemIds" value="" size="20"/>
			<input type="button" name="submitSort" id="submitSort" value="Save Order" />
			<img src="images/spacer.gif" id="sortIcon">
		</form>	
		</cfif>
	</div>
	
	<div id="tradesDiv">
	<b>TRADES:</b>
	<ol>
		<cfoutput query="qTrades">
		<LI id="trade#tradeID#">Offer <cfif targetTeamID eq cookie.teamID>received from <b>#offerTeam#</b><cfelse>made to <b>#targetTeam#</b></cfif> <A href="dsp_offer.cfm?tradeID=#tradeID#" id="#tradeID#">[ details ]</a></LI>
		</cfoutput>	
	</ol>
	</div>
</div>
