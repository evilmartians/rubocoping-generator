say "Hey! Let's configure RuboCop for your project 🤖!\n" \
    "For more information, visit https://evilmartians.com/chronicles/rubocoping-with-legacy-bring-your-ruby-code-up-to-standard"

plugins = []
gems = []

<%= include "rails" %>
<%= include "testing" %>
<%= include "graphql" %>

in_root do
  <%= include "config", indent: 2 %>
  <%= include "bin_rubocop", indent: 2 %>
end

<%= include "todo" %>

say_status :info, "Congratulations! Your project got style! 🎉"

if yes?("Would you like to run RuboCop to check your configuration? (y/n)")
  in_root do
    if has_bin_rubocop
      Bundler.with_unbundled_env { run "bin/rubocop" }
    else
      Bundler.with_unbundled_env do
        run "bundle check > /dev/null || bundle install > /dev/null"
        run "bundle exec rubocop"
      end
    end
  end
end
