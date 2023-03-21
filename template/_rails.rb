has_rails = ((specs | deps) & %w[activerecord actionpack rails]).any?

if has_rails && yes?("Would your like to install rubocop-rspec?")
  file ".rubocop/rails.yml", <%= code(".rubocop/rails.yml") %>
  plugins << ".rubocop/rails.yml"
  gems << "rubocop-rails"
end
