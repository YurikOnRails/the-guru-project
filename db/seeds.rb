# Clear the database
puts "Clearing database..."
TestResult.destroy_all
User.destroy_all
Category.destroy_all
Test.destroy_all
Question.destroy_all
Answer.destroy_all
puts "Database cleared successfully."

# Create users
puts "Creating users..."
users = User.create!([
                       { name: 'Andrey', email: 'andrey@example.com' },
                       { name: 'Pavel', email: 'pavel@example.com' }
                     ])
puts "Users created: #{users.count}"

# Create categories
puts "Creating categories..."
categories = Category.create!([
                                { name: 'Geography' },
                                { name: 'History' }
                              ])
puts "Categories created: #{categories.count}"

# Create tests
puts "Creating tests..."
tests = Test.create!([
                       { title: 'Countries of Europe', level: 1, category_id: categories[0].id, author_id: users[0].id },
                       { title: 'Ancient Civilizations', level: 2, category_id: categories[1].id, author_id: users[1].id },
                       { title: 'Capitals of the World', level: 1, category_id: categories[0].id, author_id: users[0].id }
                     ])
puts "Tests created: #{tests.count}"

# Create questions
puts "Creating questions..."
questions = Question.create!([
                               { content: 'What is the capital of France?', test_id: tests[2].id },
                               { content: 'Which country is known for the Colosseum?', test_id: tests[1].id },
                               { content: 'What is the largest country in Europe?', test_id: tests[0].id }
                             ])
puts "Questions created: #{questions.count}"

# Create answers
puts "Creating answers..."
Answer.create!([
                 { content: 'Paris', correct: true, question_id: questions[0].id },
                 { content: 'Rome', correct: true, question_id: questions[1].id },
                 { content: 'Russia', correct: true, question_id: questions[2].id },
                 { content: 'Germany', correct: false, question_id: questions[2].id },
                 { content: 'London', correct: false, question_id: questions[0].id },
                 { content: 'Athens', correct: false, question_id: questions[1].id }
               ])
puts "Answers created successfully."

# Create test results
puts "Creating test results..."
test_results = TestResult.create!([
                                    { user_id: users[0].id, test_id: tests[0].id, completed: true, score: 80 },
                                    { user_id: users[1].id, test_id: tests[2].id, completed: true, score: 100 }
                                  ])
puts "Test results created: #{test_results.count}"

puts "Hallelujah! We did it!!! Seed data created successfully!!!"
