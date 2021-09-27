class Api::V1::ProjectsController < ApplicationController
  def create
    @project = Project.create!(project_params)
    render :show
  rescue ActiveRecord::RecordInvalid
    render json: { error: I18n.t('api.errors.project.invalid', {params: project_params}) }, status: :not_acceptable
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
    render json: { message: I18n.t('api.success.project.record_delete', { name: project.first_name }) }
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('api.errors.project.not_found') }, status: :not_found
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :start_date, :project_type, :project_state)
  end
end
