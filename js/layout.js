

/* ************************	*/
/* GLOBAL VARS				*/
/* ************************	*/
// rootPath brings to root of current app directory.
var rootPath = '/2009';

// loadingDiv is a placeholder to be used in instances where loading icon may be useful.
var loadingDiv = $('<div />');
var loadingImg = $('<img />');
loadingDiv.css({"padding":"10px"});
loadingImg.attr({src:rootPath + '/images/loading.gif'});
loadingDiv.append(loadingImg);




/* ************************	*/
/* BEGIN DOCUMENT READY		*/
/* ************************	*/
$(document).ready(function(){

	
/* ************************	*/
/* PRIMARY TAB EVENTS		*/
/* ************************	*/
    $("div.pTab").bind("mouseover", function(e){
      if(!$(this).hasClass('pTabOn')){
	      $(this).removeClass('pTabOff');
	      $(this).addClass('pTabHover');
      }
    });	

    $("div.pTab").bind("mouseout", function(e){
       if(!$(this).hasClass('pTabOn')){
	      $(this).addClass('pTabOff');
	      $(this).removeClass('pTabHover');
       }   
    });		

    $("div.pTab").bind("click", function(e){
		var params = 'pTab=' + $(this).attr('id');
		var src = $(this).attr('src');
		navRelocate(src,params);
    });		
	
	
/* ************************	*/
/* SECONDARY TAB EVENTS		*/
/* ************************	*/
    $("div.sTab").bind("mouseover", function(e){
      if(!$(this).hasClass('sTabOn')){
	      $(this).removeClass('sTabOff');
	      $(this).addClass('sTabHover');
      }
    });	

    $("div.sTab").bind("mouseout", function(e){
       if(!$(this).hasClass('sTabOn')){
	      $(this).addClass('sTabOff');
	      $(this).removeClass('sTabHover');
       }   
    });		

    $("div.sTab").bind("click", function(e){
			var params = 'sTab=' + $(this).attr('id');
			var src = $(this).attr('src');
			navRelocate(src,params);
    });		
	
	
/* ************************	*/
/* TERTIARY TAB EVENTS		*/
/* ************************	*/	
    $("div.tTab").bind("mouseover", function(e){
      if(!$(this).hasClass('tTabOn')){
	      $(this).removeClass('tTabOff');
	      $(this).addClass('tTabHover');
      }
    });	

    $("div.tTab").bind("mouseout", function(e){
       if(!$(this).hasClass('tTabOn')){
	      $(this).addClass('tTabOff');
	      $(this).removeClass('tTabHover');
       }   
    });	
    
    $("div.tTab").bind("click", function(e){
      	//action only if tTab isn't already selected.
		if (!$(this).hasClass("tTabOn")) {

			var params = 'tTab=' + $(this).attr('id');
			
			// ajax the panel or relocate?
			if ($(this).attr('ajaxSrc')) {
				select_tTab($(this).attr('id'));
				navRelocateAjax($(this).attr('ajaxSrc'), params);
			}
			else 
				if ($(this).attr('src')) {
					navRelocate($(this).attr('src'), params);
				}
		}
      
    });	


/* ************************	*/
/* QUATERNARY TAB EVENTS	*/
/* ************************	*/
    $("div.qTab").bind("mouseover", function(e){
      if(!$(this).hasClass('qTabOn')){
	      $(this).removeClass('qTabOff');
	      $(this).addClass('qTabHover');
      }
    });	

    $("div.qTab").bind("mouseout", function(e){
       if(!$(this).hasClass('qbTabOn')){
	      $(this).addClass('qTabOff');
	      $(this).removeClass('qTabHover');
       }   
    });	
    
    $("div.qTab").bind("click", function(e){
			var qTabID = $(this).attr('id')
			var tTabID = $(this).parent().parent().attr('id');
			var params = 'qTab=' + qTabID+ '&tTab=' +tTabID;
			
			var src = $(this).attr('src');
			navRelocate(src,params);     	
    });	


/* ************************	*/
/* PANEL TAB EVENTS		*/
/* ************************	*/	
    $("div.fTab").bind("mouseover", function(e){
      if(!$(this).hasClass('fTabOn')){
	      $(this).removeClass('fTabOff');
	      $(this).addClass('fTabHover');
      }
    });	

    $("div.fTab").bind("mouseout", function(e){
       if(!$(this).hasClass('fTabOn')){
	      $(this).addClass('fTabOff');
	      $(this).removeClass('fTabHover');
       }   
    });	
    
    $("div.fTab").bind("click", function(e){
 	 	var thisTab = $(this);
		var thisGroup = $(this).parent().parent();
	 	selectPanelTab(thisGroup, thisTab);
    });	



/* ************************	*/
/* CONTENT EVENTS	 		*/
/* ************************	*/
    $("div.dataGroupLabel").bind("click", function(e){
     	toggleDataGroup($(this).parent());
    });	

    $("input.actionButton").bind("click", function(e){
     	$(this).blur();
    });	

	var qt = $(".quickTip").children(".label");
    qt.bind("mouseover", function(e){
		var d = $(this).parent().children('.text')
     	position = ($(this).offset());
		d.css({left:position.left});
		d.fadeIn(500);
    });	
    qt.bind("mouseout", function(e){
     	$(this).parent().children('.text').fadeOut(500);
    });	


	$('input.dateInput').each(function(){
		var dInput = $(this);
		var dInputSettings = {};
		if(dInput.attr('callback') != undefined){
			var cb = eval(dInput.attr('callback'));
			dInputSettings['onSelect'] = cb;
		}
		dInput.attachDatepicker(dInputSettings);
		dInput.attr({size :"10"});
  		
		var dImage = $("<img />");
		dImage.attr({src:"/Icons_gif/Business_And_Data/16x16/plain/calendar.gif"});
		dImage.addClass('datePickerImage');
		dImage.bind("click", function(e){
     		dInput.focus();
	    });	
		dInput.after(dImage);	
	});
	
/* ************************	*/
/* ONLOAD		 			*/
/* ************************	*/
//Panel Tabs 
	// - Open first tab and panel
	$('div.fGroupContainer').each(function(){
		var fGroup = $(this);
		var fTabs = fGroup.children('.fTabContainer');

		// 1. find tab with class of open
		var defaultTab = fTabs.children('.open');
		
		
		// 2. check url params
		if(!defaultTab.length){
			var dTabID = $(document).getUrlParam("fTab");
			var defaultTab = fTabs.children('#'+dTabID);

		}		
		
		// 3. default to first tab.
		if(!defaultTab.length){
			defaultTab =	fTabs.children('.fTab:first');	
		}			
		selectPanelTab(fGroup, defaultTab);
	});

	// - FORMAT PANEL TABS
	$('div.fTab').each(function(){
		var thisTab = $(this);
		var thisGroup = thisTab.parent().parent();
		if(thisTab.hasClass('closeable')){
			var img = $("<img>");
			img.attr({
				align:"top",
				src:"/icons_gif/windows/window_close_mini.gif",
				hspace:0,
				vspace:0,
				border:0});
			img.css({"padding":"2px 0px 0px 0px"});
			
			img.bind('click',function(){
				closeTabPanel(thisGroup,thisTab);
			});
			
			thisTab.append(img);
		}
	});




//turn on appropriate tertiary tabs .
	// Order of priorities to open tTabs
	// 1. class "open" exists in a tTab.
	// 2. url param exists named "tTab". This is auto generated by clicks in the tTabs.
	// 3. Default to first tab.
	var tTabs = $('#tTabContainer');
	
	// 1. find tab with class of open
	var defaultTab = tTabs.children('.open');
	var dTabID = defaultTab.attr('id');
	
	// 2. check url params
	if(!defaultTab.length){
		var dTabID = $(document).getUrlParam("tTab");
	}
	
	// 3. default to first tab.
	if(dTabID == null){
		dTabID =	tTabs.children('.tTab:first').attr('id');	
	}	
	
	// select tab by id.
	select_tTab(dTabID);
	
	
	

//quaternary tabs
	refresh_qTabs();

//quickTip images
	$('img.quickTip').attr({src:'/Icons_gif/Application_Basics/16x16/plain/about.gif'});


//DataGroups
	var dgs = $('div.dataGroup');
	// Open appropriate groups - class 'fixed' or 'open'
	dgs.each(function(){
		var dGroup = $(this);
		if(dGroup.hasClass('open') || dGroup.hasClass('fixed')){
			showDataGroup(dGroup,0);	
		}
		if(dGroup.hasClass('fixed')){
			dGroup.children('.dataGroupLabel').css({"background-image":"url()"});
		}		
	});
	

//DataTable 
	$('table.dataTable').each(function(e){
		iniDataTable($(this));
	});
	
	
//Dialog Boxes
	var dialogs = $('div.dialog');
	dialogs.each(function(){
		var thisDialog = $(this);
		var position = thisDialog.offset();
		
		
		var dialogChildren = $(this).children('div');
		if (dialogChildren.length) {
			$(dialogChildren[0]).addClass('dialogTitle');
			$(dialogChildren[1]).addClass('dialogMessage');
			$(dialogChildren[2]).addClass('dialogButtons');
		}
		if(thisDialog.hasClass('closeable')){
			var dImage = $("<img />");
			dImage.attr({src:"/Icons_gif/windows/window_close.gif"});
			dImage.addClass('iconButton');
			dImage.bind("click", function(e){
	     		//dImage.hide();
	     		thisDialog.slideUp("fast");
		    });	

			var d = $('<div></div>');
			d.append(dImage);
			d.css({
				left: position.left + thisDialog.width()-16,
				top: position.top +3,
				"position": "absolute"
			});
			thisDialog.prepend(d);			
		}		

		
	});
	

//Context Menus
	//dataGroup Context Menus
	var dGroupMenus = $('div.dataGroupLabel');
	dGroupMenus.contextMenu('dgContextMenu', {
		// determine whether or not to show context menu
        onContextMenu: function(e) {
			var p = $(e.target).parent();	
			if (p.hasClass('fixed')) return false;
			else return true;
		},
		
		// Logic to remove non-applicable buttons.
        onShowMenu: function(e, menu) {
			var t = $(e.target);
			var p = t.parent();	
			
			if (p.hasClass('noClose')) {
				$('#close', menu).remove();
			}
			if (!p.attr('src')) {
				$('#reload', menu).remove();
			}
			if (t.hasClass('dataGroupLabelOn')) {
				$('#expand', menu).remove();
			}
			if (!t.hasClass('dataGroupLabelOn')) {
				$('#minimise', menu).remove();
			}
			return menu;
		},
		
		// Bind buttons to actions
		bindings: {
			'expand': function(t) {
				showDataGroup($(t).parent());
			},
			'minimise': function(t) {
				hideDataGroup($(t).parent());
			},
			'reload': function(t) {
				reloadDataGroup($(t).parent());
				showDataGroup($(t).parent());
			},
			'close': function(t) {
				$(t).parent().hide(300);
			}
		}

	});

	
	// PANEL CONTEXT MENUS
	var tabMenus = $('div.fTab, div.fPanelContainer');

	tabMenus.contextMenu('tabContextMenu', {
		// determine whether or not to show context menu
        onContextMenu: function(e, menu) {
			var p = $(e.target).parent();	
			if (p.hasClass('fixed')) return false;
			else return true;
		},
		
		// Logic to remove non-applicable buttons.
        onShowMenu: function(e, menu) {
			var t = $(e.target);
			if(t.hasClass('fPanelContainer')){
				t = (t.parent().find('.fTabOn'));				
			}
			
			
			$('#blank', menu).hide();
			
			if (t.hasClass('fTabOn')) {
				$('#open', menu).remove();
			}	
			if (!t.hasClass('closeable')) {
				$('#close', menu).remove();
			}
			if (!t.attr('src')) {
				$('#reload', menu).remove();
			}
			if (menu.children('ul').children('li').length ==1) {
				$('#blank', menu).show()
			}

			return menu;
		},
		
		// Bind buttons to actions
		bindings: {
			'blank': function(t) {
				return;
			},
			'open': function(t) {
				t = $(t);
				if(t.hasClass('fPanelContainer')){
					t = (t.parent().find('.fTabOn'));				
				}	
				selectPanelTab(t.parent().parent(), t);
			},
			'reload': function(t) {
				t = $(t);
				if(t.hasClass('fPanelContainer')){
					t = (t.parent().find('.fTabOn'));				
				}	
				selectPanelTab(t.parent().parent(), t,true);
			},
			'close': function(t) {
				t = $(t);
				if(t.hasClass('fPanelContainer')){
					t = (t.parent().find('.fTabOn'));				
				}	
				closeTabPanel(t.parent().parent(), t);
			}
		}

	});


	//WORKAROUNDS FOR IE6
	if($.browser.msie){
		//append div to sContent if it exists.
		$('#sContent').append('<div class="ie6_contentSpacer"><div>');
	}

	//PRIMARY CONTENT WINDOW HEIGHT
	var pch = $('#primaryContent').height();
	if (pch <= 350){
		$('#primaryContent').height(550)
	}
	
}); 


