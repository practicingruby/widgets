class Focus
  class NullObject
    def self.click(pos)
      # no-op
    end

    def self.focus
    end
    
    def self.blur
    end
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

  def self.click(pos)
    return unless Widgets.paused?

    activated.click(pos)
  end
end