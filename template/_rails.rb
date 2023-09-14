has_rails = ((specs | deps) & %w[activerecord actionpack rails]).any?

if has_rails && yes?("Would your like to install standard-rails? (y/n)")
  plugins << "rubocop-rails"
  base_configs << "standard-rails"
  gems << "standard-rails"
end
