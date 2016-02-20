require_relative "../lib/widgets"

include Widgets

def line(p1,p2)
  p1 = Ray::Vector2[*p1]
  p2 = Ray::Vector2[*p2]

  d = p1.distance(p2)
  a = Math.atan2(p2.y - p1.y, p2.x - p1.x) * 180 / Math::PI

  line = Ray::Polygon.line([0,0],[0,d], 1, Ray::Color.gray)

  line.pos   = p1
  line.angle = a - 90

  line
end


Ray::Game.new("Experiment #008", :size => [500,500]) do     
  p1 = [250,250]
  p2 = [250,250]
    
  register do
    add_hook :quit, method(:exit!)
  end

  scene :factory do
    on :mouse_motion do |pos|
      p2 = pos
    end

    render do |win|
      win.draw(line(p1, p2))

      win.draw(Ray::Polygon.circle(p1, 5, Ray::Color.green))
      win.draw(Ray::Polygon.circle(p2, 5, Ray::Color.red))
    end
  end

  scenes << :factory
end