module EasyMeli
  USER_AGENT = "EasyMeli-%s" % VERSION
  DEFAULT_HEADERS = {
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'User-Agent' => USER_AGENT
  }
end
