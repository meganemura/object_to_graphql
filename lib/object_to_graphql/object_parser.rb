module ObjectToGraphql
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
      operation_definition = Nodes::OperationDefinition.new(name: nil,
                                                                               selections: selections)

      Nodes::Document.new(definitions: [operation_definition])
    end

    def extract_selections(object)
      object.map do |key, value|
        lower_camelized_key = key.to_s.camelize(:lower)
        case value
        when Hash
          Nodes::Field.new(name: lower_camelized_key,
                                              selections: extract_selections(value))
        when Array
          Nodes::Field.new(name: lower_camelized_key,
                                              selections: extract_selections(value.first))
        else
          Nodes::Field.new(name: lower_camelized_key)
        end
      end
    end
  end
end
