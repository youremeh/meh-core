local blockedWords = {
    'desudo','/ooc desudo','fallen#','yo add me fallen','lynx 8','plane#0007',
    'lynxmenu','anti-lynx','www.lynxmenu.com','maestro 1.3 ~ https://discord.gg/dahzn6q',
    'https://discord.gg/dahzn6q','maestro 1.3','https://discord.gg/hkzgrv3','vjuton.pl',
    'vjuton.pl lepszy serwer','alphav','eulen comunnity','you got raped by',
    'player crash attempt','sid official','bombay made by','nigga','n1gga','nigg3r',
    'nig3r','n199er','n1993r','n1gger','n1ga','rena fivem cheat','fivem cheat',
    'https://discord.gg/a4n3sd2','outcast v5.0','ham bear','∑',"^0leaker's menu ~ discord.gg/gjgbqtn",
    'discord.gg/gjgbqtn','the fucking andr','^0hammenu - hello guys!','this server just got fucked by',
    'https://discord.gg/garp','greatamerican roleplay','^13^24^3b^4y^5t^6e ^1c^2o^3m^4m^5u^6n^7i^1t^2y',
    'fallen#0811-mllll','add me fallen#0811','fallen#0811','fallen#0811-bananaparty',
    "lynx 8 ~ www.lynxmenu.com", "you got raped by lynx 8",
    'fallen#0811-fuuck','fallen#0811-crashatt','^1l^2y^3n^4x ^5r^6e^7v^8o^9l^1u^2t^3i^5o^4n',
    'lynxmenu.com - cheats and anti-lynx','vyorex community','lynx 8 vyorex','https://discord.gg/7bm3z5p',
    'obl2 ~b~','https://discord.gg/eurxg46','^8obliviusv2menu','made by luamenufr#0221','luminous ~b~',
    'https://discord.gg/pqwzbdf','by tiagomodz','fuck you server by','by tiago modz','fuck server by',
    'fuck server by tiago modz#5836','by tiago modz#1696','foriv#0002','desudo;',
    'buy at https://discord.gg/hkzgrv3','/ooc 6666 menu!','https://discord.gg/hkzgrv3','www.eulencheats.com',
    'you got raped by eulen comunnity','fendinx community','credit fendinx','https://discord.io/fendinx',
    '^1d^2r^3e^4a ^5m^6m^7e^8n^9u','abodream menu','https://discord.gg/3vr4avs','cheats and anti-lynx',
    'andr[e]a cheats','andr[e]a menu','andr[€]a',"leaker's menu",'discord.gg/gjgbqtn',
    "^1l^2e^3a^4k^5e^6r^7'^8s ^1t^2e^3a^4m","leaker's team","leaker's menu",
    "l^1^2e^3a^4k^5e^6r^7'^8s ^1t^2e^3a^4m ^5discord.gg/gjgbqtn",
    'come buy some ^6fivem cheats','^1https://discord.gg/kgeh8mb','^1lex^2menu','1l^2e^3x ^41^5.^60',
    '^1oh ^2shit ^3some ^4lex ^5customers ^6on ^7the ^8server','^4lex','^1l^2e^3x ^4m^6e^7n^8u',
    '4lex ^5customers ^6on ^7the ^8server','made by plane#0007','by luminous','lynxmenu.com 9.1',
    'yo add me fallen#0811','/tweet yo add me fallen#0811','nigger','scripthook','eulencheats',
    'lua executor','lua injector',
}

AddEventHandler('chatMessage', function(source, name, message)
    local msgLower = string.lower(message)
    for _, blockedWord in ipairs(blockedWords) do
        if string.find(msgLower, blockedWord, 1, true) then
            DropPlayer(source, 'Kicked for using a blocked word.')
            CancelEvent()
            break
        end
    end
end)