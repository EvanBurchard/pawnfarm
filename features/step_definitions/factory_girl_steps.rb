Given /^An? "([^\"]*)" exists with the following attributes:$/ do |name, attrs_table|
  attrs = {}
  attrs_table.raw.each do |(attr, value)|
    sanitized_attr = attr.gsub(/\s+/, "-").underscore
    attrs[sanitized_attr.to_sym] = value
  end
  Factory(name, attrs)
end


