class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy] 
  before_action :set_comment, only: %i[destroy]
  before_action :correct_user, only: %i[destroy] 

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    redirect_to @commentable
  end

  def destroy
    @comment.destroy
    redirect_to @commentable
  end
  
  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    if params[:book_id]
      @commentable = Book.find(params[:book_id])
    elsif params[:report_id]
      @commentable = Report.find(params[:report_id])
    end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def correct_user
    if current_user.id != @comment.user_id
      flash[:notice] = t('errors.messages.unauthorized')
      redirect_to @commentable
    end
  end

end
