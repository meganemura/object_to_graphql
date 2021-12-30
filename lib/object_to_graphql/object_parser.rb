module ObjectToGraphql
  class ObjectParser
    def self.parse(object, arguments = [])
      new(object, arguments).parse
    end

    attr_reader :object
    attr_reader :arguments

    def initialize(object, arguments)
      @object = object
      @arguments = arguments
    end

    def parse
      selections = extract_selections(object, [])
      operation_definition = Nodes::OperationDefinition.new(name: nil,
                                                            selections: selections)

      Nodes::Document.new(definitions: [operation_definition])
    end

    def extract_selections(object, routes = [])
      object.map do |key, value|
        lower_camelized_key = key.to_s.camelize(:lower)

        current = routes + [key]
        args = arguments.select { |(array, _hash)| current == array }
          .map { |(_array, hash)| Nodes::Argument.new(name: hash[:name], value: hash[:value]) }

        case value
        when Hash
          Nodes::Field.new(name: lower_camelized_key,
                           selections: extract_selections(value, current),
                           arguments: args)
        when Array
          Nodes::Field.new(name: lower_camelized_key,
                           selections: extract_selections(value.first, current),
                           arguments: args)
        else
          Nodes::Field.new(name: lower_camelized_key,
                           value: value,
                           arguments: args)
        end
      end
    end
  end
end
