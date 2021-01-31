module ApplicationHelper
  def default_meta_tags
    {
        title: 'InstaClone - Railsの実践的アプリケーション',
        description: 'Ruby on Railsの実践的な課題です。Sidekiqを使った非同期処理やトランザクションを利用した課金処理など実践的な内容が学べます。',
        charset: 'utf-8',
        keywords: ['rails', 'instaclone', 'rails特訓コース'],
        reverse: true,
        og: {
          image: image_url('/images/default.png'),
        },
    }
  end
end
