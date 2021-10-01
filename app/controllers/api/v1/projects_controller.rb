module Api
  module V1
    class ProjectsController < Api::V1::ApiController
      include Api::Concerns::Filterable

      def create
        @project = Project.create!(project_params)
        create_alerts #TODO: observer
        @project.add_project_technologies(technologies_params)
        render :show
      end

      def index
        @projects = filter!(Project).includes(:person_project, :people, :project_technologies,
                                              :technologies)
      end

      def show
        @project = Project.includes(:people, :person_project).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t('api.errors.project.not_found') }, status: :not_found
      end

      def update
        @project = Project.find(params[:id])
        @project.update!(project_params)
        @project.rebuild_project_technologies(technologies_params)
        update_alerts(project_params[:end_date])
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

      def project_params
        params.require(:project).permit(:name, :description, :start_date,
                                        :project_type, :project_state, :budget, :end_date,
                                        :organization)
      end

      def technologies_params
        params.require(:project)
        params[:project][:technologies]
      end

      def update_alerts(a_date)

        return if a_date.blank?

        if (Date.parse(a_date) - Date.parse(Time.now.strftime("%Y-%m-%d"))).to_i > 7
          UserProject.where(project_id: @project.id).update_all(notify: false, isvalid: true)
        else
          UserProject.where(project_id: @project.id).update_all(notify: true, isvalid: true)
        end
      end

      def create_alerts
        #byebug
        @users = User.all
        @users.each { |elem|
          UserProject.create(project_id: @project.id, user_id: elem[:id])
        }
        return if @project.end_date.blank?
        update_alerts(@project.end_date.strftime("%Y-%m-%d"))

      end


    end
  end
end
