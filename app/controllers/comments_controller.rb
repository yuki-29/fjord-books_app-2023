# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy]
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

  def set_commentable
    if params[:book_id]
      @commentable = Book.find(params[:book_id])
    elsif params[:report_id]
      @commentable = Report.find(params[:report_id])
    end
  end

  def set_render_variables
    case @commentable
    when Book
      @book = @commentable
      @comments = @book.comments.order(:id)
    when Report
      @report = @commentable
      @comments = @report.comments.order(:id).includes(:user)
    end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def correct_user
    return if current_user.id == @comment.user_id

    flash[:notice] = t('errors.messages.unauthorized')
    redirect_to @commentable
  end
end
