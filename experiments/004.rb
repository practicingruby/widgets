require_relative "../lib/widgets"

include Widgets

Ray::Game.new("Experiment #004", :size => [1024,768]) do
  Machine.create(:pos     => [1024/2.0, 768/2.0],
                 :color   => Ray::Color.new(150,150,150),
                 :radius  => 100)

  
  Drone.create(:start_pos => [300,300],
               :finish_pos => [550,400])

  Drone.each(&:toggle)
  
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
      case button
      when :left
        Widget.create(:color  => Ray::Color.cyan,
                      :pos    => pos,
                      :radius => 5)
      when :right
        Widget.create(:color  => Ray::Color.red,
                      :pos    => pos,
                      :radius => 5)
      end
    end

    on :key_press, key(:space) do
      # do nothing
    end

    on :key_press, key(:return) do
      Widget.delete_all
    end
  end

  scenes << :factory
end