import Config

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(app.js --bundle --target=es2017 --outdir=../output/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

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
  addition_dirs: ["/pages", "/assets"],
  reload_callback: {JorinMe, :build_all, []}
