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
      operation_definition = GraphQL::Language::Nodes::OperationDefinition.new
      selections = parse_query(object)
      operation_definition = operation_definition.merge(selections: selections)
      GraphQL::Language::Nodes::Document.new(definitions: [operation_definition])
    end

    def parse_query(object)
      object.map do |key, value|
        lower_camelized_key = key.to_s.camelize(:lower)
        case value
        when Hash
          GraphQL::Language::Nodes::Field.new(name: lower_camelized_key,
                                              selections: parse_query(value))
        when Array
          GraphQL::Language::Nodes::Field.new(name: lower_camelized_key,
                                              selections: parse_query(value.first))
        else
          GraphQL::Language::Nodes::Field.new(name: lower_camelized_key)
        end
      end
    end
  end
end
