/*

Create a cool popup on the players screen
LordsUI:ScreenMessage(player, message, font, seconds, soundURL (optional), background color (optional))

player can be 4 things
-> Entity(1) : The actual player entity to send it to a certain players screen
-> "None" : Idk maybe you just want the code to feel loved
-> "All" : to broadcast the message to everyone
-> "Everyone" : Same as above

*/


LordsUI = LordsUI or {}
if SERVER then
    util.AddNetworkString("LordsUI:ScreenMessage")
    function LordsUI:ScreenMessage(ply, str, font, seconds, soundURL, color)
        if not ply or ply == "None" then return end
        net.Start("LordsUI:ScreenMessage")
        net.WriteString(str)
        net.WriteString(font)
        net.WriteUInt(seconds, 8)
        net.WriteString(soundURL)
        net.WriteBool(color and true or false)
        if color then
            net.WriteColor(color)
        end

        if ply == "All" or ply == "Everyone" then
            net.Broadcast()
        else
            net.Send(ply)
        end
    end
    return
end

net.Receive("LordsUI:ScreenMessage", function()
    local str = net.ReadString()
    local font = net.ReadString()
    local seconds = net.ReadUInt(8) or 3
    local url = net.ReadString()
    local hasColor = net.ReadBool()
    local color = hasColor and net.ReadColor() or Color(255, 100, 100)
    sound.PlayURL(url, "mono", function(s)
        if not IsValid(s) then return end
        s:Play()
    end)

    surface.SetFont(font)
    local w, h = surface.GetTextSize(str)

    local panel = vgui.Create("DPanel")
    panel:SetSize(0, h + 50)
    panel:SizeTo(w + 100, h + 50, .3, 0)
    panel.OnSizeChanged = function(s)
        s:SetPos((ScrW()/2) - (s:GetWide()/2), 50)
    end
    panel.Paint = function(s, w, h)
        draw.RoundedBox(25, 0, 0, w, h, Color(255, 100, 100, 255))
        draw.SimpleText(str, font, w/2, h/2, color_white, 1, 1)
    end
    timer.Simple(seconds-.3, function()
        panel:SizeTo(0, h + 50, .3, 0)
    end)
    timer.Simple(seconds, function()
        panel:Remove()
    end)
end)