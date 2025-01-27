# Clear the database
puts "Clearing the database..."
TestResult.destroy_all
Answer.destroy_all
Question.destroy_all
Test.destroy_all
Category.destroy_all
User.destroy_all
puts "Database cleared successfully."

# Create users
puts "Creating users..."
users = [
  User.create!(name: 'Andrey', email: 'andrey@example.com'),
  User.create!(name: 'Pavel', email: 'pavel@example.com'),
  User.create!(name: 'Maria', email: 'maria@example.com'),
  User.create!(name: 'Olga', email: 'olga@example.com')
]
puts "Users created: #{users.count}"

# Create categories
puts "Creating categories..."
categories = [
  Category.create!(name: 'Geography'),
  Category.create!(name: 'History'),
  Category.create!(name: 'Science')
]
puts "Categories created: #{categories.count}"

# Create tests
puts "Creating tests..."
tests = [
  Test.create!(title: 'Countries of Europe', level: 1, category: categories[0], author: users[0]),
  Test.create!(title: 'Ancient Civilizations', level: 2, category: categories[1], author: users[1]),
  Test.create!(title: 'Capitals of the World', level: 1, category: categories[0], author: users[0]),
  Test.create!(title: 'Physics Basics', level: 3, category: categories[2], author: users[2])
]
puts "Tests created: #{tests.count}"

# Create questions
puts "Creating questions..."
questions = [
  tests[2].questions.create!(content: 'What is the capital of France?'),
  tests[1].questions.create!(content: 'Which country is known for the Colosseum?'),
  tests[0].questions.create!(content: 'What is the largest country in Europe?'),
  tests[3].questions.create!(content: 'What is Newton\'s second law?')
]
puts "Questions created: #{questions.count}"

# Create answers
puts "Creating answers..."
answers = [
  questions[0].answers.create!(content: 'Paris', correct: true),
  questions[1].answers.create!(content: 'Rome', correct: true),
  questions[2].answers.create!(content: 'Russia', correct: true),
  questions[2].answers.create!(content: 'Germany', correct: false),
  questions[0].answers.create!(content: 'London', correct: false),
  questions[1].answers.create!(content: 'Athens', correct: false),
  questions[3].answers.create!(content: 'F = ma', correct: true),
  questions[3].answers.create!(content: 'E = mc²', correct: false)
]
puts "Answers created successfully. Total answers: #{answers.count}"

# Create test results
puts "Creating test results..."
test_results = [
  TestResult.create!(user: users[0], test: tests[0]),
  TestResult.create!(user: users[1], test: tests[2]),
  TestResult.create!(user: users[2], test: tests[3]),
  TestResult.create!(user: users[0], test: tests[1])
]
puts "Test results created: #{test_results.count}"

puts "Hallelujah! We did it!!! Seed data created successfully!!!"
