<cfparam name="pos" default="QB">
<cfparam name="playerID" default="0">
<cfparam name="playersList" default="1">

<cfswitch expression="#pos#">
	<cfcase value="QB"><cfset sorter = 'passyds'></cfcase>
	<cfcase value="RB"><cfset sorter = 'rushyds'></cfcase>
	<cfcase value="WR"><cfset sorter = 'recyds'></cfcase>
	<cfcase value="TE"><cfset sorter = 'recyds'></cfcase>
	<cfcase value="K"><cfset sorter = 'fg'></cfcase>
	<cfcase value="D"><cfset sorter = 'sack'></cfcase>
</cfswitch>

<!--- <script language="javascript" src="/scripts/jquery.jqGrid-4.1.2/js/i18n/grid.locale-en.js"></script>
<script language="javascript" src="/scripts/jquery.jqGrid-4.1.2/js/jquery.jqGrid.min.js"></script>
<script language="javascript" src="/scripts/jquery.jqGrid-4.1.2/src/grid.common.js"></script>
<script language="javascript" src="/scripts/jquery.jqGrid-4.1.2/src/grid.formedit.js"></script>
<script language="javascript" src="/scripts/jquery.jqGrid-4.1.2/src/grid.subgrid.js"></script> --->

<script src="/scripts/jQuery/jquery.layout.js" type="text/javascript"></script>
<script src="/scripts/jQuery/jquery.jqGrid-4.4.0/grid.locale-en.js" type="text/javascript"></script>
<script type="text/javascript">
	$.jgrid.no_legacy_api = true;
	$.jgrid.useJSON = true;
</script>
<script src="/scripts/jQuery/jquery.jqGrid-4.4.0/ui.multiselect.js" type="text/javascript"></script>
<script src="/scripts/jQuery/jquery.jqGrid-4.4.0/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="/scripts/jQuery/jquery.jqGrid-4.4.0/jquery.tablednd.js" type="text/javascript"></script>
<script src="/scripts/jQuery/jquery.jqGrid-4.4.0/jquery.contextmenu.js" type="text/javascript"></script>


<link rel="stylesheet" type="text/css" href="/scripts/jQuery/jquery.jqGrid-4.4.0/css/ui.jqgrid.css" />

<style>
	body {
		font-size:10px;
	}
