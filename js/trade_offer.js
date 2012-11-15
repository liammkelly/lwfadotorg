	var movePlayerA,movePlayerB,availablePos,active,pos,flex,inj;
	var givePlayers,getPlayers,prevTradeTm,diffCt,tradeTeamID;
	var toPlayers = [], fromPlayers = [],toPlayerNames = [], fromPlayerNames = [], cutPlayers = [],cutPlayerNames = [];
	var currentTradeTm = 0;

	function changeTeam() {
		$('.tradeTeamDiv').hide();
		$('.tradeTeamDiv').eq(currentTradeTm).show();
		prevTradeTm = currentTradeTm;
	}

	function resetTradeForm() {
		$('.tradeTeamDiv').hide();
		$('.teamDiv').hide();
		$('#confirmDiv').hide();
		$('#buttonsDiv').show();
		$('#buttonsDiv').css({'margin-top':50});
		$('#buttonsDiv A').show();
		$('#offerConfirmLnk').hide();			
		$('#waiveConfirmLnk').hide();			
		$('.confirmHeader').hide();
		$('.teamDivHeaderName').show();
		toPlayers = [];
		fromPlayers = [];
		toPlayerNames = [];
		fromPlayerNames = [];
		cutPlayers = [];
		cutPlayerNames = [];	
		currentTradeTm = 0;
		$('.playerSelect option:selected').attr('selected',false).attr('disabled',false);
		$('#toPlayersArea').html('');
		$('#fromPlayersArea').html('');
		$('#cutPlayersArea').html('');
	}

	function confirmOffer() {
		$('.tradeTeamDiv').hide();
		$('.teamDiv').hide();
		$.each( toPlayerNames, function(idx,value) {
			$('#toPlayersArea').html( $('#toPlayersArea').html() + value + "<br>" );			
		})
		$.each( fromPlayerNames, function(idx,value) {
			$('#fromPlayersArea').html( $('#fromPlayersArea').html() + value + "<br>" );			
		})
		if(cutPlayers.length > 0) {
			$.each( cutPlayerNames, function(idx,value) {
				$('#cutPlayersArea').html( $('#cutPlayersArea').html() + value + "<br>" );			
			})		
			$('#cutPlayersText').show();
		}
		else {
			$('#cutPlayersText').hide();
		}
		$('#buttonsDiv').hide();
		$('#confirmDiv').show();
	}
	
	$().ready( function() {
		
		$('#offerLnk').click( function() {
			$('.tradeTeamDiv').hide();
			tradeTeamID = $('.tradeTeamDiv:eq('+currentTradeTm+')').attr('teamID');
			$('.tradeTeamDiv:eq('+currentTradeTm+') .playerSelect option:selected').each( function() {
				toPlayers[ toPlayers.length ] = $(this).val();
				toPlayerNames[ toPlayerNames.length ] = $(this).text();
			})
			$('#buttonsDiv A').hide();
			$('#offerConfirmLnk').show();			
			$('#buttonsDiv').css({'margin-top':95});
			$('.teamDiv').show("slide", { direction: "up" }, 1000);		
		})
	
		$('#offerConfirmLnk').click( function() {
			$('.teamDiv .playerSelect option:selected').each( function() {
				fromPlayers[ fromPlayers.length ] = $(this).val();
				fromPlayerNames[ fromPlayerNames.length ] = $(this).text();
				$(this).attr('disabled',true);
			})
			diffCt = toPlayers.length - fromPlayers.length;
			if(toPlayers.length > fromPlayers.length) {
				$('.teamDiv .teamDivHeaderName').hide();
				$('.confirmHeader').show();
				$('#count').html(diffCt);
				$('#buttonsDiv A').hide();
				$('#waiveConfirmLnk').show();			
				$('.teamDiv .playerSelect option:selected').attr('selected',false);
			}
			else {
				confirmOffer();
			}	
		})
	
		$('#waiveConfirmLnk').click( function() {
			if($('.teamDiv .playerSelect option:selected').length == diffCt) {
				$('.teamDiv .playerSelect option:selected').each( function() {
					cutPlayers[ cutPlayers.length ] = $(this).val();
					cutPlayerNames[ cutPlayerNames.length ] = $(this).text();
				})
				confirmOffer();
			}
		})
		
		$('#makeOfferBtn').click( function() {
			$.ajax({
				url: 	'/2012/cfc/ajax.cfc',
				type:	'POST',
				data:	{
					toTeamID:tradeTeamID,
					toPlayerList:toPlayers.join(','),
					fromPlayerList:fromPlayers.join(','),
					cutPlayerList:cutPlayers.join(','),
					method:'proposeTrade'
				}
			})
			$('#tradeDialog').dialog('close');
			resetTradeForm();			
			$('.tradeTeamDiv').eq(0).show();
		})
	
		$('#proposeTradeBtn').click( function() {
            if( 1 === 1 ) {
                alert('Sorry, the trade deadline has passed.')
            } else {
    			$('#tradeDialog').dialog('open');
    			resetTradeForm();
    			if( $.param.querystring() != '') {
    				offerTeamID = $.param.querystring().split('&')[0].split('=')[1];			
    				$('.tradeTeamDiv[teamID='+offerTeamID+']').show();			
    				currentTradeTm = $('.tradeTeamDiv[teamID='+offerTeamID+']').index() - 2;
    			}
    			else {
    				$('.tradeTeamDiv').eq(0).show();
    			}
			}
		})

		$('#nextTeam').click( function() {
			prevTradeTm=currentTradeTm;
			currentTradeTm += 1;
			if(currentTradeTm == $('.tradeTeamDiv').length) currentTradeTm = 0;
			changeTeam();		
		})
		$('#prevTeam').click( function() {
			prevTradeTm=currentTradeTm;
			currentTradeTm -= 1;
			if(currentTradeTm < 0) currentTradeTm = $('.tradeTeamDiv').length-1;
			changeTeam();		
		})
	
		$('#tradeDialog').dialog({
			autoOpen: false,
			modal: true,
			title: 'Propose Trade',
			resizable: false,
			width:440,
			close: function() {
				resetTradeForm();
			}
		})
	})
	