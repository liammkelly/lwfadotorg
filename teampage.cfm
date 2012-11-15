<cfparam name="url.teamID" default="0">
<cfif url.teamID gt 0>
	<cfset thisTeamID = url.teamID>
<cfelse>
	<cfif structKeyExists(cookie,'teamID')>
		<cfset thisTeamID = cookie.teamID>
	<cfelse>
		<cflocation url="index.cfm">
	</cfif>
</cfif>

<cfquery name="qTeam" datasource="lwfa">
	select 	t.name "team",t.nickname,t.abbv,t.coach,
				group_concat(distinct u.fullname SEPARATOR ' / ') "owner",u.email,
				s.win,s.loss
	from 	teams t join users u using (teamID) join standings s using (teamID)
	where 	t.teamID=#thisTeamID#
	group by t.name,t.nickname
</cfquery>
<cfquery name="qOffers" datasource="lwfa">
	SELECT		NULL
	FROM		trades
	WHERE		teamID = #thisTeamID# AND
					statusID = 1 AND
					offerTeam = 0
</cfquery>
<cfquery name="qCoaches" datasource="#application.dsn#">
	SELECT 		*
	FROM		coaches
	WHERE		teamID = #thisTeamID#
				<cfif structKeyExists(cookie,'teamID') AND thisTeamID eq cookie.teamID>
				OR teamID IS NULL
				</cfif>
	ORDER BY 	teamID desc, name
</cfquery>

