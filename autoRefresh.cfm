
<!--- <cfif NOT isdefined('cf_ajax_initialized')>
	<cf_ajax use="jquery">
</cfif> --->

<cfobject component="cfc.listLib" name="listLib">

<cfparam name="autoRefreshInterval" 	default="0">
<cfparam name="attributes.showDoc" 		default="0">
<cfparam name="attributes.scope" 		default="url">
<cfparam name="attributes.seconds" 		default="2,5,10,20,30,60">
<cfparam name="attributes.minutes" 		default="2,5,10,15,30,45">
<cfparam name="attributes.hours"   		default="1,2,3">
<cfparam name="attributes.progressBlocks" default="20">
<cfparam name="attributes.buttonClass" 	default="smallButton">

<cfset multiplier['seconds'] 	= 1>
<cfset multiplier['minutes'] 	= 60>
<cfset multiplier['hours'] 		= 3600>

<style>
#progressBarContainer{margin:10px;}
#progressBarConfig {background-color:white;border:gray 1px solid;padding:5px; width:120px;z-index:10;}
#progressBarTable {border:gray 1px solid;margin:0 auto;}
.progressBlockIncomplete{background-color:white;}
.progressBlockComplete {background-color:gray;}
.smallButton{
	background:Gray;
	color:white;
	font-size:10px;
	font-weight:bold;
	padding:0px 6px 0px 6px;
	margin:0px 2px 4px 2px;
	border:black 1px solid;
	font-family:verdana;
	letter-spacing:0.2em;
	text-transform:uppercase;
	cursor:pointer;
}

.smallButton:Hover{
	background:silver;
	color:black;
}
/*div.progressBarDivBlock{float:left;}*/

</style>

<!--- DOCS --->
<cfif attributes.showDoc>
	<cfcontent reset="yes">
	<h1>cf_autoRefresh</h1>
	<h3>Attributes</h3>
	<table>
		<tr><td align="right"><strong>scope</strong> :</td><td>"Form" or "URL" - defaults to URL</td></tr>
		<tr><td align="right"><strong>seconds</strong> :</td><td>comma delimited list of refresh options for seconds</td></tr>
		<tr><td align="right"><strong>minutes</strong> :</td><td>comma delimited list of refresh options for minutes</td></tr>
		<tr><td align="right"><strong>hours</strong> :</td><td>comma delimited list of refresh options for hours</td></tr>
		<tr><td align="right"><strong>progressBlocks</strong> :</td><td>number of progress increments to display - defaults to 20</td></tr>
		<tr><td align="right"><strong>buttonClass</strong> :</td><td>class name of action buttons</td></tr>
	</table>	
	<cfabort>
</cfif>



<cfset autoRefreshInterval = val(autoRefreshInterval)>
<cfset progressInterval    = autoRefreshInterval / attributes.progressBlocks * 1000>
<cfset urlRefresh 		   = "#cgi.SCRIPT_NAME#?#listLib.deleteFromList(cgi.QUERY_STRING,'autoRefreshInterval','&')#">
<cfset formRefresh 		   = "#cgi.SCRIPT_NAME#">

