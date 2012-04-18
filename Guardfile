# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Recursively load all the sources from a given directory
guard 'stitch', :paths => ['assets/javascripts'], :output => 'composit.js' do
  watch(%r{^.+\.(js|coffee)$})
end

# Recursively resolve sources from a given file,
# dynamically resolving its dependencies
guard 'stitch', :files => ['assets/javascripts/composit.coffee'], :root => 'assets/javascripts/', :output => 'composit.js' do
  watch(%r{^.+\.(js|coffee)$})
end

guard 'less', :import_paths => ['assets/vendor/stylesheets'], :output => '.', :all_on_start => true, :all_after_change => true do
  watch(%r{^assets/stylesheets/.+\.less$})
end

require 'guard/guard'

module ::Guard
  class Slim < ::Guard::Guard
    def start
      puts "start"
      run(all_paths) if options[:all_on_start]
    end

    def run_on_change(paths)
      puts "run_on_change(#{paths})"
      run(paths)
    end

    def run(paths)
      paths.each(&method(:run_on_path))
    end

    def run_on_path(path)
      output = File.join(options.fetch(:output, '.'), File.basename(path, '.slim'))
      cmd = "slimrb --pretty #{path.inspect} > #{output}"
      puts(cmd)
      system(cmd)
    end

    def all_paths
      patterns = watchers.map { |w| w.pattern }
      files = Dir.glob('**/*.*')
      paths = []
      files.each do |file|
        patterns.each do |pattern|
          paths << file if file.match(Regexp.new(pattern))
        end
      end
      paths
    end
  end
end

guard :slim, :output => '.', :all_on_start => true do
  watch(%r{assets/pages/.+\.slim})
end