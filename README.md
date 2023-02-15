# Gmod-Moveable-Tree
https://www.youtube.com/watch?v=f_ZQGCf_uv8

Looking into turning this into a UI library so if anyone wants to contribute go ahead!


An Example on how you can use this

Code:
local frame = vgui.Create("DFrame")
frame:SetSize(800, 800)
frame:Center()
frame:MakePopup()

local panel = frame:Add("LordsUI:MoveableTree")
panel:Dock(FILL)

for i = 1, 15 do
    local button = vgui.Create("DButton")
    panel:AddItem(button, math.random(30, 80), math.random(30, 80), math.random(-500, 600), math.random(-500, 1000)) 
end
