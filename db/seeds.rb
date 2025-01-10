# db/seeds.rb

# Clear the database (optional!!!)
User.destroy_all
Category.destroy_all
Test.destroy_all
Question.destroy_all
Answer.destroy_all

# Create users
users = User.create!([
                       { name: 'Andrey', email: 'andrey@example.com' },
                       { name: 'Pavel', email: 'pavel@example.com' }
                     ])

# Create categories
categories = Category.create!([
                                { name: 'Geography' },
                                { name: 'History' }
                              ])

# Create tests
tests = Test.create!([
                       { title: 'Countries of Europe', level: 1, category: categories[0], author: users[0] },
                       { title: 'Ancient Civilizations', level: 2, category: categories[1], author: users[1] },
                       { title: 'Capitals of the World', level: 1, category: categories[0], author: users[0] }
                     ])

# Create questions
questions = Question.create!([
                               { content: 'What is the capital of France?', test: tests[2] },
                               { content: 'Which country is known for the Colosseum?', test: tests[1] },
                               { content: 'What is the largest country in Europe?', test: tests[0] }
                             ])

# Create answers
Answer.create!([
                 { content: 'Paris', correct: true, question: questions[0] },
                 { content: 'Rome', correct: true, question: questions[1] },
                 { content: 'Russia', correct: true, question: questions[2] },
                 { content: 'Germany', correct: false, question: questions[2] },
                 { content: 'London', correct: false, question: questions[0] },
                 { content: 'Athens', correct: false, question: questions[1] }
               ])

puts 'Yep! Seed data for countries created successfully!!!'
