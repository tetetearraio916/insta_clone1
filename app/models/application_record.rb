class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # 最新順でかつrecentの引数に対してその数だけuserの情報を取得する
  scope :recent, ->(count) { order(created_at: :desc).limit(count) }
end