<link rel="stylesheet" type="text/css" href="css/teampage.css" />
<script language="javascript" src="/scripts/jQuery/jquery.BBQ.js"></script>
<script language="javascript" src="js/trade_offer.js"></script>
<cfif structKeyExists(cookie,'teamID')>
	<script>
		var myTeamID = <cfoutput>#cookie.teamID#</cfoutput>, offerTeamID;
		var thisTeamID = parseInt( getUrlVars()['teamID'] );
		
		<cfif url.teamID eq 0>
			thisTeamID = <cfoutput>#cookie.teamID#;</cfoutput>		
		</cfif>
		
		function returnToPending() {
			jQuery('#TB_iframeContent').attr('src','dsp_pending.cfm');
		}
	
		jQuery().ready( function() {
		
			jQuery('#changeCoachBtn').click( function() {
				$('#coachArea').hide();
				$('#coachCombo').show();
			})	

			jQuery('#coachCombo').change( function() {
				var newCoachID = $(this).val();
				if( confirm('Are you sure you want to change coaches?') ) {
					$('#coachName').html( jQuery('#coachCombo option:selected').text() );
					$.ajax({
						url		: 'cfc/ajax.cfc'
						, data	: {
							method		: 'changeCoach'
							, teamID	: thisTeamID
							, coachID	: newCoachID
						}	
						, success : function() {
							$('#coachArea').show();
							$('#coachCombo').hide();							
						} 
					})
				} else {
					$('#coachCombo').val(0);
					$('#coachArea').show();
					$('#coachCombo').hide();							
				}	
			})
		
			jQuery('#headCoachField').focus( function() {
				console.log( myTeamID );
				console.log( thisTeamID );
				if( myTeamID !== thisTeamID ) {
					$(this).blur();
				}
			})

			var isCoachEdited = 0;
			jQuery('#headCoachField').keyup( function() {
				isCoachEdited = 1;
			})

			jQuery('#headCoachField').blur( function() {
				if( isCoachEdited ) {
					jQuery.ajax({
						url			: 'cfc/ajax.cfc'
						, data		: {
							method 		: 'changeCoach'
							, showheader : false
							, name		: $(this).val()
						}
						, success	: function() {
							jQuery('#moveSuccessDialog').dialog('open');
							window.setTimeout(function() {
							    jQuery('#moveSuccessDialog').dialog('close');
							}, 1500);
						}
					})
				}
			})
		
			jQuery('select.statusSect').change( function() {
				jQuery('#lineupSubmitBtn').css({fontWeight:'bold',color:'990000',padding:0});
			});

			jQuery('#moveErrorDialog').dialog({
				autoOpen:false,
				modal:true,
				width:300,
				title:'Error!'
			})
			
			jQuery('#moveSuccessDialog').dialog({
				autoOpen:false,
				modal:true,
				width:200,
				title:'Success!'
			})
			
			jQuery('#tradeBlockDialog').dialog({
				autoOpen:false,
				modal:true,
				width:520,
				title:'Update Your Trade Block'
			})
			
			jQuery('#toggleScheduleBtn').toggle( function() {
				$('#scheduleDiv').show();
				$('#lineupDiv').hide();	
				$('#currview').html('Lineup');	
			}, function() {
				$('#scheduleDiv').hide();
				$('#lineupDiv').show();								
				$('#currview').html('Schedule');	
			})

			jQuery('#tradeBlockBtn').click( function() {
				jQuery('#tradeBlockDialog').dialog('open');
			})
			
			jQuery('#saveTradeBlockBtn').click( function() {
				var tradeBlockObj = jQuery('#tradeBlockForm').serialize();
				jQuery.ajax({
					url:	 		'/2012/cfc/ajax.cfc?method=saveTradeBlock',
					method:	'post',
					data:			tradeBlockObj
				})
				jQuery('#tradeBlockDialog').dialog('close');
			})
			
			jQuery('#lineupSubmitBtn').click( function() {
				var thisTm = <cfoutput>#thisTeamID#</cfoutput>;
				var lineup = jQuery('form#lineupForm').serialize();
				jQuery.get('act_verifyLineup.cfm',{
						playerList:lineup,updTeamID:thisTm
					}, function(data) {
						response = jQuery.trim(data);
						if(response.length > 0) {
	 						jQuery('#alertBox').html(response).fadeIn('fast').animate({opacity: 1.0}, 3000).fadeOut('slow')
						}
						else {
							window.location=window.location;
						}
					}
				)
			})
			jQuery('img.activateBtn').click( function() {
				var playerToActivate = jQuery(this).attr('id');
				jQuery.get('act_activation.cfm',{playerID:playerToActivate},function(data) {
					var b = jQuery.trim(data);
					if(b=='') {
						window.location=window.location;
					}
					else {  	
						jQuery('#alertBox').html(b).fadeIn('fast').animate({opacity: 1.0}, 3000).fadeOut('slow')
					}
				})
			})

			jQuery('.lineupBtn').live('click', function() {
				// set active status of selected player
			    active = jQuery(this).attr('active');

				// set pos of selected player
			    pos = jQuery(this).attr('pos');

				// set injury status of selected player
				inj = 0;
				if(jQuery(this).hasClass('DL')) {
					inj = 1;
				}

				availablePos = (active == 'Y') ? getAvailablePos(pos) : pos;
				movePlayerA = jQuery(this).attr('playerID');
				movePlayerBPos = (jQuery('button').index(this) * 1) + 1;
				if(active == 'Y') {
					jQuery('.benchRow').show();
					jQuery('#benchRowBtn').attr('pos',pos);
				}
	
				jQuery(this).removeClass('lineupBtn').addClass('activelineupBtn');
			    jQuery('.lineupBtn').each( function(a,b) {
			        if( jQuery(this).hasClass('lineupBtn') ) {
					    var targetpos = jQuery(this).attr('pos');
					    var targetactive = jQuery(this).attr('active');
						if (inj > 0) {
							if ( targetactive == 'N') {
								jQuery(this).removeClass('lineupBtn').addClass('activelineupBtn');
							}		        	
							else {
								jQuery(this).removeClass('lineupBtn').addClass('lockedlineupBtn');
							}
						}
						else {
							if ( availablePos.indexOf(targetpos) >= 0 && active != targetactive  && jQuery(this).hasClass('DL') == false ) {
								jQuery(this).removeClass('lineupBtn').addClass('activelineupBtn');
							}		        	
							else {
								jQuery(this).removeClass('lineupBtn').addClass('lockedlineupBtn');
								if( jQuery(this).hasClass('DL') == true ) {
									jQuery(this).css({'color':'black'})
								}
							}
						}
			        }
			    })
				
				disableInactive();
			
				return false;
			})
			jQuery('.activelineupBtn').live('click', function() {
			    active2 = jQuery(this).attr('active');
			    pos2 = jQuery(this).attr('pos');
				movePlayerB = jQuery(this).attr('playerID');
				movePlayerAPos = (jQuery('button').index(this) * 1) + 1;
		
				if(movePlayerAPos > movePlayerBPos) {
					activated = movePlayerB;
					benched = movePlayerA;
					activateIndex = movePlayerBPos;
					benchIndex = movePlayerAPos;
				}
				else {
					activated = movePlayerA;
					benched = movePlayerB;
					activateIndex = movePlayerAPos;
					benchIndex = movePlayerBPos;
				}
				if(activated != benched) {
	
					jQuery('#teamTbl TR').eq(activateIndex).after(jQuery('TR[id='+activated+']'));
					if(benched > 0) { 
						jQuery('#teamTbl TR').eq(benchIndex).after(jQuery('TR[id='+benched+']'));
					}
					else {
						jQuery('TR[id='+benched+']').remove();
					}
					if( inj > 0 ) {
						jQuery('TR[id='+benched+']').addClass('inj');
						jQuery('TR[id='+activated+']').removeClass('inj');
						jQuery('TR[id='+benched+'] TD:first-child').html('<img src="images/red_cross.jpg" />');
						jQuery('TR[id='+activated+'] TD:first-child').html('BN');
						jQuery('button[playerID='+benched+']').attr('active','N').addClass('DL');		
						jQuery('button[playerID='+activated+']').attr('active','N').removeClass('DL');
					}
					else {
						jQuery('TR[id='+benched+'] TD:first-child').html('BN');
						jQuery('TR[id='+activated+'] TD:first-child').html(jQuery('button[playerID='+activated+']').attr('pos'));
						jQuery('button[playerID='+benched+']').attr('active','N');		
						jQuery('button[playerID='+activated+']').attr('active','Y');
					}
					jQuery.ajax({
						url			: '/2012/cfc/ajax.cfc',
						type		: 'POST',
						data		: {
							active:activated,
							inactive:benched,
							inj:inj,
							method:'alterLineup'
						},
						error		: function() {
							jQuery('#moveErrorDialog').dialog('open');
						}
						<cfif NOT listFind(application.lLineupConfimOptOut,cookie.teamID)> 
						,success		: function() {
							jQuery('#moveSuccessDialog').dialog('open');
							window.setTimeout(function() {
							    jQuery('#moveSuccessDialog').dialog('close');
							}, 1500);
						}
						</cfif>
					})
				}
	
				jQuery('button').each( function(a,b) {
					if(jQuery(this).attr('locked') != 'YES') {
						jQuery(this).removeClass('lockedlineupBtn').addClass('lineupBtn');
					}
				})							
				disableInactive();
	
				if(movePlayerB < 1) {
					window.location.reload();
				}
				else {
					jQuery('.benchRow').hide();
				}
	
				return false;
			})
			
			function disableInactive() {
				jQuery('.lockedlineupBtn').attr('disabled',true);
				jQuery('.lineupBtn').attr('disabled',false);
			}
			
			function getAvailablePos(pos) {
			    var rbCount = 0;
			    var wrCount = 0;
			    var teCount = 0;
			    if(pos == 'QB' || pos == 'K' || pos == 'D') {
			    	return pos;
			    }
			    else {
			    	jQuery('.lineupBtn').each( function(a,b) {
						if(jQuery(this).attr('active') == 'Y') {
							if(jQuery(this).attr('pos') == 'RB') { rbCount++ }
							if(jQuery(this).attr('pos') == 'WR') { wrCount++ }
							if(jQuery(this).attr('pos') == 'TE') { teCount++ }
						}
					})			
					if(pos == 'RB') {
						if(wrCount == 3) {
							availablePos = 'RB';
						}
						else if(teCount == 2) {
							availablePos = 'RB';
						}
						else {
							availablePos = 'RB,WR,TE';					
						}
					}
					else if(pos == 'WR') {
						if(rbCount == 2) {
							availablePos = 'WR';
						}
						else if(teCount == 2) {
							availablePos = 'WR';
						}
						else {
							availablePos = 'RB,WR,TE';					
						}
					}
					else if(pos == 'TE') {
						if(rbCount == 2) {
							availablePos = 'TE';
						}
						else if(wrCount == 3) {
							availablePos = 'TE';
						}
						else {
							availablePos = 'RB,WR,TE';					
						}
					}
					return availablePos;
				}
			}
		})
	</script>