/* ********************************************************************************************************	*/
/* ************************	*/
/* END DOCUMENT READY		*/
/* ************************	*/
/* ********************************************************************************************************	*/





/* ************************	*/
/* PANEL FUNCTIONS			*/
/* ************************	*/
	// This function activates a tabbed panel by group and TabID
	function selectPanelTab(fGroup, fTab, forceReload){
		if (forceReload == null) {
			forceReload = false;
		}

		var thisTabContainer = fGroup.children(".fTabContainer");	 
		var theseTabs = thisTabContainer.children(".fTab");
			
		var thisPanelContainer = fGroup.children(".fPanelContainer");	 
		var thesePanels = thisPanelContainer.children(".fPanel");
		
		// if tab isn't passed in, default to first.
		if(fTab != null){
			var thisTab = fTab;
		}
		else {
			var thisTab = $(theseTabs[0]);
		}
		
		var thisTabID = thisTab.attr('id');
		var thisTabSrc = thisTab.attr('src');
		var thisTabPos = thisTab.prevAll().length;
		var thisPanel = thisPanelContainer.children().eq(thisTabPos);
		
		if( thisTabSrc && (!thisPanel.hasClass('loaded') || forceReload)  ){
			reloadTabPanel(fGroup,thisTab);
		}
		
		if(thisTab.hasClass('fTabOn')){return false;}
		
		// reset other tabs in this group and select this tab;
			theseTabs.removeClass('fTabOn');
	     	theseTabs.removeClass('fTabHover');
	     	theseTabs.addClass('fTabOff');
		  
	      	thisTab.removeClass('fTabOff');
	      	thisTab.addClass('fTabOn');
		  
		// hide other panels in this group	  
		  	thesePanels.hide();
			thisPanel.show();
	}
	
	function closeTabPanel(fGroup, fTab){
		var thisTabContainer = fGroup.children(".fTabContainer");	 
		var theseTabs = thisTabContainer.children(".fTab");
			
		var thisPanelContainer = fGroup.children(".fPanelContainer");	 
		var thesePanels = thisPanelContainer.children(".fPanel");
		
		var thisTab = fTab;
		var thisTabID = fTab.attr('id');
		var thisTabSrc = fTab.attr('src');
		var thisTabOpen = thisTab.hasClass('fTabOn');
		var thisTabPos = fTab.prevAll().length;
		var thisPanel = thisPanelContainer.children().eq(thisTabPos);
		
		
		
		
	    thisTab.remove();
	    thisPanel.remove();
		
		
	    
		if (!thisTabContainer.children(".fTab").length) {
			//no more tabs in this container, remove the whole container.
			fGroup.hide('slow');
	      	
		}
		else {
			//select new tab panel.
			if(thisTabOpen){
				selectPanelTab(fGroup);
			}	
		}		
		
		

	}

	function reloadTabPanel(fGroup, fTab){
		var thisTab = fTab;
		var thisTabID = thisTab.attr('id');
		var thisTabSrc = thisTab.attr('src');
		var thisTabPos = thisTab.prevAll().length;
			
		var thisPanelContainer = fGroup.children(".fPanelContainer");	 
		var thisPanel = thisPanelContainer.children().eq(thisTabPos);
		
		


		thisPanel.append(loadingDiv);
		thisPanel.load(thisTabSrc);
		thisPanel.addClass('loaded');
	}	
