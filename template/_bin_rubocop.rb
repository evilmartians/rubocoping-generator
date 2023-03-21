has_bin_rubocop = yes?("Would your like to create a standalone RuboCop executable (bin/rubocop)?")

if has_bin_rubocop
  file "bin/rubocop", <%= code("bin/rubocop") %>
  in_root { run "chmod +x bin/rubocop" }
end
