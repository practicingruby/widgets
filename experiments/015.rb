require_relative "../lib/widgets"

include Widgets


ding = Ray::Sound.new("ding.wav")

Ray::Game.new("Experiment #015", :size => [1024,768]) do
  Machine.create(:pos     => [350, 350],
                 :color   => Ray::Color.new(150,150,150),
                 :radius  => 100)

  
  Drone.create(:pos => [100,200], :speed => 6, :radius => 12)
  Drone.create(:pos => [150,200], :speed => 6, :radius => 12)


  Conveyor.create(:pos => [350,420], :length => 750, :width => 50, :speed => 0.5)

  register do
    add_hook :quit, method(:exit!)
  end

  scene :factory do
    border = Ray::Polygon.rectangle([0,0,10,768], Ray::Color.red)
    border.pos = [800,0]

    goal_amount  = 5
    goal_time    = 27

    start_time  = Time.now
    score       = goal_amount
    finish_time = nil


    render do |win|
      if Time.now - start_time > goal_time && score > 0
        win.draw text("GAME OVER!", :at => [300, 100], :size => 50)
      elsif score == 0
        finish_time ||= Time.now - start_time

        win.draw text("LEVEL COMPLETE!", :at => [300, 100], :size => 50)
        win.draw text("Completion time: %.1f seconds" % finish_time, :at => [300, 300], :size => 30)
      else
        Conveyor.draw_all(win)
        win.draw(border)
        Machine.draw_all(win)
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
        
        time_remaining = goal_time - (Time.now - start_time)
        time_color = 
          case time_remaining
          when 20..Float::INFINITY
            Ray::Color.green
          when 10...20
            Ray::Color.yellow
          when 0...10
            Ray::Color.new(255,100,100)
          end

        time_size = 
          case time_remaining
          when 20..Float::INFINITY
            30
          when 10...20
            40
          when 0...10
            50
          end
        

        win.draw text('%.1f' % (time_remaining), :at => [900, time_size], :size => time_size, :color => time_color)
        win.draw text(score.to_s, :at => [900, 300], :size => 50)
        win.draw text("Deliver #{goal_amount} purple widgets in #{goal_time} seconds or less", :at => [200,20], :size => 20)
      end
    end

    always do
      if Widget.none? { |e| e.color_name == :blue && e.pos.x < 150 }
        Widget.create(:pos => [25,325], :radius => 8, :color => Ray::Color.cyan)
      end

      if Widget.none? { |e| e.color_name == :red && e.pos.x < 150 }
        Widget.create(:pos => [25,425], :radius => 8, :color => Ray::Color.red)
      end  

      goals = Widget.select { |e| e.pos.x > 800 && e.color == Ray::Color.new(160,32,240) }

      if goals.any?
        goals.each { |e| Widget.delete(e) }
        ding.play
      end
  
      score -= goals.count
      goals.each { |e| Widget.delete(e) }

      Focus.shift = holding?(:lshift)
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
      exit!
    end
  end

  scenes << :factory
end