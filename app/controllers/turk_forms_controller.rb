class TurkFormsController < ApplicationController
  layout "turk_form" 
  def show
    @turk_form = TurkForm.find(params[:id])
    @tweet_prompt = @turk_form.body
    @prompt = @turk_form.prompt
  end

end
