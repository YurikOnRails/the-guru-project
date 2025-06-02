puts "Clearing the database..."
[ TestPassage, Answer, Question, Test, Category, User ].each(&:delete_all)
puts "Database cleared successfully."

puts "Seeding users..."
admin = Admin.create!(
  first_name: 'Pavel',
  last_name: 'Administrator',
  email: 'pavel@pochta.ru',
  password: 'pavel_thinknetica',
  password_confirmation: 'pavel_thinknetica',
  confirmed_at: Time.current
)

users = [
  User.create!(
    first_name: 'Pavel',
    last_name: 'Petrov',
    email: 'pavel@example.com',
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: Time.current
  ),
  User.create!(
    first_name: 'Maria',
    last_name: 'Sidorova',
    email: 'maria@example.com',
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: Time.current
  ),
  User.create!(
    first_name: 'Olga',
    last_name: 'Kozlova',
    email: 'olga@example.com',
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: Time.current
  )
]

puts "Users: #{User.count}"

puts "Seeding categories..."
categories = Category.create!([
  { name: 'География' },
  { name: 'История' },
  { name: 'Наука' },
  { name: 'Литература' },
  { name: 'Математика' },
  { name: 'Программирование' },
  { name: 'Искусство' },
  { name: 'Спорт' }
])
puts "Categories: #{Category.count}"

puts "Seeding tests..."
tests = Test.create!([
  # География
  { title: 'Страны Европы', level: 1, category: categories[0], author: admin, timer_minutes: 15 },
  { title: 'Столицы мира', level: 2, category: categories[0], author: admin, timer_minutes: 10 },
  { title: 'Горы и вершины', level: 3, category: categories[0], author: users[0], timer_minutes: 20 },
  { title: 'Океаны и моря', level: 2, category: categories[0], author: users[1], timer_minutes: 15 },

  # История
  { title: 'Древние цивилизации', level: 2, category: categories[1], author: users[0], timer_minutes: 20 },
  { title: 'Вторая мировая война', level: 3, category: categories[1], author: admin, timer_minutes: 25 },
  { title: 'История России', level: 2, category: categories[1], author: users[1], timer_minutes: 20 },
  { title: 'Великие правители', level: 3, category: categories[1], author: users[2], timer_minutes: 15 },

  # Наука
  { title: 'Основы физики', level: 3, category: categories[2], author: users[1], timer_minutes: 30 },
  { title: 'Химические элементы', level: 2, category: categories[2], author: admin, timer_minutes: 20 },
  { title: 'Биология человека', level: 2, category: categories[2], author: users[0], timer_minutes: 15 },

  # Литература
  { title: 'Русская классика', level: 2, category: categories[3], author: admin, timer_minutes: 20 },
  { title: 'Зарубежная литература', level: 2, category: categories[3], author: users[1], timer_minutes: 20 },

  # Математика
  { title: 'Алгебра', level: 3, category: categories[4], author: users[2], timer_minutes: 25 },
  { title: 'Геометрия', level: 2, category: categories[4], author: admin, timer_minutes: 20 },

  # Программирование
  { title: 'Ruby основы', level: 1, category: categories[5], author: admin, timer_minutes: 30 },
  { title: 'JavaScript базовый', level: 1, category: categories[5], author: users[0], timer_minutes: 25 },
  { title: 'SQL запросы', level: 2, category: categories[5], author: users[1], timer_minutes: 20 }
])
puts "Tests: #{Test.count}"

