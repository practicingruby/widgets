module Widgets
  class Drone
    extend Collection

    

    def initialize(pos:, speed: 4)
      @radius      = 8
      @shape       = Ray::Polygon.circle([0,0],@radius, Ray::Color.yellow)
      @speed       = speed
      @shape.pos   = pos
      @destination = @shape.pos
      @widget      = nil
    end

    attr_reader :shape

    def selected?(pos)
      @shape.pos.distance(pos) <= @radius
    end

    def blur
      @shape.color = Ray::Color.yellow
    end

    def focus
      @shape.color = Ray::Color.new(235,123,12)
    end

    def click(pos)
      @destination = pos
      Focus.blur
    end

    def operate
      return if Widgets.paused?

      dest = @destination

      dx = dest.x - @shape.pos.x
      dy = dest.y - @shape.pos.y

      d = Math.hypot(dx,dy)

      if d < 5
        @destination = @shape.pos
      else
        steps = d/@speed
        @shape.pos += [dx/steps, dy/steps]
      end
    end

    def draw_on(win)
      win.draw(@shape)

      if Widgets.paused?
        win.draw(Graphics.line(@shape.pos, @destination))
      end

      operate
    end
  end
end