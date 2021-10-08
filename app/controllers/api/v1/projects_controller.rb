module Api
  module V1
    class ProjectsController < Api::V1::ApiController
      def create
        @project = Project.create!(project_params)
        @project.add_project_technologies(technologies_params)
        render :show
      end

      def index
        @projects = Project.all
      end

      def show
        @project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.project.not_found') }, status: :not_found
      end

      def update
        @project = Project.find(params[:id])
        @project.update!(project_params)
        update_technologies
        render :show
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.project.not_found') }, status: :not_found
      end

      def destroy
        project = Project.find(params[:id])
        project.destroy!
        render json: { message: I18n.t('api.success.project.record_delete',
                                       { name: project.name }) }
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.project.not_found') }, status: :not_found
      end

      private

      def update_technologies
        # Creada para rubocop
        if request.put?
          @project.add_project_technologies(technologies_params)
        elsif request.patch? # El segundo metodo borra las que tenia
          @project.rebuild_project_technologies(technologies_params)
        end
      end

      def project_params
        params.require(:project).permit(:name, :description, :start_date,
                                        :project_type, :project_state, :budget, :end_date)
      end

      def technologies_params
        params.require(:project)
        params[:project][:technologies]
      end
    end
  end
end
