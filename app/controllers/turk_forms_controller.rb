class TurkFormsController < ApplicationController
  layout "turk_form" 
  def show
    @turk_form = TurkForm.find(params[:id])
    @prompt = @turk_form.prompt
  end

end
