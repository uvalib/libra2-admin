class WorkFilesController < ApplicationController

  # POST /work_files
  # POST /work_files.json
  def create
    # @work = WorkFile.new(work_file_params)
	#
    # respond_to do |format|
    #   if @work.save
    #     format.html { redirect_to @work, notice: 'Work was successfully created.' }
    #     format.json { render :show, status: :created, location: @work }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @work.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /work_files/1
  # PATCH/PUT /work_files/1.json
  def update
    # respond_to do |format|
    #   errors = WorkFile.update(current_user, params[:id], work_file_params)
    #   if !errors
    #     format.json { render  json: {}, status: :ok }
    #   else
    #     format.json { render json: { error: errors }, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /work_files/1
  # DELETE /work_files/1.json
  def destroy
    work = params[:work]
    WorkFile.destroy(current_user, params[:id])
    respond_to do |format|
      format.html { redirect_to "/works/#{work}", notice: 'File was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def work_file_params
      params.require(:work_file).permit(:label)
    end
end
