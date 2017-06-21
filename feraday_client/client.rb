require 'faraday'

BASE_URL = 'http://localhost:3000/api/v1'
response = Faraday.get "#{BASE_URL}/questions/4160"
puts response.body


# or we can send a post
Faraday.post "#{BASE_URL}/questions", {
  question: {
  title: "What is going on?",
  body: "Nothing at all",
  view_count: 2
  }
}

puts response.body
