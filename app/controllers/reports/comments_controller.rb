# frozen_string_literal: true

class Reports::CommentsController < CommentsController
  private

  def view_namespace
    "reports"
  end

  def set_commentable
    @commentable = Report.find(params[:report_id])
  end

  def set_render_variables
    @report = @commentable
    @comments = @report.comments.order(:id).includes(:user)
  end
end
