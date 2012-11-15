Ext.define('Voting.view.Result', {
    extend: 'Ext.chart.Chart'
    , alias: 'widget.result'
    , initComponent: function(){
 		var that = this;
    	var config = {
    		id				: 'chartCmp'
            , animate		: true
    		, width			: 430
    		, height 		: 250
            , style			: 'margin-top:10px'
            , store			: Ext.create('Ext.data.Store', {
            	fields		: ['answerID','votes','text','option']
            	, storeId	: 'chartstore'
				, proxy		: {
            		type		: 'ajax'
		            , url		: '../cfc/com_voting.cfc?method=getQuestionResult&showheader=false&questionID='+that.questionID
            		, reader	: {
            			type		: 'json'
            			, root		: 'DATA'
            		}
            	}
				, autoLoad	: true            	
            })
            , shadow		: false	
            , theme			: 'Base:gradients'
            , series		: [{
                type			: 'pie'
                , field			: 'votes'
                , showInLegend	: true
                , showInSeries	: true
                , donut			: false
                , tips			: {
                  	trackMouse		: true
                  	, width			: 140
                  	, height		: 28
                  	, renderer		: function(storeItem, item) {
                    	//calculate percentage.
                    	var total = 0;
                    	Ext.StoreMgr.get('chartstore').each(function(rec) {
                    	    total += rec.get('votes');
                    	});
                    	this.setTitle(storeItem.get('option') + ': ' + Math.round(storeItem.get('votes') / total * 100) + '%');
                  	}
                }
                , highlight	: {
                  	segment	: {
                    	margin: 20
                  	}
                }
                , label		: {
                    field		: 'option'
                    , display	: 'rotate'
                    , contrast	: true
                    , font		: '18px Arial'
                }
            }]
    	}
    	
    	Ext.apply( this, Ext.apply(config,this) );
        this.callParent();
    }
});