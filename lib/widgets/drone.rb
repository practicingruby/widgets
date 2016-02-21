module Widgets
  class Drone
    extend Collection

    def initialize(start_pos:, finish_pos:, speed: 4)
      @radius = 8
      @start  = Ray::Vector2[*start_pos]
      @finish = Ray::Vector2[*finish_pos]
      @shape  = Ray::Polygon.circle([0,0],@radius, Ray::Color.yellow)
      @speed  = speed
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

        @start = @shape.pos
        @finish = nil
      end
    end

    def click(pos)
      @finish = pos
      Focus.blur
    end

    def toggle
      @status = { :running => :stopped, :stopped => :running }[@status]
    end

    def run
      @status = :running
    end

    def stop
      @status = :stopped
    end

    def operate
      dest = @destination.peek

      dx = dest.x - @shape.pos.x
      dy = dest.y - @shape.pos.y

      d = Math.hypot(dx,dy)

      if dest == @finish
        @widget ||= Widget.find { |w|
          idx = w.pos.x - @shape.pos.x
          idy = w.pos.y - @shape.pos.y

          Math.hypot(idx, idy) < 10
        }

        if @widget
          @widget.move_to(@shape.pos) 
          @status = :running
        end
      else
        @widget = nil
      end

      return unless @status == :running

      if d < 5
        @destination.next
        @status = :stopped if @destination.peek == @finish
      else
        steps = d/@speed
        @shape.pos += [dx/steps, dy/steps]
      end
    end

    def draw_on(win)
      win.draw(@shape)
      operate
    end
  end
end