class AnswersController < ApplicationController

  def index

    inspection = current_client.inspections.joins(:inspection_type).find_by({inspection_types: {uuid: params[:inspection_type_id]},
                                                                             inspections: {uuid: params[:inspection_id]}})


    render json: map_answers_to_json_api(inspection.answers ),
           status: :ok

  end

  def required_scope
    "[answers:#{required_permission}]"
  end


  def map_answers_to_json_api(answers)

    {
        data: answers.each.map do |answer|
          {
              id: answer['uuid'],
              type: 'answer',
              attributes: {
                  question_id: answer['question_id'],
                  answer_id: answer['answer_id'],
                  not_applicable: answer['not_applicable'],
              }
          }
        end
    }


  end

end
