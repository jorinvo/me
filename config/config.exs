import Config

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=app.css
      --output=../output/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :exsync,
  src_monitor: true,
  extra_extensions: [".md", ".js", ".css"],
  addition_dirs: ["/pages", "/assets"]
