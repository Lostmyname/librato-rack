require 'logger'

module Librato
  class Rack
    # Wraps an available logger object and provides convenience
    # methods for logging using a separate set of log levels
    #
    class Logger
      LOG_LEVELS = [:off, :error, :warn, :info, :debug, :trace]

      attr_accessor :logger, :prefix

      def initialize(logger)
        self.logger = logger
        self.prefix = '[librato-rack] '
      end

      # ex: log :debug, 'this is a debug message'
      def log(level, message)
        return unless should_log?(level)
        message = prefix + message
        logger.puts(message)
        # if logger.respond_to?(:puts) # io obj
        #   logger.puts(message)
        # elsif logger.respond_to?(:error) # logger obj
        #   log_to_logger(level, message)
        # else
        #   raise "invalid logger object"
        # end
      end

      # set log level to any of LOG_LEVELS
      def log_level=(level)
        level = level.to_sym
        if LOG_LEVELS.index(level)
          @log_level = level
          require 'pp' if should_log?(:debug)
        else
          raise InvalidLogLevel, "Invalid log level '#{level}'"
        end
      end

      def log_level
        @log_level ||= :info
      end

      private

      # # write message to an ruby stdlib logger object or another class with
      # # similar interface, respecting log levels when we can map them
      # def log_to_logger(level, message)
      #   case level
      #   when :error, :warn
      #     method = level
      #   else
      #     method = :info
      #   end
      #   logger.send(method, message)
      # end

      # def logger
      #   @logger ||= if on_heroku
      #     logger = Logger.new(STDOUT)
      #     logger.level = Logger::INFO
      #     logger
      #   else
      #     ::Rails.logger
      #   end
      # end

      def should_log?(level)
        LOG_LEVELS.index(self.log_level) >= LOG_LEVELS.index(level)
      end

      # # trace current environment
      # def trace_environment
      #   log :info, "Environment: " + ENV.pretty_inspect
      # end
      #
      # # trace metrics being sent
      # def trace_queued(queued)
      #   log :trace, "Queued: " + queued.pretty_inspect
      # end
      #
      # def trace_settings
      #   settings = {
      #     :user => self.user,
      #     :token => self.token,
      #     :source => source,
      #     :explicit_source => self.explicit_source ? 'true' : 'false',
      #     :source_pids => self.source_pids ? 'true' : 'false',
      #     :qualified_source => qualified_source,
      #     :log_level => log_level,
      #     :prefix => prefix,
      #     :flush_interval => self.flush_interval
      #   }
      #   log :info, 'Settings: ' + settings.pretty_inspect
      # end

    end
  end
end