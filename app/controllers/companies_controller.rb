class CompaniesController < ApplicationController
  before_action :set_company, except: [:index, :create, :new]

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def show
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      generate_stylesheet = Services::GenerateCustomStyle.new(@company.id)
      generate_stylesheet.compile
      redirect_to companies_path, notice: "Saved"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @company.update(company_params)
      generate_stylesheet = Services::GenerateCustomStyle.new(@company.id)
      generate_stylesheet.compile
      redirect_to companies_path, notice: "Changes Saved"
    else
      render :edit
    end
  end 

  def destroy
    if @company.destroy
      redirect_to companies_path, notice: "Deleted Successfully"
    else
      render :index
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :legal_name,
      :description,
      :zip_code,
      :phone,
      :email,
      :theme_color,
      :owner_id,
      services: []
    )
  end

  def set_company
    @company = Company.find(params[:id])
  end
  
end
