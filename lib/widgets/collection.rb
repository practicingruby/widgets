module Widgets
  module Collection
    def all
      @elements ||= []
    end

    def create(params)
      all << new(params)
    end

    def delete(widget)
      all.delete(widget)
    end

    def count
      all.size
    end
  end
end
