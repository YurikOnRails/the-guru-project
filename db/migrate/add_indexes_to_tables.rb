class AddIndexesToTables < ActiveRecord::Migration[8.0]
  def change
    # Индекс для поиска тестов по названию
    add_index :tests, :title

    # Индекс для поиска тестов по уровню (для фильтрации)
    add_index :tests, :level

    # Композитный индекс для оптимизации поиска по названию и уровню
    add_index :tests, [ :title, :level ]

    # Индекс для поиска пользователей по имени и фамилии
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, [ :first_name, :last_name ]

    # Индекс для категорий по имени (для быстрого поиска)
    add_index :categories, :name, unique: true
  end
end
