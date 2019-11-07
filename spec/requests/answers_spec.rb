require 'rails_helper'

describe 'Answers for Inspection Questions', type: :request do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end


  context 'get the answers for the specified inspection' do


    it 'find the questions and possible answers for the inspection type' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[answers:read]'
                                      }, 1.hour.from_now)

      inspection_type = InspectionType.find_by(uuid: '918d0752-d251-bcdf-4e78-fe4d77a4b8fa')
      inspection = inspection_type.inspections.first

      get inspection_type_inspection_answers_path('918d0752-d251-bcdf-4e78-fe4d77a4b8fa', inspection.uuid), params: {},
          headers: {'Authorization' => jwt_token, Accept: 'application/vnd.api+json'}

      expect(response.status).to eq 200


      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:data]).to eq([{
                                     :attributes =>
                                         {
                                             :answer_id => "fe4d77a4b8fa-918d0752-4e78-d251-4",
                                             :not_applicable => false,
                                             :question_id => "fe4d77a4b8fa-918d0752-4e78-d251-1"
                                         },
                                     :id => "fe4d77a4b8fa-918d0752-4e78-d251-bcdf",
                                     :type => "answer"
                                 },
                                 {
                                     :attributes =>
                                         {
                                             :answer_id => nil,
                                             :not_applicable => true,
                                             :question_id => "fe4d77a4b8fa-918d0752-4e78-d251-2"
                                         },
                                     :id => "fe4d77a4b8fa-918d0752-4e78-bcdf-d251",
                                     :type => "answer"

                                 }])
    end

  end

  context 'submit answers from the inspection' do
    it 'should fail if the inspection is completed' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[answers:write]'
                                      }, 1.hour.from_now)

      inspection_type = InspectionType.find_by(uuid: '918d0752-d251-bcdf-4e78-fe4d77a4b8fa')
      inspection = inspection_type.inspections.first

      inspection.update_columns({complete: true}) #bypass any validations


      put inspection_type_inspection_answers_path('918d0752-d251-bcdf-4e78-fe4d77a4b8fa', inspection.uuid), params: {},
          headers: {'Authorization' => jwt_token, Accept: 'application/vnd.api+json'}

      expect(response.status).to eq 400 # bad request

      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:errors]).to eq([{:detail => "Cannot update a completed inspection", :source => {}, :status => "400", :title => "Inspection Is Read Only"}])

    end

    it 'should store the answers for inspection - no existing answers' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[answers:write]'
                                      }, 1.hour.from_now)

      inspection_type = InspectionType.find_by(uuid: '918d0752-d251-bcdf-4e78-fe4d77a4b8fa')
      inspection = inspection_type.inspections.last

      expect(inspection.answers).to eq([]) #pre-flight test

      answers = [
          {
              question_id: 'fe4d77a4b8fa-918d0752-4e78-d251-1', # 'When was the grass cut?'
              answer_id: 'fe4d77a4b8fa-918d0752-4e78-d251-3', # 'This week'
              not_applicable: false,
              id: "fe4d77a4b8fa-918d0752-4e78-d251-bcdf"
          },
      # {
      #     question_id: 'fe4d77a4b8fa-918d0752-4e78-d251-2', # 'Has the hedge been trimmed?'
      #     answer_id: 'fe4d77a4b8fa-918d0752-4e78-d251-5', # "It's been a while"
      #     not_applicable: false
      # },
      ]


      put inspection_type_inspection_answers_path('918d0752-d251-bcdf-4e78-fe4d77a4b8fa', inspection.uuid), params: {data: answers},
          headers: {'Authorization' => jwt_token, Accept: 'application/vnd.api+json'}

      expect(response.status).to eq 200 # bad request

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:data]).to eq([{
                                     :attributes =>
                                         {
                                             question_id: 'fe4d77a4b8fa-918d0752-4e78-d251-1', # 'When was the grass cut?'
                                             answer_id: 'fe4d77a4b8fa-918d0752-4e78-d251-3', # 'This week'
                                             not_applicable: false
                                         },
                                     :id => "fe4d77a4b8fa-918d0752-4e78-d251-bcdf",
                                     :type => "answer"
                                 }])
      inspection.reload
      expect(inspection.complete).to be_falsey

    end


    it 'should combine new and existing  answers for inspection' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[answers:write]'
                                      }, 1.hour.from_now)

      inspection_type = InspectionType.find_by(uuid: '918d0752-d251-bcdf-4e78-fe4d77a4b8fa')
      inspection = inspection_type.inspections.last

      inspection.answers = [{
                                question_id: 'fe4d77a4b8fa-918d0752-4e78-d251-1', # 'When was the grass cut?'
                                answer_id: 'fe4d77a4b8fa-918d0752-4e78-d251-3', # 'This week'
                                not_applicable: false,
                                uuid: "fe4d77a4b8fa-918d0752-4e78-d251-bcdf"
                            }]

      inspection.save!
      answers = [
          {
              question_id: 'fe4d77a4b8fa-918d0752-4e78-d251-2', # 'Has the hedge been trimmed?'
              answer_id: 'fe4d77a4b8fa-918d0752-4e78-d251-5', # "It's been a while"
              not_applicable: false,
              id: "fe4d77a4b8fa-918d0752-4e78-bcdf-d251"
          }
      ]


      put inspection_type_inspection_answers_path('918d0752-d251-bcdf-4e78-fe4d77a4b8fa', inspection.uuid), params: {data: answers},
          headers: {'Authorization' => jwt_token, Accept: 'application/vnd.api+json'}

      expect(response.status).to eq 200 # bad request

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:data]).to eq([{
                                     :attributes =>
                                         {
                                             question_id: 'fe4d77a4b8fa-918d0752-4e78-d251-1', # 'When was the grass cut?'
                                             answer_id: 'fe4d77a4b8fa-918d0752-4e78-d251-3', # 'This week'
                                             not_applicable: false
                                         },
                                     :id => "fe4d77a4b8fa-918d0752-4e78-d251-bcdf",
                                     :type => "answer"
                                 },
                                 {
                                     :attributes =>
                                         {
                                             question_id: 'fe4d77a4b8fa-918d0752-4e78-d251-2', # 'Has the hedge been trimmed?'
                                             answer_id: 'fe4d77a4b8fa-918d0752-4e78-d251-5', # "It's been a while"
                                             not_applicable: false,
                                         },
                                     :id => "fe4d77a4b8fa-918d0752-4e78-bcdf-d251",
                                     :type => "answer"
                                 }])

    end

    it 'should mark that inspection complete if all questions are answered' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[answers:write]'
                                      }, 1.hour.from_now)

      inspection_type = InspectionType.find_by(uuid: '918d0752-d251-bcdf-4e78-fe4d77a4b8fa')
      inspection = inspection_type.inspections.last

      expect(inspection.answers).to eq([]) #pre-flight test

      answers = [
          {
              question_id: 'fe4d77a4b8fa-918d0752-4e78-d251-1', # 'When was the grass cut?'
              answer_id: 'fe4d77a4b8fa-918d0752-4e78-d251-3', # 'This week'
              not_applicable: false,
              id: "fe4d77a4b8fa-918d0752-4e78-d251-bcdf"
          },
          {
              question_id: 'fe4d77a4b8fa-918d0752-4e78-d251-2', # 'Has the hedge been trimmed?'
              answer_id: 'fe4d77a4b8fa-918d0752-4e78-d251-5', # "It's been a while"
              not_applicable: false,
              id: "fe4d77a4b8fa-918d0752-4e78-bcdf-d251"
          }
      ]


      put inspection_type_inspection_answers_path('918d0752-d251-bcdf-4e78-fe4d77a4b8fa', inspection.uuid), params: {data: answers},
          headers: {'Authorization' => jwt_token, Accept: 'application/vnd.api+json'}

      expect(response.status).to eq 200 # bad request

      inspection.reload

      expect(inspection.complete).to be_truthy
      expect(inspection.score).to be 150
    end


    xit 'it should reject answers for questions that arent part of this inspection' do

    end

    xit 'it should reject answers that arent for the question that arent part of this inspection' do

    end


  end

end