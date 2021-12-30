# frozen_string_literal: true

# See rails/rails#43851
require "active_support/isolated_execution_state"

require "active_support/core_ext/string"
require "active_support/core_ext/hash/keys"
require "graphql"

require_relative "object_to_graphql/object_parser"
require_relative "object_to_graphql/version"
require_relative "object_to_graphql/nodes"

module ObjectToGraphql
  def self.generate(object, arguments = [], variables = [])
    document = ObjectParser.parse(object, arguments, variables)
    document.to_query_string.lstrip
  end
end
