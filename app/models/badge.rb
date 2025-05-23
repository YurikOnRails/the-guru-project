class Badge < ApplicationRecord
  has_many :user_badges
  has_many :users, through: :user_badges

  validates :name, presence: true
  validates :image_url, presence: true
  validates :rule_type, presence: true
  validates :rule_value, presence: true

  # Типы правил для выдачи бейджей
  RULE_TYPES = {
    category_complete: 'Завершение всех тестов категории',
    first_try: 'Прохождение теста с первой попытки',
    level_complete: 'Завершение всех тестов уровня'
  }.freeze

  # Проверка выполнения условий для выдачи бейджа
  def award_condition_met?(test_passage)
    case rule_type
    when 'category_complete'
      category_condition_met?(test_passage)
    when 'first_try'
      first_try_condition_met?(test_passage)
    when 'level_complete'
      level_condition_met?(test_passage)
    end
  end

  private

  def category_condition_met?(test_passage)
    return false unless test_passage.success?
    
    category = test_passage.test.category
    user_tests = test_passage.user.test_passages.joins(test: :category)
                            .where(tests: { category_id: category.id })
    
    user_tests.where(success: true).pluck(:test_id).uniq.count == 
      Test.where(category: category).count
  end

  def first_try_condition_met?(test_passage)
    return false unless test_passage.success?
    
    test_passage.user.test_passages
                .where(test: test_passage.test)
                .count == 1
  end

  def level_condition_met?(test_passage)
    return false unless test_passage.success?
    
    level = test_passage.test.level
    user_tests = test_passage.user.test_passages.joins(:test)
                            .where(tests: { level: level })
    
    user_tests.where(success: true).pluck(:test_id).uniq.count == 
      Test.where(level: level).count
  end
end 