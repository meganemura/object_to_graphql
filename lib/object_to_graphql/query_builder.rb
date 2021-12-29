module ObjectToGraphql
  class QueryBuilder
    def self.build(node)
      new(node).build
    end

    attr_reader :node

    def initialize(node)
      @node = node
    end

    def build
      query = node.deep_transform_keys { |key| key.to_s.camelize(:lower) }

      x = indent_without_parenthesis_line(puts_object(query))
      x << "\n"
      x
    end

    def puts_object(object)
      string = ""
      string << "{\n"
      object.each do |key, value|
        case value
        when Hash
          printed = indent_without_parenthesis_line(puts_object(value))
          string << "#{key}: #{printed}\n"
        when Array
          case value.first
          when Hash, Array
            printed = indent_without_parenthesis_line(puts_object(value.first))
            string << "#{key}: #{printed}\n"
          else
            raise NotImplementedError
          end
        else
          string << "#{key}\n"
        end
      end
      string << "}"
    end

    def indent_without_parenthesis_line(str)
      line_size = str.lines.size

      str.lines.map.with_index do |line, index|
        (index == 0 || index == line_size - 1) ? line : line.indent(2)
      end.join
    end
  end
end
