/* Licensed to the public under the Apache License 2.0. */

'use strict';
'require baseclass';

return baseclass.extend({
	title: _('BAC Unit'),

	rrdargs: function(graph, host, plugin, plugin_instance, dtype) {
		var p = [];
		var binary = {
			title: "%H: Binary of %pi",
			alt_autoscale: true,
			vlabel: "Binary",
			number_format: "%1.0lf%s",
			data: {
				types: [ "bool" ],
				options: {
					bool__value: {
						title: "%di",
						overlay: true,
						noarea: true
					}
				}
			}
		};
		var control = {
			title: "%H: Control of %pi",
			alt_autoscale: true,
			vlabel: "%",
			number_format: "%3.1lf%s",
			data: {
				types: [ "percent" ],
				options: {
					percent__value: {
						title: "%di",
						overlay: true,
						noarea: true
					}
				}
			}
		};
		var speed = {
			title: "%H: Speed of %pi",
			alt_autoscale: true,
			vlabel: "Hz",
			number_format: "%3.1lf%s",
			data: {
				types: [ "frequency" ],
				options: {
					frequency__value: {
						title: "%di",
						overlay: true,
						noarea: true
					}
				}
			}
		};
		var pascals = {
			title: "%H: Pressure of %pi",
			alt_autoscale: true,
			vlabel: "Pa",
			number_format: "%3.1lf%s",
			data: {
				types: [ "pressure" ],
				options: {
					pressure__value: {
						title: "%di",
						overlay: true,
						noarea: true
					}
				}
			}
		};
		var flowrate = {
			title: "%H: Flow rate of %pi",
			alt_autoscale: true,
			vlabel: "m3/h",
			number_format: "%3.1lf%s",
			data: {
				types: [ "flow" ],
				options: {
					flow__value: {
						title: "%di",
						overlay: true,
						noarea: true
					}
				}
			}
		};
		var temperature = {
			title: "%H: Temperature of %pi",
			alt_autoscale: true,
			vlabel: "\xb0C",
			number_format: "%4.1lf\xb0C",
			data: {
				types: [ "temperature" ],
				options: {
					temperature__value: {
						title: "%di",
						overlay: true,
						noarea: true
					}
				}
			}
		};
		var ppm = {
			title: "%H: CO2 Particles of %pi",
			alt_autoscale: true,
			vlabel: "CO2 ppm",
			number_format: "%3.1lf%s",
			data: {
				types: [ "objects" ],
				options: {
					objects__value: {
						title: "%di",
						overlay: true,
						noarea: true
					}
				}
			}
		};
		var humidity = {
			title: "%H: Humidity of %pi",
			alt_autoscale: true,
			vlabel: "%",
			number_format: "%2.1lf%s",
			data: {
				types: [ "humidity" ],
				options: {
					humidity__value: {
						title: "%di",
						overlay: true,
						noarea: true
					}
				}
			}
		};
		var types = graph.dataTypes(host, plugin, plugin_instance);
		for (var i = 0; i < types.length; i++)
			if (types[i] == 'bool')
				p.push(binary);
			else if (types[i] == 'percent')
				p.push(control);
			else if (types[i] == 'frequency')
				p.push(speed);
			else if (types[i] == 'flow')
				p.push(flowrate);
			else if (types[i] == 'pressure')
				p.push(pascals);
			else if (types[i] == 'objects')
				p.push(ppm);
			else if (types[i] == 'temperature')
				p.push(temperature);
			else if (types[i] == 'humidity')
				p.push(humidity);
		return p;
	}
});
