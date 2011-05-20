require 'rubygems'
require 'yaml'
require 'ostruct'
require 'delegate'
require 'logger'

module Runner
  class Harness

    attr_reader :logger
    attr_accessor :state

    def initialize(daemonize=true)
      if daemonize
        fork do
          setup_logger

          logger.debug 'redirecting filehandles'

          $stdout.reopen('/dev/null')
          $stderr.reopen('/dev/null')
          $stdin.reopen('/dev/null')

          logger.debug 'setsid'

          Process.setsid

          run_loop
        end
      else
        setup_logger(true)
        run_loop
      end
    end

    def load_state
      logger.debug 'loading state'
      self.state = Marshal.load(File.read('state.marshal')) || [ ] rescue [ ]
    end

    def dump_state
      logger.debug 'dumping state'
      File.open('state.marshal', 'w') { |f| f << Marshal.dump(self.state) }
    end

    def setup_logger(foreground=false)
      @logger = if foreground
                  Logger.new STDOUT
                else
                  Logger.new 'test-runner.log'
                end

      logger.level = Logger::DEBUG
      logger.debug 'logger initialized'
    end
    
    def run_loop
      logger.debug 'entering run loop'

      load_state

      logger.debug 'globbing'

      gems = Dir["/vagrant/valid-gems/*.gem"].map { |x| File.basename x }
	
      (gems - state).each do |gem|
        system(*%W[rvm gemset clear])
        system(*%W[gem install rubygems-test])

        logger.info "testing #{gem}"
        system(*%W[gem test /vagrant/valid-gems/#{gem}])

        if $?.exitstatus == 0
          state.push(gem)
        end
      end

      dump_state
    end
  end
end

Runner::Harness.new(false)
