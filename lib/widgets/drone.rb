module Widgets
  class Drone
    def initialize(start, finish, shape)
      @start  = start
      @finish = finish
      @shape  = shape
      @destination = [@finish, @start].cycle
      @widget      = nil

      @status = :running
    end

    attr_reader :shape

    def toggle
      @status = { :running => :stopped, :stopped => :running }[@status]
    end

    def tick
      return unless @status == :running

      dest = @destination.peek

      dx = dest.x - @shape.pos.x
      dy = dest.y - @shape.pos.y

      d = Math.hypot(dx,dy)

      if d < 5
        @destination.next
      else
        steps = d/2
        @shape.pos += [dx/steps, dy/steps]
      end

      if dest == @finish

        @widget ||= Widget.all.find { |w|
          idx = w.pos.x - @shape.pos.x
          idy = w.pos.y - @shape.pos.y

          Math.hypot(idx, idy) < 10
        }

        @widget.move_to(@shape.pos) if @widget
      else
        @widget = nil
      end
    end
  end
end