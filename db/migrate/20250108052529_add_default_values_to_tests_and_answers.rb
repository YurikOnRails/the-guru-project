class AddDefaultValuesToTestsAndAnswers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :tests, :level, 1


    change_column_default :answers, :correct, false
  end
end
