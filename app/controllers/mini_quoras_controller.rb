class MiniQuorasController < ApplicationController
  before_action :logged_in_user,  only: [:new, :create, :edit, :update, :destroy]
  def new
  	
  end

  def create
    @mini_quora = current_user.mini_quoras.create(mini_quora_params)
    flash[:success] = "#{current_user.id}"
	  if @mini_quora.save
      flash[:success] = "成功提出了问题哦!"
      redirect_to mini_quora_path(id: @mini_quora.id)
    else
      flash.now[:danger] = '空问题啊 这怎么行' #完全正确
      render 'new'
    end
  end

  def show
	  @mini_quora = MiniQuora.find(params[:id])
  end

  def index
	  @mini_quoras = MiniQuora.all
  end

  private
	  def mini_quora_params
	    params.require(:mini_quora).permit(:question, :user_id)
	  end

    def method_name
      
    end

end
