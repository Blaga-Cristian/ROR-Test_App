require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  
  test "full title helper" do
    base_title = "ROR Test App"
    assert_equal base_title, full_title
    assert_equal "Help | #{base_title}", full_title("Help")
  end

end
