require 'test_helper'

class ServiceTest < ActionView::TestCase

  test "fetch_person" do
    puts Cco::Service.fetch_person("kolizz")
  end
  
end
