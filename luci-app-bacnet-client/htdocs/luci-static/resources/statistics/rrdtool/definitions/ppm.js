/* Licensed to the public under the Apache License 2.0. */

'use strict';
'require baseclass';

return baseclass.extend({
	title: _('Air CO2'),

	rrdargs: function(graph, host, plugin, plugin_instance, dtype) {
		return {
			title: "%H: Air CO2 of %pi",
			alt_autoscale: true,
			vlabel: "CO2 ppm",
			number_format: "%3.1lf%s",
			data: {
				types: [ "objects" ],
				options: {
					objects: {
						color: "ff0000",
						title: "CO2",
						noarea: true
					}
				}
			}
		};
	}
});
