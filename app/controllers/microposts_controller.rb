class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
  	@micropost = current_user.microposts.build(micropost_params)
  	if @micropost.save
  	  flash[:success] = "哎哟 不错啊 发布成功了 ❤️"
      redirect_to root_url
	  else
      @feed_items = []
      @feed_items = current_user.feed.paginate(page: params[:page])
	    render 'static_pages/home'
	  end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "好伤心 竟然把微博删了"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
    	params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      unless current_user.admin
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
      end
      @micropost = Micropost.find_by(params[:id])
    end

end
