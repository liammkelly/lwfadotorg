<script language="javascript" src="/scripts/jquery-1.4.2.min.js"></script>
<script language="javascript" src="/2012/_scripts/jquery.form.js"></script>
<script language="javascript">
	var teamID;

	$().ready( function() {
		$('#saveBtn').click( function() {
			$('#lineupForm').ajaxSubmit();
		})
		
		$('#lineupTeam').change( function() {
			teamID = $(this).val();
			$('#lineupArea').html('');
			$.ajax({
				url: 		'cfc/admin.cfc',
				type:		'POST',
				data:		{
					teamID: teamID,
					method: 'getPlayers'	
				},
				error:		function(e) {
					alert('An error occurred'); 
					console.log(e)
				},
				success:	function(data) {
					jsonData = eval( "(" + data + ")");
					$.each( jsonData, function(idx,obj) {
						$('<input name="lineupBox" type="checkbox"/>')
							.val(obj.PLAYERID)
							.attr('checked',obj.ACTIVE)
							.appendTo($('#lineupArea'));
						$('#lineupArea').append(obj.NAME + "<br/>");
					})
					$('#saveBtn').show();
					$('input[name=teamID]').val(teamID)
				}
			})
		})
	})
</script>
<style>
	#lineupArea {
		background-color:#F6FBCF;
		width:220px;
		height:355px;
	}
	#saveBtn {
		display:none;
	}
</style>

<cfinvoke component="2012.cfc.core" method="getTeams" returnvariable="qTeams" />

<cfoutput>
<select id="lineupTeam">
	<option>- choose -</option>
	<cfloop query="qTeams">
		<option value="#teamID#">#name#</option>	
	</cfloop>
</select>
</cfoutput>

<button id="saveBtn">SAVE</button>

<form action="/2012/cfc/core.cfc" method="post" id="lineupForm">
<div id="lineupArea"></div>
<input type="hidden" name="teamID" value="">
<input type="hidden" name="method" value="saveLineup">
</form>