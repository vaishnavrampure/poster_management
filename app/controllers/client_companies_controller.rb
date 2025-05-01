class ClientCompaniesController < ApplicationController
  before_action :require_login
  before_action :authorize_manage_client_companies, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @client_companies = ClientCompany.all
  end

  def show
    if current_user.client?
      @client_company = current_user.client_company
    else
      @client_company = ClientCompany.find(params[:id])
    end
  end

  def new
    @client_company = ClientCompany.new(status:"Pending")

  end

  def create
    @client_company = ClientCompany.new(client_company_params)
    if @client_company.save
      redirect_to clients_path, notice: "Client successfully created."
    else
      render :new
    end
  end

  def edit
    @client_company = ClientCompany.find(params[:id])
  end

  def update
    @client_company = ClientCompany.find(params[:id])
    
    if @client_company.update(client_company_params)
      if params[:user_ids]
        User.where(client_company_id: @client_company.id).update_all(client_company_id: nil)

        User.where(id: params[:user_ids]).update_all(client_company_id: @client_company.id)
      end
  
      redirect_to clients_path, notice: "Client updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @client_company = ClientCompany.find(params[:id])
    @client_company.destroy
    redirect_to clients_path, notice: "Client deleted successfully!"
  end

  private

  def client_company_params
    params.require(:client_company).permit(:name, :status)
  end

  def authorize_manage_client_companies
    unless current_user.has_permission?("manage:client_companies")
      redirect_to clients_path, alert: "You are not authorized to perform this action."
    end
  end
end
