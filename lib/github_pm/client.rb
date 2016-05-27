require 'json'
require 'httparty'
require 'octokit'

module GithubPm
  class Client
    ACCESS_TOKEN = "xxxxxxxxxx"
    GITHUB_API_URL = "https://api.github.com"
    REPO_ROOT = "/repos/YOURREPOSITORY/"
    REPO = ENV['REPO']

    # gpm = GithubPm.new({username: 'xxxx', password: 'xxxx'})
    # gpm.set_repo("rails/rails")
    # gpm.summarize_pull_request(xxx)
    # gpm.report

    def initialize(options=nil)
      @client = Octokit::Client.new(options) if options
    end

    def set_repository(repository)
      @repository = repository
    end

    def summarize_pull_request(number, options = {})
      pull = @client.pull_request(@repository, number, options)
      pull
    end

    class << self

      def fetch_pull_request(id, params = {})
        url = "#{GITHUB_API_URL}#{REPO_ROOT}#{REPO}/pulls/#{id}"
        fetch(:get, url, params)
      end


      def fetch_pull_request_commits()

      end

      def fetch_issues

      end


      def fetch(method, url, options)
        default_options = {
          headers: {
            "Authorization" => "token #{ACCESS_TOKEN}",
            "User-Agent" => "cli"
          }
        }
        JSON.parse(HTTParty.send(method, url, default_options.merge(options)).body)
      end
    end
  end
end
