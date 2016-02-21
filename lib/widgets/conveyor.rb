module Widgets
  class Conveyor
    extend Collection

    def initialize(length:, width:, pos:)
      @length     = length
      @width     = width
      @shape      = Ray::Polygon.rectangle([0, 0, length, width], Ray::Color.gray)
      @shape.pos  = pos
    end

    def pos
      @shape.pos
    end

    def draw_on(win)
      win.draw(@shape)

      operate
    end

    def empty?
      widgets = Widget.select { |e| [@shape.pos.x, @shape.pos.y, @length+10, @width].to_rect.collide?([e.pos.x-e.radius, e.pos.y-e.radius, e.radius*2, e.radius*2].to_rect) }
      widgets.empty?
    end

    def operate
      widgets = Widget.select { |e| [@shape.pos.x, @shape.pos.y, @length+10, @width].to_rect.collide?([e.pos.x-e.radius, e.pos.y-e.radius, e.radius*2, e.radius*2].to_rect) }
      widgets.each { |w| w.move_to([w.pos.x+2, w.pos.y])}
    end
  end
end