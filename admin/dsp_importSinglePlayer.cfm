<script language="javascript"  type="text/javascript" src="/scripts/jquery-1.2.3.pack.js"></script>
<link type="text/css" rel="stylesheet" href="/scripts/jQueryUI/css/jquery.autocomplete.css">
<script language="javascript" src="/scripts/jQueryUI/jquery.autocomplete.js"></script>
<script type="text/javascript" language="javascript">
	$().ready( function() {
		$('input#updPlayer').autocomplete(
		'/2012/act_searchPlayers.cfm', { 
			minChars:4,
			width:150,
			matchContains:1,
			maxItemsToShow:10
		});
		$('#importBtn').click( function() {
			if(confirm("Are you sure you want to re-import data for "+$('#updPlayer').val())) {
				$.ajax({
					type:		"POST",
					url:		"/2012/admin/cfc/admin.cfc",
					data:		{
						method:'reimportPlayer',
						playerName:$('#updPlayer').val()
					},
					success:	function(data) {
						$('#resultsDiv').html(data);
					}
				})
			}
		})
	});
</script>	

Player: <input type="text" size="24" name="updPlayer" id="updPlayer">
<button id="importBtn">Re-import Stats</button>
<div id="resultsDiv"></div>