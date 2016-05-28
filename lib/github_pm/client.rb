require 'json'
require 'httparty'
require 'octokit'

module GithubPm
  class Client

    # require("github_pm")
    # client = GithubPm::Client.new(access_token: 'xxxxx')
    # client.set_repository("repo")
    # client.summarize_pull_request(xxx)

    def initialize(options={})
      @client = Octokit::Client.new(options)
    end

    def set_repository(repository)
      @repository = repository
    end

    def summarize_pull_request(number, options = {})
      commits = []
      page = 1

      print "Start to fetch commit histories "
      loop do
        fetched_commits = @client.pull_commits(@repository, number, {page: page})
        print '.'
        break if fetched_commits.size == 0
        commits << fetched_commits
        page += 1
      end
      print " done!\n"

      pull_requests = []

      print "Start to fetch merged pull-request info "
      commits.flatten.each do |commit|
        message = commit['commit']['message']
        author = commit['commit']['committer']['name']

        if matches = message.match(/Merge pull request #([\d]+) /)
          print '.'
          pr_number = matches[1]
          pr = @client.pull_request(@repository, pr_number)

          pull_requests << {
            title: pr['title'],
            url: pr['html_url'],
            username: pr['user']['login']
          }
        end
      end
      print " done!\n"

      print "# RELEASE NOTE\n"
      # output pr list
      pull_requests.each do |pr|
        print "#{pr[:title]} #{pr[:url]}\n"
      end
    end
  end
end