</cfif>

<div id="teamPageDiv">

<cfoutput>
<table cellspacing=0 id="teamHeaderTbl">
	<tr>
		<td rowspan=2 id="helmet"><img src="/2012/images/helmets/#application.aAbbv[thisTeamID]#.gif" width="116" height="94"></td>
		<th colspan=2 class="lastcell">#qTeam.team# #qTeam.nickname# (#qTeam.win#-#qTeam.loss#)</th>
	</tr>
	<tr>
		<td id="owner">OWNER: <A href="mailto:#qTeam.email#" style="color:##000">#qTeam.owner#</A></td>
		<td id="coach" class="lastcell">
			<div style="float:left;">COACH:</div> 
			<cfif structKeyExists(cookie,'teamID') AND thisTeamID eq cookie.teamID>
				<div id="coachArea">
					<span id="coachName"><cfif isNumeric(qCoaches.teamID)>#qCoaches.name#<cfelse>None</cfif></span> <A href="javascript:;" id="changeCoachBtn"><img src="/2012/images/edit_task.png" border=0></A>
				</div>
				<select id="coachCombo" style="display:none;">
					<cfloop query="qCoaches">
						<option value="#coachID#"<cfif qCoaches.teamID eq thisTeamID> SELECTED</cfif>>#name#</option>
					</cfloop>
				</select>
			<cfelse>
				<span id="coachName">#qCoaches.name#</span>
			</cfif>
		</td>
	</tr>
	<tr>
		<td colspan=3>
			<table cellspacing=0 id="teamActionTbl">
				<tr>
					<td class="teamaction"><A href="javascript:;" id="tradeBlockBtn">Trade block</A></td>
					<td class="teamaction"><A href="javascript:;" id="proposeTradeBtn">Propose trade</A></td>
					<td class="teamaction"><A href="dsp_pending.cfm?width=600&height=300&KeepThis=true&TB_iframe=true&inlineId=myOnPageContent" class="thickbox" id="pendingMovesBtn"<cfif qOffers.recordcount> style="color:##990000;font-weight:bold;"</cfif>>Pending moves</A></td>
					<td class="teamaction"><A href="dsp_dropPlayer.cfm?width=300&height=400&KeepThis=true&TB_iframe=true&inlineId=myOnPageContent" class="thickbox" id="dropPlayerBtn">Drop player</A></td>
					<td class="teamaction"><A href="javascript:;" id="toggleScheduleBtn"><span id="currview">Schedule</span></A></td>
					<td class="teamaction" style="width:10%"><img src="/2012/images/icon_post.png" onclick="postComment('team',#thisTeamID#,'#qTeam.team# #qTeam.nickname#')" style="cursor:pointer;"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfoutput>


