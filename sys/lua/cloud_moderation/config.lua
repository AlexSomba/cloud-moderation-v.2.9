cloud.colors = {
    red =           "255000000",
    blue =          "000000255",
    gray =          "128128128",
    lime =          "000255000",
    green =         "000128000",
    white =         "255255255",
    spray =         "117216216",
    scarlet =       "255025000",
    magenta =       "255000255",
    lavender =      "230230250",
    mona_lisa =     "255150150",
    dark_cyan =     "000149135",
    neon_blue =     "065105225",
    heliotrope =    "200100255",
    slate_gray =    "112128144",
    olive_drab =    "107142035",
    dodger_blue =   "050150255",
    cotton_candy =  "255200250",
    golden_yellow = "255220000",
    lavender_blue = "200200255",
    electric_blue = "150255255",
    safety_orange = "255105007"
}

cloud.settings = {
    version = "Beta - Patch v3.0",
    credits = {
        "== Credits ==",
        "Alex, (U.S.G.N)#57648 - Moderation script.",
        "EngiN33R Senpai, (U.S.G.N)#7749 - Scripting help.",
        "Rajawali, (U.S.G.N)#156189 - Scripting help.",
        "Dartex, (U.S.G.N)#75351 - Script testing."
    },
    -- Need help? Contact us on discord
    server = "[Cloud]",
    contact = "https://discord.gg/k7jPSV7",
	date = os.date("%d").."-"..os.date("%m").."-"..os.date("%Y"),
	time = os.date("%I:%M %p"),

    -- Local host gets automatically admin rank level
    local_admin = true,
    -- Messages to show each minute
    periodic_msgs = true,

    -- Commands to load --
    -- You can enable other commands here
    -- ex: {"core","freeroam","mixmatch"}
    enabled_command_modules = {"core"},

    -- Modules --
    modules = {
        -- Core modules that should be enabled --
        lastlogged = true,
        -- Access through F2 (Main Menu) --
        unban = true,
        comments = true,
        reports = true,
        logs = true,

        -- Extended scripting modules --
        freeroam = false,
        mixmatch = false
    },

    -- Cloud Buster Modules to load --
	cloud_buster = {
        -- Automatically bans blacklisted players on Join
        ban_blacklisted = true,
		chat_censor = true,
		chat_antispam = true,
        -- Looks up for offensive names and censors them on Join
		names_censor = true,
        -- Dissalow the usage of capital letters
        use_C = true
	},

    -- The prefix for say commands. --
    say_prefix = {
        "!",
        "@"
    },

	-- Censored words (patterns) --
	censored_words = {
		"fuck", "fucking", "fucker", "fuckers",
		"motherfucker", "motherfuckers",
		"fick", "ficker",
		"cum",
		"horney", "horny",
		"dick", "dicks", "dickhead", "dickheads",
		"cock", "cocks", "prick", "pricks", "boner", "boners",
		"cocksucker", "cocksuckers", "wanker", "wankers",
		"gay", "gays", "fag", "fags", "faggot", "faggots",
		"cunt", "cunts", "pussy", "pussies",
		"bitch", "bitches", "slut", "sluts",
		"whore", "whores", "hore", "hores",
		"puta", "putain", "kurwa",
		"asshole", "assholes", "ass", "asses",
		"arse", "arses", "arsehole", "arseholes",
		"anus",
		"shit", "scheisse", "schei�e", "mierda", "bullshit",
		"idiot", "idiots", "bastard", "bastards",
		"retard", "retards",
		"noob", "noobs", "n00b", "n00bs", "nub", "nubs", "nuub", "nuubs",
		"nigger", "niggers", "nigga", "niggas", "niggaz",
		"damn", "stfu"
	},

	-- Censored player names (list of patterns to match). --
	censored_names = {
        "[Ff][Uu][Cc][Kk]",
        "[Nn][Ii][Gg][Gg][Aa]",
        "[Aa][Ss][Ss]"
    },

    -- Periodic message, displayed for everyone every minute at random. --
    periodic_msg = {
        {"Cloud",colors("electric_blue").."discord.gg/xYyM3zQ"..colors("white").." - Bossing around since 2011."},
        {"Premium Members","Do you like the content we do? Become a premium member and support us."},
        {"Commands","Unfamiliar with the server commands?. Say "..colors("electric_blue").."!help <command name> or !help."}
    },

    -- Player Levels Configs --
	users = {
		blacklisted = {
            level = -1,
            name = "blacklisted",
            tag = "[Blacklisted]",
            commands = {},
            tag_color = colors("lavender")
        },

		user = {
            level = 0,
            name = "user",
            tag = "[User]",
            commands = {
                "pm","comment","report","help","credits","register","login","payfee"
            },
            tag_color = colors("lavender_blue")
        },

		premium = {
            level = 1,
            name = "premium",
            tag = "[Premium]",
            commands = {
                "pm","comment","report","help","credits","register","login","payfee"
            },
            tag_color = colors("safety_orange")
        },

		member = {
            level = 2,
            name = "member",
            tag = "[Member]",
            commands = {
                "pm","comment","report","help","credits","register","login","payfee"
            },
            tag_color = colors("neon_blue")
        },

		supporter = {
            level = 3,
            name = "supporter",
            tag = "[Supporter]",
            commands = {
                "pm","comment","report","help","kick","info","credits","register",
                "login","payfee"
            },
            tag_color = colors("magenta")
        },

		moderator = {
            level = 4,
            name = "moderator",
            tag = "[Moderator]",
            commands = {
                "pm","comment","report","help","kick","ban","info","tag","bring",
                "goto","bigears","mute","unmute","slap","kill","strip","speed",
                "equip","restart","teleport","credits","register","login","payfee"
            },
            tag_color = colors("green")
        },

		globalmod = {
            level = 5,
            name = "globalmod",
            tag = "[GM]",
            commands = {
                "pm","comment","report","help","kick","ban","info",
                "tag","god","bring","goto","bigears","mute","unmute","slap",
                "kill","strip","speed","equip","map","restart","teleport",
                "credits","register","login","payfee","prison","unprison"
            },
            tag_color = colors("dark_cyan")
        },

		admin = {
            level = 6,
            name = "admin",
            tag = "[Admin]",
            commands = {
                "pm","comment","report","help","kick","ban","make","info",
                "tag","god","bring","goto","bigears","mute","unmute","slap","kill",
                "strip","speed","equip","map","restart","rcon","reloadlua","teleport",
                "buster","periodic","credits","lastlogged","register","login","grab",
                "payfee","prison","unprison"
            },
            tag_color = colors("scarlet")
        }
	},

    -- Wich variables to save after a player leaves the server? --
    -- For example if you want var_god_toggle to load its last saved state on join
    vars_list = {
        "var_level","var_level_name",
        "var_tag_toggle","var_tag_color",
        "var_god_toggle",
        "var_tele_toggle",
        "var_bigears_toggle",
        "var_mute_toggle","var_mute_duration",
        "var_usgn_password",
        "var_grab_toggle","var_grab_targetID",
        "var_prison","var_prisonfee","var_prisoncrime","var_prison_duration",
        "var_commands"
    }
}

