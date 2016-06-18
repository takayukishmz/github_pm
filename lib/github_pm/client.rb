require 'json'
require 'httparty'
require 'octokit'

require 'github_pm/client/pull_requests'

module GithubPm
  class Client
    include GithubPm::Client::PullReqests
    ##
    ## USAGE
    ##
    #
    # # setup
    # require("github_pm")
    # client = GithubPm::Client.new(access_token: 'xxxxx')
    # client.set_repository("repo")
    #
    # client.summarize_pull_request(xxx)
    #
    def initialize(options={})
      @client = Octokit::Client.new(options)
      @repository = options[:repository] if options && options[:repository]
    end

    def set_repository(repository)
      @repository = repository
    end
  end
end
