class GistsController < ApplicationController
  before_action :authenticate_user!

  def create
    @test_passage = TestPassage.find(params[:test_passage_id])
    result = GistQuestionService.new(@test_passage.current_question).call

    flash_options = if result.successful?
      { 
        notice: t(".success"),
        gist_url: result.url
      }
    else
      { alert: t(".failure") }
    end

    redirect_to @test_passage, flash_options
  end
end
