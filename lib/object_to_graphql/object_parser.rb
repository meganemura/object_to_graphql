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
      selections = extract_selections(object)
      operation_definition = GraphQL::Language::Nodes::OperationDefinition.new(selections: selections)

      GraphQL::Language::Nodes::Document.new(definitions: [operation_definition])
    end

    def extract_selections(object)
      object.map do |key, value|
        lower_camelized_key = key.to_s.camelize(:lower)
        case value
        when Hash
          GraphQL::Language::Nodes::Field.new(name: lower_camelized_key,
                                              selections: extract_selections(value))
        when Array
          GraphQL::Language::Nodes::Field.new(name: lower_camelized_key,
                                              selections: extract_selections(value.first))
        else
          GraphQL::Language::Nodes::Field.new(name: lower_camelized_key)
        end
      end
    end
  end
end
