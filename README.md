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
