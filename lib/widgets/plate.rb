module Widgets
  class Plate
    extend Collection

    def initialize(length:, width:, pos:)
      @shape = Ray::Polygon.rectangle([0,0,length,width], Ray::Color.gray)
      @shape.pos = pos

      @length = length
      @width = width
      @active = false
    end

    attr_reader :shape

    def draw_on(win)
      win.draw(@shape)
    end

    def contain?(pos)
      [@shape.x, @shape.y, @length, @width].to_rect.contain?(pos)
    end

    def activate
      @shape.color = Ray::Color.new(200,200,200)
      @active = true
    end

    def deactivate
      @shape.color = Ray::Color.gray
      @active = false
    end

    def active?
      @active
    end
  end
end