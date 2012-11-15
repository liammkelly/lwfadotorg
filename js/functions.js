$().ready( function() {
	$('#postCommentBox').dialog({
		autoOpen	: false
		, title		: 'Post Comment'
		, modal		: true
		, height	: 400
		, width		: 400
		, buttons	: {
		    "Cancel": function() {
                $('#postCommentBox').dialog('close');    		        
		    }
			, "Post": function() {
                $.ajax({
                    url         : '/2012/cfc/ajax.cfc'
                    , data      : $('#postCommentForm').serialize()
                    , success   : function(r) {
                        $('#postCommentBox').dialog('close');    
                        if( window.location.href.match(/\index.cfm/) || !window.location.href.match(/\.cfm/) ) {
                            window.location.reload();
                        }
                    } 
                })  
			}
		}
	})
})

function getUrlVars() {
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

function formatItem(row) {
		if( row[3] > 0) {
		tm = row[4]
	} 
	else {
		tm = "&nbsp;"
	}
	playerItem = "<div class='playerLinkArea'>" + tm + "</div><img height='36' width='30' align='absmiddle' src='/2012/images/players/" + row[2] + "' /> "+ row[0];
	return playerItem; 
}

function getPlayer(block) {
	var newPlayer = '';
	var playerLink,playerItem;
	$.get('act_playerLookup.cfm',{dataBlock:block},function(data) {
		newPlayer = $.trim(data);
	})
	return newPlayer;
}

function getPlayerID(block) {
	var pID,x;
	x = block.indexOf('.');
	pID = block.substr(0,x);
	return pID;
}	

function selectItem(row) {
	var player = $('#input_search_all').val();
	window.location = 'playerpage.cfm?playerID='+row.extra[0];
}

function deleteComment(postID) {
    $.ajax({
        url     : 'cfc/ajax.cfc'
        , data  : {
            method      : 'deletePost'
            , postID    : postID
        }
        , success   : function(r) {
            if( window.location.href.match(/\index.cfm/) || !window.location.href.match(/\.cfm/) ) {
                window.location.reload();
            }
        } 
    })  
}

function postComment(type,typeID) {
	var subject = arguments[2];
	switch(type) {
		case 'team':
			subject = arguments[2];
			break;
		default:
			break;
	}
	if( subject === '') {
		$('#postCommentSubjectArea').height(0);
		$('#postCommentArea').height(230);
	} else {
		$('#postCommentSubjectArea').height(70);
		$('#postCommentArea').height(160);
	}
	$('#postCommentSubject').html(subject);
    $('#postCommentArea').val('');
    $('#postType').val(type);
    $('#postTypeID').val(typeID);
	$('#postCommentBox').dialog('open');	
}
