require_relative "../lib/widgets"

include Widgets

Ray::Game.new("Experiment #010", :size => [1024,768]) do  
  Drone.create(:start_pos => [60,255],
               :finish_pos => [60,255],
               :speed      => 1)

               
  Drone.create(:start_pos => [100,255],
               :finish_pos => [100,255],
               :speed      => 1)


   Drone.create(:start_pos => [80,255],
                :finish_pos => [80,255],
                :speed      => 1)

    100.times do 
      Widget.create(:pos => [rand(120..150), 255], :color => Ray::Color.red, :radius => 4)
    end


  start_time  = Time.now
  score       = 0
  finish_time = nil

  register do
    add_hook :quit, method(:exit!)
  end

  scene :factory do
    render do |win|
      if score == 4
        finish_time ||= Time.now - start_time

        win.draw text("LEVEL COMPLETE!", :at => [300, 100], :size => 50)
        win.draw text("Completion time: %.1f seconds" % finish_time, :at => [300, 300], :size => 30)
      else
        win.draw Ray::Polygon.rectangle([800,0,10,768], Ray::Color.red)
        win.draw Ray::Polygon.rectangle([0,250,1024,10], Ray::Color.gray)

        Conveyor.draw_all(win)
        Machine.draw_all(win)
        Drone.draw_all(win)
        Widget.draw_all(win)
        win.draw text('%.1f' % (Time.now - start_time), :at => [900, 100], :size => 30)
        win.draw text(score.to_s, :at => [900, 300], :size => 50)
        
      

      end
    end

    always do
      goals = Widget.select { |e| e.pos.x > 800 }
      goals.each { |e| Widget.delete(e) }

      score += goals.count
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