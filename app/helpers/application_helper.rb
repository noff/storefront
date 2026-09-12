module ApplicationHelper
  PLACEHOLDER_COLOR = /\A#\h{3,8}\z/

  # Плейсхолдер-картинка без внешних запросов: inline SVG в виде data-URI.
  # Цвета валидируются, а не экранируются: в SVG они попадают в атрибут,
  # и единственное осмысленное значение здесь — hex-цвет.
  def placeholder_image(text, width: 600, height: 400, background: "#e9ecef", color: "#6c757d")
    width = width.to_i
    height = height.to_i
    background = PLACEHOLDER_COLOR.match?(background.to_s) ? background : "#e9ecef"
    color = PLACEHOLDER_COLOR.match?(color.to_s) ? color : "#6c757d"
    label = text.to_s.truncate(24)
    # Подгоняем кегль под длину подписи, чтобы длинные названия не вылезали за viewBox.
    font_size = [ [ width / (0.62 * [ label.length, 1 ].max), height / 10.0 ].min.round, 12 ].max

    # Без отступов и переносов: каждый байт здесь едет инлайном в HTML.
    svg = %(<svg xmlns="http://www.w3.org/2000/svg" width="#{width}" height="#{height}" ) +
          %(viewBox="0 0 #{width} #{height}"><rect width="100%" height="100%" fill="#{background}"/>) +
          %(<text x="50%" y="50%" fill="#{color}" font-family="system-ui,sans-serif" font-size="#{font_size}" ) +
          %(text-anchor="middle" dominant-baseline="middle">#{ERB::Util.html_escape(label)}</text></svg>)

    "data:image/svg+xml,#{ERB::Util.url_encode(svg)}"
  end

  # Звёзды рейтинга с текстовой альтернативой для скринридеров.
  def rating_stars(rating)
    value = rating.to_f.round
    stars = safe_join(1.upto(5).map do |i|
      tag.i(class: "bi #{i <= value ? 'bi-star-fill' : 'bi-star'}", aria: { hidden: true })
    end)

    tag.span(stars, class: "text-warning", role: "img",
             aria: { label: "Рейтинг #{value} из 5" })
  end

  # ?q[]=x и ?q[a]=b дают Array/Parameters — в поле и в будущий SQL это пускать нельзя.
  def search_query
    params[:q] if params[:q].is_a?(String)
  end

  # Корневые категории для навигации в шапке и подвале.
  # Запрос один на рендер, limit режет уже загруженный список —
  # иначе мемоизация отдала бы второму вызову чужое количество.
  NAV_CATEGORIES_LIMIT = 9

  def nav_categories(limit: NAV_CATEGORIES_LIMIT)
    @nav_categories ||= Category.roots.order(:name).limit(NAV_CATEGORIES_LIMIT).to_a
    @nav_categories.first(limit)
  end

  def price(value)
    number_to_currency(value, unit: "₽", format: "%n %u", precision: 0, delimiter: " ")
  end
end
