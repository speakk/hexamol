local Class = require 'libs.hump.class'
local BaseElement = require 'myui.elements.BaseElement'

return Class {
  __includes = BaseElement,
  init = function(self, options)
    BaseElement.init(self, options)

    self.layout = options.layout
    self.backgroundColor = options.backgroundColor
  end,
  update = function(self)
    BaseElement.update(self)
  end
}
