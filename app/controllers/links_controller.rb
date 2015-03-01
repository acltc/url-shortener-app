class LinksController < ApplicationController
  before_action :authenticate_user!

  def index
    @links = current_user.links
  end

  def show
    @link = Link.find_by(:id => params[:id], :user_id => current_user.id)

    unless @link
      flash[:warning] = "Link not found"
      redirect_to links_path
    end
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(:slug => params[:slug], :target_url => params[:target_url], :user_id => current_user.id)
    @link.standardize_target_url!

    if @link.save
      flash[:success] = "Link created successfully"
      redirect_to links_path
    else
      render 'new'
    end
  end

  def edit
    @link = Link.find_by(:id => params[:id], :user_id => current_user.id)
    
    unless @link
      flash[:warning] = "Link not found"
      redirect_to links_path
    end
  end

  def update
    @link = Link.find_by(:id => params[:id], :user_id => current_user.id)

    if @link && @link.update(:slug => params[:slug], :target_url => params[:target_url])
      @link.standardize_target_url!
      flash[:success] = "Link created successfully"
      redirect_to links_path
    else
      render 'edit'
    end
  end

  def destroy
    @link = Link.find_by(:id => params[:id], :user_id => current_user.id)

    if @link && @link.destroy
      flash[:success] = "Link destroyed successfully"
      redirect_to links_path
    else
      flash[:warning] = "Unsuccessful"
      redirect_to links_path
    end
  end

end
