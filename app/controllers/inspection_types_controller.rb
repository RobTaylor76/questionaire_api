class InspectionTypesController < ApplicationController

  def index

    inspection_types = current_client.inspection_types.all
    render jsonapi: inspection_types,
           status: :ok

  end

  def show
    inspection_type = current_client.inspection_types.find_by(uuid: params[:id])
    render jsonapi: inspection_type,
           status: :ok

  end

  def required_scope
    "[inspection-types:#{required_permission}]"
  end

end
