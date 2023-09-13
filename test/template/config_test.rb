# frozen_string_literal: true

require "test_helper"

class ConfigTest < GeneratorTestCase
  template <<~'CODE'
    plugins = ["standard-some"]
    base_configs = ["standard-some"]
    extensions = [".rubocop/custom.yml"]
    gems = ["rubocop-some"]

    <%= include "deps" %>
    <%= include "config" %>
  CODE

  def test_config
    run_generator do |output|
      assert_file "gemfiles/rubocop.gemfile"
      assert_file_contains "gemfiles/rubocop.gemfile", "gem \"rubocop-some\""
      assert_file_contains "gemfiles/rubocop.gemfile", "gem \"standard\""

      assert_file ".rubocop.yml"
      assert_file_contains ".rubocop.yml", "- .rubocop/custom.yml"
      assert_file_contains ".rubocop.yml", "TargetRubyVersion: 3.1"
      assert_file_contains ".rubocop.yml", "- standard-some"
      assert_file_contains ".rubocop.yml", "  standard-some: config/base.yml"

      assert_file_contains "Gemfile", "eval_gemfile \"gemfiles/rubocop.gemfile\""
    end
  end
end
