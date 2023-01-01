'use strict';
'require view';
'require form';
'require tools.widgets as widgets';

return view.extend({
	render: function() {
		var m, s, o;

		m = new form.Map('bacnet_tl', 'Trendlog');
		m.tabbed = false;
		s = m.section(form.TypedSection, 'tl', _('Trendlog configuration section'));
		s.anonymous = false;
		s.addremove = true;
		s.addbtntitle = _('Add new Trendlog Object...');
		o = s.option(form.Flag, 'disable', _('Disable'));
		o.rmempty = false;
		o = s.option(form.Value, "name", _("Name"), "Name");
		o.optional = false;
		o.datatype = "string";
		o = s.option(form.Value, "description", _("Description"), "Description");
		o.optional = true;
		o.datatype = "string";
		o = s.option(form.ListValue, 'type', _('type'));
		o.value("0","Polled");
		o.value("2","COV");
		o = s.option( form.Value, "interval", _("interval in s"), "900");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "uinteger";
		o = s.option( form.Value, "device_id", _("device_id"), "4712");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "port";
		o = s.option(form.Flag, 'subscribetoproperty', _('subscribe to property'), _('PRESENT_VALUE'));
		o.rmempty = false;
		o = s.option( form.Value, "lifetime", _("lifetime"), "300");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "uinteger";
		o = s.option( form.Value, "object_instance", _("object_instance"), "0");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "port";
		o = s.option(form.ListValue, 'object_type', _('object_type'));
		o.value("0","Analog Input");
		o.value("1","Analog Output");
		o.value("2","Analog Value");
		o.value("3","Binary Input");
		o.value("4","Binary Output");
		o.value("5","Binary Value");
		o.value("13","Multistate Input");
		o.value("14","Multistate Output");
		o.value("19","Multistate Value");
		return m.render();
	}
});
