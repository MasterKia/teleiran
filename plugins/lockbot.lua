
local function isBotAllowed (userId, channelId)
  local hash = 'anti-bot:allowed:'..channelId..':'..userId
  local banned = redis:get(hash)
  return banned
end

local function allowBot (userId, channelId)
  local hash = 'anti-bot:allowed:'..channelId..':'..userId
  redis:set(hash, true)
end

local function disallowBot (userId, channelId)
  local hash = 'anti-bot:allowed:'..channelId..':'..userId
  redis:del(hash)
end

-- Is anti-bot enabled on channel
local function isAntiBotEnabled (channelId)
  local hash = 'anti-bot:enabled:'..channelId
  local enabled = redis:get(hash)
  return enabled
end

local function enableAntiBot (channelId)
  local hash = 'anti-bot:enabled:'..channelId
  redis:set(hash, true)
end

local function disableAntiBot (channelId)
  local hash = 'anti-bot:enabled:'..channelId
  redis:del(hash)
end

local function isABot (user)
  -- Flag its a bot 0001000000000000
  local binFlagIsBot = 4096
  local result = bit32.band(user.flags, binFlagIsBot)
  return result == binFlagIsBot
end

local function isABotBadWay (user)
  local username = user.username or ''
  return username:match("[Bb]ot$")
end

local function kickUser(userId, channelId)
  local channel = 'channel#id'..channelId
  local user = 'user#id'..userId
  channel_del_user(channel, user, function (data, success, result)
    if success ~= 1 then
      print('I can\'t kick '..data.user..' but should be kicked')
    end
  end, {channel=channel, user=user})
end

local function run (msg, matches)

  -- We wont return text if is a service msg
  if matches[1] ~= 'channel_add_user' and matches[1] ~= 'channel_add_user_link' then
    if msg.to.type ~= 'channel' and msg.to.type ~= 'channel' then
      return 'Lock Bot Is Open On Channel'
    end
  end

  local channelId = msg.to.id
  if matches[1] == 'lock' then
    enableAntiBot(channelId)
    return 'Lock Bot Is Install'
  end
  if matches[1] == 'unlock' then
    disableAntiBot(channelId)
    return 'Lock Bot Is UnInstall'
  end
  if matches[1] == 'open' then
    local userId = matches[2]
    allowBot(userId, channelId)
    return 'Bot '..userId..' Allowed'
  end
  if matches[1] == 'close' then
    local userId = matches[2]
    disallowBot(userId, channelId)
    return 'Bot '..userId..' DisAllowed'
  end
  if matches[1] == 'channel_add_user' or matches[1] == 'channel_add_user_link' then
    local user = msg.action.user or msg.from
    if isABotBadWay(user) then
      print('It Is Bot')
      if isAntiBotEnabled(channelId) then
        print('Lock Bot Is Install')
        local userId = user.id
        if not isBotAllowed(userId, channelId) then
          kickUser("user#id"..userId, "channel#id"..channelId)
         --channel_del_user(userId, channelId)
          channel_kick_user("channel#id"..msg.to.id, 'user#id'..userId, ok_cb, false)
          return "Bot Is DisAllowed"
        else
          print('This Bot Is Allowed')
        end
      end
    end
  end
end

return {
  description = 'When bot enters group kick it.',
  usage = {
    '!antibot enable: Enable Anti-bot on current channel',
    '!antibot disable: Disable Anti-bot on current channel',
    '!antibot allow <botId>: Allow <botId> on this channel',
    '!antibot disallow <botId>: Disallow <botId> on this channel'
  },
  patterns = {
    '^[#!/](open) [Bb][Oo][Tt] (%d+)$',
    '^[#!/](close) [Bb][Oo][Tt] (%d+)$',
    '^[#!/](lock) [Bb][Oo][Tt]$',
    '^[#!/](unlock) [Bb][Oo][Tt]$',
    '^!!tgservice (channel_add_user)$',
    '^!!tgservice (channel_add_user_link)$'
  },
  run = run
}
