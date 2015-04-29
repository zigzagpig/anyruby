class MiniQuorasController < ApplicationController
  before_action :logged_in_user,  only: [:new, :create, :edit, :update, :destroy]
  
  def new
  	@mini_quora = current_user.mini_quoras.build
  end

  def create
    @mini_quora = current_user.mini_quoras.create(mini_quora_params)
	  if @mini_quora.save
      flash[:success] = "成功提出了问题哦!"
      redirect_to mini_quora_path(id: @mini_quora.id)
    else
      flash.now[:danger] = '不对哦' 
      render 'new'
    end
  end

  def show
	  find_params
  end

  def index
	  @mini_quoras = MiniQuora.all
  end

  def edit
    find_params
  end

  def update
    find_params
    
    if @mini_quora.update(mini_quora_params)
      flash[:success] = "修改成功了哦!"
      redirect_to mini_quora_path(id: @mini_quora.id)
    else
      render 'edit'
    end
  end

  def destroy
    @mini_quora = MiniQuora.find(params[:id])
    @mini_quora.destroy
    flash[:success] = "删除成功了哦!"
 
    redirect_to mini_quoras_path
  end

  private
	  def mini_quora_params
	    params.require(:mini_quora).permit(:question)
	  end

    def find_params
      @mini_quora = MiniQuora.find(params[:id])
    end

end
