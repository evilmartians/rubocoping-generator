# frozen_string_literal: true

require "test_helper"

class TestingTest < GeneratorTestCase
  template <<~'CODE'
    extensions = []
    gems = []
    <%= include "deps" %>
    <%= include "testing" %>
    say "EXTENSIONS=#{extensions.join(",")}"
    say "GEMS=#{gems.join(",")}"
  CODE

  def test_rspec_detected_y
    prepare_dummy do
      FileUtils.mkdir("spec")
      File.write("spec/spec_helper.rb", "")
    end

    run_generator(input: ["y"]) do |output|
      assert_file ".rubocop/rspec.yml"
      assert_line_printed output, "EXTENSIONS=.rubocop/rspec.yml"
      assert_line_printed output, "GEMS=rubocop-rspec"
    end
  end

  def test_rspec_detected_n
    prepare_dummy do
      FileUtils.mkdir("spec")
      File.write("spec/spec_helper.rb", "")
    end

    run_generator(input: ["n"]) do |output|
      refute_file ".rubocop/rspec.yml"
      assert_line_printed output, "EXTENSIONS="
      assert_line_printed output, "GEMS="
    end
  end

  def test_minitest_detected_y
    prepare_dummy do
      FileUtils.mkdir("test")
      File.write("test/test_helper.rb", "")
    end

    run_generator(input: ["y"]) do |output|
      assert_file ".rubocop/minitest.yml"
      assert_line_printed output, "EXTENSIONS=.rubocop/minitest.yml"
      assert_line_printed output, "GEMS=rubocop-minitest"
    end
  end

  def test_minitest_detected_n
    prepare_dummy do
      FileUtils.mkdir("test")
      File.write("test/test_helper.rb", "")
    end

    run_generator(input: ["n"]) do |output|
      refute_file ".rubocop/minitest.yml"
      assert_line_printed output, "EXTENSIONS="
      assert_line_printed output, "GEMS="
    end
  end

  def test_both_minitest_rspec_detected_y
    prepare_dummy do
      FileUtils.mkdir("test")
      File.write("test/test_helper.rb", "")
      FileUtils.mkdir("spec")
      File.write("spec/spec_helper.rb", "")
    end

    run_generator(input: ["y", "y"]) do |output|
      assert_file ".rubocop/minitest.yml"
      assert_file ".rubocop/rspec.yml"
      assert_line_printed output, "EXTENSIONS=.rubocop/rspec.yml,.rubocop/minitest.yml"
      assert_line_printed output, "GEMS=rubocop-rspec,rubocop-minitest"
    end
  end

  def test_no_testing_detected
    run_generator do |output|
      refute_file ".rubocop/minitest.yml"
      refute_file ".rubocop/rspec.yml"
      assert_line_printed output, "EXTENSIONS="
      assert_line_printed output, "GEMS="
    end
  end
end
