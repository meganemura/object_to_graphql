module ObjectToGraphql
  class ObjectParser
    def self.parse(object, arguments = [], variables = [])
      new(object, arguments, variables).parse
    end

    attr_reader :object
    attr_reader :original_arguments
    attr_reader :original_variables

    def initialize(object, arguments, variables)
      @object = object
      @original_arguments = arguments
      @original_variables = variables
    end

    def parse
      selections = extract_selections(object, [])
      operation_type = variables.empty? ? nil : "query"
      operation_definition = Nodes::OperationDefinition.new(name: nil,
                                                            selections: selections,
                                                            operation_type: operation_type,
                                                            variables: variables)

      Nodes::Document.new(definitions: [operation_definition])
    end

    def extract_selections(object, path = [])
      object.map do |key, value|
        lower_camelized_key = key.to_s.camelize(:lower)

        current_path = path + [key]
        args = arguments.select { |(route, _)| route == current_path }.map(&:last)

        case value
        when Hash
          Nodes::Field.new(name: lower_camelized_key,
                           selections: extract_selections(value, current_path),
                           arguments: args)
        when Array
          Nodes::Field.new(name: lower_camelized_key,
                           selections: extract_selections(value.first, current_path),
                           arguments: args)
        else
          Nodes::Field.new(name: lower_camelized_key,
                           value: value,
                           arguments: args)
        end
      end
    end

    def argument_value(str)
      if str.start_with?("$")
        Nodes::VariableIdentifier.new(name: str.delete_prefix("$"))
      else
        str
      end
    end

    def arguments
      @arguments ||= original_arguments.map do |(route, argument)|
        [
          route,
          Nodes::Argument.new(name: argument[:name],
                              value: argument_value(argument[:value]))
        ]
      end
    end

    def variables
      @variables ||= original_variables.map do |variable|
        Nodes::VariableDefinition.new(name: variable_name(variable[:name]),
                                      type: variable_type(variable[:type]))
      end
    end

    def variable_name(str)
      str.delete_prefix("$")
    end

    def variable_type(str)
      not_null = str.end_with?("!")
      name = str.delete_suffix("!")

      type_name = ObjectToGraphql::Nodes::TypeName.new(name: name)

      if not_null
        ObjectToGraphql::Nodes::NonNullType.new(of_type: type_name)
      else
        type_name
      end
    end
  end
end