/* ************************	*/
/* END PANEL FUNCTIONS		*/
/* ************************	*/





/* ************************	*/
/* DATAGROUP FUNCTIONS		*/
/* ************************	*/
	var groupStatus = 1;	
	function toggleAllDataGroups(action){
		
		if(action != null){
			// use action passed in.
			a = action;
		}
		else{
			// use global var
			a = groupStatus;
			groupStatus = Math.abs(groupStatus-1);;
		}
			
		$('.dataGroup').each(function(){
				var g = $(this);
				if(a)showDataGroup(g);
				else hideDataGroup(g);
			});	
	}

	function toggleDataGroup(dGroup){
		 var p = dGroup;
		 if (p.hasClass('fixed')) {
		 	return;
		 }
		 var pLabel = p.children('.dataGroupLabel')
		 var pContainer = p.children('.dataGroupContainer')
		 var pStatus = pLabel.hasClass('dataGroupLabelOn');

		 
		 if(pStatus)
		 	hideDataGroup(dGroup);
		 else 
		 	showDataGroup(dGroup);
	}
	
	function showDataGroup(dGroup,speed){
		var p = dGroup;
		var pLabel = p.children('.dataGroupLabel');
		var pContainer = p.children('.dataGroupContainer');
		var pSrc = p.attr('src');
		
		pLabel.addClass('dataGroupLabelOn');
		if(speed == null){speed = 300;}

		 if(pSrc && !pContainer.hasClass('loaded')){
		 	pContainer.html('loading...');
		 }		
		
		pContainer.show(speed);
		 // if src defined and container isn't loaded yet, make the ajax call.
		 if(pSrc && !pContainer.hasClass('loaded')){
			reloadDataGroup(dGroup);
		 }
	}	

	function hideDataGroup(dGroup,speed){
		var p = dGroup;
		var label = p.children('.dataGroupLabel');
		var c = p.children('.dataGroupContainer');
		label.removeClass('dataGroupLabelOn');
		if(speed == null){speed = 300;}
		c.hide(speed);
	}	
	
	function reloadDataGroup(dGroup){
		var p = dGroup;
		var pLabel = p.children('.dataGroupLabel')
		var pContainer = p.children('.dataGroupContainer')
		var pStatus = pLabel.hasClass('dataGroupLabelOn');
		var pSrc = p.attr('src');
		pContainer.load(pSrc);
		pContainer.addClass('loaded');
	}	

