/* Licensed to the public under the Apache License 2.0. */

'use strict';
'require baseclass';

return baseclass.extend({
	title: _('Flow rate'),

	rrdargs: function(graph, host, plugin, plugin_instance, dtype) {
		return {
			title: "%H: Flow rate of %pi",
			alt_autoscale: true,
			vlabel: "m3/h",
			number_format: "%3.1lf%s",
			data: {
				types: [ "flow" ],
				options: {
					flow: {
						color: "ff0000",
						title: "Flow rate m3/h",
						noarea: true
					}
				}
			}
		};
	}
});
