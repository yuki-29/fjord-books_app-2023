# frozen_string_literal: true

class Report < ApplicationRecord

  URL_DETECTION = /http:\/\/localhost:3000\/reports\/([0-9]+)/

  after_save :save_mentions

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  # 1:多 レポートから、mentioning_report, mentioned_reportを紐づける。
  has_many :active_mentions, class_name: 'Mention', foreign_key: :mentioning_report_id, dependent: :destroy
  has_many :passive_mentions, class_name: 'Mention', foreign_key: :mentioned_report_id, dependent: :destroy
  # 多:多
  # has_many :mentioning_reports, through: :active_mentions, source: :mentioned_report
  # has_many :mentioned_reports, through: :passive_mentions, source: :mentioning_report
  has_many :mentioned_reports, through: :active_mentions
  has_many :mentioning_reports, through: :passive_mentions

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
    report_ids = self.content.scan(URL_DETECTION).flatten.map(&:to_i)
    mention_ids = self.mentioned_reports.ids

    if report_ids.sort != mention_ids.sort
      delete_ids = mention_ids - report_ids
      mention = self.active_mentions.where(mentioned_report_id: delete_ids)
      mention.destroy_all

      report_ids.each do |id|
        if !self.active_mentions.where(mentioned_report_id: id).present?
          mention = self.active_mentions.build(mentioned_report_id: id)
          mention.save
        end
      end
    end

  end
end
