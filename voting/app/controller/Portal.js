Ext.define('Voting.controller.Portal', {
    extend	: 'Ext.app.Controller',
    views	: ['QuestionTree','Question','Result','QuestionContainer'],
    
    refs: [
        {ref: 'tree', 	selector: 'questiontree'}
    ]
    
    , init: function() {
        var me = this;

        me.control({
            'questiontree': {
                selectionchange	: me.onQuestionChange
            }
            , 'tabpanel': {
                tabchange	: me.onQuestionChange
            }
            , 'button': {
            	click : me.buttonAction
            }
        });

        Voting.vars = {};
		Voting.vars.isAwards = 0;
        
   	}
    
    , buttonAction: function(btn,ev) {
    	var qtree = Ext.ComponentQuery.query('questiontree')[0];
    	switch(btn.id) {
			case 'votesCastBtn':
				var win = Ext.create('Voting.view.StatusWindow');
				win.show();
				break;
			case 'clearVoteBtn':
				Ext.Ajax.request({
					url			: '../cfc/com_voting.cfc?method=clearVote&showheader=false&questionID='+Ext.ComponentQuery.query('questionform')[0].questionID
					, success	: function() {
						qtree.fireEvent('selectionchange');
		    			qtree.getSelectionModel().getSelection()[0].set('iconCls','unanswered');
					}
				});
				break;
			case 'nextBtn':
				if(  qtree.getSelectionModel().getSelection()[0].nextSibling != null ) {
					qtree.getSelectionModel().select( qtree.getSelectionModel().getSelection()[0].nextSibling )
				}
				break;
			case 'previousBtn':
				if( qtree.getSelectionModel().getSelection()[0].previousSibling != null ) {
					qtree.getSelectionModel().select( qtree.getSelectionModel().getSelection()[0].previousSibling )		
				}
				break;
			case 'toggleAgendaBtn':
				btn.nextNode().toggle();
				Ext.StoreManager.get('questionTreeStore').load({params:{isAward:0}})
				Voting.vars.isAwards = 0;
				break;
			case 'toggleAwardsBtn':
				btn.previousNode().toggle();
				Ext.StoreManager.get('questionTreeStore').load({params:{isAward:1}})
				Voting.vars.isAwards = 1;
				break;
			default:
				alert( btn.id )
				break;
    	}
		if( qtree.getSelectionModel().getSelection()[0].nextSibling === null ) {
			Ext.ComponentQuery.query('#nextBtn')[0].disable(); 
		} else {
			Ext.ComponentQuery.query('#nextBtn')[0].enable();	
		}
		if( qtree.getSelectionModel().getSelection()[0].previousSibling === null ) {
			Ext.ComponentQuery.query('#previousBtn')[0].disable()
		} else {
			Ext.ComponentQuery.query('#previousBtn')[0].enable()
		}
	}
    
    , onQuestionChange: function() {
    	var tree = Ext.ComponentQuery.query('questiontree')[0].getSelectionModel();
    	var qa = Ext.ComponentQuery.query('#questionArea')[0];
    	var newQuestionID = tree.getSelection()[0].internalId;
    	//var isChart = Ext.ComponentQuery.query('tabpanel')[0].getActiveTab().title.indexOf('Results');
		qa.removeAll();
		/*
		if( isChart >= 0 ) {
			var newq = Ext.create('Voting.view.Result',{questionID:newQuestionID});					
		} else {
			var newq = Ext.create('Voting.view.Question',{questionID:newQuestionID});		
		}
		qa.add(newq);		
		*/
		qa.el.mask('Loading question..'); 
		Ext.Ajax.request({
			url			: '../cfc/com_voting.cfc?showheader=false'
			, params	: {
				method			: 'getQuestionDetails'
				, questionID	: newQuestionID
				, isAward		: Voting.vars.isAwards
			}
			, success	: function(r) {
				var qdata = eval( "(" + r.responseText + ")" );
				var chartheight = 330 - (35 * (qdata.ANSWERS - 2));
				var question = Ext.create('Voting.view.Question',{questionID:newQuestionID});		
				var chart = Ext.create('Voting.view.Result',{questionID:newQuestionID,height:chartheight});					
				qa.add(question);		
				qa.add(chart);		
				qa.el.unmask();
				if( Ext.ComponentQuery.query('questiontree')[0].getSelectionModel().getSelection()[0].nextSibling === null ) {
					Ext.ComponentQuery.query('#nextBtn')[0].disable(); 
				} else {
					Ext.ComponentQuery.query('#nextBtn')[0].enable();	
				}
				if( Ext.ComponentQuery.query('questiontree')[0].getSelectionModel().getSelection()[0].previousSibling === null ) {
					Ext.ComponentQuery.query('#previousBtn')[0].disable()
				} else {
					Ext.ComponentQuery.query('#previousBtn')[0].enable()
				}
			}
		})
    }
});