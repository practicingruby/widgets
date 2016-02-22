class Focus
  class NullObject
    def self.click(button, pos)
      # no-op
    end

    def self.focus
    end
    
    def self.blur
    end
  end

  def self.shift
    @shift
  end

  def self.shift=(state)
    @shift = state
  end

  def self.activated
    @object ||= NullObject
  end

  def self.select(object)
    return unless Widgets.paused?

    @object = object
    @object.focus
  end

  def self.blur
    return unless Widgets.paused?

    @object.blur

    select(NullObject)
  end

  def self.click(button, pos)
    return unless Widgets.paused?

    activated.click(button, pos)
  end
end