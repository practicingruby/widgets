require 'ray'

require_relative "widgets/collection"
require_relative "widgets/graphics"
require_relative "widgets/focus"
require_relative "widgets/widget"
require_relative "widgets/inventory"
require_relative "widgets/drone"
require_relative "widgets/machine"
require_relative "widgets/conveyor"
require_relative "widgets/plate"

module Widgets
  def self.pause
    @running = false
  end

  def self.paused?
    !@running
  end

  def self.run
    @running = true
  end

  def self.toggle_pause
    @running = !@running
  end
end