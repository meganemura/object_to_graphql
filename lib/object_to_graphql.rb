# frozen_string_literal: true

# See rails/rails#43851
require "active_support/isolated_execution_state"

require "active_support/core_ext/string"
require "active_support/core_ext/hash/keys"
require_relative "object_to_graphql/object_parser"
require_relative "object_to_graphql/query_builder"
require_relative "object_to_graphql/version"

module ObjectToGraphql
  def self.generate(object)
    parsed = ObjectParser.parse(object)

    query = QueryBuilder.build(parsed)
  end
end
