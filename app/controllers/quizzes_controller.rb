class QuizzesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @quiz       = Quiz.new
    @categories = Category.all
  end

  def create
    # render text: params
    @quiz       = Quiz.new(quiz_params)
    @categories = Category.all

    if @quiz.save
      flash[:notice] = "Quiz Created!"
      redirect_to @quiz
    else
      flash[:alert] = "Unable to create Quiz!"
      render :new
    end
  end

  def show
    @quiz         = Quiz.find(params[:id])
    @category     = Category.find(@quiz.category_id)
    @questions    = @quiz.questions
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
    @quizzes    = Quiz.all
    @categories = Category.all
  end

  def edit
    @quiz       = Quiz.find(params[:id])
    @categories = Category.all
  end

  def update
    # render text: params
    @quiz = Quiz.find(params[:id])
    if @quiz.update(quiz_params)
      flash[:notice] = "Quiz updated!"
      redirect_to quizzes_path
    else
      flash[:alert] = "Unable to update Quiz!"
      render :edit
    end
  end

  def destroy
    @quiz = Quiz.find (params[:id])
    @quiz.destroy
    flash[:notice] = "Quiz Deleted!"
    redirect_to quizzes_path
  end

  private

  def quiz_params 
    params.require(:quiz).permit(:title, :body, :level, :category_id)
  end

end
