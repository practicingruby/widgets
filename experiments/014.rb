require_relative "../lib/widgets"

include Widgets

Ray::Game.new("Experiment #014", :size => [1024,768]) do  
  Drone.create(:pos => [60,255], :speed => 3, :radius => 9)
  Drone.create(:pos => [90,255], :speed => 3, :radius => 9)
  Drone.create(:pos => [120,255], :speed => 3, :radius => 9)


  Widget.create(:pos => [240, 300], :color => Ray::Color.new(200,0,200), :radius => 6)

  
  register do
    add_hook :quit, method(:exit!)
  end

  scene :factory do
    always do
      Focus.shift = holding?(:lshift)
    end

    render do |win|
      Drone.draw_all(win)
      Widget.draw_all(win)

      if Widgets.paused?
        stop_top = Ray::Polygon.rectangle([0,0,1024,20], Ray::Color.new(100,0,0))
        stop_top.pos = [0,0]

        win.draw(stop_top)

        stop_bottom = Ray::Polygon.rectangle([0,0,1024,20], Ray::Color.new(100,0,0))
        stop_bottom.pos = [0,748]

        win.draw(stop_bottom)
      end
    end

    on :mouse_press do |button, pos|
      Widgets.pause

      Focus.click(button, pos)
      
      if Focus.activated == Focus::NullObject && drone = Drone.find { |e| e.selected?(pos) }
        Focus.select(drone)
      end
    end

    on :key_press, key(:space) do
      Widgets.toggle_pause
    end

    on :key_press, key(:return) do

    end
  end

  scenes << :factory
end