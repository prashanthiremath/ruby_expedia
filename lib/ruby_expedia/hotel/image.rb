module RubyExpedia
  class Image
    attr_accessor :id, :url, :caption, :width, :height, :thumbnail_url, :name

    def initialize(data)
      @id = data["hotelImageId"]
      @name = data["name"]
      @caption = data["caption"]
      @url = data["url"]
      @thumbnail_url = data["thumbnailURL"]
      @width = data["width"]
      @height = data["height"]
    end

    def size
      width.to_s + "x" + height.to_s
    end
  end
end