puts "Seeding questions..."
questions = Question.create!([
  # География - Страны Европы
  { content: 'Какая страна является самой большой по площади в Европе?', test: tests[0] },
  { content: 'Какая страна имеет форму сапога?', test: tests[0] },
  { content: 'В какой стране находится Эйфелева башня?', test: tests[0] },
  { content: 'Какая страна состоит из двух основных островов?', test: tests[0] },
  { content: 'Самая маленькая страна в мире?', test: tests[0] },

  # География - Столицы мира
  { content: 'Столица Японии?', test: tests[1] },
  { content: 'Столица Австралии?', test: tests[1] },
  { content: 'Столица Бразилии?', test: tests[1] },
  { content: 'Столица Канады?', test: tests[1] },
  { content: 'Столица Египта?', test: tests[1] },

  # География - Горы и вершины
  { content: 'Самая высокая гора в мире?', test: tests[2] },
  { content: 'Самая высокая гора в Европе?', test: tests[2] },
  { content: 'Где находятся Анды?', test: tests[2] },
  { content: 'Самая высокая гора в Африке?', test: tests[2] },
  { content: 'В какой стране находится гора Фудзияма?', test: tests[2] },

  # География - Океаны и моря
  { content: 'Самый большой океан?', test: tests[3] },
  { content: 'Самое глубокое море?', test: tests[3] },
  { content: 'Самое соленое море?', test: tests[3] },
  { content: 'Какой океан омывает Антарктиду?', test: tests[3] },
  { content: 'Самое большое море в мире?', test: tests[3] },

  # История - Древние цивилизации
  { content: 'Кто построил пирамиды в Гизе?', test: tests[4] },
  { content: 'Какая империя построила Колизей?', test: tests[4] },
  { content: 'Где находилась цивилизация майя?', test: tests[4] },
  { content: 'Кто изобрел бумагу?', test: tests[4] },
  { content: 'Столица Древней Персии?', test: tests[4] },

  # История - Вторая мировая война
  { content: 'Когда началась Вторая мировая война?', test: tests[5] },
  { content: 'Кто возглавлял СССР во время войны?', test: tests[5] },
  { content: 'Дата окончания войны в Европе?', test: tests[5] },
  { content: 'Где произошла Сталинградская битва?', test: tests[5] },
  { content: 'Когда произошла битва за Москву?', test: tests[5] },

  # История - История России
  { content: 'Кто основал Санкт-Петербург?', test: tests[6] },
  { content: 'Первый русский царь из династии Романовых?', test: tests[6] },
  { content: 'Когда произошла Октябрьская революция?', test: tests[6] },
  { content: 'Кто был первым космонавтом?', test: tests[6] },
  { content: 'Год основания Москвы?', test: tests[6] },

  # История - Великие правители
  { content: 'Кто был первым императором Римской империи?', test: tests[7] },
  { content: 'Годы правления Петра I?', test: tests[7] },
  { content: 'Кто была последней королевой Египта?', test: tests[7] },
  { content: 'Самый долгоправящий монарх в истории?', test: tests[7] },
  { content: 'Кто такой Чингисхан?', test: tests[7] },

  # Наука - Основы физики
  { content: 'Второй закон Ньютона?', test: tests[8] },
  { content: 'Закон всемирного тяготения?', test: tests[8] },
  { content: 'Что такое энергия?', test: tests[8] },
  { content: 'Три состояния вещества?', test: tests[8] },
  { content: 'Что такое инерция?', test: tests[8] },

  # Наука - Химические элементы
  { content: 'Самый распространенный элемент во Вселенной?', test: tests[9] },
  { content: 'Символ железа в таблице Менделеева?', test: tests[9] },
  { content: 'Сколько электронов у атома водорода?', test: tests[9] },
  { content: 'Что такое благородные газы?', test: tests[9] },
  { content: 'Металл в жидком состоянии при комнатной температуре?', test: tests[9] },

  # Наука - Биология человека
  { content: 'Сколько костей в теле человека?', test: tests[10] },
  { content: 'Самая большая кость в теле человека?', test: tests[10] },
  { content: 'Сколько камер в сердце человека?', test: tests[10] },
  { content: 'Какой орган очищает кровь?', test: tests[10] },
  { content: 'Самая большая железа в теле человека?', test: tests[10] },

  # Литература - Русская классика
  { content: 'Кто написал "Войну и мир"?', test: tests[11] },
  { content: 'Автор "Евгения Онегина"?', test: tests[11] },
  { content: 'Кто написал "Преступление и наказание"?', test: tests[11] },
  { content: 'Автор поэмы "Мертвые души"?', test: tests[11] },
  { content: 'Кто написал "Мастер и Маргарита"?', test: tests[11] },

  # Литература - Зарубежная литература
  { content: 'Автор "Ромео и Джульетты"?', test: tests[12] },
  { content: 'Кто написал "Дон Кихот"?', test: tests[12] },
  { content: 'Автор "Божественной комедии"?', test: tests[12] },
  { content: 'Кто написал "1984"?', test: tests[12] },
  { content: 'Автор "Гамлета"?', test: tests[12] },

  # Математика - Алгебра
  { content: 'Что такое квадратное уравнение?', test: tests[13] },
  { content: 'Формула сокращенного умножения (a+b)²?', test: tests[13] },
  { content: 'Что такое функция?', test: tests[13] },
  { content: 'Что такое логарифм?', test: tests[13] },
  { content: 'Что такое модуль числа?', test: tests[13] },

  # Математика - Геометрия
  { content: 'Теорема Пифагора?', test: tests[14] },
  { content: 'Сумма углов треугольника?', test: tests[14] },
  { content: 'Что такое параллельные прямые?', test: tests[14] },
  { content: 'Формула площади круга?', test: tests[14] },
  { content: 'Что такое медиана треугольника?', test: tests[14] },

  # Программирование - Ruby основы
  { content: 'Что такое Ruby?', test: tests[15] },
  { content: 'Как объявить массив в Ruby?', test: tests[15] },
  { content: 'Что такое символ в Ruby?', test: tests[15] },
  { content: 'Что такое gem в Ruby?', test: tests[15] },
  { content: 'Что такое блок в Ruby?', test: tests[15] },

  # Программирование - JavaScript базовый
  { content: 'Что такое JavaScript?', test: tests[16] },
  { content: 'Как объявить переменную в JavaScript?', test: tests[16] },
  { content: 'Что такое функция в JavaScript?', test: tests[16] },
  { content: 'Что такое DOM?', test: tests[16] },
  { content: 'Что такое JSON?', test: tests[16] },

  # Программирование - SQL запросы
  { content: 'Что такое SQL?', test: tests[17] },
  { content: 'Команда для выборки данных?', test: tests[17] },
  { content: 'Что такое JOIN?', test: tests[17] },
  { content: 'Что такое PRIMARY KEY?', test: tests[17] },
  { content: 'Что такое FOREIGN KEY?', test: tests[17] }
])
puts "Questions: #{Question.count}"

