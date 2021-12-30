module ObjectToGraphql
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
  end
end
