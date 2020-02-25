class PrivateInformationsController < ApplicationController
  def edit
    @private_information = PrivateInformation.find(params[:id])
  end

  def update
    PrivateInformation.find(params[:id]).update(update_params)
    redirect_back fallback_location: edit_private_information_path(params[:id])
  end

  private

  def update_params
    params.require(:private_information).permit(:postal_code, :prefectures, :city, :house_number, :building_name)
  end
end
