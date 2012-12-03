class TestQuestion < ActiveRecord::Base
  attr_accessible :choice1, :choice2, :choice3, :choice4, :content, :correct_choice, :score, :test_id

  belongs_to :test
  
  
  def self.all_cached(test_id)
    Rails.cache.fetch('TestQuestion.' + test_id.to_s) { TestQuestion.find :all, :conditions => ["test_id = ?", test_id]}
  end

  def self.expire_test_question_cache(test_id)
    Rails.cache.delete('TestQuestion.' + test_id.to_s)
  end
  
  
end
