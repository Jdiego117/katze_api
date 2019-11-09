Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html 

  #LOGIN AND REGISTER ROUTES
    get '/login', to: 'v1/users#login'
    post '/register', to: 'v1/users#register'
  #EMAIL VERIFICATION ROUTES
    get '/verifyEmail', to: 'v1/verifies#verify' 
    get '/resendVerifyCode', to: 'v1/verifies#resendCode'
  #USER ROUTES 
    get '/currentUserInfo', to: 'v1/users#getMyInfo'
    get '/GetUserByNick', to: 'v1/users#getUserInfoByNick'
    get '/GetMyBasicInfo', to: 'v1/users#getMyBasicInfo'
    get '/CanSeeUser', to: 'v1/users#canSeeUser'
    get '/UserSearch', to: 'v1/users#searchUserBasic'
    post '/UpdateUser', to: 'v1/users#updateUser'
  #CONTENT ROUTES
    get '/GetMyGallery', to: 'v1/multimedia#getGallery'
    post '/AddContent', to: 'v1/multimedia#addContent'
  #PUBLICATIONS ROUTES
    post '/NewPublication', to: 'v1/publications#createPublication'
    get '/GetMyPublications', to: 'v1/publications#getMyPublications'
    get '/GetUserPublications', to: 'v1/publications#getUserPublications'
    get '/CountPublications', to: 'v1/publications#countUserPublications'
    get '/GetFollowPublications', to: 'v1/publications#getMyFollowsPublications'

  #STORIES ROUTES
    post '/NewStory', to: 'v1/story#createStory'
    get '/GetMyStories', to: 'v1/story#getMyStories'
    get '/GetUserStories', to: 'v1/story#getUserStories'
    get '/GetStoriesPreview', to: 'v1/story#GetStoriesPreview'
  #FOLLOW ROUTES
    get '/FollowUser', to: 'v1/follows#followUser'
    get '/getFollowState', to: 'v1/follows#getFollowState'
    get '/UserGetFollowStats', to: 'v1/follows#getFollowStats'
    get '/FastFollowAction', to: 'v1/follows#fastFollowAction'
  #LIKES ROUTES
    get '/SetLikePublication', to: 'v1/likes#setLikePublication'
    get '/DeleteLikePublication', to: 'v1/likes#deleteLikePublication'
    get '/CountPublicationLikes', to: 'v1/likes#countPublicationLikes'

  namespace :v1 do
  	resources :users
  	get '/register', to: 'users#register'
  end
end
