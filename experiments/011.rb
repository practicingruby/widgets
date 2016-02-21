require_relative "../lib/widgets"

include Widgets

Ray::Game.new("Experiment #011", :size => [1024,768]) do  
  Drone.create(:pos   => [100,100],
               :speed => 1)

 Drone.create(:pos   => [200,100],
              :speed => 1)

  Drone.create(:pos   => [300,100],
               :speed => 1)

  register do
    add_hook :quit, method(:exit!)
  end

  scene :factory do
    render do |win|
      Drone.draw_all(win)

      if Widgets.paused?
        stop_top = Ray::Polygon.rectangle([0,0,1024,20], Ray::Color.new(100,0,0))
        stop_top.pos = [0,0]

        win.draw(stop_top)

        stop_bottom = Ray::Polygon.rectangle([0,0,1024,20], Ray::Color.new(100,0,0))
        stop_bottom.pos = [0,748]

        win.draw(stop_bottom)
      end
    end

    always do
      # do nothing
    end
      
    on :mouse_press do |button, pos|
      Widgets.pause

      Focus.click(pos)

      if Focus.activated == Focus::NullObject && drone = Drone.find { |e| e.selected?(pos) }
        Focus.select(drone)
      end
    end

    on :key_press, key(:space) do
      Widgets.toggle_pause
    end

    on :key_press, key(:return) do
      # do nothing
    end
  end

  scenes << :factory
end