Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
		post 'objectmatch', to: 'analyses#objectmatch'
  end	
end
