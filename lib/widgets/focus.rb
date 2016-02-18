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
    @object = object
    @object.focus
  end

  def self.blur
    @object.blur

    select(NullObject)
  end

  def self.click(pos)
    activated.click(pos)
  end
end