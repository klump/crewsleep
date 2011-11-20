require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get fetch_person" do
    get :fetch_person
    assert_response :success
  end

  test "should get add_alarm" do
    get :add_alarm
    assert_response :success
  end

  test "should get book_bed" do
    get :book_bed
    assert_response :success
  end

  test "should get finish_alarm" do
    get :finish_alarm
    assert_response :success
  end

end
