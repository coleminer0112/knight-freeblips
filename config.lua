config = {}

--[[
    Perm config
    0 - Default ACE perms. Person needs the configured ACE permission to use the commands.
    1 - Knight Duty. Must be using official knight-duty resource. Allow on-duty players with given department to use the commands.
]]
config.permtype = 0

-- If permtype is set to 0, what perm allows using this resource?
config.aceperm = "staffblips"

-- If permtype is set to 1, what department can use this resource?
config.department = "staff"