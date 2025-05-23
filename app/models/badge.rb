class Badge < ApplicationRecord
  has_many :user_badges, dependent: :destroy
  has_many :users, through: :user_badges

  validates :title, presence: true
  validates :image_url, presence: true
  validates :rule_type, presence: true
  validates :rule_params, presence: true

  RULES = {
    'category_complete' => 'Завершение всех тестов в категории',
    'first_try' => 'Прохождение теста с первой попытки',
    'level_complete' => 'Завершение всех тестов определенного уровня'
  }.freeze

  def award_condition_met?(test_passage)
    case rule_type
    when 'category_complete'
      category_complete?(test_passage)
    when 'first_try'
      first_try?(test_passage)
    when 'level_complete'
      level_complete?(test_passage)
    else
      false
    end
  end

  private

  def category_complete?(test_passage)
    return false unless test_passage.successful?

    category_id = rule_params['category_id'].to_i
    category_tests = Test.where(category_id: category_id)
    completed_tests = test_passage.user.test_passages
                                .joins(:test)
                                .where(tests: { category_id: category_id })
                                .where(successful: true)
                                .pluck(:test_id).uniq

    (category_tests.pluck(:id) - completed_tests).empty?
  end

  def first_try?(test_passage)
    return false unless test_passage.successful?

    test_passage.user.test_passages
                .where(test_id: test_passage.test_id)
                .count == 1
  end

  def level_complete?(test_passage)
    return false unless test_passage.successful?

    level = rule_params['level'].to_i
    level_tests = Test.where(level: level)
    completed_tests = test_passage.user.test_passages
                                .joins(:test)
                                .where(tests: { level: level })
                                .where(successful: true)
                                .pluck(:test_id).uniq

    (level_tests.pluck(:id) - completed_tests).empty?
  end
end 