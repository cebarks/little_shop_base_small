class Dashboard::DiscountsController < ApplicationController
  def new
    @discount = Discount.new
    @merchant = current_user
  end

  def create
    @discount = Discount.new(discount_params)
    @discount.user = User.find(params[:merchant_id])

    if @discount.save
      flash[:notice] = "Your discount was created successfully."
      redirect_to dashboard_path
    else
      flash[:notice] = "An error occured."
      render :new
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:discount, :quantity, :discount_type)
  end
end
