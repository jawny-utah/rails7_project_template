# README

Starting new rails 7 project with esbuild, tailwindcss and postgresql

rails new . --database postgresql --css tailwind --javascript esbuild

rails db:create && rails db:migrate

Add this to package.json in order for css and js rebuild after changes

"scripts": {
  "build": "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds",
  "build:css": "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify"
}
