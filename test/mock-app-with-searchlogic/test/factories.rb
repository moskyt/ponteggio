Factory.define(:simple_thing) do |f|
  f.sequence(:title) {|n| "simple thing #{n}" }
end