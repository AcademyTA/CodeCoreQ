class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  def new
  end

  def index
    @answers = @question.answers #grabs all the answers from the question
  end

  def create
    # @answer = Answer.new answer_params
    # @answer.question_id = @question.id
    @answer = @question.answers.create(answer_params)
    if @answer.save
      redirect_to quiz_questions_path(@question.quiz), notice: "Answer created successfully."
    else
      redirect_to quiz_questions_path(@question.quiz), alert: "Answer FAILED to create."
    end
  end

  def edit
    # @question = Question.find params[:question_id]
    @answer = Answer.find(params[:id])
    # render text: params
  end

  def update
    # @question = Question.find params[:question_id]
    # @answer = @question.answers.find(params[:id])
    @answer = Answer.find(params[:id])
    if @answer.update answer_params
      redirect_to question_answers_path(@question), notice: "Answer updated successfully."
    else
      redirect_to question_answers_path(@question), alert: "Answer FAILED to update."
    end
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    if @answer.destroy
      redirect_to question_answers_path(@question), notice: "Answer Deleted."
    else
      redirect_to question_answers_path(@question), alert: "Answer FAILED Delete."
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct, :question_id)
  end

end