/* ************************	*/
/* END DATAGROUP FUNCTIONS	*/
/* ************************	*/





/* ************************	*/
/* NAVIGATION FUNCTIONS		*/
/* ************************	*/
// select a tertiary tab.
	function select_tTab(tabID){
		$('.tTab').addClass('tTabOff');
		$('.tTab').removeClass('tTabOn');
				
		var tab = $(".tTab[id="+tabID+"]");
	    $(".tTab[id="+tabID+"]").removeClass('tTabHover');
	    $(".tTab[id="+tabID+"]").removeClass('tTabOff');
	    $(".tTab[id="+tabID+"]").addClass('tTabOn');
	
		refresh_qTabs();
	}

// activate relevant quaternary tabs
	function refresh_qTabs(){
		//hide all quaternary tabs
		$(".qTabContainer").hide();
		$(".qTabContainer").children(".qTab").addClass('qTabOff');

		//show any quaternary tabs placed inside a tertiary tab that is turned on.
		$(".tTabOn .qTabContainer").show();
		
	}

// open_window: used throughout old application.
	function open_window(url){
		open_win=window.open(url,"open_win","alwaysRaised=yes,toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,Width=600,Height=500")
	}

// Toggle printer friendly version on each page.
	function togglePrinterFriendly(button){
		toggleAllDataGroups(1);
		$('#pTabContainer').toggle();
		$('#sTabContainer').toggle();
		$('#sectionSelection').toggle();
		$('#tTabContainer').toggle();
	
		$('#actionButtons').toggle();
		$('.actionButton').toggle();
		$('#siteHeader').toggle();
		$('#pSiteHeader').toggle();

		if 	($('#pSiteHeader').css('display') == 'block'){
			$('#primaryContent').attr({style:"margin:0px;border:0px;padding:0px;width:1000px;"});
			$('#sContentContainer').attr({style:"margin:0px;border:0px;width:1000px;"});
			$('#sContent').attr({style:"margin:0px;border:0px;width:1000px;"});
		}
		else{
			$('#primaryContent').attr({style:""});
			$('#sContentContainer').attr({style:""});
			$('#sContent').attr({style:""});
		}
	}

