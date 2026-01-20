# frozen_string_literal: true

class Books::CommentsController < CommentsController
  private

  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

  def set_render_variables
    @book = @commentable
    @comments = @book.comments.order(:id).includes(:user)
  end
end
