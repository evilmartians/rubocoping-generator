# frozen_string_literal: true

require "test_helper"

class GraphQLTest < GeneratorTestCase
  template <<~'CODE'
    extensions = []
    gems = []
    <%= include "deps" %>
    <%= include "graphql" %>
    say "EXTENSIONS=#{extensions.join(",")}"
    say "GEMS=#{gems.join(",")}"
  CODE

  def test_graphql_detected_y
    prepare_dummy do
      File.write("Gemfile.lock", <<~CODE
        GEM
          remote: https://rubygems.org/
          specs:
            graphql (2.6.7)

        DEPENDENCIES
          graphql
      CODE
    )
    end

    run_generator(input: ["y"]) do |output|
      assert_file ".rubocop/graphql.yml"
      assert_line_printed output, "EXTENSIONS=.rubocop/graphql.yml"
      assert_line_printed output, "GEMS=rubocop-graphql"
    end
  end

  def test_graphql_detected_n
    prepare_dummy do
      File.write("Gemfile.lock", <<~CODE
        GEM
          remote: https://rubygems.org/
          specs:
            graphql (2.6.7)

      DEPENDENCIES
        graphql
      CODE
    )
    end

    run_generator(input: ["n"]) do |output|
      refute_file ".rubocop/graphql.yml"
      assert_line_printed output, "EXTENSIONS="
      assert_line_printed output, "GEMS="
    end
  end

  def test_no_graphql_detected
    run_generator do |output|
      refute_file ".rubocop/graphql.yml"
      assert_line_printed output, "EXTENSIONS="
    end
  end
end
