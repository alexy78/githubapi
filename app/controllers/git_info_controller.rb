require 'graphql/client'
  require 'graphql/client/http'
  class GitInfoController < ApplicationController
    URL = 'https://api.github.com/graphql'
    HttpAdapter = GraphQL::Client::HTTP.new(URL) do
      def headers(context)
        {
          'Authorization' => "Bearer #{ENV['GITHUB_ACCESS_TOKEN']}",
          'User-Agent' => 'Ruby'
        }
      end
    end
      Schema = GraphQL::Client.load_schema(HttpAdapter)
    Client = GraphQL::Client.new(schema: Schema, execute: HttpAdapter)
  
    USER_REPOS_QUERY = Client.parse <<-'GRAPHQL'
    query($username: String!) {
      user(login: $username) {
        name
        repositories(first: 10) {
          nodes {
            name
          }
        }
      }
    }
    GRAPHQL
  
    def index
    end
  
    def show
      github_login = params[:github_login]
      @repos = fetch_github_repos(github_login)
    end
  
    private
  
    def fetch_github_repos(username)
      response = Client.query(USER_REPOS_QUERY, variables: { username: username })
      if response.errors.any?
        @error_message = "GraphQL Error: #{response.errors['data'] || 'No additional error data'}"
        raise StandardError.new(@error_message)
      elsif response.data.user.nil?
        @error_message = "No user found with username: #{username}"
        []
      else
        @user_name = response.data.user.name
        response.data.user.repositories.nodes
      end
    end
  end
