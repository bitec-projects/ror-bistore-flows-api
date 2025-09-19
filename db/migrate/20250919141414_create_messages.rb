class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :number_id
      t.string :remote_jid
      t.boolean :from_me
      t.string :msg_id
      t.string :push_name
      t.string :body
      t.string :msg_type

      t.timestamps
    end
  end
end
