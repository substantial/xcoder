module Xcode
  class BuildCommand
    include Enumerable
    
    def initialize
      @commands = {}
    end
    
    def << (value)
      key, value = value.split(' ')
      @commands[key] = Array(value).join(' ',2)
    end
    
    def to_s
      to_a.join(" ")
    end
    
    def to_a
      @commands.map {|cmd_value| cmd_value.join(" ").strip }
    end
    
    
    # Enumerable Adherence
    
    def each
      to_a.each {|command| yield command }
    end
    
    def <=>(value)
      to_a <=> value
    end
    
  end
end