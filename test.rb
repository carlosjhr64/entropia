def hey
  if block_given?
    puts yield
  end
end

hey{ "Hello!" }
