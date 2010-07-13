class TurkFormsController < ApplicationController
  def show
    @turk_form = TurkForm.find(params[:id])
  end

end
