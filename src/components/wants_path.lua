local component = Concord.component("wants_path", function(self, from, to, finish_path_action)
  self.from_key = from
  self.to = to
  self.finish_path_action = finish_path_action
end)

function component.serialize()
  return nil
end

return component
