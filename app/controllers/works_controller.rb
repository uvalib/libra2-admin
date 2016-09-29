class WorksController < ApplicationController
  require_dependency 'user_info_client'

  before_action :set_work, only: [:show]

  # GET /works
  # GET /works.json
  def all
    @works = Work.all
    @title = 'All Works'
    render :index
  end

  # GET /works/latest
  # GET /works/latest.json
  def latest
    @works = Work.latest
    @title = 'Latest Works (last 7 days)'
    render :index
  end

  # GET /works/draft
  # GET /works/draft.json
  def draft
    @works = Work.draft
    @title = 'Draft Works'
    render :index
  end

  # GET /works/submitted
  # GET /works/submitted.json
  def submitted
    @works = Work.submitted
    @title = 'Published Works'
    render :index
  end

  # GET /works/1
  # GET /works/1.json
  def show
    @file_upload_url = Libra2.file_upload_url(current_user)
  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update

    respond_to do |format|
      errors = Work.update(current_user, params[:id], work_params)
      if !errors
        format.json { render json: {}, status: :ok }
      else
        format.json { render json: { error: errors }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy

    respond_to do |format|
      errors = Work.destroy(current_user, params[:id])
      if !errors
        format.html { redirect_to root_path, notice: 'Work was successfully destroyed.' }
        format.json { render json: {}, status: :ok }
      else
        format.html { redirect_to root_path, notice: 'Error destroying work.' }
        format.json { render json: { error: errors }, status: :unprocessable_entity }
      end
    end

  end

  # GET /computing_id
  def computing_id
    respond_to do |wants|
      wants.json {
        status, resp = ServiceClient::UserInfoClient.instance.get_by_id( params[:id] )
        if status == 404
          resp = { }
        else
          resp[:institution] = "University of Virginia"
          resp[:index] = params[:index]
        end
        render json: resp, status: :ok
      }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work
     @work = Work.find( params[:id] )
     @audits = Audit.work( params[:id] )
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_params
     params.require(:work).permit(Work::EDITABLE)
  end
end
