module Widgets
  module Collection
    include Enumerable
    
    def all
      @elements ||= []
    end

    def each(&block)
      all.each(&block)
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

    def delete_all
      all.clear
    end
  end
end
