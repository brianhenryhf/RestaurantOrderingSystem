require "application_system_test_case"

class RestaurantsTest < ApplicationSystemTestCase
  setup do
    @restaurant = restaurants(:one)
  end

  test "visiting the index" do
    visit restaurants_url
    assert_selector "h1", text: "Restaurants"
  end

  test "should create restaurant" do
    visit restaurants_url
    click_on "New restaurant"

    fill_in "Description", with: @restaurant.description
    fill_in "Name", with: @restaurant.name
    click_on "Create OrderingSystem"

    assert_text "OrderingSystem was successfully created"
    click_on "Back"
  end

  test "should update OrderingSystem" do
    visit restaurant_url(@restaurant)
    click_on "Edit this restaurant", match: :first

    fill_in "Description", with: @restaurant.description
    fill_in "Name", with: @restaurant.name
    click_on "Update OrderingSystem"

    assert_text "OrderingSystem was successfully updated"
    click_on "Back"
  end

  test "should destroy OrderingSystem" do
    visit restaurant_url(@restaurant)
    click_on "Destroy this restaurant", match: :first

    assert_text "OrderingSystem was successfully destroyed"
  end
end
