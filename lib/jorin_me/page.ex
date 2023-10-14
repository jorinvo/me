defmodule JorinMe.Page do
  @moduledoc false

  @enforce_keys [
    :id,
    :type,
    :title,
    :description,
    :body,
    :src_path,
    :html_path,
    :route
  ]

  defstruct [
    :id,
    :type,
    :title,
    :body,
    :description,
    :date,
    :src_path,
    :html_path,
    :route,
    :keywords,
    :archive
  ]

  def build("pages/posts/" <> filename, attrs, body) do
    [year, month, day, id] = String.split(Path.rootname(filename), "-", parts: 4)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    html_path = Path.join(id, "index.html")
    src_path = "pages/posts/#{filename}"
    route = Path.join("/", Path.dirname(html_path))

    unless Map.has_key?(attrs, :keywords) do
      raise "#{src_path} no keywords defined"
    end

    struct!(
      __MODULE__,
      [
        id: id,
        type: :post,
        date: date,
        body: body,
        src_path: src_path,
        html_path: html_path,
        route: route
      ] ++
        Map.to_list(attrs)
    )
  end

  def build(file_path, attrs, body) do
    id = Path.basename(Path.rootname(file_path))
    html_path = Path.join(id, "index.html")
    src_path = file_path
    route = Path.join("/", Path.dirname(html_path))

    struct!(
      __MODULE__,
      [
        id: id,
        type: :page,
        body: body,
        src_path: src_path,
        html_path: html_path,
        route: route,
        date: DateTime.utc_now()
      ] ++
        Map.to_list(attrs)
    )
  end
end
