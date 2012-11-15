Ext.onReady( function() {
	
	Ext.define('PositionType', {
        extend: 'Ext.data.Model',
        fields: [
            {type: 'string', name: 'postype'}
        ]
    });

    Ext.define('ForumThread', {
        extend: 'Ext.data.Model',
        fields: [
            'title', 'forumtitle', 'forumid', 'author',
            {name: 'replycount', type: 'int'},
            {name: 'lastpost', mapping: 'lastpost', type: 'date', dateFormat: 'timestamp'},
            'lastposter', 'excerpt', 'threadid'
        ],
        idProperty: 'threadid'
    });

    // create the Data Store
    var store = Ext.create('Ext.data.Store', {
        pageSize: 50,
        model: 'ForumThread',
        remoteSort: true,
        proxy: {
            // load using script tags for cross domain, if the data in on the same domain as
            // this page, an HttpProxy would be better
            type: 'jsonp',
            url: 'http://www.sencha.com/forum/topics-browse-remote.php',
            reader: {
                root: 'topics',
                totalProperty: 'totalCount'
            },
            // sends single sort as multi parameter
            simpleSortMode: true
        },
        sorters: [{
            property: 'lastpost',
            direction: 'DESC'
        }]
    });
		
	posTypeStore = Ext.create('Ext.data.Store', {
        model: 'PositionType',
        data: [
			{'postype':'QB'},
			{'postype':'RB'},
			{'postype':'WR'},
			{'postype':'TE'},
			{'postype':'QB + RB'},
			{'postype':'QB + RB + WR'},
			{'postype':'QB + RB + WR + TE'},
			{'postype':'RB + WR'},
			{'postype':'RB + WR + TE'},
			{'postype':'K'},
			{'postype':'D'}
		]
    });

   	nflTeamStore = Ext.create('Ext.data.Store', {
        fields: ['name'],
        proxy: {
	        type: 'ajax',
	        url : '../cfc/statcenter.cfc?method=getNFLTeams',
	        reader: {
	            type: 'json',
	            root: 'teams'
	        }
	    },
	    autoLoad: true
    });
    	
   	teamStore = Ext.create('Ext.data.Store', {
        fields: ['teamID', 'name'],
        proxy: {
	        type: 'ajax',
	        url : '../cfc/statcenter.cfc?method=getTeams',
	        reader: {
	            type: 'json',
	            root: 'teams'
	        }
	    },
	    autoLoad: true
    });
    	
	nflTeamsCombo = Ext.create('Ext.form.field.ComboBox', {
        fieldLabel: 'NFL Team',
		name: 'nflteam',
        displayField: 'name',
        store: nflTeamStore,
        queryMode: 'local',
        typeAhead: true
    });
		
	teamsCombo = Ext.create('Ext.form.field.ComboBox', {
        fieldLabel: 'Team',
		name: 'lwfateam',
        displayField: 'name',
		valueField: 'teamID',
        store: teamStore,
        queryMode: 'local',
        typeAhead: true
    });
		
	positionTypeCombo = Ext.create('Ext.form.field.ComboBox', {
        fieldLabel: 'Positions',
		name: 'postype',
        displayField: 'postype',
        store: posTypeStore,
        queryMode: 'local',
        typeAhead: true
    });
		
	statcenterWin = Ext.create('Ext.Window', {
		title: 'LWFA StatCenter',
        bodyPadding: 5,
        width: 870,
        height: 695,
		layout: 'column',    
        fieldDefaults: {
            labelAlign: 'left',
            msgTarget: 'side'
        },
		items : [
			{
				xtype		: 'form',
				height		: 650,
				id			: 'scForm',
				columnWidth	: 0.3,
				bodyPadding	: '5',
				defaults	: {
					width		: 240,
					labelWidth	: 70
				},
				defaultType	: 'textfield',
				items		: [
					Ext.create('Ext.slider.Multi', {
			            fieldLabel	: 'Week Range',
			            name		: 'weekRange',
						minValue	: 1,
						maxValue	: 16,
						values		: [1,16]
			        }),
					positionTypeCombo,
					teamsCombo,
					nflTeamsCombo
				]
			},
			{
	            columnWidth	: 0.7,
				height		: 650,
				items		: [
					{
						xtype	: 'tabpanel',
						border	: false,
						items	: [
							{
								title 	: 'Trends',
								items	: [
								
								]
							},
							{
								title : 'Performances',
								
							}
						]
					}
				]
			}
		]
 	}).show();

})

