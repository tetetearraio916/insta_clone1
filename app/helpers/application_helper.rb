module ApplicationHelper
  def default_meta_tags
    {
        site: Settings.meta.site,
        # trueに設定すると「title | site」の並びで出力
        reverse: true,
        title: Settings.meta.title,
        description: Settings.meta.description,
        keywords: Settings.meta.keywords,
        # URLを正規化するcanonicalタグを設定
        canonical: request.original_url,
        #OGPの設定
        og: {
            title: :full_title,
            #ウェブサイト、記事、ブログサイトの種類
            type: Settings.meta.og.type,
            url: request.original_url,
            image: image_url(Settings.meta.og.image_path),
            site_name: :site,
            description: :description,
            # リソース言語を設定
            locale: 'ja_JP'
        },
        twitter: {
            #twitterOGPのSummaryカード
            card: 'summary_large_image'
        },
    }
  end
end
