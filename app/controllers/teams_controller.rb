class TeamsController < ApplicationController

    before_action :validate_developer_id, only: [:create, :update]
    before_action :validate_team_id, only: [:update, :destroy]
    
    def create
        ActiveRecord::Base.transaction do            
            @team = Team.create!(name: params[:name], dept_name: params[:dept_name])            
            params[:developer_ids].each do |developer|
                @developer_team = DevelopersTeam.create!(developer_id: developer, team_id: @team.id)
            end
        end
        return render json: {message: "Team created successfully"}
    end

    def index
        @teams = Team.all
        return render json: {message: @teams}
    end

    def update
        ActiveRecord::Base.transaction do
            @team.update!(name: params[:name], dept_name: params[:dept_name])       
            @developers_teams = DevelopersTeam.where.not(developer_id: params[:developer_ids]).where(team_id: @team.id)
            @developers_teams.destroy_all if @developers_teams.present?
        end
        return render json: {message: "Team updated successfully"}
    end

    def destroy
        @team.destroy
        return render json: {message: "Team deleted successfully"}
    end

    def add_developers
        ActiveRecord::Base.transaction do           
            params[:developers].each do |developer|
                @developer = Developer.create!(full_name: developer["full_name"], email: developer["email"], mobile: developer[:mobile])
                params[:developer_ids] << @developer.id                
            end
            @team = Team.create!(params.permit(:name, :dept_name))           
            params[:developer_ids].each do |developer|
                @developer_team = DevelopersTeam.create!(developer_id: developer, team_id: @team.id)
            end
        end
        return render json: {message: "Developers added successfully to teams"}
    end

    def trigger_notification
        ActiveRecord::Base.transaction do            
            @team = Team.find_by(id: params[:team_id])
            return render json: {message: "Team does not exist"} unless @team.present?
            Message.create!(team_id: @team.id, content: params[:content], title: params[:title])
            Msg91MessageService.new.send_sms(@team.developers.collect(&:mobile), 'The content of this message')
            @team.developers.collect(&:email).each do |email|
                DeveloperMailer.send_email(email).deliver_now
            end
            @date = DateTime.now.in_time_zone("Chennai").strftime("%H:%M:%S IST %Y")        
            @sms = {id: SecureRandom.hex(10), mobiles: @team.developers.collect(&:mobile), content: params[:content], sent_at: @date}
            @email = {id: SecureRandom.hex(10), emails: @team.developers.collect(&:mobile), title: params[:title], content: params[:content], sent_at: @date}        
        end
        return render json: { team_id: params[:team_id], sms: @sms, email: @email}
    end
    
    def validate_developer_id
        params[:developer_ids].each do |developer_id|
            @developer = Developer.find_by(id: developer_id)
            return render json: {message: "Developer does not exist, please check the developer ids"} unless @developer.present?
        end
    end

    def validate_team_id
        @team = Team.find_by(id: params[:id].to_i)
        return render json: {message: "Team does not exist"} unless @team.present?
    end
end
