/* Licensed to the public under the Apache License 2.0. */

'use strict';
'require baseclass';

return baseclass.extend({
	title: _('Humidity'),

	rrdargs: function(graph, host, plugin, plugin_instance, dtype) {
		return {
			title: "%H: Humidity of %pi",
			alt_autoscale: true,
			vlabel: "%",
			number_format: "%3.1lf%s",
			data: {
				types: [ "humidity" ],
				options: {
					humidity: {
						color: "ff0000",
						title: "Humidity",
						noarea: true
					}
				}
			}
		};
	}
});
