# Railsプロジェクト初期化とデータモデル設計の提案

## 1. Rails `new` コマンド

Rails 8 (最新安定版)、PostgreSQL、Tailwind CSS、Hotwire (デフォルト) を使用する設定です。

```bash
rails new . --database=postgresql --css=tailwind --javascript=importmap --name=mandala_life
```

*   `--database=postgresql`: データベースにPostgreSQLを指定
*   `--css=tailwind`: CSSフレームワークにTailwind CSSを指定
*   `--javascript=importmap`: シンプルなJS管理のためにImportmapを指定 (Rails 8の標準的アプローチ)
*   `.`: カレントディレクトリにファイルを展開

## 2. データベース設計 (Active Record モデル)

### ER図相当の関連付け提案

曼荼羅チャートの構造（3x3, 9x9）を柔軟に表現するため、`MandalaItem` に自己結合を持たせます。

#### User (ユーザー)
認証には `devise` gem の利用を想定します。

```ruby
class User < ApplicationRecord
  # Deviseの設定はインストール時に追加
  has_many :annual_themes, dependent: :destroy
  has_many :monthly_goals, dependent: :destroy
  has_many :daily_tasks, dependent: :destroy
  has_many :reflections, dependent: :destroy
end
```

#### AnnualTheme (年間テーマ)
1年の象徴となる漢字一文字と、その意味を管理します。

```ruby
class AnnualTheme < ApplicationRecord
  belongs_to :user
  has_many :mandala_items, dependent: :destroy
  has_many :monthly_goals, dependent: :destroy

  # columns:
  #   year: integer (ex. 2024)
  #   kanji: string (ex. "挑")
  #   meaning: text (ex. "新しいことに挑戦する...")

  validates :year, presence: true, uniqueness: { scope: :user_id }
  validates :kanji, presence: true, length: { maximum: 1 } # 漢字1文字推奨だが、柔軟性のためmax 1程度に
end
```

#### MandalaItem (曼荼羅チャートの各要素)
中心テーマの周囲にある8つの要素、さらにその詳細要素を管理します。

```ruby
class MandalaItem < ApplicationRecord
  belongs_to :annual_theme

  # 階層構造 (9x9対応): 親アイテムを持つことができる
  belongs_to :parent, class_name: 'MandalaItem', optional: true
  has_many :children, class_name: 'MandalaItem', foreign_key: 'parent_id', dependent: :destroy

  # columns:
  #   content: string (目標テキスト)
  #   position: integer (0-7: 配置場所。左上から時計回りなどルールを決める)
  #   is_center: boolean (中心項目かどうか。9x9の場合の各サブグリッドの中心用)
end
```

#### MonthlyGoal (月次目標)
年間テーマや曼荼羅チャートの特定の項目にフォーカスした月の目標です。

```ruby
class MonthlyGoal < ApplicationRecord
  belongs_to :user
  belongs_to :annual_theme
  # その月、特に注力する曼荼羅チャートの項目があれば紐付け
  belongs_to :mandala_item, optional: true

  # columns:
  #   month: integer (1-12)
  #   goal: text (今月の目標記述)
end
```

#### DailyTask (日次タスク)
日々の行動タスクです。

```ruby
class DailyTask < ApplicationRecord
  belongs_to :user
  belongs_to :monthly_goal, optional: true # 月目標に紐づかないタスクもあり得るならoptional

  # columns:
  #   date: date
  #   title: string
  #   completed: boolean (default: false)
end
```

#### Reflection (振り返り)
デイリーとマンスリーの振り返りを統一的に管理します（種別カラムで区別）。

```ruby
class Reflection < ApplicationRecord
  belongs_to :user

  # columns:
  #   date: date (記録日、または対象日)
  #   content: text (日記、振り返りコメント)
  #   score: integer (1-5や1-100などの達成度自己評価)
  #   reflection_type: integer or string (enum: daily, monthly)

  enum :reflection_type, { daily: 0, monthly: 1 }
end
```

---

この構成でプロジェクトを初期化し、開発を進めてよろしいでしょうか？
承認いただければ、`rails new` の実行とモデル作成を行います。
