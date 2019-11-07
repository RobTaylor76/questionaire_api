class AnswersController < ApplicationController

  before_action :enforce_read_only_check, only: [:update]

  def show
    render json: map_answers_to_json_api(inspection.answers),
           status: :ok

  end

  def merge_with_existing_answers(existing_answers, possible_answers)
    # code here
    possible_answers.each do |possible_new_answer|
      updated =  update_existing_answer_to_question(existing_answers, possible_new_answer)
      existing_answers << possible_new_answer if !updated
    end
    existing_answers
  end

  def update
    possible_answers = get_possible_answers

    inspection.answers = merge_with_existing_answers(inspection.answers, possible_answers)

    inspection.save!

    render json: map_answers_to_json_api(inspection.answers),
           status: :ok
  end

  def required_scope
    "[answers:#{required_permission}]"
  end


  def enforce_read_only_check
    render_json_api_error("400", "Inspection Is Read Only", "Cannot update a completed inspection") if inspection.complete
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

  private

  def update_existing_answer_to_question(existing_answers, possible_new_answer)
    existing_answers.each_with_index do |existing_answer, index|
      if existing_answer['question_id'] == possible_new_answer['question_id']
        existing_answers[index] = possible_new_answer # use the new answer to question.. may be the same?
        return true
      end
    end
    return false
  end

  def get_possible_answers
    params.permit(data: [:question_id, :answer_id, :not_applicable, :id])[:data].map do |answer|
      answer[:not_applicable] = (answer[:not_applicable] == 'true') # serialization issue... fix this later
      answer[:uuid] = answer[:id] || SecureRandom.uuid
      answer
    end
  end

  def inspection
    @inspection ||= current_client.inspections.joins(:inspection_type).find_by({inspection_types: {uuid: params[:inspection_type_id]},
                                                                                inspections: {uuid: params[:inspection_id]}})
  end
end


