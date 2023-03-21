has_graphql = ((specs | deps) & %w[graphql]).any?

if has_graphql && yes?("Would your like to install rubocop-graphql?")
  file ".rubocop/graphql.yml", <%= code(".rubocop/graphql.yml") %>
  plugins << ".rubocop/graphql.yml"
  gems << "rubocop-graphql"
end
