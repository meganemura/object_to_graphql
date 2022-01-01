module ObjectToGraphQL
  module Nodes
    class Document < GraphQL::Language::Nodes::Document; end

    class OperationDefinition < GraphQL::Language::Nodes::OperationDefinition; end

    class Field < GraphQL::Language::Nodes::Field
      attr_reader :value

      def initialize_node(attributes)
        super
        @value = attributes[:value]
      end
    end

    class Argument < GraphQL::Language::Nodes::Argument; end
    class VariableIdentifier < GraphQL::Language::Nodes::VariableIdentifier; end
    class VariableDefinition < GraphQL::Language::Nodes::VariableDefinition; end
    class NonNullType < GraphQL::Language::Nodes::NonNullType; end
    class TypeName < GraphQL::Language::Nodes::TypeName; end
  end
end
