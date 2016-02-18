require_relative "../lib/widgets"

include Widgets

Ray::Game.new("Experiment #006", :size => [1024,768]) do
  Machine.create(:pos     => [1024/2.0, 768/2.0],
                 :color   => Ray::Color.new(150,150,150),
                 :radius  => 100)

  
  Drone.create(:start_pos => [500,200],
               :finish_pos => [500,200])

               
  Drone.create(:start_pos => [550,200],
               :finish_pos => [550,200])

  100.times do
    Widget.create(:pos => [rand(150..350), rand(150..300)], :color => Ray::Color.red, :radius => 4)
    Widget.create(:pos => [rand(700..900), rand(150..300)], :color => Ray::Color.cyan, :radius => 4)
  end

  register do
    add_hook :quit, method(:exit!)
  end

  scene :factory do
    render do |win|
      Machine.each { |e| e.draw_on(win) }
      Drone.each { |e| e.draw_on(win) }
      Widget.each { |e| e.draw_on(win)  }
    end

    always do
      # do nothing
    end
      

    on :mouse_press do |button, pos|
      Focus.click(pos)

      
      if Focus.activated == Focus::NullObject && drone = Drone.find { |e| e.selected?(pos) }
        Focus.select(drone)
      end
    end

    on :key_press, key(:space) do
      Drone.each { |e| e.toggle }
    end

    on :key_press, key(:return) do
      Widget.delete_all
    end
  end

  scenes << :factory
end