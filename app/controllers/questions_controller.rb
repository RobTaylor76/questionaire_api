class QuestionsController < ApplicationController

  def index

    questions = current_client.questions.joins(:inspection_type).where( inspection_types: {uuid: params[:inspection_type_id]})

    render jsonapi: questions,
           status: :ok

  end

  def required_scope
    "[questions:#{required_permission}]"
  end

end