cloud.tags = {
    -- The prefixes for all outputting methods --
    server = colors("mona_lisa").."[SERVER]: "..colors("white"),
    syntax = colors("mona_lisa").."[Correct Syntax]: "..colors("white"),
    error = colors("mona_lisa").."[Error]: "..colors("white"),
    buster = colors("mona_lisa").."[Cloud Buster]: "..colors("white"),
    pm = colors("cotton_candy").."[PM]: "..colors("white"),
    about = colors("mona_lisa").."[ABOUT]: "..colors("white"),
    info = colors("spray").."[INFO]: "..colors("white")
}

cloud.error = {
    -- The prefixes for all outputting commands errors methods --
    authorisation = cloud.tags.error.."You have no authorisation over this administration group!", -- trying to use a command thats higher than your level
    emptystring = cloud.tags.error.."You cannot send an empty string!", -- sending an emtpy string in a command
    highorequal = cloud.tags.error.."This user has a level equal or higher than you!", -- trying to alter other users
    privilege = cloud.tags.error.."You do not have enough privilege to do this!",
    noexist = cloud.tags.error.."The user ID you provided does not exist!",
    noid = cloud.tags.error.."You have not provided a user ID!",
    pm = cloud.tags.error.."You can't send a private message to yourself!",
    disabled = cloud.tags.error.."This command is disabled!",
    notplaying = cloud.tags.error.."This player is currently not playing!"
}

cloud.cloud_buster = {
    -- The prefixes for all outputting cloud buster methods --
    muted = cloud.tags.buster.."You have been muted to prevent spam! You may talk again in",
    capital_letters = cloud.tags.buster.."You are not allowed to use @C!"
}
