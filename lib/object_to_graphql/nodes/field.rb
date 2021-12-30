module ObjectToGraphql
  module Nodes
    class Field < GraphQL::Language::Nodes::Field
      attr_reader :value

      def initialize_node(attributes)
        super
        @value = attributes[:value]
      end
    end
  end
end
