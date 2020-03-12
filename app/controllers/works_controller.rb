class WorksController < ApplicationController
  require_dependency 'user_info_client'

  # GET /works
  # GET /works.json
  def all
    @works = Work.all
    render :index
  end

  # GET /works/latest
  # GET /works/latest.json
  def latest
    @works = Work.latest
    render :index
  end

  # GET /works/draft
  # GET /works/draft.json
  def draft
    @works = Work.draft
    render :index
  end

  # GET /works/submitted
  # GET /works/submitted.json
  def submitted
    @works = Work.submitted
    render :index
  end

  # GET /works/sis_only
  # GET /works/sis_only.json
  def sis_only
    @works = Work.sis_only
    render :index
  end

  # GET /works/optional_only
  # GET /works/optional_only.json
  def optional_only
    @works = Work.optional_only
    render :index
  end

  # GET /works/ingest_only
  # GET /works/ingest_only.json
  def ingest_only
    @works = Work.ingest_only
    render :index
  end

  # GET /works/libra_only
  # GET /works/libra_only.json
  def libra_only
    @works = Work.libra_only
    render :index
  end

  # GET /works/1
  # GET /works/1.json
  def show
    @work = Work.find( params[:id] )
    @audits = Audit.work( params[:id] )
    @file_upload_url = RestEndpoint.file_upload_url(current_user)
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

  def publish
    respond_to do |format|
      errors = Work.publish( current_user, params[:id] )
      if !errors
        format.json { render json: {}, status: :ok }
        format.html { redirect_to action: 'show', id: params[:id], notice: 'Work was successfully published.' }
      else
        format.json { render json: { error: errors }, status: :unprocessable_entity }
        format.html { redirect_to action: 'show', id: params[:id], notice: 'Error publishing work.' }
      end
    end
  end

  def unpublish
    respond_to do |format|
      errors = Work.unpublish( current_user, params[:id] )
      if !errors
        format.json { render json: {}, status: :ok }
        format.html { redirect_to action: 'show', id: params[:id], notice: 'Work was successfully unpublished.' }
      else
        format.json { render json: { error: errors }, status: :unprocessable_entity }
        format.html { redirect_to action: 'show', id: params[:id], notice: 'Error unpublishing work.' }
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
        if status == 200
          resp[:institution] = "University of Virginia"
          resp[:index] = params[:index]
        else
          resp = { }
        end
        render json: resp, status: :ok
      }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_params
     params.require(:work).permit(Work::EDITABLE)
  end
end
