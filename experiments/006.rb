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

  Conveyor.create(:pos => [0,100], :length => 200, :height => 50)

  Conveyor.create(:pos => [0,200], :length => 200, :height => 50)

  register do
    add_hook :quit, method(:exit!)
  end

  scene :factory do
    render do |win|
      Conveyor.draw_all(win)
      Machine.draw_all(win)
      Drone.draw_all(win)
      Widget.draw_all(win)
    end

    always do
      if Widget.none? { |e| e.color == :blue }
        Widget.create(:pos => [0,125], :radius => 4, :color => Ray::Color.cyan)
      end

      if Widget.none? { |e| e.color == :red }
        Widget.create(:pos => [0,225], :radius => 4, :color => Ray::Color.red)
      end  
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