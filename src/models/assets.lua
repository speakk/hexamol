return Class {
  init = function(self)
    self.cache = {}
  end,
  get = function(self, fileName)
    if not self.cache[fileName] then
      self.cache[fileName] = love.graphics.newImage(fileName)
    end
    return self.cache[fileName]
  end
}