</style>
<script language="javascript">
	$().ready( function() {
		var selRow;
		var mygrid = jQuery("#players").jqGrid({        
		   	url			: 'cfc/ajax.cfc?method=getPlayersJSON&showheader=false',
			datatype	: 'json',
			mtype		: 'POST',
			colNames	: [  'playerID','First','Last','Pos', 'NFLTm', 'Team', 'RecentPPG', 'RecentRk','SeasonPPG', 'SeasonRk' ], 
		   	colModel	: [ 
		   		//{name:'links',index:'links', width:18, search:false, sortable:false}, 
		   		{name:'playerid',index:'playerid', hidden:true}, 
		   		{name:'first',index:'first', width:60}, 
		   		{name:'last',index:'last', width:75}, 
		   		{name:'pos',index:'pos', width:45, stype:'select', editoptions: {value:":All;QB:QB;RB:RB;WR:WR;TE:TE;K:K;D:D"}}, 
		   		{name:'nflteam',index:'nflteam', width:45, stype:'select', editoptions: {value:":All;ARI:ARI;ATL:ATL;BAL:BAL;BUF:BUF;CAR:CAR;CHI:CHI;CIN:CIN;CLE:CLE;DAL:DAL;DEN:DEN;DET:DET;GB:GB;HOU:HOU;IND:IND;JAC:JAC;KC:KC;MIA:MIA;MIN:MIN;NE:NE;NO:NO;NYG:NYG;NYJ:NYJ;OAK:OAK;PHI:PHI;PIT:PIT;SD:SD;SEA:SEA;SF:SF;STL:STL;TB:TB;TEN:TEN;WAS:WAS"}}, 
		   		{name:'name',index:'name', width:100, stype:'select', editoptions: {value:":All;FA:FA;owned:owned;Archer:Archer;Bangkok:Bangkok;Chicago:Chicago;Cleveland:Cleveland;Gilead:Gilead;Iowa:Iowa;Ironto:Ironto;Johannesburg:Johannesburg;Lowell:Lowell;Mass:Mass;Natick:Natick;San Fernando:San Fernando;Seaside Heights:Seaside Heights;Sin City:Sin City;Watertown:Watertown;Winter Hill:Winter Hill;"}}, 
				{name:'recentppg',index:'recentppg', width:65, search:false, align:'center'}, 
				{name:'recentrank',index:'recentrank', width:65, search:false, align:'center'}, 
				{name:'seasonppg',index:'seasonppg', width:65, search:false, align:'center'}, 
				{name:'seasonrank',index:'seasonrank', width:65, search:false, align:'center'}
		   	],
			width		: 700,
			height		: 440,
		   	sortname	: 'recentPPG',
		    sortorder	: "desc",
		   	pager		: '#playerPgr',
			rowNum		: 20,
		   	rowList		: [20,50,100],
		    caption		: "LWFA Player Index",
		    viewrecords	: true,
		   	onSelectRow	: function(id) {
		   		selRow = id;
				var thisRowData2 = mygrid.jqGrid('getRowData', selRow );
				console.info( thisRowData2 );
		   	}, 
			afterInsertRow: function(rowid, aData) {
                if (jQuery('#ct-' + rowid).html == 0 || jQuery('#ct-' + rowid).html == '') {
                	console.log(rowid);
                    jQuery('#' + rowid + ' td:eq(0)').unbind();
                    jQuery('#' + rowid + ' td:eq(0)').html('&nbsp;');
                }
           	},
			subGrid		: true,
			subGridUrl	: 'cfc/data.cfc?method=getPlayerGamelog&showheader=false',
			subGridModel: [{ 
				name	: ['Week','Total','Line'],
				width	: [30,50,565],
				params	: ['playerid'],
				align	: ['center','center','left']
			}]
   		});
   		
		jQuery("#players").jqGrid('navGrid','#playerPgr',
			{edit:false,add:false,del:false,refresh:false},
			{},
			{},
			{},
			{multipleSearch:true, multipleGroup:true}
		);
		
		mygrid.jqGrid('navButtonAdd',"#playerPgr",{caption:"Clear",title:"Clear Search",buttonicon :'ui-icon-refresh',
			onClickButton:function(){
				mygrid[0].clearToolbar()
			} 
		});
		
		<cfif structKeyExists(cookie,'teamID')>
		mygrid.jqGrid('navButtonAdd',"#playerPgr",{caption:"Claim Selected Player",title:"Claim Selected Player",buttonicon :'ui-icon-plusthick',
			onClickButton:function(){
				var thisRowData = mygrid.jqGrid('getRowData', selRow );
				if (thisRowData.name != 'FA') {
					console.warn( 'This player is already on a team.' );				
				}
				else {
					jQuery('#playerBox').load('dsp_claimPlayer.cfm?playerID=' + thisRowData.playerid).dialog({title:"Claim Player",modal:true}).dialog('open');
				}
			} 
		});
		</cfif>

		mygrid.jqGrid('filterToolbar',{stringResult: true,searchOnEnter: false});

		jQuery('#submitBtn').live("click", function() {
			jQuery('#playerBox').dialog('close');
			jQuery('#alertBox').fadeIn(1500).fadeOut(3000);
		})
		
		console.log(mygrid)
		
	})
</script>

<table id="players" class="scroll" cellpadding="0" cellspacing="0"></table>
<div id="playerPgr" class="scroll" style="text-align:center;"></div>


<div id="alertBox" class="ui-state-highlight">
Your claim has been submitted.
</div>

<div id="playerBox"></div>
<div id="playerClaim"></div>

