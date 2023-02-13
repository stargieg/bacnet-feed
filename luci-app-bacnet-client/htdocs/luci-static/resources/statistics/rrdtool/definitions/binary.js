/* Licensed to the public under the Apache License 2.0. */

'use strict';
'require baseclass';

return baseclass.extend({
	title: _('Binary'),

	rrdargs: function(graph, host, plugin, plugin_instance, dtype) {
		return {
			title: "%H: Binary of %pi",
			alt_autoscale: true,
			vlabel: "Binary",
			number_format: "%1.0lf%s",
			data: {
				types: [ "bool" ],
				options: {
					bool: {
						color: "ff0000",
						title: "Binary",
						noarea: true
					}
				}
			}
		};
	}
});
