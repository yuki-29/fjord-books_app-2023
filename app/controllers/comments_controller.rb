class CommentsController < ApplicationController
  before_action :set_report, only: %i[create destroy]
  before_action :ensure_correct_user, only: %i[destroy]

  def create
    @comment = @report.comments.new(comment_params)
    @comment.user = current_user
    @comment.commentable_type = "Report"
    @comment.save
    redirect_to report_path(@report)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to report_path(@report)
  end
  
  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_report
    @report = Report.find(params[:report_id])
  end

  def ensure_correct_user
    if current_user.id != @report.user_id
      flash[:notice] = "権限がありません"
      redirect_to report_path(@report)
    end
  end

end
