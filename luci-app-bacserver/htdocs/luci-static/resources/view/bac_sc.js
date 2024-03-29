'use strict';
'require view';
'require form';
'require tools.widgets as widgets';

return view.extend({
	render: function() {
		var m, s, o;

		m = new form.Map('bacnet_sc', 'Schedule');
		m.tabbed = false;
		s = m.section(form.TypedSection, 'sc', _('Schedule configuration section'));
		s.anonymous = false;
		s.addremove = true;
		s.addbtntitle = _('Add new Schedule Object...');
		o = s.option(form.Flag, 'disable', _('Disable'));
		o.rmempty = false;
		o = s.option(form.Value, "name", _("Name"), "Name");
		o.optional = false;
		o.datatype = "string";
		o = s.option(form.Value, "description", _("Description"), "Description");
		o.optional = true;
		o.datatype = "string";
		o = s.option( form.Value, "prio", _("prio"), "16");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "range(1,16)";
		o = s.option( form.Value, "default", _("default Value"),"0=NULL 1=Bool 4=Real 9=Enum, Value e.g. 1,0 or 4,23.5 or 9,3");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "string";
		o = s.option( form.DynamicList, "weekly_0", _("Monday"), "Hour,Minute,Second,0=NULL 1=Bool 4=Real 9=Enum, Value e.g. 1,0 or 4,23.5 or 9,3");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "string";
		o = s.option( form.DynamicList, "weekly_1", _("Tuesday"), "Hour,Minute,Second,0=NULL 1=Bool 4=Real 9=Enum, Value e.g. 1,0 or 4,23.5 or 9,3");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "string";
		o = s.option( form.DynamicList, "weekly_2", _("Wednesday"), "Hour,Minute,Second,0=NULL 1=Bool 4=Real 9=Enum, Value e.g. 1,0 or 4,23.5 or 9,3");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "string";
		o = s.option( form.DynamicList, "weekly_3", _("Thursday"), "Hour,Minute,Second,0=NULL 1=Bool 4=Real 9=Enum, Value e.g. 1,0 or 4,23.5 or 9,3");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "string";
		o = s.option( form.DynamicList, "weekly_4", _("Friday"), "Hour,Minute,Second,0=NULL 1=Bool 4=Real 9=Enum, Value e.g. 1,0 or 4,23.5 or 9,3");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "string";
		o = s.option( form.DynamicList, "weekly_5", _("Saturday"), "Hour,Minute,Second,0=NULL 1=Bool 4=Real 9=Enum, Value e.g. 1,0 or 4,23.5 or 9,3");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "string";
		o = s.option( form.DynamicList, "weekly_6", _("Sunday"), "Hour,Minute,Second,0=NULL 1=Bool 4=Real 9=Enum, Value e.g. 1,0 or 4,23.5 or 9,3");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "string";
		o = s.option( form.DynamicList, "references", _("Reference Objects"), "Device ID (-1 for local), ai=0 ao=1 av=2 bi=3 bo=4 bv=5 mi=13 mo=14 mv=19, Instance ID");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "string";
		return m.render();
	}
});
