require 'github_pm'
require 'thor'

module GithubPm
  class CLI < Thor
    desc "summarize_pull_request 1 abcxxxx github_pm", "summarize target pull-request"
    def summarize_pull_request(pr_number, access_token, repository)
      client = GithubPm::Client.new(access_token: access_token)
      client.set_repository(repository)
      client.summarize_pull_request(pr_number)
    end
  end
end
