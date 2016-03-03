require "./kemal-blog/*"
require "kemal"
require "kemal-mysql"

CONN_OPTS = {
  "host" => "127.0.0.1",
  "user" => "root",
  "password" => "",
  "db" => "kemal-blog"
}

mysql_connect CONN_OPTS

# Index
get '/' do |env|
  env.redirect "/articles"
end

# New article form
get "/articles/new" do |env|
  render "src/views/articles/new.ecr"
end

# Lists all articles
get "/articles" do |env|
  articles = conn.query "SELECT * FROM articles"
  render "src/views/articles/index.ecr"
end

# Show Article with given id
get "/articles/:id" do |env|
  id = env.params["id"]
  article = conn.query "SELECT * FROM articles WHERE articles.id=#{id} LIMIT 1"
  article = article.not_nil!.first
  render "src/views/articles/show.ecr"
end

post "/articles" do |env|
  title = env.params["title"] as String
  body = env.params["body"] as String
  conn.query "INSERT INTO articles(title, body) VALUES ('#{title}', '#{body}')"
  env.redirect "/articles"
end
