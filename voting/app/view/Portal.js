Ext.define('Voting.view.Portal', {
    extend: 'Ext.Panel'
    , alias: 'widget.votingportal'
    , initComponent: function(){
    	Ext.apply(this, {
            layout			: 'border'
           	, width			: 700
          	, height		: 500
          	, renderTo		: 'votingArea'
          	, modal			: true
          	, dockedItems	: [
	          	{
      				xtype		: 'toolbar'
        			, dock		: 'top'
        			, items		: [
	        			{
	        				xtype		: 'tbtext'
	        				, text		: 'LWFA Postseason Voting'
	        			},
        				'->',
        				{
			            	text		: 'Clear This Vote'
			            	, id		: 'clearVoteBtn'
			            	, iconCls	: 'unvote'
			        	},
			        	'|',
        				{
			            	text		: 'Team Ballot Status'
			            	, id		: 'votesCastBtn'
			            	, iconCls	: 'users'
			        	}
			        ]
	          	}
          	]
            , items			: [
	            {
	            	xtype			: 'panel'	
	            	, region		: 'west'
	            	, dockedItems	: [
		            	{
		            		xtype		: 'toolbar'
		            		, items		: [
			            		{
			            			text 			: 'Offseason Agenda'
			            			, enableToggle	: true
			            			, pressed		: true
			            			, id			: 'toggleAgendaBtn'
			            			, flex			: 1
			            		},
			            		{
			            			text 			: '2012 Awards'
			            			, enableToggle	: true
			            			, id			: 'toggleAwardsBtn'
			            			, flex			: 1
			            		}
		            		]
		            	}
	            	]
	            	, items			: [
						{
	            			xtype		: 'questiontree'
	            		}          	
	            	]
	            },
	            {
	            	xtype		: 'questioncontainer'
	            	, region	: 'center'
	            	, border	: false
	            }
            ]
        });
        this.callParent();
    }
});