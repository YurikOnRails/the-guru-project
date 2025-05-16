class GistsController < ApplicationController
  before_action :authenticate_user!

  def create
    @test_passage = TestPassage.find(params[:test_passage_id])
    result = GistQuestionService.new(@test_passage.current_question).call

    flash_options = if result.successful?
      { notice: t(".success", url: view_context.link_to(t(".view_gist"), result.url,
          class: "btn btn-sm btn-outline-primary ms-2",
          target: "_blank")).html_safe }
    else
      { alert: t(".failure") }
    end

    redirect_to @test_passage, flash_options
  end
end
