class Inspection < ApplicationRecord
  belongs_to :client
  belongs_to :inspection_type

  before_save :update_if_inspection_completed

  def update_if_inspection_completed
    self.complete = all_questions_answered?
    if self.complete && self.score.nil?
      self.score = calculate_score
    end
  end

  def all_questions_answered?
    answered_questions = answers.select{ |answer| answer['answer_id'].present? || answer['not_applicable'] == true }

    inspection_type.questions.map do |question|
      find_answer_for_question(question, answered_questions)
    end.none?{|answer| answer.nil? }
  end

  def calculate_score
    answered_questions_to_score = answers.select{ |answer| answer['answer_id'].present? }

    inspection_type.questions.map do |question|
      answer_for_question = find_answer_for_question(question, answered_questions_to_score)
      answer_definition = question.answers.find { |answer| answer['uuid'] == answer_for_question['answer_id'] }
      if answer_definition.present?
        answer_definition['value']
      else
        0  # invalid answer!!!!
      end
    end.reduce(0, :+)
  end


  def find_answer_for_question(question, answers)
    answers.find{|answer| answer['question_id'] == question['uuid']}
  end
end