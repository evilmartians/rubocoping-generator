# frozen_string_literal: true

require "test_helper"

class TodoTest < GeneratorTestCase
  template <<~'CODE'
    plugins = []
    base_configs = []
    extensions = [".rubocop/custom.yml"]
    gems = []

    <%= include "deps" %>
    <%= include "rails" %>
    <%= include "config" %>
    <%= include "todo" %>

    Bundler.with_unbundled_env { run "bundle exec rubocop" }
  CODE

  def test_todo_generation
    prepare_dummy do
      FileUtils.mkdir_p(".rubocop")
      File.write(".rubocop/custom.yml", "")
      File.delete("Gemfile.lock")
      File.write("Gemfile", %(source "https://rubygems.org"\ngem 'activerecord'\n))
    end

    run_generator(input: ["y", "y"]) do |output|
      assert_file ".rubocop_todo.yml"
      assert_file ".rubocop.yml"
      assert_file_contains ".rubocop.yml", "  - rubocop-performance\n  - rubocop-rails"
      assert_file_contains ".rubocop.yml", "  - .rubocop_todo.yml\n  - .rubocop/strict.yml"
    end
  end

  def test_todo_generation_with_bin_rubocop
    prepare_dummy do
      FileUtils.mkdir_p("bin")
      FileUtils.cp(File.join(__dir__, "../../template/bin/rubocop"), "bin/rubocop")
      FileUtils.chmod(0o755, "bin/rubocop")
      FileUtils.mkdir_p(".rubocop")
      File.write(".rubocop/custom.yml", "")
      File.delete("Gemfile.lock")
      File.write("Gemfile", %(source "https://rubygems.org"\n))
    end

    run_generator(input: ["y"]) do |output|
      assert_file ".rubocop_todo.yml"
      assert_file ".rubocop.yml"
      assert_file_contains ".rubocop.yml", "  - .rubocop_todo.yml\n  - .rubocop/strict.yml"
    end
  end
end
