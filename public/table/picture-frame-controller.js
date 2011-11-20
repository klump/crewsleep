/**
 * Person display controller
 */
var PictureFrameController = new Class({
    initialize: function(pictureFrame, pictureFrameImage) {
        this.pictureFrame = pictureFrame
        this.pictureFrameImage = pictureFrameImage

        this.pictureFrameImage.addEvent("load", this.show.bind(this))
    },

    show: function() {
        this.pictureFrame.removeClass("hidden")
    },

    hide: function() {
        this.pictureFrame.addClass("hidden")
    },

    updateAndShow: function(avatarUrl) {
        this.pictureFrameImage.set("src", avatarUrl)
    }
})