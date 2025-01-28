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
User.create!(
  [
    { name: 'Andrey', email: 'andrey@example.com' },
    { name: 'Pavel', email: 'pavel@example.com' },
    { name: 'Maria', email: 'maria@example.com' },
    { name: 'Olga', email: 'olga@example.com' }
  ]
)
puts "Users created: #{User.count}"

# Create categories
puts "Creating categories..."
Category.create!(
  [
    { name: 'Geography' },
    { name: 'History' },
    { name: 'Science' }
  ]
)
puts "Categories created: #{Category.count}"

# Create tests
puts "Creating tests..."
Test.create!(
  [
    { title: 'Countries of Europe', level: 1, category: Category.first, author: User.first },
    { title: 'Ancient Civilizations', level: 2, category: Category.second, author: User.second },
    { title: 'Capitals of the World', level: 1, category: Category.first, author: User.first },
    { title: 'Physics Basics', level: 3, category: Category.third, author: User.third }
  ]
)
puts "Tests created: #{Test.count}"

# Create questions
puts "Creating questions..."
Question.create!(
  [
    { content: 'What is the capital of France?', test: Test.first },
    { content: 'Which country is known for the Colosseum?', test: Test.second },
    { content: 'What is the largest country in Europe?', test: Test.first },
    { content: 'What is Newton\'s second law?', test: Test.third }
  ]
)
puts "Questions created: #{Question.count}"

# Create answers
puts "Creating answers..."
Answer.create!(
  [
    { content: 'Paris', correct: true, question: Question.first },
    { content: 'London', correct: false, question: Question.first },
    { content: 'Rome', correct: true, question: Question.second },
    { content: 'Athens', correct: false, question: Question.second },
    { content: 'Russia', correct: true, question: Question.third },
    { content: 'Germany', correct: false, question: Question.third },
    { content: 'F = ma', correct: true, question: Question.fourth },
    { content: 'E = mc²', correct: false, question: Question.fourth }
  ]
)
puts "Answers created: #{Answer.count}"

# Create test results
puts "Creating test results..."
TestResult.create!(
  [
    { user: User.first, test: Test.first },
    { user: User.second, test: Test.second },
    { user: User.third, test: Test.third },
    { user: User.first, test: Test.second }
  ]
)
puts "Test results created: #{TestResult.count}"

puts "Hallelujah! We did it!!! Seed data created successfully!!!"
