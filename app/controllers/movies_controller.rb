class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings

    @sort_by = params[:sort_by]
    @ratings = params[:ratings]

    if @sort_by.nil? || @ratings.nil?
      params[:sort_by] = session[:sort_by] || '' if @sort_by.nil?
      params[:ratings] = session[:ratings] || Movie.ratings if @ratings.nil?
      redirect_to movies_path(params)
    else
      @movies = Movie.where(rating: @ratings.keys).order(@sort_by)
      
      @all_ratings.each do |k,v|
          if !params[:ratings].keys.include? k
            @all_ratings[k] = false
          end
      end

      if @sort_by == 'title'
        @title, @release = 'hilite', ''
      elsif @sort_by == 'release_date'
        @title, @release = '','hilite'
      else
        @title, @release = '',''
      end       
    end
    session[:sort_by] = @sort_by
    session[:ratings] = @ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
