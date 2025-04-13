class GistQuestionService
  def initialize(question, client: nil)
    @question = question
    @test = @question.test
    @client = client || GitHubClient.new
    @user = @question.test.author
  end

  def call
    response = @client.create_gist(gist_params)

    if response.html_url.present?
      save_gist(response.html_url)
      { success: true, url: response.html_url }
    else
      { success: false }
    end
  rescue Octokit::Error
    { success: false }
  end

  private

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
    content = [ @question.content ]
    content += @question.answers.pluck(:content)
    content.join("\n")
  end

  def save_gist(url)
    @user.gists.create!(
      question: @question,
      url: url
    )
  end
end
