namespace :user do
  desc "TODO"
  task say_hello: :environment do
    p "hello"
  end
  task create_user: :environment do
    User.create(name: "rake_task", email: "rake_task@g.c", password: "123456")
    p "create user done"
  end
  task :create_micropost, [:user_id] => [:environment] do |_,args|
    Micropost.create(title: "title rake task",content: "content rake task",user_id: args[:user_id])
  end
  task create_user_10000: :environment do
    10000.times {
      User.create(name: Faker::Name.name, email: Faker::Internet.email, password: "123456")
    }
  end

  task :create_micro_5000, [:user_id] => [:environment] do |_,args|
    columns = [ :title, :content, :user_id, :category_id ]
    values = []
    5000.times do
      values << [Faker::Lorem.sentence, Faker::Lorem.paragraph,args[:user_id],Random.rand(1..6)]
    end
    Micropost.import columns, values
  end

end
