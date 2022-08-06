# frozen_string_literal: true

if ENV["CI"] == "true"
  require "simplecov"
  require "simplecov-cobertura"

  module SimpleCov
    module Formatter
      class CoberturaFormatter

        def result_to_xml(result)
          doc = REXML::Document.new set_xml_head
          doc.context[:attribute_quote] = :quote
          doc.add_element REXML::Element.new('coverage')
          coverage = doc.root

          set_coverage_attributes(coverage, result)

          coverage.add_element(sources = REXML::Element.new('sources'))
          sources.add_element(source = REXML::Element.new('source'))
          source.text = SimpleCov.root

          coverage.add_element(packages = REXML::Element.new('packages'))

          if result.groups.empty?
            groups = {File.basename(SimpleCov.root) => result.files}
          else
            groups = result.groups
          end

          groups.each do |name, files|
            next if files.empty?
            packages.add_element(package = REXML::Element.new('package'))
            set_package_attributes(package, name, files)

            package.add_element(classes = REXML::Element.new('classes'))

            files.each do |file|
              classes.add_element(class_ = REXML::Element.new('class'))
              set_class_attributes(class_, file)

              class_.add_element(REXML::Element.new('methods'))
              class_.add_element(lines = REXML::Element.new('lines'))

              branched_lines = file.branches.map(&:start_line)
              total_branches = file.total_branches

              file.lines.each do |file_line|
                if file_line.covered? || file_line.missed?
                  lines.add_element(line = REXML::Element.new('line'))
                  set_line_attributes(line, file_line)
                  set_branch_attributes(line, file_line, branched_lines, total_branches) if SimpleCov.branch_coverage?
                end
              end
            end
          end

          doc
        end

        def set_branch_attributes(line, file_line, branched_lines, total_branches)
          if branched_lines.include?(file_line.number)
            # branched_lines_covered = total_branches.select(&:covered?).map(&:start_line)

            x = total_branches.select { |branch| branch.start_line == file_line.number }
            # bunbo = x.sum(&:coverage)
            bunbo = x.size
            if bunbo == 0
              puts 'x'
            end
            bunshi = x.select(&:covered?).size

            # pct_coverage, branches_covered = branched_lines_covered.include?(file_line.number) ? [100, '1/1'] : [0, '0/1']

            pct_coverage = bunshi * 100 / bunbo
            branches_covered = "#{bunshi}/#{bunbo}"

            if file_line.number == 19
              # binding.irb
            end

            line.attributes['branch'] = 'true'
            line.attributes['condition-coverage'] = "#{pct_coverage}% (#{branches_covered})"
          else
            line.attributes['branch'] = 'false'
          end
        end
      end
    end
  end

  SimpleCov.start do
    enable_coverage :branch
  end
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

require "object_to_graphql"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
