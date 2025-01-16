# Clear the database
puts "Clearing database..."
TestResult.destroy_all
Answer.destroy_all
Question.destroy_all
Test.destroy_all
Category.destroy_all
User.destroy_all
puts "Database cleared successfully."

# Create users
puts "Creating users..."
users = User.create!([
  { name: 'Andrey', email: 'andrey@example.com' },
  { name: 'Pavel', email: 'pavel@example.com' },
  { name: 'Maria', email: 'maria@example.com' }
])
puts "Users created: #{users.count}"

# Create categories
puts "Creating categories..."
categories = Category.create!([
  { name: 'Geography' },
  { name: 'History' },
  { name: 'Science' }
])
puts "Categories created: #{categories.count}"

# Create tests
puts "Creating tests..."
tests = Test.create!([
  { title: 'Countries of Europe', level: 1, category: categories[0], author_id: users[0].id },
  { title: 'Ancient Civilizations', level: 2, category: categories[1], author_id: users[1].id },
  { title: 'Capitals of the World', level: 1, category: categories[0], author_id: users[0].id },
  { title: 'Physics Basics', level: 3, category: categories[2], author_id: users[2].id }
])
puts "Tests created: #{tests.count}"

# Create questions
puts "Creating questions..."
questions = Question.create!([
  { content: 'What is the capital of France?', test: tests[2] },
  { content: 'Which country is known for the Colosseum?', test: tests[1] },
  { content: 'What is the largest country in Europe?', test: tests[0] },
  { content: 'What is Newton\'s second law?', test: tests[3] }
])
puts "Questions created: #{questions.count}"

# Create answers
puts "Creating answers..."
answers = Answer.create!([
  { content: 'Paris', correct: true, question: questions[0] },
  { content: 'Rome', correct: true, question: questions[1] },
  { content: 'Russia', correct: true, question: questions[2] },
  { content: 'Germany', correct: false, question: questions[2] },
  { content: 'London', correct: false, question: questions[0] },
  { content: 'Athens', correct: false, question: questions[1] },
  { content: 'F = ma', correct: true, question: questions[3] },
  { content: 'E = mc²', correct: false, question: questions[3] }
])
puts "Answers created successfully. Total answers: #{answers.count}"

# Create test results
puts "Creating test results..."
test_results = TestResult.create!([
  { user: users[0], test: tests[0], completed: true, score: 80 },
  { user: users[1], test: tests[2], completed: true, score: 100 },
  { user: users[2], test: tests[3], completed: false, score: 50 },
  { user: users[0], test: tests[1], completed: true, score: 90 }
])
puts "Test results created: #{test_results.count}"

# Additional examples
puts "Creating additional examples..."
additional_tests = Test.create!([
  { title: 'Famous Landmarks', level: 2, category: categories[0], author_id: users[1].id },
  { title: 'World Wars', level: 3, category: categories[1], author_id: users[2].id }
])
puts "Additional tests created: #{additional_tests.count}"

additional_questions = Question.create!([
  { content: 'Where is the Eiffel Tower located?', test: additional_tests[0] },
  { content: 'Which countries were part of the Allies in World War II?', test: additional_tests[1] }
])
puts "Additional questions created: #{additional_questions.count}"

additional_answers = Answer.create!([
  { content: 'Paris', correct: true, question: additional_questions[0] },
  { content: 'London', correct: false, question: additional_questions[0] },
  { content: 'USA, UK, USSR', correct: true, question: additional_questions[1] },
  { content: 'Germany, Japan, Italy', correct: false, question: additional_questions[1] }
])
puts "Additional answers created: #{additional_answers.count}"

puts "Hallelujah! We did it!!! Seed data created successfully!!!"
