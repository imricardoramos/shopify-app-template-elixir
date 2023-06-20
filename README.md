## Shopify App Template - Elixir

This is an unofficial template for building a [Shopify app](https://shopify.dev/docs/apps/getting-started) using Phoenix and React. It contains the basics for building a Shopify app.

It attempts to follow Shopify's CLI v3 project structure and conventions. It's also based on the https://github.com/Shopify/shopify-app-template-ruby repo.

## Getting Started

1. Clone this Repo
2. Open the `./setup` script and put the name you wish for your app, otherwise the default name will be `my_app`.
3. Run the `./setup` script. This will rename the app and also remove any existing version control (which is unwanted for a new project)
4. Add `^/auth(/|(\\?.*)?$)": proxyOptions` to your `vite.config.js` file
5. Run `npm run dev` to start the app.
