class LinksController < ApplicationController
  def index
    @links = current_user.links
  end

  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new
  end

  def create
    @link = current_user.links.new(params[:link])
    @link.standardize_target_url!

    if @link.save
      flash[:success] = "Link created successfully"
      redirect_to links_path
    else
      render 'new'
    end
  end

  def edit
    @link = Link.find(params[:id])
  end

  def update
    @link = Link.find(params[:id])
    if @link.update(params[:link])
      @link.standardize_target_url!
      flash[:success] = "Link created successfully"
      redirect_to links_path
    else
      render 'new'
    end
  end

end
