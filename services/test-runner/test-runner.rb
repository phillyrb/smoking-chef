require 'rubygems'
require 'yaml'
require 'ostruct'
require 'delegate'
require 'logger'
require 'sqlite3'

module Runner
  class Config < DelegateClass(OpenStruct)
    def initialize(filename)
      @ostr = OpenStruct.new YAML.load_file(filename)
      super(@ostr)
    end
  end

  class Harness

    attr_reader :logger
    attr_reader :config
    attr_reader :db

    def initialize(config, daemonize=true)
      @config = config

      if daemonize
        fork do
          setup_logger

          logger.debug 'prepping daemonize'

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

    def setup_logger(foreground=false)
      @logger = if !foreground and config.respond_to?(:log) and config.log
                  Logger.new config.log
                else
                  if foreground
                    Logger.new STDOUT
                  else
                    Logger.new '/dev/null'
                  end
                end

      if config.respond_to?(:loglevel) 
        @logger.level = Logger.const_get(config.loglevel.upcase)
      end

      logger.debug 'logger initialized'
    end

    def setup_database
      logger.info 'connecting to database'

      unless config.respond_to?(:database)
        logger.fatal 'database not specified: aborting'
        raise "database not specified"
      end

      @db = SQLite3::Database.new config.database
      at_exit { @db.close }
    end

    def run_loop
      setup_database

      logger.info 'initializing main loop'

      while true
        sleep 10
      end
    end
  end
end

Runner::Harness.new(
  Runner::Config.new(ARGV[0] || '/etc/test-runner.yaml'),
  ARGV[1] != "1" # run in foreground
)
