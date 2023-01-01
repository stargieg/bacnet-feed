'use strict';
'require view';
'require form';
'require tools.widgets as widgets';

return view.extend({
	render: function() {
		var m, s, o;

		m = new form.Map('bacnet_nc', 'Notification Class');
		m.tabbed = false;
		s = m.section(form.TypedSection, 'nc', _('Notification Class configuration section'));
		s.anonymous = false;
		s.addremove = true;
		s.addbtntitle = _('Add new Notification Class Object...');
		o = s.option(form.Flag, 'disable', _('Disable'));
		o.rmempty = false;
		o = s.option(form.Value, "name", _("Name"), "Name");
		o.optional = false;
		o.datatype = "string";
		o = s.option(form.Value, "description", _("Description"), "Description");
		o.optional = true;
		o.datatype = "string";
		o = s.option(form.ListValue, 'ack_required', _('ACK required'));
		o.value("0","NONE");
		o.value("1","OFFNORMAL");
		o.value("2","FAULT");
		o.value("3","OFFNORMAL and FAULT");
		o.value("4","NORMAL");
		o.value("5","OFFNORMAL and NORMAL");
		o.value("6","FAULT and NORMAL");
		o.value("7","OFFNORMAL and FAULT and NORMAL");
		o = s.option( form.Value, "prio_offnormal", _("prio offnormal"), "254");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "range(0,254)";
		o = s.option( form.Value, "prio_offnormal", _("prio_fault"), "254");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "range(0,254)";
		o = s.option( form.Value, "prio_offnormal", _("prio_normal"), "254");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "range(0,254)";
		o = s.option( form.DynamicList, "recipient", _("recipients"), "d,device ID d,1010 | n,net ID,ip addr:Port n,0,192.168.104.58:47808 | n,net ID n,65535");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "string";
		return m.render();
	}
});
