class Dashboard::DiscountsController < Dashboard::BaseController
  def show
    @discount = Discount.find(params[:id])
  end

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

  def edit
    @discount = Discount.find(params[:id])
    @merchant = @discount.user
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      flash[:notice] = "Your discount has been updated!"
      redirect_to dashboard_path
    else
      flash[:notice] = "An error occured when trying to update your discount."
      render :edit
    end
  end

  def destroy
    @discount = Discount.find(params[:id])
    @discount.destroy
    redirect_to dashboard_path
  end

  private

  def discount_params
    params.require(:discount).permit(:discount, :quantity, :discount_type)
  end
end
