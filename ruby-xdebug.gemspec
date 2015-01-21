Gem::Specification.new do |s|
    s.name        = 'ruby-xdebug'
    s.version     = '0.0.1'
    s.date        = '2015-01-21'
    s.summary     = "Ruby Xdebug Client"
    s.description = "Xdebug client written in Ruby"
    s.authors     = ["Janaka Wickramasinghe"]
    s.email       = 'janakawicks@gmail.com'
    s.files       = `git ls-files bin lib *.md LICENSE`.split("\n") 
    s.executables = ["ruby-xdebug"]
    s.homepage    = 'https://github.com/janakawicks/ruby-xdebug'
    s.license       = 'AGPL V3.0'
end
