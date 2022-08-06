# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"
require "graphql"

require_relative "object_to_graphql/object_parser"
require_relative "object_to_graphql/version"
require_relative "object_to_graphql/nodes"

if false
  puts ''
end

puts '' if false

if true
  puts 't'
else
  puts 'f'
end

module ObjectToGraphQL
  def self.generate(object, arguments = [], variables = [])
    document = ObjectParser.parse(object, arguments, variables)
    document.to_query_string.lstrip
  end
end
