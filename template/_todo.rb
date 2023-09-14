if yes?("Would you like to generate a TODO config? (y/n)")
  # First, run RuboCop and check the output
  # with formatter json
  in_root do
    has_bin_rubocop = File.file?("bin/rubocop")
    command = has_bin_rubocop ? "bin/rubocop" : "bundle exec rubocop"

    output = Bundler.with_unbundled_env do
      # Make sure dependencies are installed
      if has_bin_rubocop
        `#{command} > /dev/null`
      else
        run "bundle check > /dev/null || bundle install > /dev/null"
      end
      `#{command} --format json`
    end
    require "json"
    summary = JSON.parse(output).dig("summary")

    if summary["offense_count"] > 0
      Bundler.with_unbundled_env do
        # Prevent RuboCop from updating the `.rubocop.yml`
        run "cp .rubocop.yml .rubocop.yml.bak"
        run "#{command} " \
            "--auto-gen-config " \
            "--auto-gen-only-exclude " \
            "--no-exclude-limit"
        run "mv .rubocop.yml.bak .rubocop.yml"
      end

      inject_into_file ".rubocop.yml", "  - .rubocop_todo.yml\n", before: "  - .rubocop/strict.yml"
    else
      say "No offenses detected, good job! Skipping TODO generation"
    end
  end
end
