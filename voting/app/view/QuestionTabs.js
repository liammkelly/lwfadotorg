Ext.define('Voting.view.QuestionTabs', {
    extend: 'Ext.tab.Panel'
    , alias: 'widget.questiontabs'
    , initComponent: function(){
    	Ext.apply(this, {
        	items	: [
        	{
    			title		: 'View Ballot'
        	  	, id		: 'ballottab'
      		}, 
      		{
       		   	title		: 'Current Results'
       		   	, id		: 'resultstab'
       		   	, items		: []
      		}]
    	});

        this.callParent();
    }
})