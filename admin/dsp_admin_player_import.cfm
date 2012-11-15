<script language="javascript" src="/scripts/jquery-1.4.2.min.js"></script>
<script language="javascript">
	$().ready( function() {
		$('#importPlayerBtn').click( function() {
			$.ajax({
				url: 		'cfc/admin.cfc',
				type:		'POST',
				data:		{
					playerID: $('#playerID').val(),
					method: 'loadPlayer'	
				},
				error:		function(e) {
					alert('An error occurred'); 
					console.log(e)
				},
				success:	function(data) {
					$('#linkDiv').html(data);
				}
			})
		})
	})
</script>

<input type="text" id="playerID">
<button id="importPlayerBtn">IMPORT</button>

<div id="linkDiv"></div>