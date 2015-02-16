class AnswersController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_question, only: [:update] 

  def new
    # render text: params
    @question = Question.find params[:question_id]
  end

  def create
    # render text: params
      @question = Question.find params[:question_id]
      @answer = Answer.new answer_params
      @answer.question_id = @question.id
      if @answer.save
        redirect_to quiz_questions_path(@question.quiz), notice: "Answer created successfully."
      else
        redirect_to quiz_questions_path(@question.quiz), alert: "Answer FAILED to create."
      end
  end
  def update
    #find_quiz
    @answer = @question.answers.find(params[:id])
    if @answer.update answer_params
      redirect_to quiz_questions_path(@question.quiz), notice: "Answer updated successfully."
    else
      redirect_to quiz_questions_path(@question.quiz), alert: "Answer FAILED to update."
    end
  end

  private

  def find_question
    @question = Quiz.find(params[:question_id])
  end
  def answer_params
    params.require(:answer).permit(:body, :correct, :question_id)
  end
end
