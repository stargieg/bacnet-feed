'use strict';
'require view';
'require form';
'require tools.widgets as widgets';

return view.extend({
	render: function() {
		var m, s, o;

		m = new form.Map('bacnet_bo', 'Binary Output');
		m.tabbed = false;
		s = m.section(form.TypedSection, 'bo', _('Binary Output configuration section'));
		s.anonymous = false;
		s.addremove = true;
		s.addbtntitle = _('Add new Binary Output Object...');
		o = s.option(form.Flag, 'disable', _('Disable'));
		o.rmempty = false;
		o = s.option(form.Flag, 'Out_Of_Service', _('Out Of Service'));
		o.rmempty = false;
		o = s.option(form.Value, "name", _("Name"), "Name");
		o.optional = false;
		o.datatype = "string";
		o = s.option(form.Value, "description", _("Description"), "Description");
		o.optional = true;
		o.datatype = "string";
		o = s.option(form.Value, "active_text", _("Active Text"), "Active Text");
		o.optional = true;
		o.datatype = "string";
		o = s.option(form.Value, "inactive_text", _("Inactive Text"), "Inactive Text");
		o.optional = true;
		o.datatype = "string";
		o = s.option(form.Flag, "alarm_value", _("Alarm Value"));
		o.optional = true;
		o = s.option( form.Flag, "value", _("Value"), "0");
		o.optional = true;
		o.rmempty = true;
		o = s.option( form.Value, "nc", _("Notification Class"), "0");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "port";
		o = s.option( form.ListValue, "event", _("Event Enable"), "0");
		o.optional = true;
		o.rmempty = true;
		o.value("0","NONE");
		o.value("1","OFFNORMAL");
		o.value("2","FAULT");
		o.value("3","OFFNORMAL and FAULT");
		o.value("4","NORMAL");
		o.value("5","OFFNORMAL and NORMAL");
		o.value("6","FAULT and NORMAL");
		o.value("7","OFFNORMAL and FAULT and NORMAL");
		o = s.option( form.Value, "time_delay", _("Time Delay in s"), "0");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "uinteger";
		o = s.option( form.ListValue, "notify_type", _("Notify Type"), "0");
		o.value("0","Alarm");
		o.value("1","Event");
		o.optional = true;
		o.rmempty = true;
		return m.render();
	}
});
