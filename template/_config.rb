# Final configuration generation

file ".rubocop/strict.yml", <%= code ".rubocop/strict.yml" %>
file ".rubocop.yml", <%= code ".rubocop.yml" %>
file "gemfiles/rubocop.gemfile", <%= code "gemfiles/rubocop.gemfile" %>

in_root do
  if File.file?("Gemfile")
    # inject line in the end of the file with Thor
    last_non_emoty_line = File.readlines("Gemfile").reverse.find { |line| !line.strip.empty? }

    inject_into_file "Gemfile", %(\ngroup :development do\n  eval_gemfile "gemfiles/rubocop.gemfile"\nend), after: last_non_emoty_line
  end
end
