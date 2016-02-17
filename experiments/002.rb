require_relative "../lib/widgets"


Ray::Game.new("Experiment #002", :size => [1024,768]) do
  inventory = Widgets::Inventory.new
  inventory.add_widget

  register do
    add_hook :quit, method(:exit!)
  end

  scene :square do
    drawables = []

    rect = Ray::Polygon.rectangle([0,0,50,768], Ray::Color.gray)
    rect.pos = [1024-50,0]

    drawables << rect

    render do |win|
      inventory.add_widget if rand(1..20) == 1 && Widgets::Widget.count < 100
      
      drawables.each do |e| 
        win.draw(e)
      end
      
      inventory.draw_on(win)
    end

    on :mouse_press do |button, pos|
      inventory.click(pos)
    end

    on :key_press, key(:space) do
      inventory.drones.each { |e| e.toggle }
    end

    on :key_press, key(:return) do
      inventory.drones.clear
      inventory.markers.clear
      inventory.waypoints.clear
    end
  end

  scenes << :square
end