<script src="/scripts/jquery-1.4.2.min.js" language="javascript"></script>
<script>
$().ready( function() {
	$('#submitBtn').click( function() {
		$('div#loadingDiv').show();
		$.ajax({
			url: 		'act_dropPlayer.cfm',
			type:		'GET',
			data: 	{
				dropID:$('#playerDrop').val(),
				activateID:$('#playerActivate').val()				
			},
			success:	function() {
				parent.window.location.reload();			
			}
		})
	})
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
	}
</style>

<cfquery name="qClaimTeam"  datasource="lwfa">
	select	*
	from		players	
	where	teamID=#cookie.teamID# 
	order by last
</cfquery>

<cfset injFound = 0>
<h2>Player to drop:</h2>
<select id="playerDrop" size="<cfoutput>#qClaimTeam.recordcount#</cfoutput>" style="width:190px;" multiple="false">
<cfoutput query="qClaimTeam">
	 <cfif inj eq 'Y'> 
		<cfset injFound = 1>
	</cfif> 
	<option value="#playerID#">#last#, #first# (#pos# - #nflteam#)</option> 
 </cfoutput>
</select>

<cfif injFound>
	<h2>Player to activate:</h2>
	<select id="playerActivate" size="2" style="width:190px;">
	<cfoutput query="qClaimTeam">
		<cfif inj eq 'Y'>
			<option value="#playerID#">#last#, #first# (#pos# - #nflteam#)</option> 
		</cfif>
	</cfoutput>
	</select>
</cfif>

<input type="button" id="submitBtn" value="SUBMIT" class="submitBtn">

<div id="loadingDiv">
<img src="images/loading.gif" align="absmiddle"> <b>Processing...</b>
</div>