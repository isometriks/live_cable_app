class HelloWorld < Live::Component
  reactive :counter, 0
  reactive :gender, nil
  reactive :name, nil
  reactive :total, 0, shared: true

  def increment
    self.counter = counter + 1
    self.total = total + 1
  end
end
