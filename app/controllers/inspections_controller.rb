class InspectionsController < ApplicationController

  deserializable_resource :inspections, only: [:index, :show, :update]

  def index

    inspections = current_client.inspections.joins(:inspection_type).where( inspection_types: {uuid: params[:inspection_type_id]})
    render jsonapi: inspections,
           status: :ok

  end

  def show

    inspections = current_client.inspections.joins(:inspection_type).where({ inspection_types: {uuid: params[:inspection_type_id]},
                                                                             inspections: {uuid: params[:id]}})
    render jsonapi: inspections,
           status: :ok

  end

  def required_scope
    "[inspections:#{required_permission}]"
  end

end
