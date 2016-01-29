Hooks:PostHook(HUDTeammate, "init", "killcounter_hudteammate_init", function(self)
  local kill_counter_panel_name = "kill_counter_panel"
  local main_player = self._id == HUDManager.PLAYER_PANEL
  local deployable_equipment_panel = self._player_panel:child("deployable_equipment_panel")
  local cable_ties_panel = self._player_panel:child("cable_ties_panel")
  local grenades_panel = self._player_panel:child("grenades_panel")


  if main_player then
    if self._panel:child(kill_counter_panel_name) then
      self._panel:remove(self._panel:child(kill_counter_panel_name))
    end

    local name = self._panel:child("name")
    local player = self._panel:child("player")
    local equipment = deployable_equipment_panel:child("equipment")
    local cable_ties = cable_ties_panel:child("cable_ties")
    local grenades = grenades_panel:child("grenades")

    equipment:set_x(equipment:x() + 4)
    cable_ties:set_x(cable_ties:x() + 4)
    grenades:set_x(grenades:x() + 4)

    self._kill_counter_panel = self._panel:panel({
      name = kill_counter_panel_name,
      visible = true,
      w = 64,
      h = name:h(),
      x = 0,
      halign = "right"
    })

    self._kill_counter_panel:set_rightbottom(player:right(), name:bottom())

    self._kill_icon = self._kill_counter_panel:bitmap({
      layer = 1,
      name = "kill_icon",
      texture = "guis/textures/pd2/risklevel_blackscreen",
      w = 16,
      h = 16,
      y = (self._kill_counter_panel:h() - 16) / 2,
      blend_mode = KillCounter.blend_mode,
      color = Color(KillCounter.color)
    })

    self._kill_text = self._kill_counter_panel:text({
      layer = 1,
      name = "kill_text",
      text = "0/0",
      w = self._kill_counter_panel:w() - 20,
      h = self._kill_counter_panel:h(),
      align = "right",
      vertical = "center",
      color = Color(KillCounter.color),
      font = "fonts/font_medium_mf",
      font_size = 14
    })

    self._kill_text:set_right(self._kill_counter_panel:w() - 4)

    self._kill_counter_bg = self._kill_counter_panel:bitmap({
      layer = 0,
      name = "kill_counter_bg",
      texture = "guis/textures/pd2/hud_tabs",
      texture_rect = { 84, 0, 44, 32 },
      visible = true,
      color = Color.white / 3,
      x = 0,
      y = 0,
      w = self._kill_counter_panel:w(),
      h = self._kill_counter_panel:h()
    })
  else
    local equipment_amount = deployable_equipment_panel:child("amount")
    local cable_ties_amount = cable_ties_panel:child("amount")
    local grenades_amount = grenades_panel:child("amount")

    equipment_amount:set_vertical("top")
    cable_ties_amount:set_vertical("top")
    grenades_amount:set_vertical("top")
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
end