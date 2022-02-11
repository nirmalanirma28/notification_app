class DevelopersController < ApplicationController
    before_action :validate_id, only: [:update, :destroy]

    def create
        @developer = Developer.create!(params.permit(:full_name, :email, :mobile))        
        return render json: {message: "Developer created successfully"}
    end

    def index
        @developers = Developer.all
        return render json: {message: @developers}
    end

    def update       
        @developer.update!(full_name: params[:full_name], email: params[:email], mobile: params[:mobile])
        return render json: {message: "Developer updated successfully"}
    end

    def destroy        
        @developer.destroy
        return render json: {message: "Developer deleted successfully"}
    end    

    def validate_id
        @developer = Developer.find_by(id: params[:id])
        return render json: {message: "Developer not exist"} unless @developer.present?
    end
end
