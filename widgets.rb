require 'ray'

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
    $inventory.add_widget if rand(1..20) == 1 && $inventory.widgets.size < 100

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

      @widget ||= $inventory.widgets.find { |w|
        idx = w.pos.x - @shape.pos.x
        idy = w.pos.y - @shape.pos.y

        Math.hypot(idx, idy) < 10
      }

      @widget.pos = @shape.pos if @widget
    else
      @widget = nil
    end
  end

end

class Inventory
  def initialize
    @waypoints = []
    @markers   = []
    @drones    = []
    @widgets   = []
  end

  attr_reader :drones, :widgets, :markers, :waypoints

  def add_widget
    shape = Ray::Polygon.circle([0,0], 5, Ray::Color.cyan)
    shape.pos = [rand(50..500), rand(50..500)]

    @widgets << shape
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
    @widgets.each   { |e| win.draw(e) }
    @markers.each   { |e| win.draw(e) } 
    @waypoints.each { |e| win.draw(e) }
  end
end

$inventory = Inventory.new
$inventory.add_widget

class DroneBuilder
  attr_reader :positions

  def click(pos)
    $inventory.click(pos) 
  end
end

Ray::Game.new("Hello world!", :size => [1024,768]) do
  register do
    add_hook :quit, method(:exit!)
  end

  scene :square do
    drawables = []

    rect = Ray::Polygon.rectangle([0,0,50,768], Ray::Color.gray)
    rect.pos = [1024-50,0]

    builder = DroneBuilder.new

    drawables << rect

    render do |win|
      drawables.each do |e| 
        win.draw(e)
      end
      
      $inventory.draw_on(win)
    end

    on :mouse_press do |button, pos|
      builder.click(pos)
    end

    on :key_press, key(:space) do
      $inventory.drones.each { |e| e.toggle }
    end

    on :key_press, key(:return) do
      $inventory.drones.clear
      $inventory.markers.clear
      $inventory.waypoints.clear
    end
  end

  scenes << :square
end