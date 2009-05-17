namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'

    [Item, Comment, Star, Tag, Tagging].each(&:delete_all)

    Tag.populate 10 do |tag|
      tag.name = ["wss", "moss", "InfoPath", "javascript", "metadata", "enduser", "search", "admin", "dev", "codeplex", "2007", "2010", "MSDN", "3.0", "centraladmin", "tip", "article"]
    end

    Item.populate 2000 do |item|
      item.title = Populator.words(2..5).titleize
      item.byline = Faker::Name.name
      item.content = Populator.sentences(1..2) +" <a href=\"http://" + Faker::Internet.domain_name + "\">" + Populator.words(1..4) + "</a> " + Populator.sentences(0..2)
      item.created_at = 24.months.ago..Time.now
      Tagging.populate 0..5 do |tagging|
        tagging.tag_id = 1..10
        tagging.taggable_id = item.id
        tagging.taggable_type = "Item"
      end
    end
  end
end
