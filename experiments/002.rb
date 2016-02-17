require_relative "../lib/widgets"

include Widgets

Ray::Game.new("Experiment #002", :size => [1024,768]) do
  register do
    add_hook :quit, method(:exit!)
  end

  scene :factory do
    render do |win|
      Widget.all.each { |e| e.draw_on(win) }
    end

    always do
      colors = Widget.all.group_by { |e| e.color } 
      colors.default = []

      if colors[:red].size > 0 && colors[:blue].size > 0
        sleep 1
  
        Widget.delete(colors[:red].first)
        Widget.delete(colors[:blue].first)
        Widget.create(:color  => Ray::Color.new(160,32,240),
                      :pos    => [rand(100..500),rand(100..500)],
                      :radius => 5 )
      end
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
      # do nothing
    end
  end

  scenes << :factory
end