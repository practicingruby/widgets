module Widgets
  class Drone
    extend Collection

    def initialize(start_pos:, finish_pos:)
      @radius = 8
      @start  = Ray::Vector2[*start_pos]
      @finish = Ray::Vector2[*finish_pos]
      @shape  = Ray::Polygon.circle([0,0],@radius, Ray::Color.yellow)
      @shape.pos = @start
      @destination = [@finish, @start].cycle
      @widget      = nil

      @status = :stopped
    end

    attr_reader :shape

    def selected?(pos)
      @shape.pos.distance(pos) <= @radius
    end

    def blur
      @shape.color = Ray::Color.yellow

      @destination = [@finish, @start].cycle
      @status = :running
    end

    def focus
      if @status == :running
        Focus.blur
      else
        @shape.color = Ray::Color.new(235,123,12)

        @status = :stopped

        @start = nil
        @finish = nil
      end
    end

    def click(pos)
      if @start.nil?
        @start = pos
        @shape.pos = @start
      else
        @finish = pos
        Focus.blur
      end
    end

    def toggle
      @status = { :running => :stopped, :stopped => :running }[@status]
    end

    def operate
      return unless @status == :running

      dest = @destination.peek

      dx = dest.x - @shape.pos.x
      dy = dest.y - @shape.pos.y

      d = Math.hypot(dx,dy)

      if d < 5
        @destination.next
      else
        steps = d/3
        @shape.pos += [dx/steps, dy/steps]
      end

      if dest == @finish

        @widget ||= Widget.find { |w|
          idx = w.pos.x - @shape.pos.x
          idy = w.pos.y - @shape.pos.y

          Math.hypot(idx, idy) < 10
        }

        @widget.move_to(@shape.pos) if @widget
      else
        @widget = nil
      end
    end

    def draw_on(win)
      win.draw(@shape)
      operate
    end
  end
end