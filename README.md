# Gmod-Moveable-Tree

https://user-images.githubusercontent.com/62381889/219128444-9987456a-6f2d-475a-be4f-0d67cb05f3a4.mp4


Looking into turning this into a UI library so if anyone wants to contribute go ahead!


An Example on how you can use this

***
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
***
