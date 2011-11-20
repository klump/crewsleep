require 'test_helper'

class CcoServiceTest < ActionView::TestCase

  test "fetch_person" do
    puts Crew::CcoService.fetch_person("kolizz")
  end
  
end
