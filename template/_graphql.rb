has_graphql = ((specs | deps) & %w[graphql]).any?

if has_graphql && yes?("Would your like to install rubocop-graphql? (y/n)")
  file ".rubocop/graphql.yml", <%= code(".rubocop/graphql.yml") %>
  extensions << ".rubocop/graphql.yml"
  gems << "rubocop-graphql"
end
