class Api::V1::ProjectsController < ApplicationController
  def create
    @project = Project.create!(Project_params.merge(project_state: PROJECT_STATES[3])) #por defecto el proyecto empieza en estado "verde"
    render :show
  end

  def index
    @project = Project.all
  end

  def show
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('api.errors.project.not_found') }, status: :not_found
  end

  def update
    @project = Project.find(params[:id])
    @project.update!(project_params)
    render :show
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('api.errors.project.not_found') }, status: :not_found
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy!
    render json: { message: I18n.t('api.success.record_delete', { name: project.first_name }) }
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('api.errors.person.not_found') }, status: :not_found
  end

  private

  def Project_params
    params.require(:project).permit(:name, :description, :start_date, :project_type)
  end
end