// This function relocates the browser.
	function navRelocate(src,params){
		//src: defined by nav component.
		//params: used by navigation to help keep state across requests
		var goTo = src+ '&' +params;
		if(src.indexOf('?') == -1){
			var goTo = src + '?' + params		
		}
		location.href = goTo;
	}

// This function uses ajax to update panel content.
	function navRelocateAjax(src,params){
		//src: defined by nav component.
		//params: used by navigation to help keep state across requests
		var goTo = src+ '&' +params;
		if(src.indexOf('?') == -1){
			var goTo = src + '?' + params		
		}
		$('#sContent').load(goTo);
	}



// SELECT SECTION
	function selectSection(m){
		if (m) {
			$('#currentSection').hide();
			$('#sectionContainer').show();
			setTimeout('selectSection(false)',1000);
		}
		else {
			if ($('#sectionContainer').hasClass('mouseover')){
				setTimeout('selectSection(false)',1000);
			} 
			else {
				$('#currentSection').show();
				$('#sectionContainer').hide();
			}
		}
	}

// function 
	function showLoading(){
		var pc = $('#primaryContent');
		pc.html('');

		var a = $("<div />");
		a.attr({id:"docLoading"});
		a.css({"width":"100%","height":"600px","padding":"150px 150px 150px 300px"});
		a.append('<img src="/icons_gif/loading.gif"> <br><br>');
		a.append('Loading ... <br><br>');
		pc.append(a);
		
	}


