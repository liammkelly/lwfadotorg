<cfif structKeyExists(form,'update') AND form.update eq 1>
	<cfloop from=1 to=256 index="r">
		<!--- <cfquery datasource="lwfa">
			UPDATE 	players
			SET			teamID = 0
		</cfquery> --->
		<cfif form['selection_'&r] neq ''>
			<cfquery datasource="lwfa">
				UPDATE 	draft d, players p
				SET		 	d.playerID=p.playerID
				where		d.overallPos = #r# AND
								p.last = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(listgetAt(form['selection_'&r],1))#"> AND
								p.first = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(listgetAt(form['selection_'&r],2))#">
			</cfquery>
			<cfquery datasource="lwfa">
				UPDATE 	players p
				SET			teamID = #form['team_'&r]#,active='Y'
				WHERE		p.last = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(listgetAt(form['selection_'&r],1))#"> AND
								p.first = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(listgetAt(form['selection_'&r],2))#">
			</cfquery>			
		</cfif>
	</cfloop>
	<cfabort>
</cfif>

<cfquery datasource="lwfa" name="qDraftSpots">
	select 	d.*,p.first,p.last,t.name "lwfaTeam",d.teamID 
	from 	draft d 
				join teams t on d.teamID=t.teamID 
				left join players p on d.playerID=p.playerID
</cfquery>

<script language="javascript"  type="text/javascript" src="/scripts/jquery-1.4.2.min.js"></script>
<link type="text/css" rel="stylesheet" href="/scripts/jQueryUI/css/jquery.autocomplete.css">
<script language="javascript" src="/scripts/jQueryUI/jquery.autocomplete.js"></script>
<script language="javascript" src="/scripts/jQueryUI/jquery.form.js"></script>
<script type="text/javascript" language="javascript">
	function selectItem(row) {
		var player = $('input#updPlayer').val();
		window.location = 'dsp_admin_player.cfm?playerName='+player;
	}
	$().ready( function() {
	    var blocksave = 0;
	    
	    $(".savingDiv").bind("ajaxStart", function(){
			$(this).show();
		    }).bind("ajaxStop", function(){
			$(this).hide();
	    });
  
   		$('input.choice').autocomplete(
		'/2012/act_searchPlayers.cfm?showheader=false', { 
			minChars:4,
			width:150,
			matchContains:1,
			maxItemsToShow:25/*,
			onItemSelect:selectItem*/
		});

		$('input.choice').keypress(function(event) {
		    if(event.charCode == 115) {
				blocksave = 1;		
		    } 
		})
	
		$().keypress(function(event) {
		    if(event.charCode == 115) {
		    	if (blocksave == 0) {
			        $('#draftForm').trigger('submit');
				}
				blocksave = 0;
		    } 
		})

		$('#draftForm').submit(function() { 
	        // inside event callbacks 'this' is the DOM element so we first 
	        // wrap it in a jQuery object and then invoke ajaxSubmit 
	        $(this).ajaxSubmit(); 
	 
	        // !!! Important !!! 
	        // always return false to prevent standard browser submit and page navigation 
	        return false; 
	    }); 	
	})
</script>
<Style>
	.savingDiv {
		background-color:#900;
		color:white;
		width:90px;
		height:20px;
		display:none;
		float:left;
		font-family:verdana;
	}
</Style>

<form id="draftForm" action="<cfoutput>#cgi.script_name#</cfoutput>" method="post">
<input type="submit" value="Update" id="updateBtn">
<div class="savingDiv">Saving...</div>
<table>
	<tr>
		<th>Overall</th>
		<th>Round/Spot</th>
		<th>Player</th>
	</tr>
<cfoutput query="qDraftSpots">
	<tr>
		<td>#overallPos#</td>
		<td>#round#.#selection#</td>
		<td>
			<input type="text" name="selection_#overallPos#" class="choice" value="<cfif first neq ''>#last#, #first#</cfif>">
			<input type="hidden" name="team_#overallPos#" value="#teamID#">
		</td>
		<td>#lwfaTeam#</td>
	</tr>
</cfoutput>
</table>
<input type="submit" value="Update">
<input type="hidden" name="update" value=1>
</form>