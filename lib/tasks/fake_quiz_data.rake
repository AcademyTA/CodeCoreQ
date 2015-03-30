namespace :fake_quiz_data do

  desc "Generate fake data to populate 4 quizzes"

  task :populate_quizzes => :environment do

    # generate 3 user
    3.times do |n|
      User.create(name: Faker::Name.first_name, email: Faker::Internet.user_name + "@email.com", password: "password", admin: [true, false].sample, activated: true )
    end

    # generate 3 categories
    Category.create(title: "Ruby")
    Category.create(title: "JavaScript")
    Category.create(title: "HTML")

    # generate 3 quiz for each category
    Category.all.each do |c|
      3.times do
        quiz = c.quizzes.create(title: Faker::Hacker.say_something_smart, body: Faker::Lorem.sentence(10), level: [1, 2, 3].sample, category_id: Category.all.sample.id)
      end
    end

    # generate 10 questions for each quiz
  
    Quiz.all.each_with_index do |quiz, index|
      10.times do 
        question = quiz.questions.create(title: "Question-#{index+1}", body: Faker::Lorem.sentence(15), explanation: Faker::Lorem.sentence(10) )
      end
    end


    # generate 3 answers for each question
    Question.all.each do |question|
      3.times do
        question.answers.create(body: Faker::Lorem.sentence, correct: false)
      end

      # initialize all 3 answers to false, choose one at random set to true
      question.answers.sample.update(correct: true)
    end

    User.all.each do |u|

      # generate random UserQuiz pairings between users and quizzes
      2.times do
        userquiz = u.user_quizzes.create(quiz_id: Quiz.select("id").sample.id )

        # generate selection pairings between users and answers based on userquiz
        userquiz.quiz.questions.each do |question|
          selection = u.selections.create(answer_id: question.answers.sample.id)
        end
      end


    end

  end

end
