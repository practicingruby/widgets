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
    @paused = true
  end

  def self.paused?
    @paused
  end

  def self.run
    @paused = false
  end

  def self.toggle_pause
    @paused = !@paused
  end
end