<!--- 

			   	colNames:[  'PLAYERID','FULLNAME','ASSTACK', 'DEFINT', 'DEFINTYDS', 'FF', 'FG', 'FPPG', 'FR', 'FRTD', 'FUMBLE', 'GAMES', 'HISTEAMID', 'INTTD', 'KRTD', 'KRYDS', 'LASTUPDWEEK', 'LFG', 'LWFATEAM', 'NFLTEAM', 'NFLTEAM', 'PASS2PC', 'PASSINT', 'PASSTD', 'PASSYDS', 'PRTD', 'PRYDS', 'REC2PC', 'RECENTFP', 'RECENTPPG', 'RECENTRANK', 'RECTD', 'RECYDS', 'RUSH2PC', 'RUSHTD', 'RUSHYDS', 'SACK', 'SEASONFP', 'SEASONPPG', 'SEASONRANK', 'SFG', 'TACKLE', 'XP' ], 
			   	colModel:[ 
			   		{name:'PLAYERID',index:'PLAYERID', hidden:'true'}, 
			   		{name:'FULLNAME',index:'FULLNAME', width:100}, 
			   		{name:'ASSTACK',index:'ASSTACK', width:100}, 
			   		{name:'DEFINT',index:'DEFINT', width:100}, 
			   		{name:'DEFINTYDS',index:'DEFINTYDS', width:100}, 
			   		{name:'FF',index:'FF', width:100}, 
			   		{name:'FG',index:'FG', width:100}, 
			   		{name:'FPPG',index:'FPPG', width:100}, 
			   		{name:'FR',index:'FR', width:100}, 
			   		{name:'FRTD',index:'FRTD', width:100}, 
			   		{name:'FUMBLE',index:'FUMBLE', width:100}, 
			   		{name:'GAMES',index:'GAMES', width:100}, 
			   		{name:'HISTEAMID',index:'HISTEAMID', width:100}, 
			   		{name:'INTTD',index:'INTTD', width:100}, 
			   		{name:'KRTD',index:'KRTD', width:100}, 
			   		{name:'KRYDS',index:'KRYDS', width:100}, 
			   		{name:'LASTUPDWEEK',index:'LASTUPDWEEK', width:100}, 
			   		{name:'LFG',index:'LFG', width:100}, 
			   		{name:'LWFATEAM',index:'LWFATEAM', width:100}, 
			   		{name:'NFLTEAM',index:'NFLTEAM', width:100}, 
			   		{name:'PASS2PC',index:'PASS2PC', width:100}, 
			   		{name:'PASSINT',index:'PASSINT', width:100}, 
			   		{name:'PASSTD',index:'PASSTD', width:100}, 
			   		{name:'PASSYDS',index:'PASSYDS', width:100}, 
			   		{name:'POS',index:'POS', width:100}, 
					{name:'PRTD',index:'PRTD', width:100}, 
					{name:'PRYDS',index:'PRYDS', width:100}, 
					{name:'REC2PC',index:'REC2PC', width:100}, 
					{name:'RECENTFP',index:'RECENTFP', width:100}, 
					{name:'RECENTPPG',index:'RECENTPPG', width:100}, 
					{name:'RECENTRANK',index:'RECENTRANK', width:100}, 
					{name:'RECTD',index:'RECTD', width:100}, 
					{name:'RECYDS',index:'RECYDS', width:100}, 
					{name:'RUSH2PC',index:'RUSH2PC', width:100}, 
					{name:'RUSHTD',index:'RUSHTD', width:100}, 
					{name:'RUSHYDS',index:'RUSHYDS', width:100}, 
					{name:'SACK',index:'SACK', width:100}, 
					{name:'SEASONFP',index:'SEASONFP', width:100}, 
					{name:'SEASONPPG',index:'SEASONPPG', width:100}, 
					{name:'SEASONRANK',index:'SEASONRANK', width:100}, 
					{name:'SFG',index:'SFG', width:100}, 
					{name:'TACKLE',index:'TACKLE', width:100}, 
					{name:'XP',index:'XP', width:100} 
			   	],
,
			subGrid: true,
			subGridUrl: 'cfc/ajax.cfc?method=getPlayerData',
			subGridModel: [{ 
				name: ['stats'],
				width: [400],
				params: ['playerid'] 
			}]

 --->
 