/* ************************	*/
/* END NAVIGATION FUNCTIONS	*/
/* ************************	*/

/* ************************	*/
/* PROMPTBOX FUNCTIONS		*/
/* ************************	*/
function openPrompt(params){

	// defaults
	var promptURL = params.url;
	var promptHeight = '400';
	var promptWidth = '500';
	var promptTitle = '';
	var promptType = 'div';
	var promptCloseable = true;
	

	if(typeof params.src != 'undefined'){
		promptURL = params.src;
	}	
	if(typeof params.height != 'undefined'){
		promptHeight = params.height;
	}	
	if(typeof params.width != 'undefined'){
		promptWidth = params.width;
	}	
	if(typeof params.title != 'undefined'){
		promptTitle = params.title;
	}	
	if(typeof params.type != 'undefined'){
		promptType = params.type;
	}	
	if(typeof params.closeable != 'undefined'){
		promptCloseable = params.closeable;
	}	
	
	
	
	if (promptType == 'div') {
		var iFrameHeight = promptHeight - 22;
		var iFrameWidth = promptWidth-0;
		
		
		var h = ($(document).height());
		var s = window.pageYOffset;
		
		if(promptCloseable){
			$('#promptBoxButtons').show();			
		}
		else{
			$('#promptBoxButtons').hide();			
		}
		
		
		$('#promptBoxBackground').css({
			"height": h
		});
		$('#promptBoxContent').css({
			"top": s,
			"height": promptHeight + 'px',
			"width": promptWidth + 'px'
		});
		$('#promptBoxTitle').html(promptTitle);
		
		if ($.browser.msie) {
			$('#promptBoxBackground').slideDown();
			$('#promptBoxContent').slideDown();
		}
		else {
			$('#promptBoxBackground').fadeIn();
			$('#promptBoxContent').fadeIn();
		}
		
		$('#promptBoxIFrame').attr({
			"src": promptURL,
			"height": iFrameHeight + 'px',
			"width": iFrameWidth + 'px'
		});
		$('#promptBoxIFrame').css({
			"background": "white"
		});
		
	}
	else 
		if (promptType == 'popup') {
			
			var a = window.open(promptURL,null,"height=" + promptHeight + ",width=" + promptWidth + ",top=50,left=50,status=yes,toolbar=no,menubar=no,location=no");
			a.focus();
		}
	
	else{
		alert('Invalid prompt type. \n\n Valid options are: div,popup');
	}
}

function closePrompt(params){
	if(typeof params == 'undefined'){var params = new Object;}


	if ($.browser.msie) {
		$('#promptBoxBackground').slideUp();
		$('#promptBoxContent').slideUp();
	}
	else {
		$('#promptBoxBackground').fadeOut();
		$('#promptBoxContent').fadeOut();
	}
	$('#promptBoxIFrame').attr({"src":''});
	
	if(typeof params.reload != 'undefined' && params.reload){
		showLoading();
		setTimeout('location.reload(true)',500);
	}	

}
/* ************************	*/
/* END PROMPTBOX FUNCTIONS	*/
/* ************************	*/


/* ************************	*/
/* DATATABLE FUNCTIONS		*/
/* ************************	*/
function iniDataTable(dTable){

		var dTableB = dTable.children();
		var dTableRows = dTableB.children();
		var dTableCells = dTableRows.children();

		tableFormat(dTable);	
			
		// add <thead>, <tbody>, <tfoot> tags to tables that don't have them.
		if (dTable.hasClass('sortable') || dTable.hasClass('paging')) {
			var dTableBody = dTable.find('tbody');
			var hRow = 	dTableBody.find('tr:first');
					
			if(dTable.find('thead').length == 0){
				var th = $('<thead />');
				var nhRow = hRow.clone(true);
				dTable.prepend(th);
				th.append(nhRow);
				hRow.remove();				
			}
			if(dTable.find('tfoot').length == 0){
				var tf = $('<tfoot />');
				dTable.append(tf);
			}
		}
		
		if (dTable.hasClass('sortable')) {
			var theseHeaders = dTable.find('tr:first').children('th');
			var headerConfig = {}; 
			
			theseHeaders.each(function(){
				hp = $(this).prevAll().length;
				if ($(this).hasClass('nonSortable')) {
					headerConfig[hp] = {};
					headerConfig[hp].sorter = false;
				}
				
			});

			dTable.tablesorter({cssHeader:"dataSorter", headers:headerConfig});

			if (!dTable.hasClass('paging')){
				theseHeaders.bind("click",function(){
					tableFormat(dTable);
				});
			}


		}
		
		//option - showHide
		if(dTable.hasClass('showHide')){
			dTable.css({"cursor":"pointer"});

			dTable.find('tr:first').bind("click", function(e){
	      		
				if (dTable.hasClass('closed')){
					dTable.find('tr:gt(0)').fadeIn();
					dTable.removeClass('closed');
				}
				else{
					dTable.find('tr:gt(0)').fadeOut();	
					dTable.addClass('closed');
				}
		    });	

			if (dTable.hasClass('closed')) {
				dTable.find('tr:gt(0)').hide();
			}			
			
		}
		
		//option - paging
		if(dTable.hasClass('paging')){
			buildPaging(dTable);		
		}
		

}

