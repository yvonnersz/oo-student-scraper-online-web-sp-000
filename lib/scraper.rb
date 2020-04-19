require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    students = []

    # roster: doc.css("div.roster-cards-container")
    # name: doc.css("h4.student-name").text
    # location: doc.css("p.student-location").text
    # profile_url: doc.css("div.student-card a").attribute("href").value

    doc.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        name = student.css(".student-name").text
        location = student.css(".student-location").text
        profile_url = student.attr("href")
        students << {:name => name, :location => location, :profile_url => profile_url}
      end
    end

    students

  end



  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student = {}

    # :twitter=> doc.css("div.social-icon-container a")[0].attribute("href").value
    # :linkedin=> doc.css("div.social-icon-container a")[1].attribute("href").value
    # :github=> doc.css("div.social-icon-container a")[2].attribute("href").value
    # :blog=> doc.css("div.social-icon-container a")[3].attribute("href").value
    # :profile_quote=> doc.css("div.profile-quote").text
    # :bio=> doc.css("div.description-holder p").text

    social_media_array = doc.css("div.social-icon-container a").collect {|x| x.attribute("href").value}
    social_media_array.each do |social_media|
      if social_media.include?("twitter")
        student[:twitter] = social_media_array[0]
      elsif social_media.include?("linkedin")
        student[:linkedin] = social_media_array[1]
      elsif social_media.include?("github")
        student[:github] = social_media_array[2]
      else
        student[:blog] = social_media_array[3]
      end
    end

    student[:profile_quote] = doc.css(".profile-quote").text
    student[:bio] = doc.css("div.description-holder p").text

    student

  end

end
