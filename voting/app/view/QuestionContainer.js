Ext.define('Voting.view.QuestionContainer', {
    extend: 'Ext.panel.Panel'
    , alias: 'widget.questioncontainer'
    , initComponent: function(){
    	Ext.apply(this, {
        	buttons	: [
          		{
          			text		: 'Previous'
          			, id		: 'previousBtn'
          			, cls		: 'questionBtn'
          			, disabled	: true
          		},
          		{
          			text		: 'Next'
          			, id		: 'nextBtn'
					, cls		: 'questionBtn'
          		}        	
        	]
        	, items		: [
            	/*{
            		xtype		: 'tabpanel'
            		, border	: false
            		, items		: [
			 			{
			    			title		: 'View Ballot'
			        	  	, id		: 'ballottab'
			      		}, 
			      		{
			       		   	title		: 'Current Results'
			       		   	, id		: 'resultstab'
			       		   	, items		: []
			      		}           		
			   		]
            	},*/
            	{
            		border		: true
            		, id		: 'questionArea'
            		, height	: 460
            		, items		: []
            	}
        	]
    	});
        this.callParent();
    }
});