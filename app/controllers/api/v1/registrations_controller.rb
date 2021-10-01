module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      # protect_from_forgery with: :exception
      skip_forgery_protection
      include Api::Concerns::ActAsApiRequest

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation,
                                     :first_name, :last_name)
      end

      def render_create_success
        user = User.find_by(email: sign_up_params[:email])
        Project.all.each { |proyect| proyect.add_alert(user) }

        render :create
        @projects = Project.all
        @projects.each { |elem|
          UserProject.create(project_id: elem.id, user_id: User.find_by(email: sign_up_params[:email])[:id])
          unless elem.end_date.blank?
            update_alerts_from_user(elem.end_date.strftime("%Y-%m-%d"),elem.id)
          end
        }
      end

      def update_alerts_from_user(a_date,p_id)
        return if a_date.blank?
        if (Date.parse(a_date) - Date.parse(Time.now.strftime("%Y-%m-%d"))).to_i > 7
          UserProject.where(project_id: p_id).update_all(notify: false, isvalid: true)
        else
          UserProject.where(project_id: p_id).update_all(notify: true, isvalid: true)
        end
      end

    end
  end
end
