# frozen_string_literal: true

require "test_helper"

class RailsTest < GeneratorTestCase
  template <<~'CODE'
    plugins = []
    base_configs = []
    extensions = []
    gems = []
    <%= include "deps" %>
    <%= include "rails" %>
    say "BASE_CONFIGS=#{base_configs.join(",")}"
    say "EXTENSIONS=#{extensions.join(",")}"
    say "PLUGINS=#{plugins.join(",")}"
    say "GEMS=#{gems.join(",")}"
  CODE

  def test_rails_detected_y
    run_generator(input: ["y"]) do |output|
      refute_file ".rubocop/rails.yml"
      assert_line_printed output, "BASE_CONFIGS=standard-rails"
      assert_line_printed output, "EXTENSIONS="
      assert_line_printed output, "PLUGINS=rubocop-rails"
      assert_line_printed output, "GEMS=standard-rails"
    end
  end

  def test_rails_detected_n
    run_generator(input: ["n"]) do |output|
      refute_file ".rubocop/rails.yml"
      assert_line_printed output, "BASE_CONFIGS="
      assert_line_printed output, "EXTENSIONS="
      assert_line_printed output, "GEMS="
    end
  end

  def test_rails_detected_via_gemfile
    prepare_dummy do
      File.delete("Gemfile.lock")
      File.write("Gemfile", "gem 'activerecord'")
    end

    run_generator(input: ["y"]) do |output|
      refute_file ".rubocop/rails.yml"
      assert_line_printed output, "BASE_CONFIGS=standard-rails"
      assert_line_printed output, "EXTENSIONS="
      assert_line_printed output, "GEMS=standard-rails"
    end
  end

  def test_no_rails_detected
    prepare_dummy do
      File.delete("Gemfile.lock")
      File.delete("Gemfile")
    end

    run_generator do |output|
      refute_file ".rubocop/rails.yml"
      assert_line_printed output, "BASE_CONFIGS="
      assert_line_printed output, "EXTENSIONS="
      assert_line_printed output, "GEMS="
    end
  end
end
