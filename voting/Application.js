Ext.Loader.setConfig({
    enabled: true
});

Ext.application({
    name: 'Voting',
    
    appFolder: 'app',

    views: [
    	'Portal'
    ],
    
    controllers: [
        'Portal'
    ],

    launch: function() {
		Ext.create('Voting.view.Portal');
	}
});