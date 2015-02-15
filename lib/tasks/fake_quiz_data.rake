namespace :fake_quiz_data do

  desc "Generate fake data to populate 4 quizzes"

  task :populate_quizzes => :environment do

    # generate 3 user
    3.times do 
      user = User.create(name: Faker::Internet.password(7), email: Faker::Internet.email, password: Faker::Internet.password(8), admin: [true, false].sample, activated: true )
    end

    # generate 2 category
    2.times do
      category = Category.create(title: Faker::Lorem.word)
    end

    # generate 3 quiz for each category
    Category.all.each do |c|
      3.times do
        quiz = c.quizzes.create(title: Faker::Company.bs, body: Faker::Lorem.sentence(10), level: [1, 2, 3].sample, category_id: Category.all.sample.id)
      end
    end

    # generate 10 questions for each quiz
  
    Quiz.all.each do |quiz|
      10.times do 
        question = quiz.questions.create(title: Faker::Lorem.word, body: Faker::Lorem.sentence(15), explanation: Faker::Lorem.sentence(10) )
      end
    end


    # generate 3 answers for each question
    Question.all.each do |question|
      3.times do
        answer = question.answers.create(body: Faker::Lorem.sentences(5), correct: [true, false].sample)
      end
    end

    User.all.each do |u|

      # generate random selection pairings between users and answers
      10.times do
        selection = u.selections.create(points: rand(500), answer_id: Answer.select("id").sample.id )
      end

      # generate random UserQuiz pairings between users and quizzes
      2.times do
        userquiz = u.user_quizzes.create(quiz_id: Quiz.select("id").sample.id )
      end 
    end

  end

end
