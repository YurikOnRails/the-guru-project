class Badge < ApplicationRecord
  has_many :user_badges, dependent: :destroy
  has_many :users, through: :user_badges

  validates :name, presence: true, uniqueness: true
  validates :image_url, format: { with: URI::regexp(%w[http https]), message: 'должен быть валидным URL' }, if: -> { image_url.present? }
  validates :rule_type, presence: true, inclusion: { in: :available_rule_types }
  validates :rule_value, presence: true

  before_validation :set_default_image_url

  # Типы правил для выдачи бейджей
  RULE_TYPES = {
    category_complete: 'Завершение всех тестов категории',
    first_try: 'Прохождение теста с первой попытки',
    level_complete: 'Завершение всех тестов уровня'
  }.freeze

  DEFAULT_IMAGE_URL = 'https://cdn-icons-png.flaticon.com/512/2583/2583344.png'.freeze

  # Проверка выполнения условий для выдачи бейджа
  def award_condition_met?(test_passage)
    return false unless test_passage&.success?

    case rule_type.to_sym
    when :category_complete
      category_condition_met?(test_passage)
    when :first_try
      first_try_condition_met?(test_passage)
    when :level_complete
      level_condition_met?(test_passage)
    else
      false
    end
  end

  private

  def set_default_image_url
    self.image_url = DEFAULT_IMAGE_URL if image_url.blank?
  end

  def available_rule_types
    RULE_TYPES.keys.map(&:to_s)
  end

  def category_condition_met?(test_passage)
    category = test_passage.test.category
    return false unless category.id.to_s == rule_value

    completed_tests = test_passage.user.test_passages
                                .joins(test: :category)
                                .where(tests: { category_id: category.id })
                                .where(success: true)
                                .select('DISTINCT test_id')
    
    completed_tests.count == Test.where(category: category).count
  end

  def first_try_condition_met?(test_passage)
    test = test_passage.test
    return false unless test.id.to_s == rule_value

    test_passage.user.test_passages
                .where(test: test)
                .count == 1
  end

  def level_condition_met?(test_passage)
    level = rule_value.to_i
    return false unless test_passage.test.level == level

    completed_tests = test_passage.user.test_passages
                                .joins(:test)
                                .where(tests: { level: level })
                                .where(success: true)
                                .select('DISTINCT test_id')
    
    completed_tests.count == Test.where(level: level).count
  end
end 