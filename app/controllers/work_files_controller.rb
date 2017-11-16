class WorkFilesController < ApplicationController

  # POST /work_files
  # POST /work_files.json
  def create

    work_id = params[:work]
    file_id = params[:file]
    label = params[:label]

    respond_to do |format|
      errors = WorkFile.create( current_user, file_id, work_id, label )
      if !errors
         format.html { redirect_to "/works/#{work_id}", notice: 'File was successfully added.' }
         format.json { render json: {}, status: :ok }
      else
        format.html { redirect_to "/works/#{work_id}", notice: 'Error adding file.' }
        format.json { render json: { error: errors }, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /work_files/1
  # DELETE /work_files/1.json
  def destroy
    work_id = params[:work]
    respond_to do |format|
      errors = WorkFile.destroy( current_user, params[:id] )
      if !errors
         format.html { redirect_to "/works/#{work_id}", notice: 'File was successfully removed.' }
         format.json { render json: {}, status: :ok }
      else
        format.html { redirect_to "/works/#{work_id}", notice: 'Error removing file.' }
        format.json { render json: { error: errors }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      errors = WorkFile.update( current_user, params[:id], work_file_params )
      if !errors
         format.html { redirect_to "/works/#{work_id}", notice: 'File was successfully updated.' }
         format.json { render json: {}, status: :ok }
      else
        format.html { redirect_to "/works/#{work_id}", notice: 'Error updating file.' }
        format.json { render json: { error: errors }, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def work_file_params
      params.require(:work_file).permit(:label)
    end

end
