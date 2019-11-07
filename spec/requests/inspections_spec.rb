require 'rails_helper'

describe 'Inspections', type: :request do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end


  context 'get inspections for specified type' do


    it 'find all inspections for inspection type' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[inspections:read]'
                                      }, 1.hour.from_now)


      get inspection_type_inspections_path('918d0752-d251-bcdf-4e78-fe4d77a4b8fa'), params: {},
          headers: {'Authorization' => jwt_token, Accept: 'application/vnd.api+json'}

      expect(response.status).to eq 200


      body = JSON.parse(response.body, symbolize_names: true)

      inspection_type = InspectionType.find_by(uuid: '918d0752-d251-bcdf-4e78-fe4d77a4b8fa')

      expect(body[:data].size).to eq(inspection_type.inspections.size)

      #first one should  == the inspection_types
      expect(body[:data][0]).to eq({:attributes => {:complete => true, :due_date => inspection_type.first_inspection_date.to_s, :score => 50}, :id => "1-uuid-kkk", :type => "inspection"})
    end

    xit 'should allow pagination of the inspections as there may be many' do

    end

    it 'should find a specfic inspection' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[inspections:read]'
                                      }, 1.hour.from_now)

      inspection_type = InspectionType.find_by(uuid: '918d0752-d251-bcdf-4e78-fe4d77a4b8fa')
      inspection = inspection_type.inspections.order(:due_date).first

      get inspection_type_inspection_path('918d0752-d251-bcdf-4e78-fe4d77a4b8fa', inspection.uuid), params: {},
          headers: {'Authorization' => jwt_token, Accept: 'application/vnd.api+json'}

      expect(response.status).to eq 200


      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:data].size).to eq(1)

      #first one should  == the inspection_types
      expect(body[:data][0]).to eq({:attributes =>
                                        {:complete => inspection.complete,
                                         :due_date => inspection.due_date.to_s,
                                         :score => inspection.score
                                        }, :id => inspection.uuid, :type => "inspection"})

    end
  end

end