'use strict';
'require view';
'require ui';
'require rpc';
'require poll';

var callgetData = rpc.declare({
	object: 'bacnetclient',
	method: 'objlist',
	params: [ 'devid' ]
});

var callsetData = rpc.declare({
	object: 'bacnetclient',
	method: 'objdesc',
	params: [ 'devid', 'object_type', 'object_instance', 'Description' ]
});

function createTable(data) {
    let tableData = [];
    data.list.forEach(row => {
		let description =
			E('input', {
				'class': 'cbi-input-text',
				'id': row.devid + '_' + row.object_type + '_' + row.object_instance,
				'type': 'text',
				'value': row.Description,
				'style': 'width:30em'
			});
		let apply =
			E('span', { 'class': 'control-group' }, [
				E('button', {
					'class': 'cbi-button cbi-button-apply',
					'click': ui.createHandlerFn(this, function() {
						let nameValue = document.getElementById(row.devid + '_' + row.object_type + '_' + row.object_instance).value;
						return callsetData(row.devid,row.object_type,row.object_instance,nameValue);
					})
				}, 
				_('Speichern')),
			]);
		tableData.push([
            apply,
            row.devid,
            row.object_type,
			row.object_instance,
            row.object_name,
            description
        ])
    });
    return tableData;
};

return view.extend({
	title: _('Datenpunkt Liste'),
	handleSaveApply: null,
	handleSave: null,
	handleReset: null,


	render: function(data) {

		var tr = E('table', { 'class': 'table' });
		tr.appendChild(E('tr', { 'class': 'tr cbi-section-table-titles' }, [
			E('th', { 'class': 'th left' }, [ '' ]),
			E('th', { 'class': 'th left' }, [ 'Dev ID' ]),
			E('th', { 'class': 'th left' }, [ 'Typ' ]),
			E('th', { 'class': 'th left' }, [ 'Instanz' ]),
			E('th', { 'class': 'th left' }, [ 'Name' ]),
			E('th', { 'class': 'th left' }, [ 'Beschreibung' ])
		]));
		let params = new URLSearchParams(document.location.search);
		let devid = params.get("devid");
        poll.add(() => {
            Promise.all([
				callgetData(devid)
            ]).then((results) => {
                cbi_update_table(tr, createTable(results[0]));
            })
        }, 10);
        return tr

	}

});
