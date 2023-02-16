local mat = Material("icon16/arrow_refresh.png")
local PANEL = {}
AccessorFunc(PANEL, "RowSize", "RowSize", FORCE_NUMBER)
AccessorFunc(PANEL, "MinScale", "MinScale", FORCE_NUMBER)
AccessorFunc(PANEL, "MaxScale", "MaxScale", FORCE_NUMBER)
AccessorFunc(PANEL, "BackgroundColor", "BackgroundColor", FORCE_COLOR)
function PANEL:Init()
    self.Scale = 1
    self:SetRowSize(100)
    self:SetMinScale(0.1)
    self:SetMaxScale(3)
    self:SetBackgroundColor(Color(30, 30, 30))

    self.Panels = {}
    self.ScaleBar = self:Add("DNumSlider")
    self.ScaleBar:SetSize(150, 20)
    self.ScaleBar.Label:Hide()
    self.ScaleBar.TextArea:SetWide(30)
    self.ScaleBar:SetMinMax(self.MinScale, self.MaxScale)
    self.ScaleBar:SetValue(self:GetScale())
    self.ScaleBar.OnValueChanged = function(s, val)
        self:SetScale(val)
    end

    self.ResetButton = self:Add("DButton")
    self.ResetButton:SetPos(155, 2)
    self.ResetButton:SetSize(20, 20)
    self.ResetButton:SetText("")
    self.ResetButton.Paint = function(s, w, h)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(2, 2, w-4, h-2)
    end
    self.ResetButton.DoClick = function()
        surface.PlaySound("buttons/button15.wav")
        self.Diff = Vector(0, 0)
        self.ShouldDrag = false
        self:SetScale(1)
        self:UpdatePanels()
    end
end

function PANEL:SetScale(scale)
    self.Scale = scale
    self.ScaleBar:SetValue(scale)
    self:UpdatePanels()
end

function PANEL:GetScale()
    return self.Scale
end

function PANEL:AddItem(panel, w, h, x, y)
    w = w or 50
    h = h or 50
    x = x or 0
    y = y or 0

    panel:SetParent(self) -- just for safety yk yk
    panel.TreeData = {w = w, h = h, x = x, y = y}
    table.insert(self.Panels, panel)
end

function PANEL:UpdatePanels()
    self:InvalidateLayout(true)
end

function PANEL:PerformLayout(w, h)
    self.Diff = self.Diff or Vector(w, h) *.5

    local scale = self:GetScale()
    for k, panel in ipairs(self.Panels) do
        local data = panel.TreeData
        local scaledW, scaledH = (data.w*scale), (data.h*scale)
        panel:SetSize(scaledW, scaledH)

        local x, y = (data.x*scale) + self.Diff.x, (data.y*scale) + self.Diff.y
        panel:SetPos(x, y)
    end
end

function PANEL:UpdateZoom(amount, stopUpdate)
    self:SetScale(math.Clamp(self:GetScale() + amount, self.MinScale, self.MaxScale))

    if stopUpdate then return end
    self:UpdatePanels()
end

function PANEL:OnMousePressed(key)
    if key == MOUSE_LEFT then
        self.DragPos = Vector(gui.MouseX(), gui.MouseY())
        self.ShouldDrag = true
    end
end

function PANEL:OnMouseReleased(key)
    if key == MOUSE_LEFT then
        self.ShouldDrag = false
    end
end

function PANEL:Think()
    if self.ShouldDrag and input.IsMouseDown(MOUSE_LEFT) then
        local newpos = Vector(gui.MouseX(), gui.MouseY())
        self.Diff = self.Diff + (newpos - self.DragPos)
        self.DragPos = newpos
        self:UpdatePanels()
    end
end

function PANEL:OnMouseWheeled(delta)
    delta = delta * 0.1

    self:UpdateZoom(delta, true)
    if self:GetScale() == self.MinScale or self:GetScale() == self.MaxScale then return end

    local x, y = self:LocalCursorPos()
    self.Diff = self.Diff + Vector(self.Diff.x - x, self.Diff.y - y) * delta
    self:UpdatePanels()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(self:GetBackgroundColor())
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("LordsUI:MoveableTree", PANEL, "EditablePanel")

if IsValid(frame) then frame:Remove() end
frame = vgui.Create("DFrame")
frame:SetSize(800, 800)
frame:Center()
frame:MakePopup()

local panel = frame:Add("LordsUI:MoveableTree")
panel:Dock(FILL)

for i = 1, 15 do
    local button = vgui.Create("DButton")
    panel:AddItem(button, math.random(30, 80), math.random(30, 80), math.random(-500, 600), math.random(-500, 1000)) 
end