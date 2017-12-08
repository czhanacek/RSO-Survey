class Question < ApplicationRecord
  def answer_limits
    answersNumber = Answer.where(:question_id => self.id).count
    if !(answersNumber >= 2)
      errors.add(:answers, "must have 2 or more answers")
    elsif !(answersNumber <= 4)
      errors.add(:answers, "must have 4 or less answers")
    end
  end

  validates :answers, :presence => true
  validates :position, :presence => true
  validates :question_title, :presence => true
  
  validate :answer_limits
  has_many :answers, :dependent => :delete_all
  belongs_to :category


  def self.to_csv
    attributes = ["Question", "Position", "Category", "Category Group", "Answer 1", "Answer 2", "Answer 3", "Answer 4", "Keyword 1 For Answer 1", "Weight For Keyword 1 For Answer 1", "Keyword 2 For Answer 1", "Weight For Keyword 2 For Answer 1", "Keyword 3 For Answer 1", "Weight For Keyword 3 For Answer 1", "Keyword 4 For Answer 1", "Weight For Keyword 4 For Answer 1", "Keyword 5 For Answer 1", "Weight For Keyword 5 For Answer 1", "Keyword 1 For Answer 2", "Weight For Keyword 1 For Answer 2", "Keyword 2 For Answer 2", "Weight For Keyword 2 For Answer 2", "Keyword 3 For Answer 2", "Weight For Keyword 3 For Answer 2", "Keyword 4 For Answer 2", "Weight For Keyword 4 For Answer 2", "Keyword 5 For Answer 2", "Weight For Keyword 5 For Answer 2", "Keyword 1 For Answer 3", "Weight For Keyword 1 For Answer 3", "Keyword 2 For Answer 3", "Weight For Keyword 2 For Answer 3", "Keyword 3 For Answer 3", "Weight For Keyword 3 For Answer 3", "Keyword 4 For Answer 3", "Weight For Keyword 4 For Answer 3", "Keyword 5 For Answer 3", "Weight For Keyword 5 For Answer 3", "Keyword 1 For Answer 4", "Weight For Keyword 1 For Answer 4", "Keyword 2 For Answer 4", "Weight For Keyword 2 For Answer 4", "Keyword 3 For Answer 4", "Weight For Keyword 3 For Answer 4", "Keyword 4 For Answer 4", "Weight For Keyword 4 For Answer 4", "Keyword 5 For Answer 4", "Weight For Keyword 5 For Answer 4"]

    CSV.generate(headers: true) do |csv|
      csv << attributes
      
      all.each do |q|
        row = []
        row << q.question_title
        row << q.position
        if(q.category_id == -1 || q.category == nil)
          row << "No category"
          row << "No category group"
        else
          row << q.category.title
          row << q.category.category_group.title
        end
        q.answers.sort_by(&:position).each do |a|
          row << a.answer_title
        end
        (4 - q.answers.count).times do 
          row << ""
        end
        q.answers.sort_by(&:position).each do |a|
          a.keywords.limit(5).each do |k|
            row << k.keyword
            row << k.weight
          end
          (5 - a.keywords.limit(5).count).times do
            row << ""
            row << ""
          end
        end
        (4 - q.answers.count).times do 
          10.times do 
            row << ""
          end
        end
        csv << row
      end
    end
    
  end

end
