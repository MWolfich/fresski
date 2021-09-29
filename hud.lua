local function draw_Icon(x, y, w, h, color, icon)

	surface.SetMaterial(icon)
	surface.SetDrawColor(color)
	surface.DrawTexturedRect(x, y, w, h)

end

local driver_license = Material("fresski/driver-license.png")
local handcuffs = Material("fresski/handcuffs.png")

surface.CreateFont("HUDDefault", {
	font = "Arial", 
	size = 30, 
	weight = 600, 
	antialias = true, 
})

local ply = LocalPlayer()

local elements = {
	['CHudHealth'] = false,
	['CHudBattery'] = false,
	['CHudAmmo'] = false
}


hook.Add('HUDShouldDraw', 'HudHide', function( element )
	return elements[element]
end)

local w,h = ScrW(),ScrH()
local red_col = Color(201, 24, 24,255)
local health_col = Color(0, 255, 102)
local health_bad_col = Color(255, 0, 0)

local armor_col = Color(0, 200, 255)
local armor_bad_col = Color(102, 200, 255)
hook.Add( "HUDPaint", "FREEHUD", function()
	local hp = LocalPlayer():Health()
	local ap = LocalPlayer():Armor()

    draw.RoundedBox(80, 10, h -144, 135, 135, color_white )
    draw.RoundedBox(70, 148, h -87, 250, 4, color_white )
	
    draw.SimpleText( LocalPlayer():Name(), "HUDDefault", 397, h - 122, color_white, 2, 0)
    draw.SimpleText( LocalPlayer():getDarkRPVar( "job" ), "HUDDefault", 151, h - 122, color_white, 0 )


	draw.SimpleText( hp < 40 and "В плохом состояние" or "Здоров", "HUDDefault", 151, h - 76, hp < 40 and health_bad_col or health_col, 0 )
	draw.SimpleText( "Бронежилет", "HUDDefault", 151, h - 39, ap < 40 and armor_col or armor_bad_col )

	surface.SetDrawColor( LocalPlayer():getDarkRPVar("wanted") and red_col or color_white )
	surface.SetMaterial( handcuffs )
	surface.DrawTexturedRect( 355, h -80,39,39 )

	surface.SetDrawColor( LocalPlayer():getDarkRPVar("license") and red_col or color_white )
	surface.SetMaterial( driver_license )
	surface.DrawTexturedRect( 300, h -80,39,39 )
end)


hook.Add( "InitPostEntity", "some_unique_name", function()

	local notificationSound = GAMEMODE.Config.notificationSound
	local function DisplayNotify(msg)
		local txt = msg:ReadString()
		GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
		surface.PlaySound(notificationSound)

		-- Log to client console
		MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
		
	end

	usermessage.Hook("_Notify", DisplayNotify)

	local Avatar = vgui.Create("CircleAvatarImage", panel)
	Avatar:SetSize(135, 135)
	Avatar:SetPos(10, ScrH() - 144)
	Avatar:SetPlayer(LocalPlayer(), 64)
	Avatar:ParentToHUD()
end )