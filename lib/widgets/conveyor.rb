module Widgets
  class Conveyor
    extend Collection

    def initialize(length:, height:, pos:)
      @length     = length
      @height     = height
      @shape      = Ray::Polygon.rectangle([0, 0, length, height], Ray::Color.gray)
      @shape.pos  = pos
    end

    def pos
      @shape.pos
    end

    def draw_on(win)
      win.draw(@shape)

      operate
    end

    def operate
      widgets = Widget.select { |e| [@shape.pos.x, @shape.pos.y, @length+10, @height].to_rect.collide?([e.pos.x-e.radius, e.pos.y-e.radius, e.radius*2, e.radius*2].to_rect) }
      widgets.each { |w| w.move_to([w.pos.x+1, w.pos.y])}
    end
  end
end