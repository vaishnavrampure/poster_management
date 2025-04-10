class ClientCompaniesController < ApplicationController
  before_action :require_login
  before_action :authorize_manage_client_companies, only: [:new, :create, :edit, :update, :destroy]

  def index
    @client_companies = ClientCompany.all
  end

  def show
    @client_company = ClientCompany.find(params[:id])
  end

  def new
    @client_company = ClientCompany.new
  end

  def create
    @client_company = ClientCompany.new(client_company_params)
    if @client_company.save
      redirect_to client_companies_path, notice: "Client successfully created."
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
      redirect_to client_companies_path, notice: "Client updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @client_company = ClientCompany.find(params[:id])
    @client_company.destroy
    redirect_to client_companies_path, notice: "Client deleted successfully!"
  end

  private

  def client_company_params
    params.require(:client_company).permit(:name)
  end

  def authorize_manage_client_companies
    unless current_user.has_permission?("manage:client_companies")
      redirect_to client_companies_path, alert: "You are not authorized to perform this action."
    end
  end
end
