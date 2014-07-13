class LinksController < ApplicationController
  before_action :authenticate_user!

  def index
    @links = current_user.links
  end

  def show
    @link = current_user.links.find_by(:id => params[:id])

    unless @link
      flash[:warning] = "Link not found"
      redirect_to links_path
    end
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
    @link = current_user.links.find_by(:id => params[:id])

    unless @link
      flash[:warning] = "Link not found"
      redirect_to links_path
    end
  end

  def update
    @link = current_user.links.find_by(:id => params[:id])

    if @link && @link.update(params[:link])
      @link.standardize_target_url!
      flash[:success] = "Link created successfully"
      redirect_to links_path
    else
      render 'new'
    end
  end

  def destroy
    @link = current_user.links.find_by(:id => params[:id])

    if @link && @link.destroy
      flash[:success] = "Link destroyed successfully"
      redirect_to links_path
    else
      flash[:warning] = "Unsuccessful"
      redirect_to links_path
    end
  end

end
