local component = Concord.component("has_path", function(self, path, finish_path_action)
  self.path = path
  self.finish_path_action = finish_path_action
end)

-- TODO: Perhaps serialize path if it's important
function component.serialize()
  return nil
end

return component
