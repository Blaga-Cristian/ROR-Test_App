# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3

pin "react", to: "https://ga.jspm.io/npm:react@18.2.0/index.js"
pin "react-dom", to: "https://ga.jspm.io/npm:react-dom@18.2.0/index.js"
pin "react-dom/client", to: "https://ga.jspm.io/npm:react-dom@18.2.0/client.js"
pin_all_from "app/javascript/components", under: "components", to: "components"
pin "scheduler", to: "https://ga.jspm.io/npm:scheduler@0.23.0/index.js"

pin "dropdown", to: "dropdown.js"
pin "init_react", to: "init_react.js"
