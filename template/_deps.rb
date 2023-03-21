specs = []
deps = []
ruby_version = Gem::Version.new(RUBY_VERSION).segments[0..1].join(".")

in_root do
  if File.file?("Gemfile.lock")
    bundler_parser = Bundler::LockfileParser.new(Bundler.read_file("Gemfile.lock"))
    specs = bundler_parser.specs.map(&:name)
    locked_version = bundler_parser.ruby_version.match(/(\d+\.\d+\.\d+)/)&.[](1) if bundler_parser.ruby_version
    ruby_version = Gem::Version.new(locked_version).segments[0..1].join(".") if locked_version
  end
end

in_root do
  if File.file?("Gemfile")
    bundler_parser = Bundler::Dsl.new
    bundler_parser.eval_gemfile("Gemfile")
    deps = bundler_parser.dependencies.map(&:name)
  end
end
