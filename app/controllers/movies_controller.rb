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
    params[:sort_by] ? session[:sort_by] = params[:sort_by] : session[:sort_by] 
    params[:ratings] ? session[:ratings] = params[:ratings] : session[:ratings] = session[:ratings] || Movie.ratings 
    
    
    if session[:ratings] || session[:sort_by]
      ratings =[]
      session[:ratings].each {|k,v| ratings << k}

        @all_ratings.each do |k,v| 
          if !ratings.include? k
          @all_ratings[k] = false
          end
        end 

     case session[:sort_by]
      when "title"
      @movies = Movie.where(rating: ratings).order(:title)
      @title = 'hilite'
      @release = ''
      when "release_date"
      @movies = Movie.where(rating: ratings).order(:release_date)
      @title = ''
      @release = 'hilite'
      else #when there is no params[:sort_by]       
        @movies = Movie.where(rating: ratings)
      end 
    else  #when there is no params[:ratings]
      @movies = Movie.all
    end
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
