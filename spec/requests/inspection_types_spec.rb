require 'rails_helper'

describe 'Inspection Types', type: :request do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context 'JWT Tests - Validity and Authorization' do
    it 'will reject call if no jwt tokes' do
      get inspection_types_path, params: {}, headers: {'Authorization' => '',
                                                       Accept: 'application/vnd.api+json'}
      expect(response.status).to eq 401
    end

    it 'will reject tampered jwt token ' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[inspection-types:read]'
                                      }, 1.hour.from_now)

      get inspection_types_path, params: {}, headers: {'Authorization' => jwt_token[0...-1],
                                                       Accept: 'application/vnd.api+json'}
      expect(response.status).to eq 401
    end

    it 'will reject call if expired jwt token' do

      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[inspection-types:read]'
                                      }, 1.hour.ago)


      get inspection_types_path, params: {}, headers: {'Authorization' => jwt_token,
                                                       Accept: 'application/vnd.api+json'}
      expect(response.status).to eq 401

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:errors]).to eq([{:detail=>"Need api scope: [inspection-types:read]", :source=>{}, :status=>"401", :title=>"Not Authorized"}])

    end

    it 'will reject request if JWT doesnt have required authorization' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[inspection-types:wibble]'
                                      }, 1.hour.ago)


      get inspection_types_path, params: {}, headers: {'Authorization' => jwt_token,
                                                       Accept: 'application/vnd.api+json'}
      expect(response.status).to eq 401


      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:errors]).to eq([{:detail=>"Need api scope: [inspection-types:read]", :source=>{}, :status=>"401", :title=>"Not Authorized"}])

    end

    it 'will accept call if valid jwt token supplied' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[inspection-types:read]'
                                      }, 1.hour.from_now)


      get inspection_types_path, params: {}, headers: {'Authorization' => jwt_token,
                                                       Accept: 'application/vnd.api+json'}

      expect(response.status).to eq 200
    end

  end

  context 'get inspection types for client' do


    it 'list all the inspection types based on the jwt token contents' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[inspection-types:read]'
                                      }, 1.hour.from_now)


      get inspection_types_path, params: {}, headers: {'Authorization' => jwt_token,
                                                    Accept: 'application/vnd.api+json'}

      expect(response.status).to eq 200


      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:data]).to eq([
                                    {:attributes=>{:interval=>7, :name=>"Inspect The Garden"}, :id=>"918d0752-4e78-d251-bcdf-fe4d77a4b8fa", :type=>"inspection_type"},
                                    {:attributes=>{:interval=>14, :name=>"Inspect The House"}, :id=>"918d0752-d251-bcdf-4e78-fe4d77a4b8fa", :type=>"inspection_type"}])
    end

    it 'find the specified inspection type for client based on the jwt token contents' do
      jwt_token = JsonWebToken.encode({
                                          client: {
                                              uuid: '918d0752-d251-4e78-bcdf-fe4d77a4b8fa'
                                          },
                                          scope: '[inspection-types:read]'
                                      }, 1.hour.from_now)


      get inspection_type_path('918d0752-d251-bcdf-4e78-fe4d77a4b8fa'), params: {},
          headers: {'Authorization' => jwt_token,  Accept: 'application/vnd.api+json'}

      expect(response.status).to eq 200


      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:data]).to eq({:attributes=>{:interval=>14, :name=>"Inspect The House"}, :id=>"918d0752-d251-bcdf-4e78-fe4d77a4b8fa", :type=>"inspection_type"})
    end

  end

end