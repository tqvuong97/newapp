class CommentsController < ApplicationController
  before_action :authen_comment, only: :destroy
  def new
    @comment = Comment.new
  end
  def create
    @micropost = Micropost.friendly.find(params[:micropost_id])
    @comment = @micropost.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to micropost_path(@micropost), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        p @comment.errors
        format.html { redirect_to micropost_path(@micropost), notice: 'Cannot create comment' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end

  end

  def show
  end

  def update
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to(@comment.micropost)
  end

  private
  def comment_params
    params.require(:comment).permit(:user_id,:micropost_id,:body)
  end
  def authen_comment
    @comment = Comment.find(params[:id])
    redirect_to @comment.micropost, notice: "You cannot delete this comment" if @comment.user != current_user
  end

end
