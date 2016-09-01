class WorksController < ApplicationController
  before_action :set_work, only: [:show]

  # GET /works
  # GET /works.json
  def index
    @works = Work.all
      @title = "All Works"
  end

  # GET /works/draft
  # GET /works/draft.json
  def draft
    @works = Work.search({ status: 'pending' })
    @title = "All Drafts"
      render :index
  end

  # GET /works/submitted
  # GET /works/submitted.json
  def submitted
    @works = Work.search({ status: 'submitted' })
    @title = "All Published Works"
    render :index
  end

  # GET /works/1
  # GET /works/1.json
  def show
    @file_upload_url = Libra2.file_upload_url(current_user)
  end

  # GET /works/new
  def new
    @work = Work.new
  end

  # GET /works/1/edit
  def edit
  end

  # POST /works
  # POST /works.json
  def create
    @work = Work.new(work_params)

    respond_to do |format|
      if @work.save
        format.html { redirect_to @work, notice: 'Work was successfully created.' }
        format.json { render :show, status: :created, location: @work }
      else
        format.html { render :new }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    respond_to do |format|
      errors = Work.update(current_user, params[:id], work_params)
      if !errors
        format.json { render  json: {}, status: :ok }
      else
        format.json { render json: { error: errors }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy
    Work.destroy(current_user, params[:id])
    respond_to do |format|
      format.html { redirect_to works_url, notice: 'Work was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work
      @work = Work.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_params
      params.require(:work).permit(Work::EDITABLE)
    end
end
