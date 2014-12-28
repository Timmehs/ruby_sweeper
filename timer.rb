class Timer 
  attr_accessor :time

  def initialize(time = 0) 
    @time = time
  end
  
  def start
    @start = Time.now
  end

  def stop
    stop = Time.new
    @time += (stop - @start)
  end
  
end

t = Timer.new
