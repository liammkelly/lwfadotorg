Ext.define('Voting.view.QuestionTree', {
    extend: 'Ext.tree.Panel'
    , alias: 'widget.questiontree'
    , initComponent: function(){
    	Ext.apply(this, {
			border		: false
	        , height		: 300
	        , width			: 250
	        , id			: 'questiontree'
	        , store			: Ext.create('Ext.data.TreeStore', {
	        	folderSort	: true
	        	, storeId	: 'questionTreeStore'
	        	, proxy		: {
	        	    type		: 'ajax'
	        	    , url		: '../cfc/com_voting.cfc?method=getQuestions&showheader=false'
	        	}
	        	, root		: {
	        	    text		: 'Ext JS'
	        	    , id		: 'src'
	        	    , expanded	: true
	        	}
		    	, listeners		: {
		    		load : function() {
		    			this.getSelectionModel().select(0);
		    		}
		        	, scope		: this
		    	}
	    	})
			, rootVisible	: false
	        , useArrows		: true
		});
        this.callParent();
    }

});