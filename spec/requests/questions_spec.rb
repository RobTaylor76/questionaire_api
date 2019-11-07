require 'rails_helper'

describe 'Inspection Type Questions', type: :request do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end


  context 'get inspection type questions for specified type' do


    it 'find the questions and possible answers for the inspection type' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[questions:read]'
                                      }, 1.hour.from_now)


      get inspection_type_questions_path('918d0752-d251-bcdf-4e78-fe4d77a4b8fa'), params: {},
          headers: {'Authorization' => jwt_token,  Accept: 'application/vnd.api+json'}

      expect(response.status).to eq 200


      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:data]).to eq([{:attributes=>
                                      {:answers=>
                                           [{:uuid=>"fe4d77a4b8fa-918d0752-4e78-d251-2", :display_text=>"Today", :value=>100},
                                            {:uuid=>"fe4d77a4b8fa-918d0752-4e78-d251-3", :display_text=>"This week", :value=>75},
                                            {:uuid=>"fe4d77a4b8fa-918d0752-4e78-d251-4", :display_text=>"Last week", :value=>50},
                                            {:uuid=>"fe4d77a4b8fa-918d0752-4e78-d251-5", :display_text=>"It's been a while", :value=>75}],
                                       :sequence=>1,
                                       :text=>"When was the grass cut?",
                                       :allow_not_applicable_response=>false},
                                  :id=>"fe4d77a4b8fa-918d0752-4e78-d251-1",
                                  :type=>"question"},
                                 {:attributes=>
                                      {:answers=>
                                           [{:uuid=>"fe4d77a4b8fa-918d0752-4e78-d251-2",:display_text=>"Today", :value=>100},
                                            {:uuid=>"fe4d77a4b8fa-918d0752-4e78-d251-3",:display_text=>"This week", :value=>75},
                                            {:uuid=>"fe4d77a4b8fa-918d0752-4e78-d251-4",:display_text=>"Last week", :value=>50},
                                            {:uuid=>"fe4d77a4b8fa-918d0752-4e78-d251-5",:display_text=>"It's been a while", :value=>75}],
                                       :sequence=>2,
                                       :text=>"Has the hedge been trimmed?",
                                       :allow_not_applicable_response=>true},
                                  :id=>"fe4d77a4b8fa-918d0752-4e78-d251-2",
                                  :type=>"question"}])
    end

  end

end