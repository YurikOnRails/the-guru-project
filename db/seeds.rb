puts "Clearing the database..."
[ TestResult, Answer, Question, Test, Category, User ].each(&:delete_all)
puts "Database cleared successfully."

puts "Seeding users..."
users = User.create!([
                       { name: 'Andrey', email: 'andrey@example.com' },
                       { name: 'Pavel', email: 'pavel@example.com' },
                       { name: 'Maria', email: 'maria@example.com' },
                       { name: 'Olga', email: 'olga@example.com' }
                     ])
puts "Users: #{User.count}"

puts "Seeding categories..."
categories = Category.create!([
                                { name: 'Geography' },
                                { name: 'History' },
                                { name: 'Science' }
                              ])
puts "Categories: #{Category.count}"

puts "Seeding tests..."
tests = Test.create!([
                       { title: 'Countries of Europe', level: 1, category: categories[0], author: users[0] },
                       { title: 'Ancient Civilizations', level: 2, category: categories[1], author: users[1] },
                       { title: 'Capitals of the World', level: 1, category: categories[0], author: users[0] },
                       { title: 'Physics Basics', level: 3, category: categories[2], author: users[2] }
                     ])
puts "Tests: #{Test.count}"

puts "Seeding questions..."
questions = Question.create!([
                               { content: 'What is the capital of France?', test: tests[0] },
                               { content: 'Which country is known for the Colosseum?', test: tests[1] },
                               { content: 'What is the largest country in Europe?', test: tests[0] },
                               { content: "What is Newton's second law?", test: tests[3] }
                             ])
puts "Questions: #{Question.count}"

puts "Seeding answers..."
Answer.create!([
                 { content: 'Paris', correct: true, question: questions[0] },
                 { content: 'London', correct: false, question: questions[0] },
                 { content: 'Rome', correct: true, question: questions[1] },
                 { content: 'Athens', correct: false, question: questions[1] },
                 { content: 'Russia', correct: true, question: questions[2] },
                 { content: 'Germany', correct: false, question: questions[2] },
                 { content: 'F = ma', correct: true, question: questions[3] },
                 { content: 'E = mc²', correct: false, question: questions[3] }
               ])
puts "Answers: #{Answer.count}"

puts "Seeding test results..."
TestResult.create!([
                     { user: users[0], test: tests[0] },
                     { user: users[1], test: tests[1] },
                     { user: users[2], test: tests[2] },
                     { user: users[0], test: tests[1] }
                   ])
puts "Test Results: #{TestResult.count}"

puts "Seeding completed successfully!"
