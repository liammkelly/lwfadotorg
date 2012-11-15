Ext.define('Voting.view.Question', {
    extend: 'Ext.form.Panel'
    , alias: 'widget.questionform'
    , initComponent: function(){
    	Ext.apply(this, {
            id			: 'questionformpanel'
			, width		: 430
			, border	: false
            , scope		: this
        });
		var that = this;

       	Ext.Ajax.request({
    		url			: '../cfc/com_voting.cfc'
    		, method	: "GET"
    		, params	: {
    			method		 	: 'getQuestions'
    			, isTree	 	: 0
    			, showheader 	: false
    			, questionID 	: that.questionID
				, isAward		: Voting.vars.isAwards
    		}
    		, success	: function(r) {
    			var json = Ext.JSON.decode( r.responseText );
    			var questionlabel =  {
    				border	: false
    				, style	: 'float:left;margin-bottom:20px'
    				, html	: '<h3>'+json.questions[0]['question']+'</h3>'
    			}
    			that.add(questionlabel);
    			Ext.Array.each( json.questions[0]['answers'], function(itm,idx) {
	    			var newquestion = {
		                boxLabel		: itm.answerText
		                , xtype			: 'radio'
		                , name			: 'answerID'
		                , inputValue	: itm.answerID
		                , handler		: that.submitAnswer
		                , style			: 'margin-left:20px'
		                , checked		: itm.isSelected
		            }
	    			that.add(newquestion);
    			})
    		}
    	})

        this.callParent();
    }

    , submitAnswer: function(radio) {
		if(radio.getValue() == true) {
			var qID = this.up('questionform').questionID;

	    	Ext.Ajax.request({
	    		url			: '../cfc/com_voting.cfc'
	    		, params	: {
	    			method			: 'saveAnswer'
	    			, questionID	: qID
	    			, answerID		: radio.inputValue
	    		}
	    		, success	: function(r){
	    			Ext.StoreMgr.get('chartstore').load();
	    			Ext.ComponentQuery.query('questiontree')[0].getSelectionModel().getSelection()[0].set('iconCls','answered');
	    		}
	    	})
	    	
	    }
    }
    
    /*, onSelect: function(rec) {
		vlog(rec)
    }*/

});