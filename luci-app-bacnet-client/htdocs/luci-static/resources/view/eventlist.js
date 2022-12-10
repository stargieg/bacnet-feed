'use strict';
'require view';
'require ui';
'require rpc';
'require poll';

var callgetData = rpc.declare({
	object: 'bacnetclient',
	method: 'eventlist'
});

var callsetData = rpc.declare({
	object: 'bacnetclient',
	method: 'ackevent',
	params: [ 'devid', 'object_type', 'object_instance', 'event_time_stamp' ]
});

function createTable(data) {
    let tableData = [];
    data.list.forEach(row => {
		let event_time_stamp = Date.parse(row.event_time_stamp);
		let event_time_stamp_loc = new Date(event_time_stamp);
		let ack =
			E('span', { 'class': 'control-group' }, [
				E('button', {
					'class': 'cbi-button cbi-button-apply',
					'click': ui.createHandlerFn(this, function() {
						return callsetData(row.devid,row.object_type,row.object_instance,event_time_stamp);
					})
				}, 
				_('Quit')),
			]);
		tableData.push([
			ack,
            row.idx,
            row.devid,
            row.devname,
            row.devdesc,
            row.devloc,
            row.object_name,
            row.Description,
			row.event_state,
			row.value,
			//event_time_stamp
			event_time_stamp_loc.toLocaleDateString('de-DE'),
			event_time_stamp_loc.toLocaleTimeString('de-DE')
        ])
    });
    return tableData;
};

return view.extend({
	title: _('Alarmliste'),
	handleSaveApply: null,
	handleSave: null,
	handleReset: null,


	render: function(data) {

		var tr = E('table', { 'class': 'table' });
		tr.appendChild(E('tr', { 'class': 'tr cbi-section-table-titles' }, [
			E('th', { 'class': 'th left' }, [ 'Quit' ]),
			E('th', { 'class': 'th left' }, [ 'Index' ]),
			E('th', { 'class': 'th left' }, [ 'Dev ID' ]),
			E('th', { 'class': 'th left' }, [ 'Dev Name' ]),
			E('th', { 'class': 'th left' }, [ 'Dev Beschreibung' ]),
			E('th', { 'class': 'th left' }, [ 'Dev Ort' ]),
			E('th', { 'class': 'th left' }, [ 'Datenpunkt' ]),
			E('th', { 'class': 'th left' }, [ 'Beschreibung' ]),
			E('th', { 'class': 'th left' }, [ 'Ereignis Status' ]),
			E('th', { 'class': 'th left' }, [ 'Wert' ]),
			E('th', { 'class': 'th left' }, [ 'Datum' ]),
			E('th', { 'class': 'th left' }, [ 'Uhrzeit' ])
		]));
        poll.add(() => {
            Promise.all([
				callgetData()
            ]).then((results) => {
                cbi_update_table(tr, createTable(results[0]));
            })
        }, 10);
        return tr

	}

});
