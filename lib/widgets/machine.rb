module Widgets
  class Machine
    extend Collection

    def initialize(radius:, color:, pos:)
      @radius     = radius
      
      @shape      = Ray::Polygon.circle([0,0], radius, color)
      @shape.pos  = pos

      @activation_time = nil
    end

    def pos
      @shape.pos
    end

    def draw_on(win)
      win.draw(@shape)

      operate
    end

    def operate
      widgets = Widget.all.select { |e| e.pos.distance(@shape.pos) < @radius }

      by_color = widgets.group_by { |e| e.color }
      by_color.default = []

      red   = by_color[:red].first
      blue  = by_color[:blue].first

      if @activation_time
        activate if @activation_time < Time.now
      elsif red && blue
        @activation_time = Time.now + 0.5
      end
    end

    def activate
      widgets = Widget.all.select { |e| e.pos.distance(@shape.pos) < @radius }

      by_color = widgets.group_by { |e| e.color }
      by_color.default = []

      red   = by_color[:red].first
      blue  = by_color[:blue].first

      Widget.delete(red)
      Widget.delete(blue)

      Widget.create(:color  => Ray::Color.new(160,32,240),
                    :pos    => [@shape.pos.x + rand(-80..80), @shape.pos.y + rand(-80..80)],
                    :radius => 5)

      @activation_time = nil
    end
  end
end