namespace :users do
  desc "Создает администратора и тестового пользователя"
  task create_admin_and_user: :environment do
    # Создаем администратора
    admin = Admin.find_or_initialize_by(email: "pavel_admin@pochta.ru")
    
    unless admin.persisted?
      admin.assign_attributes(
        password: "pavel_admin",
        password_confirmation: "pavel_admin",
        first_name: "Админ",
        last_name: "Системы"
      )
      
      # Пропускаем подтверждение email
      admin.skip_confirmation! if admin.respond_to?(:skip_confirmation!)
      admin.confirm if admin.respond_to?(:confirm)
      
      if admin.save
        puts "Администратор создан успешно: #{admin.email}"
      else
        puts "Ошибка при создании администратора: #{admin.errors.full_messages.join(', ')}"
      end
    else
      puts "Администратор с email #{admin.email} уже существует"
    end

    # Создаем обычного пользователя
    user = User.find_or_initialize_by(email: "andrey_user@pochta.ru")
    
    unless user.persisted?
      user.assign_attributes(
        password: "andrey_user",
        password_confirmation: "andrey_user",
        first_name: "Тестовый",
        last_name: "Пользователь"
      )
      
      # Пропускаем подтверждение email
      user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
      user.confirm if user.respond_to?(:confirm)
      
      if user.save
        puts "Пользователь создан успешно: #{user.email}"
      else
        puts "Ошибка при создании пользователя: #{user.errors.full_messages.join(', ')}"
      end
    else
      puts "Пользователь с email #{user.email} уже существует"
    end
  end

  # Добавим отдельную задачу только для администратора (для простоты использования в production)
  desc "Создает только администратора"
  task create_admin: :environment do
    admin = Admin.find_or_initialize_by(email: "pavel_admin@pochta.ru")
    
    unless admin.persisted?
      admin.assign_attributes(
        password: "pavel_admin",
        password_confirmation: "pavel_admin",
        first_name: "Админ",
        last_name: "Системы"
      )
      
      # Пропускаем подтверждение email несколькими способами для большей совместимости
      admin.skip_confirmation! if admin.respond_to?(:skip_confirmation!)
      admin.confirm if admin.respond_to?(:confirm)
      
      if admin.save
        puts "Администратор создан успешно: #{admin.email}"
      else
        puts "Ошибка при создании администратора: #{admin.errors.full_messages.join(', ')}"
      end
    else
      puts "Администратор с email #{admin.email} уже существует"
    end
  end
end
