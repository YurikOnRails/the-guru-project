class GitHubClient
  ACCESS_TOKEN = ENV["GITHUB_TOKEN"]

  def initialize
    @client = Octokit::Client.new(access_token: ACCESS_TOKEN)
  end

  def create_gist(params)
    @client.create_gist(params)
  end
end
