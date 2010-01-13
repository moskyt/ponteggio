require 'test_helper'

class SimpleThingsControllerTest < ActionController::TestCase
  
  context "Having the database filled with 100 records, the SimpleThing " do
    
    setup do
      100.times { Factory(:simple_thing) }
    end

    context "index" do
      setup do
        get :index
      end
    
      should_render_template :default
      should_assign_to :simple_things
      should_assign_to :records      
      should "have no pagination" do
        assert_nil assigns(:items_per_page)
      end
      should "render the index table" do
        assert_select "body > table.index-table"
      end
      context "the index table" do
        should "have a header" do
          assert_select "body > table.index-table > thead"
          assert_select "body > table.index-table > thead > tr"
          assert_select "body > table.index-table > thead > tr > th:nth-of-type(1)", :html => '_title'
          assert_select "body > table.index-table > thead > tr > th:nth-of-type(6)", :html => ''
        end
        should "have 100 rows in body" do
          assert_select "body > table.index-table > tbody.index-records"
          assert_select "body > table.index-table > tbody.index-records > tr", :count => 100
        end
      end
    
    end
    
  end
  
end
