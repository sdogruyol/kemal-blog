require "./kemal-blog/*"
require "kemal"
require "kemal-mysql"

public_folder "src/public"

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
  render "src/views/articles/new.ecr", "src/views/layouts/layout.ecr"
end

# Lists all articles
get "/articles" do |env|
  articles = conn.query "SELECT * FROM articles"
  render "src/views/articles/index.ecr", "src/views/layouts/layout.ecr"
end

# Show Article with given id
get "/articles/:id" do |env|
  id = env.params["id"]
  article = conn.query "SELECT * FROM articles WHERE articles.id=#{id} LIMIT 1"
  article = article.not_nil!.first
  render "src/views/articles/show.ecr", "src/views/layouts/layout.ecr"
end

# Edit article
get "/articles/:id/edit" do |env|
  id = env.params["id"]
  article = conn.query "SELECT * FROM articles WHERE articles.id=#{id} LIMIT 1"
  article = article.not_nil!.first
  render "src/views/articles/edit.ecr", "src/views/layouts/layout.ecr"
end

# Create new article
post "/articles" do |env|
  title = env.params["title"] as String
  body = env.params["body"] as String
  conn.query "INSERT INTO articles(title, body) VALUES ('#{title}', '#{body}')"
  env.redirect "/articles"
end

# Update article
patch "/articles/:id" do |env|
  id = env.params["id"]
  title = env.params["title"] as String
  body = env.params["body"] as String
  conn.query "UPDATE articles SET title='#{title}', body='#{body}' WHERE articles.id=#{id}"
  env.redirect "/articles"
end

# Delete article
delete "/articles/:id" do |env|
  id = env.params["id"]
  conn.query "DELETE FROM articles WHERE articles.id=#{id}"
  env.redirect "/articles"
end