function tableFormat(dTable){
		
		var dTableB = dTable.children();
		var dTableRows = dTableB.children();
		var dTableCells = dTableRows.children();
	
		// option - addBedding
		if (dTable.hasClass('addBedding')) {
			dTable.find('tr:last').addClass('dataBedding');
		}
		
		// option - altRows
		if(dTable.hasClass('altRows')){
			var dTableRows = dTable.children("tbody").children("tr");
			var dEvenTableRows = dTable.children("tbody").children("tr:even");
			dTableRows.removeClass('rowAlt');
			dEvenTableRows.addClass('rowAlt');			
		}
		
		// option - noBorder
		if(dTable.hasClass('noBorder')){
			dTable.css({'border':"0px"});
		}


		// options - grid / rowBorders
		if(dTable.hasClass('rowBorders')){
			dTableRows.addClass('rowBorder');
		}
		else
			if(dTable.hasClass('grid')){
				dTableCells.addClass('grid');
			}

		// option - rowHover
		if(dTable.hasClass('rowHover')){
			dTable.css({"cursor":"pointer"});
			dTable.find('tr:not(".dataBedding")').bind("mouseover", function(e){
	      		$(this).addClass('rowHover');
		    });	
			dTable.find('tr:not(".dataBedding")').bind("mouseout", function(e){
	      		$(this).removeClass('rowHover');
		    });	
		}			
	
}

