require "test_helper"

class FeedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    get feed_url
    @doc = Nokogiri::XML(response.body) { |config| config.strict }
  end

  test "responds with xml" do
    assert_response :success
    assert_equal "application/xml; charset=utf-8", response.headers["Content-Type"]
  end

  test "root is yml_catalog with a date attribute" do
    assert_equal "yml_catalog", @doc.root.name
    assert_match(/\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}\z/, @doc.root["date"])
  end

  test "shop header points at the current host" do
    assert_equal "http://www.example.com", @doc.at_xpath("//shop/url").text
    assert_equal "RUB", @doc.at_xpath("//currencies/currency")["id"]
    assert @doc.at_xpath("//shop/name").text.present?
    assert @doc.at_xpath("//shop/company").text.present?
  end

  test "shop declares every city in the locations directory" do
    locations = @doc.xpath("//shop/locations/location")

    assert_equal City::ALL.map(&:code), locations.map { |l| l["id"] }
    assert_equal City::ALL.map(&:name), locations.map { |l| l["name"] }
    assert_equal [ "city" ] * City::ALL.size, locations.map { |l| l["type"] }
  end

  test "offer locations reference ids from the shop directory" do
    declared = @doc.xpath("//shop/locations/location").map { |l| l["id"] }
    used = offer_for(products(:air_max)).xpath("locations/location").map { |l| l["id"] }

    assert_equal declared.sort, used.sort
  end

  test "categories use ext_id and link inside the storefront" do
    running = @doc.at_xpath("//categories/category[@id='running']")

    assert_equal "Кроссовки", running.text
    assert_equal "shoes", running["parentId"]
    assert_equal "http://www.example.com/categories/running", running["url"]
  end

  test "root category has no parentId" do
    assert_nil @doc.at_xpath("//categories/category[@id='shoes']")["parentId"]
  end

  test "offer url points at the internal product page, not the source url" do
    offer = offer_for(products(:air_max))

    assert_equal "http://www.example.com/products/air-max-pro",
                 offer.at_xpath("url").text
    assert_not_equal products(:air_max).url, offer.at_xpath("url").text
  end

  test "offer carries prices, category and rounded rating" do
    product = products(:air_max)
    offer = offer_for(product)

    assert_equal "true", offer["available"]
    assert_equal "18900", offer.at_xpath("price").text
    assert_equal "22900", offer.at_xpath("oldprice").text
    assert_equal "17", offer.at_xpath("discount_percent").text
    assert_equal "running", offer.at_xpath("categoryId").text
    assert_equal "ShopCo", offer.at_xpath("vendor").text
    assert_equal product.picture, offer.at_xpath("picture").text
    assert_equal "5", offer.at_xpath("rating").text
  end

  test "params keep their feed order" do
    offer = offer_for(products(:air_max))

    assert_equal [ "Цвет", "Размер" ], offer.xpath("param").map { |p| p["name"] }
    assert_equal [ "Чёрный", "US 10" ], offer.xpath("param").map(&:text)
  end

  test "locations list every city with the offer price" do
    offer = offer_for(products(:air_max))
    locations = offer.xpath("locations/location")

    assert_equal City::ALL.map(&:code), locations.map { |l| l["id"] }
    assert_equal [ "18900", "18900" ], locations.map { |l| l.at_xpath("price").text }
    assert_equal [ "22900", "22900" ], locations.map { |l| l.at_xpath("oldprice").text }
  end

  test "offer without category, rating or params is still valid" do
    offer = offer_for(products(:sold_out))

    assert_equal "false", offer["available"]
    assert_nil offer.at_xpath("categoryId")
    assert_nil offer.at_xpath("rating")
    assert_nil offer.at_xpath("oldprice")
    assert_empty offer.xpath("param")
    assert_equal City::ALL.size, offer.xpath("locations/location").size
  end

  test "products without a price are skipped" do
    Product.create!(ext_id: "no-price", name: "Без цены", available: true)
    get feed_url

    assert_nil Nokogiri::XML(response.body).at_xpath("//offer[@id='no-price']")
  end

  test "base url can be overridden for production behind a proxy" do
    ENV["FEED_BASE_URL"] = "https://storefront.mkechinov.ru"
    get feed_url
    doc = Nokogiri::XML(response.body)

    assert_equal "https://storefront.mkechinov.ru", doc.at_xpath("//shop/url").text
    assert_equal "https://storefront.mkechinov.ru/products/air-max-pro",
                 doc.at_xpath("//offer[@id='air-max-pro']/url").text
  ensure
    ENV.delete("FEED_BASE_URL")
  end

  private

  def offer_for(product)
    @doc.at_xpath("//offers/offer[@id='#{product.ext_id}']")
  end
end
