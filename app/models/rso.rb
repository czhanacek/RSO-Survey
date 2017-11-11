class Rso < ApplicationRecord
  has_many :rso_keywords, :dependent => :delete_all
  has_many :keywords, through: :rso_keywords, :dependent => :delete_all

  validates :name, :presence => true
  validates_length_of :name, :maximum => 255
  validates :nickname, :presence => true
  validates_length_of :nickname, :maximum => 50


  def self.to_csv
    attributes = ["Name", "Nickname", "Website", "Description", "Keyword 1", "Weight 1", "Keyword 2", "Weight 2", "Keyword 3", "Weight 3", "Keyword 4", "Weight 4", "Keyword 5", "Weight 5"]

    CSV.generate(headers: true) do |csv|
      csv << attributes
      
      all.each do |r|
        row = []
        #puts r.inspect
        row << r.name
        row << r.nickname
        row << r.website
        row << r.description
        ks = r.keywords.limit(5)
        puts ks.inspect
        if(ks.empty? == false)
          ks.each do |k|
            row << k.keyword
            row << k.weight
          end
        end
        csv << row
      end
    end
    
  end
end