function buildPaging(jTable){
	var recordsPerPage = 20;
	var pagingPosition = 'top';
	
	var jTableFoot = jTable.find('tfoot');
	var jTableBody = jTable.find('tbody');
	var jTableContainer = $('<div></div>');
	jTableContainer.css({
		"padding":"0px",
		"margin":"0px"
	});
	
	jTable.before(jTableContainer);
	
	jTableContainer.append(jTable);
	
	if(jTable.attr('paging') > 0){
		recordsPerPage = parseInt(jTable.attr('paging'));
	}

	if(jTable.attr('pagingPosition') != undefined){
		pagingPosition = jTable.attr('pagingPosition');
	}
	
	var recordCount = jTable.find('tr:gt(0)').length;
	var records = jTableBody.find('tr');
	var headers = jTable.find('tr:first').children('th')
	
	var pages = Math.ceil(records.length / recordsPerPage);
	
	
	if(pages == 1){return;}
	var recordsToFill = (pages*recordsPerPage) - records.length;
	
	for(i = 0; i< recordsToFill; i++){
		nr = $('<tr/>')
		for (c = 0; c < headers.length; c++) {
			nr.append('<td>&nbsp</td>');
		}
		jTableFoot.append(nr);
		records = jTable.find('tr:gt(0)');
		tableFormat(jTable);		
	}
	
	var cols = jTable.find('tr:eq(0)').children().length;
	
	records.hide();
	records.slice(0,recordsPerPage).show();

	var endRecord = 1+recordsPerPage-1;
		
	if(endRecord > recordCount){
		endRecord = recordCount;
	}	

	var priorPage = $('<input type="button" class="smallButton disabled" value=" < ">');
	var nextPage = $('<input type="button" class="smallButton " value=" > ">');
	var currentPage = $('<input type="text" class="smallButton currentPage" value="1" size="1" disabled style="padding:1px;">');
	var recordStatus1 = $('<div class="pd1" style="float:left;"/>');
	var recordStatus2 = $('<div class="pd2" style="float:left;"/>');
	var recordStatus3 = $('<div class="pd3" style="float:left;margin:0px 4px 0px 4px;"/>');
	var recordStatus4 = $('<div class="pd4" style="float:left;"/>');
	var recordStatus5 = $('<div class="pd5" style="float:left;margin:0px 4px 0px 4px;"/>');
	
	
	recordStatus1.append('Displaying Records:&nbsp;');
	recordStatus2.append(1);
	recordStatus3.append(' to ');
	recordStatus4.append(endRecord);
	recordStatus5.append(' of ' + recordCount + '.');
	
	var pagingContainer = $("<div />")
	var pagingText = $("<div />")
	var pagingButtons = $("<div />")

	pagingText.css({"float":"left", "margin":"5px"});
	pagingButtons.css({"float":"right", "margin":"5px"});

	pagingText.append(recordStatus1);
	pagingText.append(recordStatus2);
	pagingText.append(recordStatus3);
	pagingText.append(recordStatus4);
	pagingText.append(recordStatus5);
	
	pagingButtons.append(priorPage);
	pagingButtons.append(currentPage);
	pagingButtons.append(nextPage);



	pagingContainer.addClass('dataPaging');
	

	pagingContainer.append(pagingText);
	pagingContainer.append(pagingButtons);
	pagingContainer.append('<br clear="all">');

		pagingContainer.css({
			"margin": "0px",
			"padding": "0px"
		});

	var pcWidth = jTable.width();
	if (pcWidth > 0) {
		pagingContainer.css({
			"width": pcWidth
		});
	}	
	else{
		if(jTable.attr('width') != undefined){
			pagingContainer.css({
			"width": jTable.attr('width')
			});
		}
		
	}
	
	if (jTable.hasClass('sortable')) {
		headers.bind("click",function(){
			if (!$(this).hasClass('nonSortable')) {
				records.hide();
				records = jTable.find('tr:gt(0)');
				records.slice(0, recordsPerPage).show();
				jTableContainer.find('.currentPage').val(1);
				
				var startRecord = 1;
				var endRecord = startRecord + recordsPerPage - 1;
				
				if (endRecord > records.length) {
					endRecord = records.length;
				}
				
				jTableContainer.find('.pd2').html(startRecord);
				jTableContainer.find('.pd4').html(endRecord);
				priorPage.removeClass('disabled');
				nextPage.removeClass('disabled');
				priorPage.addClass('disabled');	
				
				tableFormat(jTable);
			}
		});
	}
	
	
	nextPage.bind("click",function(){
		var cp = parseInt(currentPage.val());
		var p = cp + 1;
		if(p > pages){return;}
		
		jTableContainer.find('.currentPage').val(p);

		var startRecord = (recordsPerPage * (p-1)) + 1;
		var endRecord = startRecord+recordsPerPage-1;
		
		if(endRecord > records.length){
			endRecord = records.length;
		}
		
		jTableContainer.find('.pd2').html(startRecord);
		jTableContainer.find('.pd4').html(endRecord);
		
		records.hide();
		records.slice(startRecord-1, (startRecord+recordsPerPage-1) ).show();
		
		priorPage.removeClass('disabled');
		nextPage.removeClass('disabled');
		if(p == pages){nextPage.addClass('disabled');}

	});

	priorPage.bind("click",function(){
		var cp = parseInt(currentPage.val());
		var p = cp - 1;
		if(p < 1){return;}
		
		jTableContainer.find('.currentPage').val(p);
		
		var startRecord = (recordsPerPage * (p-1)) + 1;
		var endRecord = p*recordsPerPage;

		jTableContainer.find('.pd2').html(startRecord);
		jTableContainer.find('.pd4').html(endRecord);

		records.hide();
		records.slice(startRecord-1, (startRecord+recordsPerPage-1) ).show();
		
		priorPage.removeClass('disabled');
		nextPage.removeClass('disabled');
		if(p == 1){priorPage.addClass('disabled');}		

	});
	
	if(pagingPosition == 'top'){
		jTable.before(pagingContainer);
	}
	else if (pagingPosition == 'bottom'){
		jTable.after(pagingContainer);
	}
	else if (pagingPosition == 'both'){
		p1 = pagingContainer;
		p2 = pagingContainer.clone(true);
		jTable.before(p1);
		jTable.after(p2);
	}
	
}



/* ************************	*/
/* END DATATABLE FUNCTIONS		*/
/* ************************	*/


/* ************************	*/
/* PDF FUNCTIONS			*/
/* ************************	*/
function exportPDF(content){
	// IN DEV RIGHT NOW
	var a = jQuery.post('/cia2/exportPDF.cfm',{cleanData:1,showHeader:1,content:content.html()});

}

