require "github_pm/version"
require "github_pm/client"

module GithubPm
  # gpm = GithubPm.new({username: 'xxxx', password: 'xxxx'})
  # gpm.set_repo("rails/rails")
  # gpm.summarize_pull_request(xxx)
  # gpm.report
  def initialize(options=nil)
    @client = Octokit::Client.new(options) if options.present?
  end

  def set_repository(repository)
    @repository = repository
  end

  def summarize_pull_request(number, options = {})
    pull = @client.pull_request(@repository, number, options)
  end
end
