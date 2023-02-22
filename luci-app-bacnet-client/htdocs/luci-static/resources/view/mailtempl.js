'use strict';
'require view';
'require fs';
'require ui';

var isReadonlyView = !L.hasViewPermission() || null;

return view.extend({
	load: function() {
		return L.resolveDefault(fs.read('/etc/bacalarmtemplate.txt'), '');
	},

	handleSave: function(ev) {
		var value = (document.querySelector('textarea').value || '').trim().replace(/\r\n/g, '\n') + '\n';

		return fs.write('/etc/bacalarmtemplate.txt', value).then(function(rc) {
			document.querySelector('textarea').value = value;
			ui.addNotification(null, E('p', _('Contents have been saved.')), 'info');
		}).catch(function(e) {
			ui.addNotification(null, E('p', _('Unable to save contents: %s').format(e.message)));
		});
	},

	render: function(bacalarmtemplate) {
		return E([
			E('h2', _('Mail Vorlage für Erreignise')),
			E('p', { 'class': 'cbi-section-descr' }, _('Mail Vorlage für Erreignise # wird ersetzt')),
			E('p', {}, E('textarea', { 'style': 'width:100%', 'rows': 25, 'disabled': isReadonlyView }, [ bacalarmtemplate != null ? bacalarmtemplate : '' ]))
		]);
	},

	handleSaveApply: null,
	handleReset: null
});
