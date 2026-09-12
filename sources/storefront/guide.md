# Storefront (Local Folder)

Bookmark to the local Rails storefront project at
`/Users/mkechinov/Developer/webdevblog/storefront/storefront`.

## Scope

- Ruby on Rails application: `app/`, `config/`, `db/`, `lib/`, `test/`, `bin/`
- Deployment/config: `Dockerfile`, `.kamal/`, `Procfile.dev`, `Gemfile`
- Also the Craft Agent workspace root — contains `sources/`, `skills/`, `sessions/`,
  `labels/`, `statuses/`, `theme.json`, `config.json`, `views.json`

## Guidelines

- No MCP server is involved. Use the built-in `Read`, `Write`, `Edit`, `Glob`, and `Grep`
  tools with absolute paths under the folder above.
- Skip generated/vendored directories when searching: `tmp/`, `log/`, `node_modules/`,
  `vendor/`, `storage/`, `public/assets/`.
- Workspace-management files (`sessions/`, `labels/`, `statuses/`, `views.json`,
  `events.jsonl`) are Craft Agent state — read them for context, but avoid editing by hand
  unless explicitly asked.
- Git repo on branch `main`; use read-only git commands freely, commit only when asked.

## Examples

- `Glob` `app/**/*.rb` — list application Ruby files
- `Grep` for a route or model name across `app/` and `config/`
- `Read` `config/routes.rb` to understand the URL map
