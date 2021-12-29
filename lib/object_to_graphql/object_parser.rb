module ObjectToGraphql
  class Node
    attr_reader :key
    attr_reader :value

    def initialize(key:, value:)
      @key = key
      @value = value
    end
  end

  class ObjectParser
    def self.parse(object)
      new(object).parse
    end

    attr_reader :object

    def initialize(object)
      @object = object
    end

    def parse
      object
    end
  end
end
