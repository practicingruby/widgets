require_relative "../lib/widgets"

include Widgets

Ray::Game.new("Experiment #009", :size => [1024,768]) do     

  register do
    add_hook :quit, method(:exit!)
  end

  scene :factory do
    plate = Plate.new(:length => 20, :width => 50, :pos => [200,175])

    Drone.create(:start_pos => [210,200], :finish_pos => [500,200])
    Conveyor.create(:pos => [0,175], :length => 200, :width => 50)

    always do
      if plate.contain?(Drone.first.shape.pos)
        plate.activate
      else
        plate.deactivate
      end
      
      if Conveyor.first.empty? && plate.active?
        Widget.create(:pos => [10,200], :color => Ray::Color.red, :radius => 4)
      end
    end

    render do |win|
      Conveyor.each { |e| e.draw_on(win) }
      plate.draw_on(win)
      Drone.each { |e| e.draw_on(win) }
      Widget.each { |e| e.draw_on(win) }
    end
  end

  scenes << :factory
end