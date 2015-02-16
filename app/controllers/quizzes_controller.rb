class QuizzesController < ApplicationController

  def new
    @quiz = Quiz.new
    @categories = Category.all
  end

  def create
    # render text: params
    @categories = Category.all
    @quiz = Quiz.new quiz_params
    if @quiz.save
      redirect_to @quiz
    else
      render :new
    end
  end

  def show
    @quiz = Quiz.find(params[:id])
    @category = Category.find(@quiz.category_id)
    @questions = @quiz.questions

    new_user_quiz = true
    UserQuiz.all.each do |uq|
      if uq.quiz == @quiz && uq.user == current_user
        new_user_quiz = false
      end
    end
    if new_user_quiz
      UserQuiz.create(user_id: current_user.id, quiz_id: @quiz.id)
    end
  end


  def index
    @quizzes = Quiz.all
    @categories = Category.all
  end



  def edit
    @categories = Category.all
    @quiz = Quiz.find(params[:id])
  end

  def update
    # render text: params
    @quiz = Quiz.find(params[:id])
    
    if @quiz.update(quiz_params)
      redirect_to quizzes_path
    else 
      render :edit
    end
  end

  def destroy
    @quiz = Quiz.find (params[:id])
    @quiz.destroy
    redirect_to quizzes_path

  end


  private
  def quiz_params 
    params.require(:quiz).permit(:title, :body, :level, :category_id)
  end


end
