Ext.create('Ext.data.Store', {
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