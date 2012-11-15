<!--- <script src="_scripts/jquery-1.2.3.pack.js" language="javascript"></script> --->
<script>
$().ready( function() {
	$('input#submitBtn').click( function() {
		$('div#loadingDiv').show();
		$.get('act_claimPlayer.cfm',{
				deactivate:$('input#deactivate').attr('checked'),
				dropID:$('select#playerDrop').val(),
				addID:$('input#playerAdd').val()
			},
			function(data) {
			$('#claimPlayerDiv').dialog('close');
		})
	})
	$('#submitBtn').button();
})
</script>
<style>
	* {
		font-family:verdana;
	}
	div#loadingDiv {
		display:none;
		margin:20px 0 0 40px;
	}
	h2 {
		font:bold 18px verdana;
	}
	.submitBtn {
		font:bold 11px verdana;
		background-color:silver;
		border:1px solid black;
		border-width:1px 2px 2px 1px;
		padding:3px 0;
		margin-left:30px;
	}
</style>

<cfquery name="qClaimTeam"  datasource="lwfa">
	select		pd.total,p.*
	from			players	p
					left join playerdata pd on (p.playerID=pd.playerID AND pd.weekNo=#application.currwk# AND pd.active='Y')
	where		(p.teamID=#cookie.teamID# OR p.playerID=#url.playerID#)
	order by 	view,last
</cfquery>

<cfset DLcount = 0>

<h2>Player to be claimed:</h2>
<cfoutput query="qClaimTeam">
	<cfif teamID neq cookie.teamID>
		<cfif fileExists(expandPath('images/players/#playerID#.jpg'))>
			<img src="/2012/images/players/#playerID#.jpg" align="absmiddle" width=50 height=60>
		<cfelse>
			<img src="/2012/images/players/unknown.jpg" align="absmiddle" width=50 height=60>
		</cfif>
		#pos# #first# #last#, #nflteam#<P>
	<cfelseif inj eq 'Y'>
		<cfset DLcount++>
	</cfif>
</cfoutput>
<h2>Player to drop:</h2>
<select id="playerDrop" >
<cfif qClaimTeam.recordcount lt 17><option value="">-no player-</option></cfif>	
<cfoutput query="qClaimTeam"> 
	<cfif teamID eq cookie.teamID>
	<option value="#playerID#"<cfif isNumeric(total)> disabled="disabled"</cfif>>#last#, #first# (#pos# - #nflteam#)</option> 
	</cfif>
</cfoutput>
</select>
<cfif ((month(now()) eq 9 And day(now()) gt 10) or (month(now()) gt 9)) AND DLcount lt 2>
<p/><input type="checkbox" name="deactivate" id="deactivate" value=1> place on D.L.
</cfif>

<input type="hidden" id="playerAdd" value="<cfoutput>#url.playerID#</cfoutput>">

<input type="button" id="submitBtn" value="SUBMIT" class="submitBtn">

<div id="loadingDiv">
<img src="images/loading.gif" align="absmiddle"> <b>Submitting claim...</b>
</div>