<div id="mainTeamDiv">
	<div id="lineupDiv">
		<cfinclude template="dsp_lineup_new.cfm">
	</div>
	<div id="scheduleDiv" style="display:none;">
		<cfinclude template="dsp_team_schedule.cfm">
	</div>
	<div id="timeDiv">
		<cfset currentTimeDate = createTime( hour(now())+1,minute(now()),second(now()) )>
		Current LWFA Time: <cfoutput>#timeformat(currentTimeDate,'h:mm:ss tt')#</cfoutput>
	</div>
</div>

<div id="alertBox"></div>

</div>

<cfif structKeyExists(cookie,'teamID')>
	<cfquery name="qTeam" datasource="lwfa">
		select p.*,t.name,t.nickname from players p join teams t on p.teamID=t.teamID where p.teamID = #cookie.teamID# AND inj = 'N' order by p.view
	</cfquery>
	<cfquery name="qTradeTeam" datasource="lwfa">
		select p.*,t.name,t.nickname from players p join teams t on p.teamID=t.teamID where p.teamID <> #cookie.teamID# AND inj = 'N' order by t.name,p.view
	</cfquery>
	
	<cfset teamID = cookie.teamID>
	<cfset tradeTeamID = qTradeTeam.teamID[1]>
	
	<div id="tradeDialog">
		<cfoutput>
		<div id="confirmDiv">
			RECEIVE
			<div id="toPlayersArea"></div>
			FOR
			<div id="fromPlayersArea"></div>
			<P><span id="cutPlayersText">and you will waive</span>
			<div id="cutPlayersArea"></div>
			<button id="makeOfferBtn">Submit Offer</button>
		</div>
		<div class="teamDiv">
			<div class="teamDivHeader">
				<div class="teamDivHeaderName">
					<h4>#qTeam.name#</h4>
				</div>
				<div class="confirmHeader">
					<h4>Choose <span id="count"></span> to drop</h4>
				</div>
			</div>
			<select  name="from" class="playerSelect" multiple="true" size="16">
			<cfloop query="qTeam">
			<option value="#playerID#">#first# #last#, #pos# - #nflteam#</option>
			</cfloop>
			</select>
			<div id="fromPlayers"></div>
		</div>
		<cfloop query="qTradeTeam">
			<cfif qTradeTeam.currentrow eq 1 OR qTradeTeam.teamID[currentrow] neq qTradeTeam.teamID[currentrow-1]>
			<div id="tradeTeam#teamID#Div" teamID="#teamID#" class="tradeTeamDiv"<cfif structKeyExists(url,'teamID')><cfif qTradeTeam.teamID[currentrow] eq url.teamID> style="display:block;"</cfif><cfelseif currentrow eq 1> style="display:block;"</cfif>>
			<div class="teamDivHeader">
				<div class="teamDivHeaderName">
					<h4>#name#</h4>
				</div>
			</div>
			<select  name="to" class="playerSelect" multiple="true" size="16">
			</cfif>
			<option value="#playerID#">#first# #last#, #pos# - #nflteam#</option>
			<cfif qTradeTeam.currentrow eq qTradeTeam.recordcount OR qTradeTeam.teamID[currentrow] neq qTradeTeam.teamID[currentrow+1]>
			</select>
			<cfif teamID eq tradeTeamID><div id="toPlayers"></div></cfif>
			</div>
			</cfif>
		</cfloop>
		</cfoutput>
		<div id="buttonsDiv">	
			<A name="prev" class="tradeBtn" href="javascript:;" id="prevTeam">[ prev ]</A><br />
			<A name="submit" class="tradeBtn" href="javascript:;" id="offerLnk">Make Offer</A><br />
			<A name="next" class="tradeBtn" href="javascript:;" id="nextTeam">[ next ]</A>
			<A name="submit" class="tradeBtn" href="javascript:;" id="offerConfirmLnk">Make Offer</A><br />	
			<A name="submit" class="tradeBtn" href="javascript:;" id="waiveConfirmLnk">Confirm</A><br />	
		</div>
	</div>
	
	<cfif thisTeamID eq cookie.teamID>
		<div id="moveErrorDialog" style="display:none;">
			<img src="/2012/images/error.png" style="float:left;">Lineup NOT updated<br />Please contact the <A style="color:#900;text-decoration:underline;" href="mailto:liammkelly@gmail.com?subject=LWFA - Lineup problem">commissioner</a>
		</div>
		
		<div id="moveSuccessDialog" style="display:none;">
			<img src="/2012/images/checkmark.gif"><br />Lineup updated
		</div>
		
		<div id="tradeBlockDialog" style="display:none;">
			<cfinclude template="dsp_tradeBlock.cfm">
		</div>
	</cfif>
</cfif>