# frozen_string_literal: true

require 'git_work_tracker/version'
require 'git'
require 'logging'

module GitWorkTracker
  autoload :Repository, 'git_work_tracker/repository'

  class Error < StandardError; end

  def self.debug!
    logger.level = :debug
  end

  def self.logger
    @logger ||= ::Logging.logger[self].tap do |logger|
      logger.add_appenders ::Logging.appenders.stdout
      logger.level = :info
    end
  end
end

GitWorkTracker.logger # TODO: do more appropriately
