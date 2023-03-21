# frozen_string_literal: true

require "test_helper"

class RailsTest < GeneratorTestCase
  template <<~'CODE'
    plugins = []
    gems = []
    <%= include "deps" %>
    <%= include "rails" %>
    say "PLUGINS=#{plugins.join(",")}"
    say "GEMS=#{gems.join(",")}"
  CODE

  def test_rails_detected_y
    run_generator(input: ["y"]) do |output|
      assert_file ".rubocop/rails.yml"
      assert_line_printed output, "PLUGINS=.rubocop/rails.yml"
      assert_line_printed output, "GEMS=rubocop-rails"
    end
  end

  def test_rails_detected_n
    run_generator(input: ["n"]) do |output|
      refute_file ".rubocop/rails.yml"
      assert_line_printed output, "PLUGINS="
      assert_line_printed output, "GEMS="
    end
  end

  def test_rails_detected_via_gemfile
    prepare_dummy do
      File.delete("Gemfile.lock")
      File.write("Gemfile", "gem 'activerecord'")
    end

    run_generator(input: ["y"]) do |output|
      assert_file ".rubocop/rails.yml"
      assert_line_printed output, "PLUGINS=.rubocop/rails.yml"
      assert_line_printed output, "GEMS=rubocop-rails"
    end
  end

  def test_no_rails_detected
    prepare_dummy do
      File.delete("Gemfile.lock")
      File.delete("Gemfile")
    end

    run_generator do |output|
      refute_file ".rubocop/rails.yml"
      assert_line_printed output, "PLUGINS="
      assert_line_printed output, "GEMS="
    end
  end
end
