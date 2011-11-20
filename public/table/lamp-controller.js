var LampController = new Class({
	initialize: function(lamp, light) {
		this.lamp = lamp;
		this.light = light;
	},
	
	on: function() {
		this.lamp.addClass("on")
		this.light.addClass("on")
	},
	
	off: function() {
		this.lamp.removeClass("on")
		this.light.removeClass("on")
	}
})