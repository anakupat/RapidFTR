begin
  namespace :quality do
    require 'cane/rake_task'
    require 'rubocop/rake_task'

    desc 'Run cane to check quality metrics'
    Cane::RakeTask.new(:cane) do |cane|
      cane.abc_max = 144

      # TODO: clean up whitespaces and long lines of code
      cane.no_style = true
      # cane.no_style = false
      # cane.style_measure = 110 # max line length

      cane.no_doc = true

      cane.max_violations = 20
    end

    RuboCop::RakeTask.new(:rubocop) do |task|
      task.options = ['--rails']
    end

    desc 'Run all quality metrics'
    task :all => [:cane, :rubocop]
  end

  desc 'Alias for quality:all'
  task :quality => 'quality:all'

  if ENV['COVERALLS']
    require 'coveralls/rake/task'
    Coveralls::RakeTask.new
  end

rescue LoadError

  # Quality checks not needed when in production
  desc 'Run all quality metrics (not available)'
  task :quality do
    abort 'Quality rake task is not available in this environment.'
  end

end
