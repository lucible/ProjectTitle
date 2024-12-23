local Font = require("ui/font")
for k, v in pairs(Font.fontmap) do
    if v == "NotoSans-Regular.ttf" then
        Font.fontmap[k] = "source/SourceSans3-Regular.ttf"
    elseif v == "NotoSans-Bold.ttf" then
        Font.fontmap[k] = "source/SourceSans3-Bold.ttf"
    end
end

for k, v in pairs(Font.sizemap) do
    Font.sizemap[k] = Font.sizemap[k] + 1
end
