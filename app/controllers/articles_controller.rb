class ArticlesController < ApplicationController
  before_action :logged_in_user,  only: [:new, :create, :edit, :update, :destroy]

  def new
    @user = User.find(params[:user_id])
    @article = @user.articles.build
  end

  def create
    @user = User.find(params[:user_id])
    @article = @user.articles.create(article_params)
    if @article.save
      flash[:success] = "新文章写入成功了哦!"
      redirect_to user_article_path(id: @article.id)
    else
      flash.now[:danger] = '空 标题/内容 啊 这怎么行' #完全正确
      render 'new'
    end
  end

  def edit
    find_params
  end

  def index
  	@articles = Article.all
  end

  def show
    find_params
  end

  def update
    find_params
    
    if @article.update(article_params)
      flash[:success] = "修改文章成功了哦!"
      redirect_to user_article_path(id: @article.id)
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])

    @article.destroy
    redirect_to user_articles_path(current_user) 
  end

  private
    #安全参数
    def article_params
      params.require(:article).permit(:title, :text, :user_id)
    end

    #获取参数
    def find_params
      @article = Article.find(params[:id])
    end
end