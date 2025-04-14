class GistQuestionService
  GistResult = Struct.new(:success, :url) do
    def successful?
      success
    end
  end

  def initialize(question, client = default_client)
    @question = question
    @test = @question.test
    @client = client
    @user = @question.test.author
  end

  def call
    response = @client.create_gist(gist_params)

    if response.html_url.present?
      save_gist!(response.html_url)
      GistResult.new(true, response.html_url)
    else
      GistResult.new(false, nil)
    end
  rescue Octokit::Error
    GistResult.new(false, nil)
  end

  private

  def default_client
    Octokit::Client.new(access_token: fetch_github_token)
  end

  def fetch_github_token
    ENV.fetch("GITHUB_TOKEN") { raise "GitHub token is missing. Please set the GITHUB_TOKEN environment variable." }
  end

  def gist_params
    {
      description: I18n.t("services.gist_question_service.description", title: @test.title),
      public: true,
      files: {
        I18n.t("services.gist_question_service.filename") => {
          content: gist_content
        }
      }
    }
  end

  def gist_content
    [ @question.content, *@question.answers.pluck(:content) ].join("\n")
  end

  def save_gist!(url)
    @user.gists.create!(
      question: @question,
      url: url
    )
  end
end
