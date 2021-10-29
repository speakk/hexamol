return Concord.component("wants_path", function(self, from, to, stop_next_to_target, force_target_available)
  self.from = from
  self.to = to
  self.stop_next_to_target = stop_next_to_target
  self.force_target_available = force_target_available
end)
