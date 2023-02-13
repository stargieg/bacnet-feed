/* Licensed to the public under the Apache License 2.0. */

'use strict';
'require baseclass';

return baseclass.extend({
	title: _('Control'),

	rrdargs: function(graph, host, plugin, plugin_instance, dtype) {
		return {
			title: "%H: Control of %pi",
			alt_autoscale: true,
			vlabel: "%",
			number_format: "%3.1lf%s",
			data: {
				types: [ "percent" ],
				options: {
					percent: {
						color: "ff0000",
						title: "Percent",
						noarea: true
					}
				}
			}
		};
	}
});
