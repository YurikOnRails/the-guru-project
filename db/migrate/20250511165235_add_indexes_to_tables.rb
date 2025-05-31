class AddIndexesToTables < ActiveRecord::Migration[7.0]
  def change
    # Индекс для поиска тестов по названию
    add_index :tests, :title unless index_exists?(:tests, :title)

    # Индекс для поиска тестов по уровню (для фильтрации)
    add_index :tests, :level unless index_exists?(:tests, :level)

    # Композитный индекс для оптимизации поиска по названию и уровню
    add_index :tests, [ :title, :level ] unless index_exists?(:tests, [ :title, :level ])

    # Индекс для поиска пользователей по имени и фамилии
    add_index :users, :first_name unless index_exists?(:users, :first_name)
    add_index :users, :last_name unless index_exists?(:users, :last_name)
    add_index :users, [ :first_name, :last_name ] unless index_exists?(:users, [ :first_name, :last_name ])

    # Индекс для категорий по имени (для быстрого поиска)
    add_index :categories, :name, unique: true unless index_exists?(:categories, :name, unique: true)

    add_index :test_passages, :started_at
    add_index :test_passages, :success
    add_index :tests, :timer_minutes
  end
end