<script>
	<cfoutput>
	var progressBlockIntervalID = 0;
	var progressBlocks = #attributes.progressBlocks#;
	var autoRefreshInterval = #autoRefreshInterval#;
	var urlRefresh = '#urlRefresh#';
	</cfoutput>
	
	
	$(document).ready(function(){
		$('#progressBarConfig').hide();
		
		if (autoRefreshInterval > 0){
			beginRefresh(autoRefreshInterval);
			showStopButton();
			}
		else {	
			showStartButton();
			$('#progressBarTable').hide();
			$('#progressBarStopButton').hide();
			}
	});		
	
	
	function autoRefresh(t){
		<cfif attributes.scope eq "url">
			location.href= urlRefresh + '&autoRefreshInterval='+ t;
		<cfelse>
			$('#progressBarHiddenForm').submit();
		</cfif>
	}

	function showStartButton(){
		if ($('#progressBarStartButton').length == 0){
			var myButton = $('<input type="button"/>');
			myButton.attr({
				id:'progressBarStartButton',
				class:'<cfoutput>#attributes.buttonClass#</cfoutput>',
				value:"Auto-Refresh",
				onClick:"configRefresh()"
			});
			$('#progressBarButtonContainer').append(myButton);
			
		}
		$('#progressBarStartButton').show();
		
	}
	function showStopButton(){
		if ($('#progressBarStopButton').length == 0){
			var myButton = $('<input type="button"/>');
			myButton.attr({
				id:'progressBarStopButton',
				class:'<cfoutput>#attributes.buttonClass#</cfoutput>',
				value:"Stop",
				onClick:"clearRefresh()"
			});
			$('#progressBarButtonContainer').append(myButton);
			
		}
		$('#progressBarStopButton').show();	

	}

	function configRefresh(){
		var position = $('#progressBarStartButton').offset();
		if ($('#progressBarConfig').length == 0){
			var a = $('<div />');
			a.attr('id','progressBarConfig');
			a.css({top:position.top,left:position.left,display:'hidden',position:'absolute',textAlign:'right'});
			a.append('<strong>Auto Refresh</strong> <br>[ <a href="javascript:void(0);" onClick="$(\'#progressBarConfig\').hide();">Cancel</a> ]<br>');
			<cfoutput>
			<cfloop list="Seconds,Minutes,Hours" index="ttype">
				<cfloop list="#attributes[ttype]#" index="m">
					a.append('<div style="margin:4px;"><a href="javascript:void(0);" onClick="beginRefresh(#round(m*multiplier[ttype])#)">#m# #tType#</a></div>');
				</cfloop>
			</cfloop>
			</cfoutput>		
			$('#progressBarContainer').append(a);
		}
		
		$('#progressBarConfig').show();

		
		//$('#progressBarConfig').show();
	}

	function clearRefresh(){
		clearInterval(progressBlockIntervalID);
		$('td.progressBlock').removeClass('progressBlockComplete');
		$('td.progressBlock').addClass('progressBlockIncomplete');
		$('#progressBarTable').hide();
		$('#progressBarStopButton').hide();
		showStartButton();
	}
	
	function beginRefresh(t){
		$('#progressBarStartButton').hide();
		$('#progressBarConfig').hide();
		<cfif attributes.scope eq "form">
			$('#progressBarHiddenFormAutoRefresh').val(t)
		</cfif>
		
		$('#progressBarTable').show();
		showStopButton();
		progressBlockInterval = t * 1000 / progressBlocks  ;
		progressBlockIntervalID = setInterval('makeProgress('+t+')',progressBlockInterval);	
	}

	function makeProgress(t){
		var pb = $('td.progressBlockIncomplete:first');
		if(pb.length > 0){
			pb.addClass('progressBlockComplete');
			pb.removeClass('progressBlockIncomplete');
			}
		else{
			clearInterval(progressBlockIntervalID);
			autoRefresh(t);
		}

	}
</script>

<div id="progressBarContainer" class="progressBarDivBlock">
	<cfoutput>
 	
	<!--- PROGRESS BAR --->
	<div class="progressBarDivBlock">
		<table id="progressBarTable" cellpadding="0" cellspacing="1">
			<tr>
				<cfloop from="1" to="#attributes.progressBlocks#" index="pb">
					<td class="progressBlock progressBlockIncomplete" id="#pb#">&nbsp;</td>				
				</cfloop>
			</tr>
		</table>		
		
		<cfif attributes.scope eq "form">
			<div style="display:hidden;">
			<form id="progressBarHiddenForm" action="#formRefresh#" method="post">
				<input type="hidden" id="progressBarHiddenFormAutoRefresh" name="autoRefreshInterval" value="#autoRefreshInterval#" />
				<cfloop collection="#form#" item="field">
					<cfif NOT listFindNoCase("autoRefreshInterval,FieldNames",field)>
						<input type="hidden" name="#field#" value="#form[field]#" />
					</cfif>
				</cfloop>
			</form>
			</div>
		</cfif>
		
		
	</div>
	
	<!--- BUTTONS --->
	<div id="progressBarButtonContainer" class="progressBarDivBlock"></div>
	</cfoutput>
</div>
<br clear="all">