puts "Seeding answers..."
Answer.create!([
  # География - Страны Европы
  { content: 'Россия', correct: true, question: questions[0] },
  { content: 'Германия', correct: false, question: questions[0] },
  { content: 'Франция', correct: false, question: questions[0] },

  { content: 'Италия', correct: true, question: questions[1] },
  { content: 'Греция', correct: false, question: questions[1] },
  { content: 'Испания', correct: false, question: questions[1] },

  { content: 'Франция', correct: true, question: questions[2] },
  { content: 'Бельгия', correct: false, question: questions[2] },
  { content: 'Нидерланды', correct: false, question: questions[2] },

  { content: 'Великобритания', correct: true, question: questions[3] },
  { content: 'Дания', correct: false, question: questions[3] },
  { content: 'Ирландия', correct: false, question: questions[3] },

  { content: 'Ватикан', correct: true, question: questions[4] },
  { content: 'Монако', correct: false, question: questions[4] },
  { content: 'Сан-Марино', correct: false, question: questions[4] },

  # География - Столицы мира
  { content: 'Токио', correct: true, question: questions[5] },
  { content: 'Киото', correct: false, question: questions[5] },
  { content: 'Осака', correct: false, question: questions[5] },

  { content: 'Канберра', correct: true, question: questions[6] },
  { content: 'Сидней', correct: false, question: questions[6] },
  { content: 'Мельбурн', correct: false, question: questions[6] },

  { content: 'Бразилиа', correct: true, question: questions[7] },
  { content: 'Рио-де-Жанейро', correct: false, question: questions[7] },
  { content: 'Сан-Паулу', correct: false, question: questions[7] },

  { content: 'Оттава', correct: true, question: questions[8] },
  { content: 'Торонто', correct: false, question: questions[8] },
  { content: 'Монреаль', correct: false, question: questions[8] },

  { content: 'Каир', correct: true, question: questions[9] },
  { content: 'Александрия', correct: false, question: questions[9] },
  { content: 'Луксор', correct: false, question: questions[9] },

  # География - Горы и вершины
  { content: 'Эверест', correct: true, question: questions[10] },
  { content: 'К2', correct: false, question: questions[10] },
  { content: 'Канченджанга', correct: false, question: questions[10] },

  { content: 'Эльбрус', correct: true, question: questions[11] },
  { content: 'Монблан', correct: false, question: questions[11] },
  { content: 'Маттерхорн', correct: false, question: questions[11] },

  { content: 'Южная Америка', correct: true, question: questions[12] },
  { content: 'Северная Америка', correct: false, question: questions[12] },
  { content: 'Азия', correct: false, question: questions[12] },

  { content: 'Килиманджаро', correct: true, question: questions[13] },
  { content: 'Кения', correct: false, question: questions[13] },
  { content: 'Рувензори', correct: false, question: questions[13] },

  { content: 'Япония', correct: true, question: questions[14] },
  { content: 'Китай', correct: false, question: questions[14] },
  { content: 'Корея', correct: false, question: questions[14] },

  # География - Океаны и моря
  { content: 'Тихий', correct: true, question: questions[15] },
  { content: 'Атлантический', correct: false, question: questions[15] },
  { content: 'Индийский', correct: false, question: questions[15] },

  { content: 'Филиппинское', correct: true, question: questions[16] },
  { content: 'Средиземное', correct: false, question: questions[16] },
  { content: 'Карибское', correct: false, question: questions[16] },

  { content: 'Мертвое море', correct: true, question: questions[17] },
  { content: 'Красное море', correct: false, question: questions[17] },
  { content: 'Каспийское море', correct: false, question: questions[17] },

  { content: 'Южный океан', correct: true, question: questions[18] },
  { content: 'Индийский океан', correct: false, question: questions[18] },
  { content: 'Тихий океан', correct: false, question: questions[18] },

  { content: 'Саргассово море', correct: true, question: questions[19] },
  { content: 'Средиземное море', correct: false, question: questions[19] },
  { content: 'Черное море', correct: false, question: questions[19] },

  # История - Древние цивилизации
  { content: 'Древние египтяне', correct: true, question: questions[20] },
  { content: 'Римляне', correct: false, question: questions[20] },
  { content: 'Греки', correct: false, question: questions[20] },

  { content: 'Римская империя', correct: true, question: questions[21] },
  { content: 'Греческая империя', correct: false, question: questions[21] },
  { content: 'Персидская империя', correct: false, question: questions[21] },

  { content: 'Центральная Америка', correct: true, question: questions[22] },
  { content: 'Южная Америка', correct: false, question: questions[22] },
  { content: 'Северная Америка', correct: false, question: questions[22] },

  { content: 'Китайцы', correct: true, question: questions[23] },
  { content: 'Египтяне', correct: false, question: questions[23] },
  { content: 'Греки', correct: false, question: questions[23] },

  { content: 'Персеполь', correct: true, question: questions[24] },
  { content: 'Вавилон', correct: false, question: questions[24] },
  { content: 'Сузы', correct: false, question: questions[24] },

  # История - Вторая мировая война
  { content: '1 сентября 1939', correct: true, question: questions[25] },
  { content: '22 июня 1941', correct: false, question: questions[25] },
  { content: '7 декабря 1941', correct: false, question: questions[25] },

  { content: 'И.В. Сталин', correct: true, question: questions[26] },
  { content: 'В.М. Молотов', correct: false, question: questions[26] },
  { content: 'Г.К. Жуков', correct: false, question: questions[26] },

  { content: '9 мая 1945', correct: true, question: questions[27] },
  { content: '8 мая 1945', correct: false, question: questions[27] },
  { content: '2 сентября 1945', correct: false, question: questions[27] },

  { content: 'Сталинград', correct: true, question: questions[28] },
  { content: 'Ленинград', correct: false, question: questions[28] },
  { content: 'Курск', correct: false, question: questions[28] },

  { content: '1941-1942', correct: true, question: questions[29] },
  { content: '1942-1943', correct: false, question: questions[29] },
  { content: '1943-1944', correct: false, question: questions[29] },

  # История - История России
  { content: 'Петр I', correct: true, question: questions[30] },
  { content: 'Екатерина II', correct: false, question: questions[30] },
  { content: 'Александр I', correct: false, question: questions[30] },

  { content: 'Михаил Федорович', correct: true, question: questions[31] },
  { content: 'Петр I', correct: false, question: questions[31] },
  { content: 'Алексей Михайлович', correct: false, question: questions[31] },

  { content: '1917', correct: true, question: questions[32] },
  { content: '1905', correct: false, question: questions[32] },
  { content: '1918', correct: false, question: questions[32] },

  { content: 'Юрий Гагарин', correct: true, question: questions[33] },
  { content: 'Герман Титов', correct: false, question: questions[33] },
  { content: 'Алексей Леонов', correct: false, question: questions[33] },

  { content: '1147', correct: true, question: questions[34] },
  { content: '1237', correct: false, question: questions[34] },
  { content: '1380', correct: false, question: questions[34] },

  # История - Великие правители
  { content: 'Октавиан Август', correct: true, question: questions[35] },
  { content: 'Юлий Цезарь', correct: false, question: questions[35] },
  { content: 'Нерон', correct: false, question: questions[35] },

  { content: '1682-1725', correct: true, question: questions[36] },
  { content: '1725-1727', correct: false, question: questions[36] },
  { content: '1721-1725', correct: false, question: questions[36] },

  { content: 'Клеопатра', correct: true, question: questions[37] },
  { content: 'Нефертити', correct: false, question: questions[37] },
  { content: 'Хатшепсут', correct: false, question: questions[37] },

  { content: 'Людовик XIV', correct: true, question: questions[38] },
  { content: 'Елизавета II', correct: false, question: questions[38] },
  { content: 'Виктория', correct: false, question: questions[38] },

  { content: 'Основатель Монгольской империи', correct: true, question: questions[39] },
  { content: 'Китайский император', correct: false, question: questions[39] },
  { content: 'Правитель гуннов', correct: false, question: questions[39] },

  # Наука - Основы физики
  { content: 'F = ma', correct: true, question: questions[40] },
  { content: 'E = mc²', correct: false, question: questions[40] },
  { content: 'P = mv', correct: false, question: questions[40] },

  { content: 'F = G(m₁m₂)/r²', correct: true, question: questions[41] },
  { content: 'E = mgh', correct: false, question: questions[41] },
  { content: 'P = F/S', correct: false, question: questions[41] },

  { content: 'Способность совершать работу', correct: true, question: questions[42] },
  { content: 'Сила тяжести', correct: false, question: questions[42] },
  { content: 'Скорость движения', correct: false, question: questions[42] },

  { content: 'Твердое, жидкое, газообразное', correct: true, question: questions[43] },
  { content: 'Горячее, теплое, холодное', correct: false, question: questions[43] },
  { content: 'Легкое, среднее, тяжелое', correct: false, question: questions[43] },

  { content: 'Свойство тела сохранять состояние покоя или движения', correct: true, question: questions[44] },
  { content: 'Способность тела падать', correct: false, question: questions[44] },
  { content: 'Способность тела плавать', correct: false, question: questions[44] },

  # Наука - Химические элементы
  { content: 'Водород', correct: true, question: questions[45] },
  { content: 'Кислород', correct: false, question: questions[45] },
  { content: 'Углерод', correct: false, question: questions[45] },

  { content: 'Fe', correct: true, question: questions[46] },
  { content: 'Fi', correct: false, question: questions[46] },
  { content: 'Fr', correct: false, question: questions[46] },

  { content: 'Один', correct: true, question: questions[47] },
  { content: 'Два', correct: false, question: questions[47] },
  { content: 'Три', correct: false, question: questions[47] },

  { content: 'Инертные газы, не вступающие в реакции', correct: true, question: questions[48] },
  { content: 'Газы, используемые в промышленности', correct: false, question: questions[48] },
  { content: 'Газы в атмосфере', correct: false, question: questions[48] },

  { content: 'Ртуть', correct: true, question: questions[49] },
  { content: 'Свинец', correct: false, question: questions[49] },
  { content: 'Золото', correct: false, question: questions[49] },

  # Наука - Биология человека
  { content: '206', correct: true, question: questions[50] },
  { content: '180', correct: false, question: questions[50] },
  { content: '230', correct: false, question: questions[50] },

  { content: 'Бедренная кость', correct: true, question: questions[51] },
  { content: 'Плечевая кость', correct: false, question: questions[51] },
  { content: 'Большеберцовая кость', correct: false, question: questions[51] },

  { content: 'Четыре', correct: true, question: questions[52] },
  { content: 'Три', correct: false, question: questions[52] },
  { content: 'Пять', correct: false, question: questions[52] },

  { content: 'Печень', correct: true, question: questions[53] },
  { content: 'Почки', correct: false, question: questions[53] },
  { content: 'Селезенка', correct: false, question: questions[53] },

  { content: 'Печень', correct: true, question: questions[54] },
  { content: 'Щитовидная железа', correct: false, question: questions[54] },
  { content: 'Поджелудочная железа', correct: false, question: questions[54] },

  # Литература - Русская классика
  { content: 'Лев Толстой', correct: true, question: questions[55] },
  { content: 'Федор Достоевский', correct: false, question: questions[55] },
  { content: 'Иван Тургенев', correct: false, question: questions[55] },

  { content: 'Александр Пушкин', correct: true, question: questions[56] },
  { content: 'Михаил Лермонтов', correct: false, question: questions[56] },
  { content: 'Николай Некрасов', correct: false, question: questions[56] },

  { content: 'Федор Достоевский', correct: true, question: questions[57] },
  { content: 'Лев Толстой', correct: false, question: questions[57] },
  { content: 'Антон Чехов', correct: false, question: questions[57] },

  { content: 'Николай Гоголь', correct: true, question: questions[58] },
  { content: 'Александр Пушкин', correct: false, question: questions[58] },
  { content: 'Михаил Лермонтов', correct: false, question: questions[58] },

  { content: 'Михаил Булгаков', correct: true, question: questions[59] },
  { content: 'Борис Пастернак', correct: false, question: questions[59] },
  { content: 'Иван Бунин', correct: false, question: questions[59] },

  # Литература - Зарубежная литература
  { content: 'Уильям Шекспир', correct: true, question: questions[60] },
  { content: 'Чарльз Диккенс', correct: false, question: questions[60] },
  { content: 'Джон Мильтон', correct: false, question: questions[60] },

  { content: 'Мигель де Сервантес', correct: true, question: questions[61] },
  { content: 'Лопе де Вега', correct: false, question: questions[61] },
  { content: 'Федерико Гарсиа Лорка', correct: false, question: questions[61] },

  { content: 'Данте Алигьери', correct: true, question: questions[62] },
  { content: 'Джованни Боккаччо', correct: false, question: questions[62] },
  { content: 'Франческо Петрарка', correct: false, question: questions[62] },

  { content: 'Джордж Оруэлл', correct: true, question: questions[63] },
  { content: 'Олдос Хаксли', correct: false, question: questions[63] },
  { content: 'Рэй Брэдбери', correct: false, question: questions[63] },

  { content: 'Уильям Шекспир', correct: true, question: questions[64] },
  { content: 'Кристофер Марло', correct: false, question: questions[64] },
  { content: 'Бен Джонсон', correct: false, question: questions[64] },

  # Математика - Алгебра
  { content: 'ax² + bx + c = 0', correct: true, question: questions[65] },
  { content: 'ax + b = 0', correct: false, question: questions[65] },
  { content: 'x + y = 0', correct: false, question: questions[65] },

  { content: 'a² + 2ab + b²', correct: true, question: questions[66] },
  { content: 'a² - b²', correct: false, question: questions[66] },
  { content: 'a² + b²', correct: false, question: questions[66] },

  { content: 'Соответствие между элементами двух множеств', correct: true, question: questions[67] },
  { content: 'Математическое выражение', correct: false, question: questions[67] },
  { content: 'Числовая последовательность', correct: false, question: questions[67] },

  { content: 'Показатель степени, в которую нужно возвести основание', correct: true, question: questions[68] },
  { content: 'Корень из числа', correct: false, question: questions[68] },
  { content: 'Частное от деления', correct: false, question: questions[68] },

  { content: 'Абсолютная величина числа', correct: true, question: questions[69] },
  { content: 'Отрицательное число', correct: false, question: questions[69] },
  { content: 'Положительное число', correct: false, question: questions[69] },

  # Математика - Геометрия
  { content: 'a² + b² = c²', correct: true, question: questions[70] },
  { content: 'a + b = c', correct: false, question: questions[70] },
  { content: 'a × b = c', correct: false, question: questions[70] },

  { content: '180 градусов', correct: true, question: questions[71] },
  { content: '360 градусов', correct: false, question: questions[71] },
  { content: '90 градусов', correct: false, question: questions[71] },

  { content: 'Прямые, которые не пересекаются', correct: true, question: questions[72] },
  { content: 'Прямые, которые пересекаются', correct: false, question: questions[72] },
  { content: 'Прямые под углом 90 градусов', correct: false, question: questions[72] },

  { content: 'πr²', correct: true, question: questions[73] },
  { content: '2πr', correct: false, question: questions[73] },
  { content: 'πd', correct: false, question: questions[73] },

  { content: 'Отрезок, соединяющий вершину с серединой противоположной стороны', correct: true, question: questions[74] },
  { content: 'Отрезок, соединяющий середины сторон', correct: false, question: questions[74] },
  { content: 'Перпендикуляр к стороне из противоположной вершины', correct: false, question: questions[74] },

  # Программирование - Ruby основы
  { content: 'Динамический язык программирования', correct: true, question: questions[75] },
  { content: 'База данных', correct: false, question: questions[75] },
  { content: 'Операционная система', correct: false, question: questions[75] },

  { content: 'array = []', correct: true, question: questions[76] },
  { content: 'array = {}', correct: false, question: questions[76] },
  { content: 'array = ()', correct: false, question: questions[76] },

  { content: 'Неизменяемый идентификатор', correct: true, question: questions[77] },
  { content: 'Строка', correct: false, question: questions[77] },
  { content: 'Число', correct: false, question: questions[77] },

  { content: 'Пакет Ruby библиотек', correct: true, question: questions[78] },
  { content: 'Драгоценный камень', correct: false, question: questions[78] },
  { content: 'Тип данных', correct: false, question: questions[78] },

  { content: 'Анонимная функция', correct: true, question: questions[79] },
  { content: 'Структура данных', correct: false, question: questions[79] },
  { content: 'Условный оператор', correct: false, question: questions[79] },

  # Программирование - JavaScript базовый
  { content: 'Язык программирования для веб', correct: true, question: questions[80] },
  { content: 'Язык разметки', correct: false, question: questions[80] },
  { content: 'База данных', correct: false, question: questions[80] },

  { content: 'let x = 5', correct: true, question: questions[81] },
  { content: 'x := 5', correct: false, question: questions[81] },
  { content: 'var x := 5', correct: false, question: questions[81] },

  { content: 'Блок кода, который можно вызвать', correct: true, question: questions[82] },
  { content: 'Тип данных', correct: false, question: questions[82] },
  { content: 'Условный оператор', correct: false, question: questions[82] },

  { content: 'Document Object Model', correct: true, question: questions[83] },
  { content: 'Data Object Model', correct: false, question: questions[83] },
  { content: 'Document Oriented Module', correct: false, question: questions[83] },

  { content: 'JavaScript Object Notation', correct: true, question: questions[84] },
  { content: 'JavaScript Oriented Notation', correct: false, question: questions[84] },
  { content: 'Java Standard Object Notation', correct: false, question: questions[84] },

  # Программирование - SQL запросы
  { content: 'Structured Query Language', correct: true, question: questions[85] },
  { content: 'Simple Query Language', correct: false, question: questions[85] },
  { content: 'Standard Query Logic', correct: false, question: questions[85] },

  { content: 'SELECT', correct: true, question: questions[86] },
  { content: 'FIND', correct: false, question: questions[86] },
  { content: 'SEARCH', correct: false, question: questions[86] },

  { content: 'Объединение таблиц', correct: true, question: questions[87] },
  { content: 'Удаление данных', correct: false, question: questions[87] },
  { content: 'Сортировка данных', correct: false, question: questions[87] },

  { content: 'Уникальный идентификатор записи', correct: true, question: questions[88] },
  { content: 'Первая колонка таблицы', correct: false, question: questions[88] },
  { content: 'Индекс таблицы', correct: false, question: questions[88] },

  { content: 'Ссылка на PRIMARY KEY другой таблицы', correct: true, question: questions[89] },
  { content: 'Ключ шифрования', correct: false, question: questions[89] },
  { content: 'Резервная копия ключа', correct: false, question: questions[89] }
])
puts "Answers: #{Answer.count}"

puts "Seeding completed successfully!"
