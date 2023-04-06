has_rspec = in_root do
  ((specs | deps) & %w[rspec-core]).any? && File.directory?("spec")
end

if has_rspec && yes?("Would your like to install rubocop-rspec? (y/n)")
  file ".rubocop/rspec.yml", <%= code(".rubocop/rspec.yml") %>
  extensions << ".rubocop/rspec.yml"
  gems << "rubocop-rspec"
end

has_minitest = in_root do
  ((specs | deps) & %w[minitest]).any? && File.directory?("test")
end

if has_minitest && yes?("Would your like to install rubocop-minitest? (y/n)")
  file ".rubocop/minitest.yml", <%= code(".rubocop/minitest.yml") %>
  extensions << ".rubocop/minitest.yml"
  gems << "rubocop-minitest"
end
