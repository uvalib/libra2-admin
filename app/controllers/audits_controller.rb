class AuditsController < ApplicationController

  #before_action :set_work, only: [:show]

  # GET /audits
  # GET /audits.json
  def index
    @audits = Audit.all
    render :index
  end

end
