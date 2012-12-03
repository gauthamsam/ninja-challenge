class Test < ActiveRecord::Base
  attr_accessible :admin_id, :duration, :end_date, :level_id, :max_score, :name, :start_date

  #validates :end_date,  :presence => true
  #validates :start_date, :presence => true
  #validates :level_id, :presence => true
  #validates :max_score, :presence => true
  #validates :name, :presence => true

  has_one :admin
  has_many :test_questions
  
  def self.all_cached(admin_id)
    Rails.cache.fetch('Test.' + admin_id.to_s) { Test.find :all, :conditions => ["admin_id = ?", admin_id]}
  end
  
  def self.all_tests_by_level_cached(level_id)
    Rails.cache.fetch('Test.' + level_id.to_s) { Test.find :all, :conditions => ["level_id = ?", level_id]}
  end

#  after_save    :expire_test_all_cache
#  after_destroy :expire_test_all_cache

  def self.expire_test_cache(admin_id)
    Rails.cache.delete('Test.' + admin_id.to_s)
  end

end
