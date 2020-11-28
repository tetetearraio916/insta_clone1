class SearchForm
  #ActiveModel::ModelはActiveRecordからDBへ依存する部分を除いたライブラリらしい
  include ActiveModel::Model
  #ActiveRecordのカラムのような属性を加えられる
  include ActiveModel::Attributes

  attribute :post_content, :string
  attribute :comment_content, :string
  attribute :name, :string

  def search
    #重複したレコードを削除し各データに一意性を持たせる
    scope = Post.distinct
    #postモデルで定義したスコープを利用してデータベース検索、また空白によって生まれる何個かの条件から複数のレコードを取得している
    scope = split_attributes.map{ |word| scope.post_like(word)}.inject{ |result, scp| result.or(scp) } if post_content.present?
    scope = scope.comment_like(comment_content) if comment_content.present?
    scope = scope.user_like(name) if name.present?
    scope
  end

  private

  def split_attributes
    #各属性に対して,stripで先頭と末尾の空白を取り除き、spritで文中の空白文字を分割して配列に戻す。正規表現にはPOSIXブラケットを用いている
    post_content.strip.split(/[[:blank:]]+/)
  end
end
