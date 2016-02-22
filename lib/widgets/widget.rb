module Widgets
  class Widget
    extend Collection
    def initialize(radius:, color:, pos:)
      @radius     = radius
      @color      = color
      
      @shape      = Ray::Polygon.circle([0,0], radius, color)
      @shape.pos  = pos
    end
    
    attr_reader :radius, :color

    def pos
      @shape.pos
    end

    def move_to(pos)
      @shape.pos = pos
    end

    def color_name
      { Ray::Color.cyan => :blue,
        Ray::Color.red  => :red }[@color]
    end

    def draw_on(win)
      win.draw(@shape)
    end
  end
end