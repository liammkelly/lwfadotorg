Ext.create('Ext.data.Store', {
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