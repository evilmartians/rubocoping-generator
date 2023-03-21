# frozen_string_literal: true

require "test_helper"

class BinRubocopTest < GeneratorTestCase
  template <<~'CODE'
    <%= include "bin_rubocop" %>
  CODE

  def test_bin_rubocop_y
    run_generator(input: ["y"]) do |output|
      assert_file "bin/rubocop"
    end
  end

  def test_bin_rubocop_n
    run_generator(input: ["n"]) do |output|
      refute_file "bin/rubocop"
    end
  end
end
