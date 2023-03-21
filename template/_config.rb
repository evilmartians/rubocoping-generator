# Final configuration generation

file ".rubocop/strict.yml", <%= code ".rubocop/strict.yml" %>
file ".rubocop.yml", <%= code ".rubocop.yml" %>
file "gemfiles/rubocop.gemfile", <%= code "gemfiles/rubocop.gemfile" %>

in_root do
  if File.file?("Gemfile")
    file "Gemfile", File.read("Gemfile") + %(\ngroup :development do\n  eval_gemfile "gemfiles/rubocop.gemfile"\nend\n), force: true
  end
end
