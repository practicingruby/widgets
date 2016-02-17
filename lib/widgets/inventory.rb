module Widgets
  class Inventory
    def initialize
      @waypoints = []
      @markers   = []
      @drones    = []
    end

    attr_reader :drones, :markers, :waypoints

    def add_widget
      Widget.create(:pos      => [rand(50..500), rand(50..500)],
                    :color    => Ray::Color.cyan,
                    :radius   => 5)
    end

    def add_drone(start, finish)
      return if @drones.length == 3

      shape = Ray::Polygon.circle([0,0], 10, Ray::Color.yellow)
      shape.pos = start

      drone = Drone.new(start, finish, shape)

      @drones << drone
    end

    def click(pos)
      @markers.clear if @waypoints.empty?

      point = Ray::Polygon.rectangle([-3,-3,6,6], Ray::Color.white)
      point.pos = pos
      point.angle = 45

      @waypoints << point



      if @waypoints.size == 2
        create_path
      end
    end

    def create_path
      start = Ray::Polygon.rectangle([-2,-2,4,4], Ray::Color.green)
      start.pos = @waypoints.first.pos
      start.angle = 45

      finish = Ray::Polygon.rectangle([-2,-2,4,4], Ray::Color.red)
      finish.pos = @waypoints.last.pos
      finish.angle = 45

      @markers << start
      @markers << finish

      add_drone(start.pos, finish.pos)
      
      @waypoints.clear
    end


    def draw_on(win)
      @drones.each    { |e| win.draw(e.shape); e.tick }
      Widget.all.each do |e| 
        if e.pos.x > 975
          Widget.delete(e)
        else
          e.draw_on(win) 
        end
      end
      @markers.each   { |e| win.draw(e) } 
      @waypoints.each { |e| win.draw(e) }
    end
  end
end