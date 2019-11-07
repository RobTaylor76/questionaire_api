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

end