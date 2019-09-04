# frozen_string_literal: true

module GitWorkTracker
  class Repository

    def initialize(basedir = nil)
      @basedir = basedir || Dir.pwd
    end

    def logger
      @logger ||= Logging::Logger[self]
    end

    def unpushed_commits
      arr_opts = %w[--no-color --branches --not --remotes --pretty=oneline --decorate]

      cur_branch = nil
      commits = git.lib.send(:command_lines, 'log', arr_opts, true).map do |line|
        matches = GIT_LOG_REX.match(line)
        next unless matches

        sha = matches['sha']
        cur_branch = matches['branch'] if matches['branch']
        branch_str = cur_branch
        branches = branch_str.split(', ').map do |branch|
          branch = branch.split(' -> ').last if branch.include? ' -> '
          branch unless branch.include? '/'
        end.compact

        branch = branches.first

        Git::Object::Commit.new(git, sha).tap do |commit|
          commit.instance_variable_set :@branch, git.branch(branch)
          commit.instance_eval do
            def branch
              @branch
            end
          end
        end
      end

      commits
    end

    def unpushed_branches
      unpushed_commits.group_by { |c| c.branch.to_s }
    end

    def stale_branches
      git.branches.local.select do |branch|
        head = branch.gcommit

        authored = (head.author.email == git.config['user.email'] || head.author.name == git.config['user.name'])
        stale = (Time.now - head.date) > 7 * 24 * 60 * 60

        authored && stale
      end
    end

    def latest_commit
      git.branches.map(&:gcommit).max { |a, b| a.date <=> b.date }
    end

    def stale_repo?
      stale_branches.map(&:gcommit).include? latest_commit
    end

    private

    GIT_LOG_REX = /^(?<sha>\w+) (?:\((?<branch>.+)\) )?(?<message>.*)$/.freeze

    def git
      @git ||= Git.open(@basedir, log: logger)
    end
  end
end
