# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :set_micropost, only: %i[show edit update destroy]
  before_action :check_owner_post, only: %i[edit update destroy]
  before_action :authenticate_user!
  # GET /microposts
  # GET /microposts.json
  def index
    (@filterrific = initialize_filterrific(
      Micropost,
      params[:filterrific],
      select_options: {
        sorted_by: Micropost.options_for_sorted_by,
        with_category_id: Category.options_for_select
      },
      persistence_id: 'shared_key',
      sanitize_params: true
    )) || return
    @microposts = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /microposts/1
  # GET /microposts/1.json
  def show
    @comment = Comment.new
    @comment = @micropost.comments
  end

  # GET /microposts/new
  def new
    @micropost = current_user.microposts.new
  end

  # GET /microposts/1/edit
  def edit; end

  # POST /microposts
  # POST /microposts.json
  def create
    @micropost = Micropost.new(micropost_params)
    @micropost.user_id = current_user.id
    respond_to do |format|
      if @micropost.save
        format.html { redirect_to user_micropost_path(current_user.id, @micropost), notice: 'Micropost was successfully created.' }
        format.json { render :show, status: :created, location: @micropost }
      else
        format.html { render :new }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /microposts/1
  # PATCH/PUT /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to @micropost, notice: 'Micropost was successfully updated.' }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_to microposts_url, notice: 'Micropost was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_micropost
    @micropost = Micropost.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def micropost_params
    params.require(:micropost).permit(:title, :content, :user_id, :category_id)
  end

  def check_owner_post
    if @micropost.user_id != current_user.id
      redirect_to microposts_path, notice: 'no permit to edit'
    end
  end
end
