<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>LWFA2012</title>
	<link rel="SHORTCUT ICON" href="/2012/images/lwfa_favicon.ico"/>
	<script language="javascript" src="/scripts/jquery-1.4.2.min.js"></script>
	<script language="javascript" src="/scripts/jQueryUI/jquery-ui-LWFA-2012.js"></script>
	<link type="text/css" rel="stylesheet" href="/scripts/jQueryUI/css/jquery-ui-LWFA-2012.css">
	<link type="text/css" rel="stylesheet" href="/scripts/jQueryUI/css/jquery.autocomplete.css">
	<link type="text/css" rel="stylesheet" href="/scripts/jQueryUI/css/thickbox.css">
	<script language="javascript" src="/2012/js/functions.js"></script>
	<script language="javascript" src="/scripts/jQueryUI/ui.thickbox.js"></script>
	<script language="javascript" src="/scripts/jQueryUI/jquery.autocomplete.js"></script>
	<script language="javascript" type="text/javascript">
		jQuery().ready( function() {	
			jQuery('#loginButton').click( function() {
				var myUN = jQuery('#uname').val();
				var myPW = jQuery('#pword').val();
				jQuery.get('/2012/act_login.cfm?showheader=false',{uname:myUN,pword:myPW},function(data) {
					jQuery('div#loginArea').html(data);
				})
			})
			
			jQuery('.plyrTeamLnk').click( function(e) {
				window.location = '/2012/teampage.cfm?teamID=' + jQuery(this).attr('teamID');
				e.preventDefault();
			})
			
			//jQuery('#toolsArea').dialog({autoOpen:false,title:'LWFA.org Tools',modal:true}).load('/2012/tools.cfm');
			jQuery('#toolsLnk').toggle( function() {
				jQuery('#toolsDiv').slideDown()
			}, function() {
				jQuery('#toolsDiv').slideUp()
			})
			
			jQuery('#input_search_all').autocomplete(
				'/2012/act_searchPlayers.cfm?showheader=false', { 
					minChars:4,
					width:200,
					matchContains:1,
					maxItemsToShow:10,
 					formatItem:formatItem,
					onItemSelect:selectItem
			});
			jQuery('#input_search_all').focus( function() {
				var text = jQuery(this).val();
			})
		})
	</script>
	<link type="text/css" rel="stylesheet" href="/2012/css/core.css">
	<link type="text/css" rel="stylesheet" href="/scripts/jQueryUI/css/jquery.autocomplete.css">
	<cftry>
		<cfset sTeams = deserializeJson( application.cfc.functions.getTeams() )>
		<cfcatch><cflocation url="http://www.lwfa.org/2012/?refresh=1"></cfcatch>
	</cftry>
	<cfif structKeyExists(cookie,'teamID')>
		<cfif structKeyExists(cookie,'lastLoginDate')>
			<cfset LOCAL.lastLoginDate = cookie.lastLoginDate>
		<cfelse>
			<cfset LOCAL.lastLoginDate = createDate(2012,1,1)>		
		</cfif>
		<cfquery name="qQuery" datasource="lwfa">
			SELECT		max(change_date) "changeDate"
			FROM		tradeblock
		</cfquery>
		<cfif qQuery.recordcount>
			<cfif qQuery.changeDate GT LOCAL.lastLoginDate>
				<cfset LOCAL.newTradeBlock = 1>
			<cfelse>
				<cfset LOCAL.newTradeBlock = 0>
			</cfif>
		<cfelse>
			<cfset LOCAL.newTradeBlock = 0>
		</cfif>
		<cfcookie name = "lastLoginDate" value = "#Now()#" expires = "never">  
	</cfif>
</head>
<body>
<div id="orderArea"></div>
<div id="main">
	<div id="header">
		<a href="/2012/"><div style="width:360px;height:72px;float:left;">&nbsp;</div></a>
		<div id="loginArea"><cfinclude template="/2012/login.cfm"></div>
	</div>
	<div id="contentArea">
		<!--- <div class="outerTbl1" style="height:426px;width:163px;float:left;clear:none;margin-right:10px;"> --->
			<!--- <div class="outerTbl2" style="height:424px;width:161px;"> --->
			<div id="leftCol" class="column" style="width:161px;border:3px double #000;">
				<div id="playerSearchDiv">
					<input type="hidden" id="search_all_value" name="search_value">
					<ul>			
					<li><input type="text" size="19" name="search_txt" id="input_search_all" class="search_txt"></li>
					<!--- <li><input type="submit" class="searchBtnOK" value="Ok"></li> --->
					</ul>
				</div>	
				<a HREF="/2012/points.cfm">leaderboard</a>
				<a HREF="/2012/top25.cfm">the top 25<!---  <span class="ui-icon ui-icon-notice"></span> ---></a>
				<a HREF="/2012/weekMVP.cfm">week mvp</a>
				<a HREF="/2012/standings.cfm">standings</a>
				<a HREF="/2012/rosters.cfm">rosters</a>
				<a HREF="/2012/players.cfm">players</a>
				<a HREF="javascript:;" id="toolsLnk">tools</a>
				<div id="toolsDiv" style="font:11px arial;display:none;">
					<P><a HREF="/2012/overview.cfm" style="font:11px arial;"> &raquo; Team Stats</a></p>
					<P><A href="/2012/draftResults.cfm" style="font:11px arial;"> &raquo; Draft Results</A></P>
					<P><A href="/2012/nflScheduleGrid.cfm" style="font:11px arial;"> &raquo; NFL Schedule Grid</A></P>
					<P><A href="/2012/charter.cfm" style="font:11px arial;"> &raquo; League Rules</A></P>
					<P><A href="/2012/tiebreak.cfm" style="font:11px arial;"> &raquo; Playoff Tiebreakers</A></P>
					<P><A href="/2012/playoffs.cfm" style="font:11px arial;"> &raquo; Playoff Picture</A></P>
					<P><A href="/2012/keepers.cfm" style="font:11px arial;"> &raquo; <cfoutput>#year(now())+1#</cfoutput> Keeper Status</A></P>
					<P><A href="/2012/tiebreakGrid.cfm" style="font:11px arial;"> &raquo; Compare Tiebreakers</A></P>
				</div>
				<a HREF="/2012/history.cfm">owner records</a>
				<a HREF="/2012/schedule.cfm">schedule</a>
				<a HREF="/2012/transactions.cfm">transactions</a>
				<a HREF="/2012/tradeblock.cfm">trade block<cfif structKeyExists(cookie,'teamID') AND LOCAL.newTradeBlock> <span class="ui-icon ui-icon-notice"></span></cfif></a>
				<div id="teamsListing">
					<table cellpadding="0" cellspacing="0" id="teamsTbl">
						<tr>
						<cfoutput>
							<cfloop from=1 to="#arraylen( sTeams['records'] )#" index="tmIdx">
								<cfif tmIdx neq 1 AND tmIdx mod 2 eq 1>
								</tr><tr>
								</cfif>
								<td>
								<a HREF="/2012/teampage.cfm?teamID=#sTeams['records'][ tmIdx ]['teamID']#">#lcase( sTeams['records'][ tmIdx ]['abbv'] )#</a>			
								</td>
							</cfloop>
						</cfoutput>
						</tr>
					</table>
				</div>
			<!--- </div></div> --->
		</div>
		<div id="middleCol" class="column">