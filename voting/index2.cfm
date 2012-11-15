<link rel="stylesheet" type="text/css" href="/scripts/ext-4.0.2a/resources/css/ext-all.css" />
<script type="text/javascript" src="/scripts/ext-4.0.2a/bootstrap.js"></script>
<script type="text/javascript" src="classes/Question.js"></script>
<script>
	Ext.onReady( function() {
		Ext.Loader.setConfig({
			enabled		: true
			, paths		: {
				Voting : 'classes'	
			}
		})
		
		Ext.require([
		    'Ext.tab.*',
		    'Ext.window.*',
		    'Ext.tip.*',
		    'Ext.layout.container.Border'
		]);
	
	    var win = Ext.create('widget.window', {
              title: 'LWFA Voting Portal',
              closable: true,
              modal:true,
              closeAction: 'hide',
              //animateTarget: this,
              width: 700,
              height: 500,
              layout: 'border',
              bodyStyle: 'padding: 5px;',
              items: [
              	{
                  region	: 'west'
                  , title		: '2012 Agenda'
                  , width		: 200
                  , split		: true
                  , collapsible	: true
                  , floatable	: false
                  , items		: [
				    {
				    	xtype			: 'treepanel'
						, border		: false
				        , store			: Ext.create('Ext.data.TreeStore', {
				        	folderSort	: true
				        	, proxy		: {
				        	    type		: 'ajax'
				        	    , url		: '../cfc/com_voting.cfc?method=getQuestions&showheader=false'
				        	}
				        	, root		: {
				        	    text		: 'Ext JS'
				        	    , id		: 'src'
				        	    , expanded	: true
				        	}
				    	})
						, rootVisible	: false
				        , height		: 300
				        , width			: 250
				        , useArrows		: true
  					}
              	  ]
              	}, 
              	{
                  	region		: 'center'
					, items		: [
		              	{
		                  	xtype		: 'tabpanel'
		           		},
		           		{
		           			id			: 'questionformarea'
		                  	, border	: false
		                  	, items		: [
		                  		new Voting.Question({questionID:1})
		                  	]
		                  	, buttons	: [
		                  		{
		                  			text	: 'Previous'
		                  			, id	: 'previousBtn'
		                  		},
		                  		'->',
		                  		{
		                  			text	: 'Next'
		                  			, id	: 'nextBtn'
		                  		}
		                  	]
		           		}
					]
              	}
           	]
        })
		win.show();
	})
</script>

<body>

<div id="votingportal"></div>

</body>
</html>