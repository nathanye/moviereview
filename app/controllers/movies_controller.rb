class MoviesController < ApplicationController

  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :find_movie_and_check_permission ,only: [:edit, :update, :destroy]

  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def edit
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user

    if @movie.save
      current_user.join!(@movie)
      redirect_to movies_path
    else
      render :new
    end
  end

  def update
    if @movie.update(movie_params)
      redirect_to movies_path, notice: "更新成功"
    else
      render :edit
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path, alert: "删除成功"
  end

  def favorite
    @movie = Movie.find(params[:id])

    if !current_user.is_member_of?(@movie)
      current_user.favorite!(@movie)
      flash[:notice] = "收藏成功！"
    else
      flash[:warning] = "已经收藏，不能重复收藏！"
    end

    redirect_to movie_path(@movie)
  end

  def dislike
    @movie = Movie.find(params[:id])

    if current_user.is_member_of?(@movie)
      current_user.dislike!(@movie)
      flash[:alert] = "取消收藏成功！"
    else
      flash[:warning] = "还没收藏，怎么取消？"
    end

    redirect_to movie_path(@movie)
  end


  private

  def find_movie_and_check_permission
    @movie = Movie.find(params[:id])

    if current_user != @movie.user
      redirect_to root_path, alert: "你的操作不被允许。"
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :description)
  end
end
