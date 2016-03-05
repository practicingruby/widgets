module Widgets
  class Machine
    SOUND = Ray::Sound.new("click.wav")

    extend Collection

    def initialize(radius:, color:, pos:)
      @radius     = radius
      
      @shape      = Ray::Polygon.circle([0,0], radius, color)
      @shape.pos  = pos

      @output     = Ray::Polygon.circle([0,0], radius/2, Ray::Color.new(200,175,200))
      @output.pos  = [@shape.pos.x, @shape.pos.y+radius]

      @activation_time = nil
    end

    def pos
      @shape.pos
    end

    def draw_on(win)
      win.draw(@shape)
      win.draw(@output)

      operate
    end

    def operate
      widgets = Widget.all.select { |e| e.pos.distance(@shape.pos) < @radius }

      by_color = widgets.group_by { |e| e.color_name }
      by_color.default = []

      red   = by_color[:red].first
      blue  = by_color[:blue].first

      if @activation_time
        activate if @activation_time < Time.now
      elsif red && blue
        @activation_time = Time.now + 0.5
        SOUND.play
      end
    end

    def activate
      widgets = Widget.all.select { |e| e.pos.distance(@shape.pos) < @radius }

      by_color = widgets.group_by { |e| e.color_name }
      by_color.default = []

      red   = by_color[:red].first
      blue  = by_color[:blue].first

      Widget.delete(red)
      Widget.delete(blue)

      Widget.create(:color  => Ray::Color.new(160,32,240),
                    :pos    => [@output.pos.x, @output.pos.y],
                    :radius => 8)


      @activation_time = nil
    end
  end
end