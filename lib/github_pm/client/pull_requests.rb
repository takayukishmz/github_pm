require 'tapp'

module GithubPm
  class Client

    module PullReqests
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

        GithubPm::Client::PullReqests.output_as_list(pull_requests)
        GithubPm::Client::PullReqests.output_count_per_user(pull_requests)

        return
      end

      private_class_method

      def self.output_as_list(pull_requests)
        print "# RELEASE NOTE\n"

        pull_requests.each do |pr|
          print "#{pr[:title]} #{pr[:url]}\n"
        end
      end

      # OUTPUT format
      #
      # ## Pull request summary
      # ```
      # {"tom"=>10,
      #  "kevin"=>14,
      #  "taro"=>9,
      #  "john"=>6}
      # ```
      def self.output_count_per_user(pull_requests)
        print "\n"
        print "## Pull request summary\n"
        print "\n"
        print "```\n" #markdown
        pull_requests.map { |pr| pr[:username] }.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }.tapp
        print "```\n"
      end
    end
  end
end
