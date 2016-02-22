module Widgets
  class Drone
    extend Collection

    def initialize(pos:, speed: 4)
      @radius       = 8
      @shape        = Ray::Polygon.circle([0,0],@radius, Ray::Color.yellow)
      @speed        = speed
      @shape.pos    = pos
      @destination  = @shape.pos
      @widget       = nil    
      @controller   = SingleMoveController.new(self)
    end

    attr_reader   :shape
    attr_accessor :destination

    def selected?(pos)
      @shape.pos.distance(pos) <= @radius
    end

    def blur
      @shape.color = Ray::Color.yellow

      @controller.blur
    end

    def focus
      if Focus.shift
        @controller = PatrolController.new(self)
      else
        @controller = SingleMoveController.new(self)
      end

      @controller.focus
    end

    def click(button, pos)
      @controller.click(button, pos)
    end

    def operate
      return if Widgets.paused?

      @controller.operate

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
      @controller.draw_on(win)
      win.draw(@shape)

      operate
    end

    class SingleMoveController
      def initialize(drone)
        @drone = drone
        @mode  = :pickup
      end

      def click(button, pos)
        @mode = (button == :left ? :pickup : :dropoff)
        @drone.destination = pos

        Focus.blur  
      end

      def blur
        # do nothing
      end

      def focus
        @drone.shape.color = Ray::Color.new(235,123,12)
      end

      def operate
        if @mode == :pickup
          @widget ||= Widget.find { |w|
            idx = w.pos.x - @drone.shape.pos.x
            idy = w.pos.y - @drone.shape.pos.y

            Math.hypot(idx, idy) < 10
          }

          if @widget
            @widget.move_to(@drone.shape.pos) 
          end
        else
          @widget = nil
        end
      end

      def draw_on(win)
        return unless Widgets.paused?

        line_color = (@mode == :pickup ? Ray::Color.green : Ray::Color.red)
        win.draw(Graphics.line(@drone.shape.pos, @drone.destination,
                               :color => line_color))
      end
    end

    class PatrolController
      def initialize(drone)
        @drone   = drone
        @start   = nil
        @finish  = nil
        @destinations = [@drone.shape.pos, @drone.shape.pos].cycle
        @repositioning = true
      end

      def focus
        @drone.shape.color = Ray::Color.new(123,235,12)
        @drone.destination = @drone.shape.pos
      end

      def blur
        @destinations  = [@start, @finish].cycle
        @repositioning = true
      end
      
      def click(button, pos)
        if @start.nil?
          @start = pos
        else
          @finish = pos
          Focus.blur
        end
      end

      def operate
        dest = @destinations.peek
        @drone.destination = dest

        dx = dest.x - @drone.shape.pos.x
        dy = dest.y - @drone.shape.pos.y

        d = Math.hypot(dx,dy)

        if dest == @finish
          @widget ||= Widget.find { |w|
            idx = w.pos.x - @drone.shape.pos.x
            idy = w.pos.y - @drone.shape.pos.y

            Math.hypot(idx, idy) < 10
          }

          if @widget
            @widget.move_to(@drone.shape.pos) 
          end
        else
          @widget = nil
        end

        if d < 5
          @drone.destination = @destinations.next
          @repositioning = false
        end
    
      end

      def draw_on(win)
        return unless Widgets.paused?
        return if @start.nil? && @finish.nil?
      
        if @repositioning
          win.draw Graphics.line(@drone.shape.pos, @start, :color => Ray::Color.gray)
        end

        win.draw Ray::Polygon.circle(@start, 3, Ray::Color.green)        

        if @finish
          win.draw Graphics.line(@start, @finish, :color => Ray::Color.cyan)
          win.draw Ray::Polygon.circle(@finish, 3, Ray::Color.red)
        end
      end
    end
  end
end