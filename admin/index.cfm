<link rel="stylesheet" type="text/css" href="../css/admin.css">
<script type="text/javascript" language="javascript">
	jQuery().ready( function() {
		jQuery('A.adminLink').click( function() {
			jQuery('A.adminLink').css({'backgroundColor':'white','color':'black'});
			jQuery(this).css({'backgroundColor':'#AC7233','color':'white'});
		})
		
		jQuery('.datepicker').datepicker();
		/*
		jQuery('#wkProcLnk').toggle( function() {
			jQuery('#weeklyProcessArea').slideDown()
		},function() {
			jQuery('#weeklyProcessArea').slideUp()
		})
		* */
	})
</script>

<cfif dayofweek(now()) eq 3>
	<cfquery name="qProposal" datasource="#application.dsn#">
		SELECT 		playerID,weekNo
		FROM		stat_import_log
		WHERE		weekNo = #application.currwk#
		ORDER BY	weekNo
	</cfquery>
	<cfquery name="qQuery" datasource="#application.dsn#">
		SELECT		distinct playerID
		FROM		playerstats
	</cfquery>
	<cfset pctProcessed = (qProposal.recordcount / qQuery.recordcount) * 100>
</cfif>

<div id="adminControls">
<a href="javascript:;" target="adminArea" class="adminLink" id="wkProcLnk">Weekly Process<cfif dayofweek(now()) eq 3> <span style="font-size:11px;color:blue">[<cfoutput>#round(pctProcessed)#%</cfoutput>]</span></cfif></a>
<a onclick="return confirm('Are you sure?');" href="act_compileStats.cfm" target="adminArea" class="adminLink"> > compile stats</a>
<a onclick="return confirm('Are you sure?');" href="act_updateScores.cfm" target="adminArea" class="adminLink"> > update scores</a>
<a onclick="return confirm('Are you sure?');" href="standadmin.cfm" target="adminArea" class="adminLink"> > update standings</a>
<a onclick="return confirm('Are you sure?');" href="act_updateWeekMVP.cfm" target="adminArea" class="adminLink"> > update week mvp</a>
<a onclick="return confirm('Are you sure?');" href="act_updateRanks.cfm" target="adminArea" class="adminLink"> > update ranks/ppg</a>
<a onclick="return confirm('Are you sure?');" href="act_advanceWeek.cfm" target="adminArea" class="adminLink"> > advance week</a>
<a href="dsp_admin_player.cfm?playerName=zzz,zzz" target="adminArea" class="adminLink">Add Player</a>
<a href="dsp_admin_statConflicts.cfm" target="adminArea" class="adminLink">Compare stats</a>
<A href="../scoring/liveUpdate.cfm" target="adminArea" class="adminLink">Initiate Live Scoring</A>
<A href="act_playerImport.cfm" target="adminArea" class="adminLink">Import Y! Rosters</A>
<A href="dsp_claims.cfm" target="adminArea" class="adminLink">Manage Claims</A>
<A href="dsp_admin_pending.cfm" target="adminArea" class="adminLink">Manage Trades</A>
<a onclick="return confirm('Are you sure?');" href="act_compilePrevStats.cfm" target="adminArea" class="adminLink">Re-compile stats</a>
<a href="dsp_importSinglePlayer.cfm" target="adminArea" class="adminLink">Re-import player stats</a>
<a href="dsp_admin_player_import.cfm" target="adminArea" class="adminLink">Re-import player</a>
<a href="act_claims_autoupdate.cfm" target="adminArea" class="adminLink" onclick="return confirm('Are you sure?')">Run Claims Process</a>
<A href="dsp_edit_stats.cfm" target="adminArea" class="adminLink">Update Live Stats</A>
<A href="dsp_updateNFLSchedule.cfm" target="adminArea" class="adminLink">Update NFL Schedule</A>
<a href="dsp_admin_player.cfm" target="adminArea" class="adminLink">Update Player</a>
<A href="dsp_updateSchedule.cfm" target="adminArea" class="adminLink">Update Schedule</A>
<A href="dsp_admin_teamweek.cfm" target="adminArea" class="adminLink">Update Team Week</A>
<A href="dsp_admin_lineups.cfm" target="adminArea" class="adminLink">Update Team Lineup</A>
<A href="dsp_admin_order.cfm" target="adminArea" class="adminLink">Update Waivers</A>
<a href="ulogin.cfm" target="adminArea" class="adminLink">Admin Login</a>
</div>

<iframe id="adminArea" name="adminArea" frameborder="0"></iframe>
	