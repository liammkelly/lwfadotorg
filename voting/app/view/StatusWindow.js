Ext.define('Voting.view.StatusWindow', {
    extend: 'Ext.window.Window'
    , alias: 'widget.statuswindow'
    , initComponent: function(){
    	Ext.apply(this, {
           	title			: 'LWFA Voting: Team Status'
           	, modal			: true
          	, items			: [
	          	{
	          		xtype			: 'chart'
		            , animate		: true
		           	, width			: 600
		          	, height		: 500
		          	, shadow		: false
	          		, store			: Ext.create('Ext.data.Store', {
		            	fields			: ['team','votes','votePercent']
						, autoLoad		: true            	
		            	, storeId		: 'voteStatusStore'
						, proxy			: {
		            		type			: 'ajax'
				            , url			: '../cfc/com_voting.cfc?method=getVoterStatus&showheader=false&isAward='+Voting.vars.isAwards
		            		, reader		: {
		            			type			: 'json'
		            			, root			: 'DATA'
		            		}
		            	}
		            })
					, axes: [
						{
			                type		: 'Numeric'
			                , position	: 'bottom'
			                , fields	: ['votePercent']
			                , label		: {
			                   renderer: Ext.util.Format.numberRenderer('0,0')
			                }
			                , title		: '% Of Ballot Completed'
			                , minimum	: 0
			            }, 
			            {
			                type		: 'Category'
			                , position	: 'left'
			                , fields	: ['team']
			                , title		: 'LWFA Team'
			            }
		            ]
		            , series: [
		            	{
			                type		: 'bar'
			                , axis		: 'bottom'
			                , label		: {
			                    display			: 'insideEnd'
			                    , field			: 'votePercent'
			                    , renderer		: function(val) {
									return val + "%"
			                   	}
			                    , orientation	: 'horizontal'
			                    , color			: '#333'
			                    , 'text-anchor'	: 'middle'
			                    , contrast		: true
			                }
			                , xField	: 'name'
			                , yField	: ['votePercent']
			                //color renderer
			                , renderer	: function(sprite, record, attr, index, store) {
			                    var fieldValue = Math.random() * 20 + 10;
			                    var value = (record.get('votePercent') >> 0) % 5;
			                    var color = ['rgb(213, 70, 121)', 
			                                 'rgb(44, 153, 201)', 
			                                 'rgb(146, 6, 157)', 
			                                 'rgb(49, 149, 0)', 
			                                 'rgb(249, 153, 0)'][value];
			                    return Ext.apply(attr, { fill: color });
			                }
			            }
		            ]
            	}
          	]
    	})
        this.callParent();
    }
})