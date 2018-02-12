require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read('fixtures/student-site/index.html')
    scraper = Nokogiri::HTML(html)
    students = scraper.css('.student-card')
    students_array = []
    students.each do |student|
      temp = {}
      temp[:name] = student.css('.student-name').text
      temp[:location] = student.css('.student-location').text
      temp[:profile_url] = student.css('a')[0]['href']
      students_array.push(temp)
    end
    students_array
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    scraper = Nokogiri::HTML(html)
    student = {}
    student_array = scraper.css('.social-icon-container').css('a')
    student_array.each do |stud|
      booger = stud['href']
      case
      when booger.include?('twitter')
        student[:twitter] = booger
      when booger.include?('linkedin')
        student[:linkedin] = booger
      when booger.include?('github')
        student[:github] = booger
      else
        student[:blog] = booger
      end
    end
    student[:profile_quote] = scraper.css('.profile-quote').text
    student[:bio] = scraper.css('.bio-content').css('.description-holder').text.strip
    student
  end

end

#{ }`:name`, `:location` and `:profile_url`
# => {:twitter=>"http://twitter.com/flatironschool",
