'use strict';
'require view';
'require ui';
'require rpc';
'require poll';

var callgetData = rpc.declare({
	object: 'bacnetclient',
	method: 'devlist'
});

var callsetData = rpc.declare({
	object: 'bacnetclient',
	method: 'objdesc',
	params: [ 'devid', 'object_type', 'object_instance', 'Description' ]
});
var callsetDataLoc = rpc.declare({
	object: 'bacnetclient',
	method: 'objloc',
	params: [ 'devid', 'object_type', 'object_instance', 'Location' ]
});

function createTable(data) {
    let tableData = [];
    data.list.forEach(row => {
		let dp =
			E('span', { 'class': 'control-group' }, [
				E('button', {
					'class': 'cbi-button cbi-button-apply',
					'click': ui.createHandlerFn(this, function() {
						console.log(row.devid);
						window.open('objlist?devid=' + row.devid, "_self");
					})
				},
				_('Datenpunkte')),
			]);
		let description =
			E('input', {
				'class': 'cbi-input-text',
				'id': row.devid + '_device_' + row.devid,
				'type': 'text',
				'value': row.Description,
				'style': 'width:30em'
			});
			let description_apply =
			E('span', { 'class': 'control-group' }, [
				E('button', {
					'class': 'cbi-button cbi-button-apply',
					'click': ui.createHandlerFn(this, function() {
						let nameValue = document.getElementById(row.devid + '_device_' + row.devid).value;
						console.log(nameValue);
						return callsetData(row.devid,'device',row.devid,nameValue);
					})
				}, 
				_('Speichern')),
			]);
		let location =
			E('input', {
				'class': 'cbi-input-text',
				'id': row.devid + '_device_' + row.devid + '_loc',
				'type': 'text',
				'value': row.Location,
				'style': 'width:30em'
			});
			let location_apply =
			E('span', { 'class': 'control-group' }, [
				E('button', {
					'class': 'cbi-button cbi-button-apply',
					'click': ui.createHandlerFn(this, function() {
						let nameValue = document.getElementById(row.devid + '_device_' + row.devid + '_loc').value;
						console.log(nameValue);
						return callsetDataLoc(row.devid,'device',row.devid,nameValue);
					})
				}, 
				_('Speichern')),
			]);
		tableData.push([
            dp,
            row.devid,
            row.object_name,
            description,
            description_apply,
            location,
            location_apply
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
			E('th', { 'class': 'th left' }, [ 'Datenpunkte' ]),
			E('th', { 'class': 'th left' }, [ 'ID' ]),
			E('th', { 'class': 'th left' }, [ 'Name' ]),
			E('th', { 'class': 'th left' }, [ 'Beschreibung' ]),
			E('th', { 'class': 'th left' }, [ 'Speichern' ]),
			E('th', { 'class': 'th left' }, [ 'Ort' ]),
			E('th', { 'class': 'th left' }, [ 'Speichern' ])
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
