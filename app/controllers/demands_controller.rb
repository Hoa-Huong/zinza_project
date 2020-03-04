class DemandsController < ApplicationController
  include DemandsHelper

  before_action :demand, only: %i(show edit update)

  def index
    @demands = Demand.includes(:province, :district)
  end

  def create
    @demand = current_user.demands.new demand_params
    if @demand.save
      flash[:success] = t "create_demand_success"
      redirect_to user_my_demands_path current_user.id
    else
      flash[:danger] = t "create_demand_fail"
      render :new
    end
  end

  def new
    @demand = Demand.new
  end

  def edit
  end

  def show
  end

  def update
    if @demand.update demand_params
      flash[:success]= t "update_demand_success"
      redirect_to user_my_demands_path current_user.id
    else
      flash[:danger] = t "update_demand_fail"
      render :edit_my_demand
    end
  end

  def my_demands
    @demands = Demand.where(user_id: current_user.id).includes(:province, :district)
  end

  private

  def demand_params
    params.require(:demand).permit(:user_id, :title, :subject, :fee, :time_per_session, :number_student, :note, :level_class, :province_id, :district_id)
  end

  def demand
    @demand = Demand.find_by id: params[:id]
    return if @demand

    flash[:danger] = t "demand_not_found"
    redirect_to root_url
  end
end