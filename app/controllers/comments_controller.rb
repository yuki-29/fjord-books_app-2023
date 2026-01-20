# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create]
  before_action :set_comment, only: %i[destroy]
  before_action :correct_user, only: %i[destroy]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable
    else
      set_render_variables
      render "#{@commentable.class.table_name}/show", status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy!
    redirect_to @commentable
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    set_commentable
    @comment = @commentable.comments.find(params[:id])
  end

  def correct_user
    return if current_user.id == @comment.user_id

    flash[:notice] = t('errors.messages.unauthorized')
    redirect_to @commentable
  end
end
