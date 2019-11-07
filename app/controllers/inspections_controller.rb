class InspectionsController < ApplicationController

  def index

    inspections = current_client.inspections.joins(:inspection_type).where( inspection_types: {uuid: params[:inspection_type_id]}).order(:due_date)
    render jsonapi: inspections,
           status: :ok

  end

  def show

    inspection = current_client.inspections.joins(:inspection_type).where({ inspection_types: {uuid: params[:inspection_type_id]},
                                                                             inspections: {uuid: params[:id]}})
    render jsonapi: inspection,
           status: :ok

  end

  def required_scope
    "[inspections:#{required_permission}]"
  end

end
