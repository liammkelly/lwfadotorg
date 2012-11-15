Ext.create('Ext.data.Store', {
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