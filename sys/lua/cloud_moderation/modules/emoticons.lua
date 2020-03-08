emoticons = {}
emoticons.player = {}
emoticons.setting = {}

-- The alpha (transparency) of the image on creation. Lower the value to make the emoticon and bubble less visible (range 0 - 1)
emoticons.setting.alpha = 0.6

-- The duration of how long the emoticon is visible until it starts to fade out
emoticons.setting.duration = 2

-- The fadeout alpha. A value of 0.1 would fade the image out after the duration by 0.1 every 100 milliseconds
emoticons.setting.fadeout = 0.1

-- Emoticon directory path
emoticons.setting.path = "gfx/cloud/lua/emoticons/"

-- Emoticon list
emoticons.setting.list = {
    ["^[:=8][-^o]?[)%]3>]$"] = "smiling", -- :)
    ["^%^[_]?%^$"] = "smiling", -- ^_^
    ["^[:=8][-^o]?[D]$"] = "smiling_big", -- :D
    ["^[:=8][-^o]?[(%[]$"] = "frowning", -- :(
    ["^[;][-^o]?[)%]D]$"] = "winking", -- ;)
    ["^[xX][-^o]?[D]+$"] = "laughing", -- xD
    ["^[lL1][oO��0]+[lL1]+[sSzZ]*%??$"] = "laughing", -- lol
    ["^[hH][aAeEoO��][hH][aAeEoO��]$"] = "laughing", -- hehe
    ["^[rR][oO��0]+[fF][lL1]+$"] = "laughing", -- rofl
    ["^[:=8xX][-^o]?[pPbq]$"] = "cheeky", -- :P
    ["^[:=8xX]['][-^o]?%($"] = "crying", -- :'(
    ["^[;][-]?%($"] = "crying", -- ;(
    ["^D[-^o]?[:=8xX]$"] = "crying", -- Dx
    ["^T[_.-]?T$"] = "crying", -- T_T
    ["^[:=8][-^o]?[oO0]$"] = "surprised", -- :O
    ["^[oO0][_.-]?[oO0]$"] = "surprised", -- O_o
    ["^[oO0][mM][gG]$"] = "surprised", -- omg
    ["^[:=8][-^o]?[/\\]$"] = "skeptical", -- :/
    ["^[:=8][-^o]?[sS]$"] = "uneasy", -- :S
    ["^>[:=8;][-^o]?[)%]D]$"] = "evil", -- >:D
    ["^>[_.-]<$"] = "angry", -- >_<
    ["^>[:=8;][-^o]?[(%[]$"] = "angry", -- >:(
    ["^<3$"] = "heart" -- <3
}

function emoticons.displayEmoticon(id, emoticon)
	if player(id, "health") > 0 then
		if emoticons.player[id].chat then
			freeimage(emoticons.player[id].emote)
			freeimage(emoticons.player[id].bubble)

			emoticons.player[id].emote = nil
			emoticons.player[id].bubble = nil
		end

		emoticons.player[id].bubble = image(emoticons.setting.path.."speechbubble.png", 0, 0, 132 + id)
		emoticons.player[id].emote = image(emoticons.setting.path..emoticon..".png", 0, 0, 132 + id)

		imagealpha(emoticons.player[id].bubble, emoticons.setting.alpha)
		imagealpha(emoticons.player[id].emote, emoticons.setting.alpha)

		emoticons.player[id].time = os.time()
		emoticons.player[id].alpha = emoticons.setting.alpha

		emoticons.player[id].chat = true
	end
end

function emoticons.join(id)
    emoticons.player[id] = {}
    emoticons.player[id].chat = false
end
addhook("join","emoticons.join",-999999)

function emoticons.leave(id)
    if emoticons.player[id].chat then
        freeimage(emoticons.player[id].emote)
        freeimage(emoticons.player[id].bubble)

        emoticons.player[id].emote = nil
        emoticons.player[id].bubble = nil
    end
end
addhook("leave","emoticons.leave",-999999)

function emoticons.say(id, text)
    for word in string.gmatch(text, "[^%s]+") do
        for smiley, emoticon in pairs(emoticons.setting.list) do
            if word:match(smiley) then
                emoticons.displayEmoticon(id, emoticon)
                return
            end
        end
    end
    if not emoticons.player.chat then
        emoticons.displayEmoticon(id, "chat")
    end
end
addhook("say","emoticons.say",-999999)

function emoticons.ms100()
    for _, id in pairs(player(0, "table")) do
        if emoticons.player[id] and emoticons.player[id].chat then
            local time = os.difftime(os.time(), emoticons.player[id].time)

            if time > emoticons.setting.duration then
                emoticons.player[id].alpha = emoticons.player[id].alpha - emoticons.setting.fadeout
                if emoticons.player[id].alpha <= 0 then
                    if emoticons.player[id].alpha then
                        freeimage(emoticons.player[id].emote)
                        freeimage(emoticons.player[id].bubble)

                        emoticons.player[id].emote = nil
                        emoticons.player[id].bubble = nil

                        emoticons.player[id].chat = false
                    end
                else
                    imagealpha(emoticons.player[id].emote, emoticons.player[id].alpha)
                    imagealpha(emoticons.player[id].bubble, emoticons.player[id].alpha)
                end
            end
        end
    end
end
addhook("ms100","emoticons.ms100",-999999)
