Hooks:PostHook(HUDTeammate, "init", "killcounter_hudteammate_init", function(self)
  local kill_counter_name = "kill_counter_" .. self._id
  local main_player = self._id == HUDManager.PLAYER_PANEL

  if main_player then
    if self._panel:child(kill_counter_name) then
      self._panel:remove(self._panel:child(kill_counter_name))
    end

    local name_label = self._panel:child("name")
    local player_panel = self._panel:child("player")

    self._kill_counter = self._panel:panel({
      name = kill_counter_name,
      visible = true,
      w = 64,
      h = name_label:h(),
      x = 0,
      halign = "right"
    })

    self._kill_counter:set_rightbottom(player_panel:right(), name_label:bottom())

    self._kill_icon = self._kill_counter:bitmap({
      layer = 1,
      name = "kill_icon",
      texture = "guis/textures/pd2/risklevel_blackscreen",
      w = 16,
      h = 16,
      y = (self._kill_counter:h() - 16) / 2,
      blend_mode = KillCounter.blend_mode,
      color = Color(KillCounter.color)
    })

    self._kill_text = self._kill_counter:text({
      layer = 1,
      name = "kill_text",
      text = "0/0",
      w = self._kill_counter:w() - 16,
      h = self._kill_counter:h(),
      align = "right",
      vertical = "center",
      color = Color(KillCounter.color),
      font = "fonts/font_medium_mf",
      font_size = 14
    })

    self._kill_text:set_right(self._kill_counter:w() - 2)

    self._kill_counter_bg = self._kill_counter:bitmap({
      layer = 0,
      name = "kill_counter_bg",
      texture = "guis/textures/pd2/hud_tabs",
      texture_rect = { 84, 0, 44, 32 },
      visible = true,
      color = Color.white / 3,
      x = 0,
      y = 0,
      w = self._kill_counter:w(),
      h = self._kill_counter:h()
    })
  end
end)

Hooks:PostHook(HUDTeammate, "set_name", "killcounter_hudteammate_set_name", function(self)
  local main_player = self._id == HUDManager.PLAYER_PANEL

  if main_player then
    local teammate_panel = self._panel
    local name = teammate_panel:child("name")
    local teammate_w = teammate_panel:w()
    local max_w = teammate_w - 72
    local name_w = name:w()

    if name_w > max_w then
      local name_bg = teammate_panel:child("name_bg")

      name:set_w(max_w)
      managers.hud:make_fine_text(name)
      name_bg:set_w(max_w + 4)
    end
  end
end)

function HUDTeammate:update_kill_counter(headshots, total)
  self._kill_text:set_text(headshots .. "/" .. total)
  managers.hud:make_fine_text(self._kill_text)
end
