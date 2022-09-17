# README

Starting new rails 7 project with esbuild, tailwindcss, postgresql

```
rails new . --database postgresql --css tailwind --javascript esbuild
rails db:create && rails db:migrate
```

Make sure you have `postcss` npm package installed in your `package.json` file

Add this to `package.json` in order for css and js rebuild after changes

```
"scripts": {
  "build": "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds",
  "build:css": "tailwindcss --postcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify"
}
```

Create postcss.config.js file and change it content to this:
```
module.exports = {
  plugins: [
    require('postcss-import'),
    require('tailwindcss/nesting'),
    require('tailwindcss'),
  ],
};
```

Cleanup gem file - remove comments, order all gems name in alphabetics order (`ctrl + shift + a` in vscode)

## Installing haml gem (skip this if you want to stick with classic .html.erb views format)

- Add `gem "haml"` and `gem "haml-rails"` to Gemfile
- Run `bundle` and `rails haml:erb2haml` to convert all html.erb files into html.haml format
- After converting files you can remove `gem "haml-rails"` line from Gemfile
- In `tailwind.config.js` file change line
  `'./app/views/**/*.html.erb',` -> `'./app/views/**/*.html.haml'`

## Add "hotwire-livereload" gem for page to take changes immediately

- Add `gem "hotwire-livereload"` to Gemfile
- Add this to `layouts/application.html.haml`
  ```
  - if Rails.env == 'development'
    = hotwire_livereload_tags
  ```

## Setup css

Change application.tailwind.css stylesheet content to this to remove warnings

```
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";
```

Adding variables to this css file written in next format:

```
:root {
  --variable-name: value;
}
```

After creating new css file, don't forget to import it in application.tailwind.css file:

`@import "css_file_name.css"`

Generate controller for pages - `rails g controller Pages`

Create `index.html.haml` file in pages directory. Specify `root "pages#index"` in `routes.rb`


## Config security keys in Rails applcations

Adding secret keys will be with gem figaro

```
gem "figaro"
bundle exec figaro install
```

Then clean up application.yml file from comments.
Add your secret keys in next format:

```
client_id: "1rfivlpk7i55k7sbbyfgskhn"
client_secret: "9fh6awjslaqxpbg6c23x9q"
```

## Adding omniauth login (twitch example)

Install needed gems:

```
gem "omniauth-rails_csrf_protection"
gem "omniauth-twitch"
gem "omniauth"
```

Generate user model

`rails g model User`

In migration file add next fields

```
t.string :name
t.string :uid
t.string :avatar
t.integer :role, default: 0
```

`rails db:migrate`

In user model add next method

```
def self.from_omniauth(res)
  User.find_or_create_by(uid: res[:uid]) do |user|
    user.name = res[:info][:name] || res[:info][:nickname]
    user.avatar = res[:info][:image]
  end
end
```

It will be responsive to create or get user on its login process.

Add `omniauth.rb` in initializer folder
```
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitch, ENV["twitch_client_id"], ENV["twitch_client_secret"]
end
```

## Generate sessions controller

`rails g controller sessions`

In routes specify route for twitch callback + routes for session destroy to logout user.

```
get '/auth/:provider/callback' => 'sessions#omniauth'
resource :sessions, only: :destroy
```

Add omniauth method in newly created controller

```
def omniauth
  user = User.from_omniauth(request.env['omniauth.auth'])

  if user.valid?
    session[:user_id] = user.id
  end
  redirect_to root_path
end
```

Add destroy method to logout

```
def destroy
  session[:user_id] = nil
  redirect_to root_path
end
```

Add current_user helper method in application controller

```
helper_method :current_user

def current_user
  @current_user ||= User.find_by(id: session[:user_id]) if !!session[:user_id]
end
```

Add login and logout buttons if current_user present

```
- if current_user
  = link_to "Logout", sessions_path, class: "button", data: { "turbo-method": :delete }
- else
  = button_to "Login with Twitch", '/auth/twitch', class: 'button', data: { method: :post, turbo: "false" }
```
