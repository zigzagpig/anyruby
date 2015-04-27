class ArticlesController < ApplicationController
  before_action :logged_in_user

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
  
    if @article.save
      redirect_to @article
    else
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
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
   
    redirect_to articles_path
  end

  private
    #安全参数
    def article_params
      params.require(:article).permit(:title, :text)
    end

    #获取参数
    def find_params
      @article = Article.find(params[:id])
    end
end