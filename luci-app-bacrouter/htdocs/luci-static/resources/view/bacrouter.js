'use strict';
'require rpc';
'require view';
'require form';
'require tools.widgets as widgets';

var callFileList = rpc.declare({
	object: 'file',
	method: 'list',
	params: [ 'path' ],
	expect: { entries: [] },
	filter: function(list, params) {
		var rv = [];
		for (var i = 0; i < list.length; i++)
			if (list[i].name.match(/^ttyUSB/) || list[i].name.match(/^ttyS/) || list[i].name.match(/^ttyACM/))
				rv.push(params.path + list[i].name);
		return rv.sort();
	}
});

return view.extend({
	render: function() {
		var m, s, o;

		m = new form.Map('bacrouter', 'BACnet Router');
		m.tabbed = true;
		s = m.section(form.GridSection, 'dev', _('interface configuration section'));
		s.anonymous = true;
		s.addremove = true;
		s.addbtntitle = _('Add new interface...');
		o = s.option(form.Flag, 'enable', _('Enabled'));
		o.rmempty = false;
		o = s.option(form.ListValue, 'bacdl', _('Data link'));
		//o.value('arcnet','Arcnet');
		o.value('bip','IPv4');
		//o.value('bip6','IPv6');
		//o.value('ethernet','Ethernet');
		o.value('mstp','MSTP/RS485');
		o.optional = true;
		//o = s.option(form.Value, "iface", _("Interface"), _("The interface bacnet should serve."));
		o = s.option(widgets.NetworkSelect, 'iface', _('Device name', 'lan'));
		o.depends('bacdl', 'arcnet');
		o.depends('bacdl', 'bip');
		o.depends('bacdl', 'bip6');
		o.depends('bacdl', 'ethernet');
		o.datatype = "string";
		o = s.option(form.Value, "serial", _("Serial Port"), _("The Serial Port bacnet should serve. /dev/ttyUSB0"));
		o.depends('bacdl', 'mstp');
		o.datatype = "string";
		o.placeholder = "/dev/ttyUSB0";
		o.load = function(section_id) {
			return callFileList('/dev/').then(L.bind(function(devices) {
				for (var i = 0; i < devices.length; i++)
					this.value(devices[i]);
				return form.Value.prototype.load.apply(this, [section_id]);
			}, this));
		};
		o = s.option(form.Value, "port", _("IP Port"), "47808");
		o.depends('bacdl', 'bip');
		o.depends('bacdl', 'bip6');
		o.optional = true;
		o.placeholder = 47808;
		o.datatype = "portrange";
		o = s.option(form.Value, "mac", _("MAC for MSTP"), "1");
		o.depends('bacdl', 'mstp');
		o.optional = true;
		o.rmempty = true;
		o.datatype = "range(0,127)";
		o.placeholder = 1;
		o = s.option(form.Value, "max_master", _("MAX Master for MSTP"), "127");
		o.depends('bacdl', 'mstp');
		o.optional = true;
		o.rmempty = true;
		o.datatype = "range(0,127)";
		o.placeholder = 127;
		o = s.option(form.Value, "max_frames", _("MAX Frames for MSTP"), "128");
		o.depends('bacdl', 'mstp');
		o.optional = true;
		o.rmempty = true;
		o.datatype = "range(0,128)";
		o.modalonly = true;
		o.placeholder = 128;
		o = s.option(form.ListValue, "baud", _("Datarate"), "38400");
		o.depends('bacdl', 'mstp');
		o.value("9600");
		o.value("19200");
		o.value("38400");
		o.value("57600");
		o.value("115200");
		o.optional = true;
		o = s.option(form.ListValue, "parity_bit", _("Parity Bit"), "N");
		o.depends('bacdl', 'mstp');
		o.value("N");
		o.value("O");
		o.value("E");
		o.optional = true;
		o = s.option(form.ListValue, "data_bit", _("Data Bit"), "8");
		o.depends('bacdl', 'mstp');
		o.value("5");
		o.value("6");
		o.value("7");
		o.value("8");
		o.optional = true;
		o = s.option(form.ListValue, "stop_bit", _("Stop Bit"), "1");
		o.depends('bacdl', 'mstp');
		o.value("1");
		o.value("2");
		o.optional = true;
		o = s.option( form.Value, "net", _("NET Number"), "6661");
		o.optional = true;
		o.rmempty = true;
		o.datatype = "portrange";
		o.modalonly = true;
		return m.render();
	}
});
