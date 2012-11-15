<cfset variables.dir = "ASC">
<cfif month(now()) eq 9 AND day(now()) eq 4>
	<cfset variables.dir = "DESC">
</cfif>

<cfquery name="qDraft" datasource="lwfa">
	SELECT		p.first,p.last,p.pos,p.nflteam,
					dr.*,
					t.name "lwfaTeam"
	FROM		draft dr 
					JOIN players p on dr.playerID=p.playerID
					JOIN teams t on dr.teamID=t.teamID
	order by 	dr.overallPos #variables.dir#
</cfquery>

<cfset leaderTotal = 0>

<link rel="stylesheet" type="text/css" href="css/draft_results.css">
<!---  
<link rel="stylesheet" type="text/css" href="/scripts/ext-4.0.2a/resources/css/ext-all.css" />
<script type="text/javascript" src="/scripts/ext-4.0.2a/bootstrap.js"></script>
<script>
	$().ready( function() {
		$('#viewAvailableLnk')
			.appendTo($('#progressBarButtonContainer'))
			.click( function() {
				showPlayersWin();	
			})
	})
	Ext.onReady( function() {
		showPlayersWin = function() {
			new Ext.Window({
				width : 650,
				height : 400,
				modal : true,
				items : [
					{
						xtype 		: 'grid',
						height		: 370,
						remoteSort 	: true,
						store 		: new Ext.data.Store({
							model		: Ext.define('Player', {
							    extend: 'Ext.data.Model',
							    fields: [
							        {name: 'PLAYERID'	, type: 'int'},
							        {name: 'FIRST'		, type: 'string'},
							        {name: 'LAST'		, type: 'string'},
							        {name: 'POS'		, type: 'string'},
							        {name: 'NFLTEAM'	, type: 'string'}
							    ]
							}),
						    proxy		: {
								type 	: 'ajax',
								url		: 'cfc/data.cfc?method=getAvailablePlayers&showheader=false',						
								reader	: {
									type	: 'json',
								    root	: 'records'
								}							
							},
							storeId		: 'playerStore',
							autoLoad	: true
						}),
						columns 	: [
							{dataIndex:'PLAYERID',hidden:true,hideable:false},
							{dataIndex:'FIRST',header:"First"},
							{dataIndex:'LAST',header:"Last"},
							{dataIndex:'POS',header:"Pos"},
							{dataIndex:'NFLTEAM',header:"NFL"}
						]				
					}
				]		
			}).show()
		}
	})
</script>
--->
<div id="pointsLeaderboardDiv">
<h3>2012 LWFA Draft</h3>
	
<table id="pointsTbl" cellpadding="0" cellspacing="0">
	<caption>
	<cf_autoRefresh scope="url" seconds="1,2,5,10,30,60" minutes="5,15,30" hours="" >
	</caption>
	<tr>
		<th style="width:80px;">Pos</th>
		<th style="width:250px;">Player</th>
		<th style="width:80px;">Team</th>
	</tr>
	<cfoutput query="qDraft">
	<tr<cfif structKeyExists(cookie,'teamID') AND teamID eq cookie.teamID> style="background-color:##878EED;font-weight:bold;"</cfif>>
		<td>#round#.#selection# (#overallPos#)</td>
		<td><A href="teampage.cfm?teamID=#teamID#">#first# #last#, #pos# - #nflteam#</A></td>
		<td>#lwfateam#</td>
	</tr>
	</cfoutput>
</table>
</div>

