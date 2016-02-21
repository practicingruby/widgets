module Widgets
  module Graphics
    def self.line(p1,p2, color: Ray::Color.green)
      p1 = Ray::Vector2[*p1]
      p2 = Ray::Vector2[*p2]

      d = p1.distance(p2)
      a = Math.atan2(p2.y - p1.y, p2.x - p1.x) * 180 / Math::PI

      line = Ray::Polygon.line([0,0],[0,d], 1, color)

      line.pos   = p1
      line.angle = a - 90

      line
    end
  end
end