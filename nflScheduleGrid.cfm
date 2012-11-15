<cfquery name="qSchedule" datasource="lwfa">
	SELECT		distinct nflteam
	FROM		players
	WHERE		nflteam <> 'FA'
	ORDER BY nflteam
</cfquery>


<style>
	#skedGridTbl {
		border:1px solid black;
		border-width: 1px 0 0 1px;
		background-color:white;
	}
	#skedGridTbl TD {
		font:12px arial;
		border:1px solid black;
		border-width: 0 1px 1px 0;
		padding:1px 0;
		text-align:center;
	}
	.byeweek {
		background-color:yellow;
		font-style:italic;
	}
	.teamname {
		color:white;
		background-color:black;
	}
	.selectedGridRow {
		background-color:#FCDBB6;
	}
</style>
<script language="javascript" type="text/javascript">
	$().ready( function() {
		var xPos;
		var yPos;
		$('#skedGridTbl TD').hover( function() {
			xPos = $(this).attr('x');
			yPos = $(this).attr('y');
			$('TD[x='+xPos+']').addClass('selectedGridRow');
			$('TD[y='+yPos+']').addClass('selectedGridRow');
		}, function() {
			$('TD[x='+xPos+']').removeClass('selectedGridRow');
			$('TD[y='+yPos+']').removeClass('selectedGridRow');
		})
	})
</script>

<cfoutput>

	<table cellspacing="0" id="skedGridTbl">
		<tr>
			<td class="teamname">Team</td>
			<cfloop from=1 to=16 index="r">
			<td class="teamname">#r#</td>
			</cfloop>
		</tr>
	<cfloop query="qSchedule">
		<cfquery name="qTeamSchedule" datasource="lwfa">
			SELECT		*
			FROM		nflschedule
			WHERE		nfltm = '#qSchedule.nflteam#' AND weekno < 17
			ORDER BY	weekno
		</cfquery>
		<tr>
		<td class="teamname">#nflteam#</td>
		<cfloop query="qTeamSchedule">
			<td<cfif opp is "bye"> class="byeweek"</cfif> y="#qTeamSchedule.currentrow#" x="#qSchedule.currentrow#">#opp#</td>
		</cfloop>
		</tr>
	</cfloop>
	</table>
	
</cfoutput>

