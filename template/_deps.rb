specs = []
deps = []

in_root do
  if File.file?("Gemfile.lock")
    bundler_parser = Bundler::LockfileParser.new(Bundler.read_file("Gemfile.lock"))
    specs = bundler_parser.specs.map(&:name)
  end
end

in_root do
  if File.file?("Gemfile")
    bundler_parser = Bundler::Dsl.new
    bundler_parser.eval_gemfile("Gemfile")
    deps = bundler_parser.dependencies.map(&:name)
  end
end
