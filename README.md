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

# Player Area Controls

![image](https://github.com/lord-sugarv2/Gmod-Helpers/assets/62381889/3fa551e0-9950-4f4c-97a0-2c150089eec1)

***
    -- the mainID is used to make the area not duplicate over lua refresh
    local pos1 = Vector(-3293.659912, -2068.002686, 47.968750)
    local pos2 = Vector(-2954.133057, -1164.360474, -195.968750)
    LordsUI:OnEnterArea(pos1, pos2, function(ply, cornerOne, cornerTwo)
        print(ply, "ENTERED THE BANK")
    end, "mainID")
    
    LordsUI:OnExitArea(pos1, pos2, function(ply, cornerOne, cornerTwo)
        print(ply, "LEFT THE BANK")
    end, "mainID")
    
    LordsUI:WhileInArea(pos1, pos2, function(ply, cornerOne, cornerTwo)
        print(ply, "IS IN THE BANK")
    end, "mainID")
    
    LordsUI:WhileNotInArea(pos1, pos2, function(ply, cornerOne, cornerTwo)
        print(ply, "IS NOT IN THE BANK")
    end, "mainID")
***
