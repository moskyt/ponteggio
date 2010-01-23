require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require File.expand_path(File.dirname(__FILE__) + '/data/models')

# Higher level tests.

class SortingScopesTest < ActiveSupport::TestCase
  def setup
    I18n.locale = :en
    reset_db!
    ActiveRecord::Base.locale = nil
  end

  test "sorting is performed correctly for well-defined translations" do
    item1 = Sortable.create
    item2 = Sortable.create
    item3 = Sortable.create
    I18n.locale = :cs
    item1.update_attribute(:title, 'zetko')
    item2.update_attribute(:title, 'tecko')
    item3.update_attribute(:title, 'vecko')
    I18n.locale = :en
    item1.update_attribute(:title, 'alpha')
    item2.update_attribute(:title, 'gamma')
    item3.update_attribute(:title, 'beta')
    
    I18n.locale = :en
    assert_equal [item1, item3, item2], Sortable.ascend_by_title.all
    I18n.locale = :cs
    assert_equal [item2, item3, item1], Sortable.ascend_by_title.all
  end

  test "sorting is performed correctly for partially-defined translations" do
    item1 = Sortable.create
    item2 = Sortable.create
    item3 = Sortable.create
    I18n.locale = :en
    item1.update_attribute(:title, 'alpha')
    item2.update_attribute(:title, 'beta')
    item3.update_attribute(:title, 'gamma')
    I18n.locale = :cs
    item1.update_attribute(:title, 'zetko')
    item2.update_attribute(:title, 'tecko')
    
    I18n.locale = :en
    assert_equal [item1, item2, item3], Sortable.ascend_by_title.all
    I18n.locale = :cs
    assert_equal [item3, item2, item1], Sortable.ascend_by_title.all
  end

end
