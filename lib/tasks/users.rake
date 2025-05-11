namespace :users do
  desc "Создает администратора и тестового пользователя"
  task create_admin_and_user: :environment do
    # Создаем администратора
    admin_email = ENV["ADMIN_EMAIL"] || "admin@example.com"
    admin_password = ENV["ADMIN_PASSWORD"] || "password"

    admin = Admin.find_by(email: admin_email)

    if admin
      puts "Администратор с email #{admin_email} уже существует"
    else
      admin = Admin.new(
        email: admin_email,
        password: admin_password,
        password_confirmation: admin_password,
        first_name: "Админ",
        last_name: "Системы"
      )

      admin.skip_confirmation!

      if admin.save
        puts "Администратор создан успешно: #{admin_email}"
      else
        puts "Ошибка при создании администратора: #{admin.errors.full_messages.join(', ')}"
      end
    end

    # Создаем обычного пользователя
    user_email = ENV["USER_EMAIL"] || "user@example.com"
    user_password = ENV["USER_PASSWORD"] || "password"

    user = User.find_by(email: user_email)

    if user
      puts "Пользователь с email #{user_email} уже существует"
    else
      user = User.new(
        email: user_email,
        password: user_password,
        password_confirmation: user_password,
        first_name: "Тестовый",
        last_name: "Пользователь"
      )

      user.skip_confirmation!

      if user.save
        puts "Пользователь создан успешно: #{user_email}"
      else
        puts "Ошибка при создании пользователя: #{user.errors.full_messages.join(', ')}"
      end
    end
  end
end
