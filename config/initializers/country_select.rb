# Return a string to customize the text in the <option> tag, `value` attribute will remain unchanged


CountrySelect::FORMATS[:with_data_attrs] = lambda do |country|
  [
    country.name,
    country.name,
  ]
end