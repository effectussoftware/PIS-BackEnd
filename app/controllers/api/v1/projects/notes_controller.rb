module Api
  module V1
    class Projects::NotesController < Api::V1::ApiController

      def create
        @note = Project.find(params[:project_id]).notes.create!(note_params)       
      end
  
      def update
        @note = Note.includes(:project).find(params[:id])
        @note.update!(note_params)
      end

      def destroy
        note = Note.find(params[:id]).destroy!
        head :ok
      end

      private

      def note_params
        params.require(:note).permit(:text)
      end

    end
  end
end
  