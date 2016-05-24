require 'octokit'

username = 'xxxx'
password = 'xxxx'

Octokit.configure do |c|
  c.login = username
  c.password = password
end

module GithubPm
  module PullReqests
    def self.summarize
      Octokit.pulls('FiNCDeveloper/wellness_survey')
    end
  end
end
