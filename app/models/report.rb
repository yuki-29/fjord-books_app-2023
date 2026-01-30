# frozen_string_literal: true

class Report < ApplicationRecord
  REPORT_URL_REGEX = %r{http://localhost:3000/reports/([0-9]+)}

  after_save :save_mentions

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_mentions, class_name: 'Mention', foreign_key: :mentioning_report_id, inverse_of: :mentioning_report, dependent: :destroy
  has_many :passive_mentions, class_name: 'Mention', foreign_key: :mentioned_report_id, inverse_of: :mentioned_report, dependent: :destroy

  has_many :mentioning_reports, through: :active_mentions, source: :mentioned_report
  has_many :mentioned_reports, through: :passive_mentions, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def save_mentions
    report_ids = content.scan(REPORT_URL_REGEX).flatten.map(&:to_i).uniq
    reports = Report.where(id: report_ids)
    self.mentioning_reports = reports
  end
end
