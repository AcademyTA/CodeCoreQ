class SelectionsController < ApplicationController
  before_action :find_answer, only: [:create, :update]

  def create
    # render text: params
   # render :text => params.inspect
   
    selection = Selection.new(user_id: current_user.id, answer_id: @answer.id )

    if selection.save
      redirect_to quiz_question_path(@answer.question.quiz, @answer.question), notice: "Selection created successfully."
      #flash[:notice] = "Selection created successfully."
    else
      redirect_to quiz_question_path(@answer.question.quiz, @answer.question), alert: "Selection FAILED to create."
      #flash[:alert] = "Selection FAILED to create."
    end
  end

  def update
    if selection.update(user_id: current_user.id, answer_id: @answer.id)
      redirect_to quiz_question_path(@answer.question.quiz, @answer.question), notice: "Selection data updated successfully."
      #flash[:notice] = "Selection data updated successfully." 
    else
      redirect_to quiz_question_path(@answer.question.quiz, @answer.question), notice: "Selection data FAILED to update."
      #flash[:alert] = "Selection data FAILED to update."
    end
  end

  private 

  def find_answer
    @answer = Answer.find(params[:answer_id] || params[:id])
  end

  def find_user

  end

  def selection_params
    params.require(:selection).permit(:user_id, :answer_id)    
  end
end
