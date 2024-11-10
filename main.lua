--A SgtBlackDeer's mod--

local DevilDaggers = RegisterMod("Devil Daggers", 1);
local Devil = Isaac.GetPlayerTypeByName("Devil", false);
local TaintedDevil = Isaac.GetPlayerTypeByName("Tainted Devil", true);
local ddbody = Isaac.GetCostumeIdByPath("gfx/characters/costume_body_devil.anm2");
local ddbodyblue = Isaac.GetCostumeIdByPath("gfx/characters/costume_body_devil_blue.anm2");
local dd = Isaac.GetCostumeIdByPath("gfx/characters/costume_devil.anm2");
local ddblue = Isaac.GetCostumeIdByPath("gfx/characters/costume_devil_blue.anm2");
local tddbody = Isaac.GetCostumeIdByPath("gfx/characters/costume_body_tainted_devil.anm2");
local tddbodyblue = Isaac.GetCostumeIdByPath("gfx/characters/costume_body_tainted_devil_blue.anm2");
local tdd = Isaac.GetCostumeIdByPath("gfx/characters/costume_tainted_devil.anm2");
local tddblue = Isaac.GetCostumeIdByPath("gfx/characters/costume_tainted_devil_blue.anm2");
local COLLECTIBLE_THE_DAGGER = Isaac.GetItemIdByName("The Dagger");
local COLLECTIBLE_THE_POWER = Isaac.GetItemIdByName("The Power");
local CHALLENGE_DEVIL_DAGGERS = Isaac.GetChallengeIdByName("Devil Daggers");
local HudPickups = Sprite();
HudPickups:Load("gfx/ui/hudpickups.anm2", true);
local HudNumbers = Sprite();
HudNumbers:Load("gfx/ui/hudnumbers.anm2",true);
local Sound = SFXManager();
local SpawnPos1 = nil;
local SpawnPos2 = nil;
local SpawnPos3 = nil;
local spiderlingpos = nil;
local appearNO = Vector(170,220);
local appearNE = Vector(870,220);
local appearSO = Vector(170,660);
local appearSE = Vector(920,660);
local VARIANT_CHANCE = 50;
local MUTED_CHANCE = 20;
local ULTRA_CHANCE = 10;
local centerroom = Vector(580,390);
local scaled = false;
local upgraded = false;
local ascended = false;
local timespid = 0;
local timesquid1 = 690;
local timesquid2 = 690;
local timesquid3 = 690;
local timelev = 300;
local timeorb = 75;
local spacing = 17;
local wavesbegin = 0;
local start = 0;
local giorgh = 0;
local tablepos = { appearNO, appearNE, appearSO, appearSE };
local randompos = tablepos[math.random(1, #tablepos)];
local tableposthorn = { Vector(350,320), Vector(770,290), Vector(290,520), Vector(720,520) };

PickupVariant.GEMS = Isaac.GetEntityVariantByName("Gems");

SoundEffect.GettingGems = Isaac.GetSoundIdByName("getgems");
SoundEffect.GettingGemsPlus = Isaac.GetSoundIdByName("getgemsplus");
SoundEffect.Dies = Isaac.GetSoundIdByName("isdead");
SoundEffect.Debut = Isaac.GetSoundIdByName("debut");
SoundEffect.Shot = Isaac.GetSoundIdByName("shot");
SoundEffect.ShotPlus = Isaac.GetSoundIdByName("shotplus");
SoundEffect.Firing = Isaac.GetSoundIdByName("5fire");
SoundEffect.FiringPlus = Isaac.GetSoundIdByName("35fire");
SoundEffect.FiringPlusPlus = Isaac.GetSoundIdByName("75fire");
SoundEffect.levelup = Isaac.GetSoundIdByName("5levelup");
SoundEffect.levelupplus = Isaac.GetSoundIdByName("35levelup");
SoundEffect.levelupplusplus = Isaac.GetSoundIdByName("75levelup");
SoundEffect.idleskulli = Isaac.GetSoundIdByName("idleskull1");
SoundEffect.idleskullii = Isaac.GetSoundIdByName("idleskull2");
SoundEffect.idleskulliii = Isaac.GetSoundIdByName("idleskull3");
SoundEffect.idleskulliv = Isaac.GetSoundIdByName("idleskull4");
SoundEffect.idleskullimuted = Isaac.GetSoundIdByName("idleskull1muted");
SoundEffect.idleskulliimuted = Isaac.GetSoundIdByName("idleskull2muted");
SoundEffect.idleskulliiimuted = Isaac.GetSoundIdByName("idleskull3muted");
SoundEffect.idleskullivmuted = Isaac.GetSoundIdByName("idleskull4muted");
SoundEffect.spawnsquidi = Isaac.GetSoundIdByName("spawnsquid1");
SoundEffect.spawnsquidii = Isaac.GetSoundIdByName("spawnsquid2");
SoundEffect.spawnsquidiii = Isaac.GetSoundIdByName("spawnsquid3");
SoundEffect.idlesquidi = Isaac.GetSoundIdByName("idlesquid1");
SoundEffect.idlesquidii = Isaac.GetSoundIdByName("idlesquid2");
SoundEffect.idlesquidiii = Isaac.GetSoundIdByName("idlesquid3");
SoundEffect.wave1 = Isaac.GetSoundIdByName("spawnwave1");
SoundEffect.wave2 = Isaac.GetSoundIdByName("spawnwave2");
SoundEffect.wave3 = Isaac.GetSoundIdByName("spawnwave3");
SoundEffect.spawnegg = Isaac.GetSoundIdByName("spawnegg");
SoundEffect.spawnspideri = Isaac.GetSoundIdByName("spawnspider1");
SoundEffect.spawnspiderii = Isaac.GetSoundIdByName("spawnspider2");
SoundEffect.idlespideri = Isaac.GetSoundIdByName("idlespider1");
SoundEffect.idlespiderii = Isaac.GetSoundIdByName("idlespider2");
SoundEffect.eat1 = Isaac.GetSoundIdByName("eating1");
SoundEffect.eat2 = Isaac.GetSoundIdByName("eating2");
SoundEffect.idlecenti = Isaac.GetSoundIdByName("idlecenti");
SoundEffect.idlegiga = Isaac.GetSoundIdByName("idlegiga");
SoundEffect.idleghost = Isaac.GetSoundIdByName("idleghost");
SoundEffect.idlelev = Isaac.GetSoundIdByName("idlelev");
SoundEffect.spawnlev = Isaac.GetSoundIdByName("spawnlev");
SoundEffect.levmuted = Isaac.GetSoundIdByName("levmuted");
SoundEffect.levbeckon = Isaac.GetSoundIdByName("levbeckon");
SoundEffect.levkill = Isaac.GetSoundIdByName("levkill");


GEMS = {
    SUBTYPE_GEMS = 1
}

local Enemies = {
    ENTITY_SQUID = Isaac.GetEntityTypeByName("Squids"),
    ENTITY_SPIDER = Isaac.GetEntityTypeByName("Spiders"),
    ENTITY_EGG = Isaac.GetEntityTypeByName("Eggs"),
    ENTITY_LEVIATHAN = Isaac.GetEntityTypeByName("Leviathan")
}

local EnemyVariant = {
    EGGI = Isaac.GetEntityVariantByName("Egg I"),
    EGGII = Isaac.GetEntityVariantByName("Egg II"),
    SPIDERLING = Isaac.GetEntityVariantByName("Spiderling"),
    SQUIDI = Isaac.GetEntityVariantByName("Squid I"),
    SQUIDII = Isaac.GetEntityVariantByName("Squid II"),
    SQUIDIII = Isaac.GetEntityVariantByName("Squid III"),
    SPIDERI = Isaac.GetEntityVariantByName("Spider I"),
    SPIDERII = Isaac.GetEntityVariantByName("Spider II"),
    THORN = Isaac.GetEntityVariantByName("Thorn"),
    SKULLI = Isaac.GetEntityVariantByName("Skull I"),
    SKULLII = Isaac.GetEntityVariantByName("Skull II"),
    SKULLIII = Isaac.GetEntityVariantByName("Skull III"),
    SKULLIV = Isaac.GetEntityVariantByName("Skull IV"),
    SKULLItransmuted = Isaac.GetEntityVariantByName("Skull I muted"),
    SKULLIItransmuted = Isaac.GetEntityVariantByName("Skull II muted"),
    SKULLIIItransmuted = Isaac.GetEntityVariantByName("Skull III muted"),
    SKULLIVtransmuted = Isaac.GetEntityVariantByName("Skull IV muted"),
    CENTIPEDE = Isaac.GetEntityVariantByName("Centipede"),
    GIGAPEDE = Isaac.GetEntityVariantByName("Gigapede"),
    GHOSTPEDE = Isaac.GetEntityVariantByName("Ghostpede"),
    LEVIATHAN = Isaac.GetEntityVariantByName("Leviathan"),
    THEORB = Isaac.GetEntityVariantByName("The Orb")
}

local TearFlagsLocal = {
    FLAG_HOMING = 1<<2,
    FLAG_PERSISTENT = 1<<9,
    FLAG_SPLIT = 1<<18
}

local EntityFlagsLocal = {
    FLAG_FREEZE = 1<<5,
    FLAG_MIDAS_FREEZE = 1<<10,
    FLAG_ICE_FROZEN = 1<<49,
    FLAG_ICE = 1<<50
}

UILayout = {
    GEMS_FRAME = 17,
    GEMS_ICON = Vector(56, 68),
    GEMS_NUM = Vector(72, 72)
}

local gemsDropLuck = {
    BASE_CHANCE = 30,
    BR_CHANCE = 60,
	MAX_LUCK = 12
}

local homingTearsLuck = {
	BASE_CHANCE = 30,
    LOW_LUCK = 2,
    MID_LUCK = 4,
	MAX_LUCK = 6
}

local Daggersstats = { 
    DAMAGE = 1,
    FIREDELAY = 7,
    SPEED = 0.1,
    SHOTSPEED = 1.5,
    TEARHEIGHT = -3,
    LUCK = -1,
    FLYING = false,                                 
    TEARFLAG = 0.75,
    TEARFLAG = TearFlagsLocal.FLAG_PERSISTENT
}

SpidState = {
    INIT = 0,
    CHOICE = 1,
    IDLE = 2,
    HIDDEN = 3
}

--External ID Desription--
if not __eidItemDescriptions then         
  __eidItemDescriptions = {};
end

if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
    __eidItemDescriptions[COLLECTIBLE_THE_DAGGER] = "Stats up, turn tears into daggers piercing dead enemies#Activates gems drop increasing firedelay at 10, 70 and 150";
    __eidItemDescriptions[COLLECTIBLE_THE_POWER] = "Shotgun type fire#Activates gems drop giving homing tears chance at 10, 70 and 150";
else
    __eidItemDescriptions[COLLECTIBLE_THE_DAGGER] = "Stats up, turn tears into daggers piercing dead enemies#Activates gems drop increasing firedelay at 5, 35 and 75";
    __eidItemDescriptions[COLLECTIBLE_THE_POWER] = "Shotgun type fire#Activates gems drop giving homing tears chance at 5, 35 and 75";
end

--New game starting items--
function DevilDaggers:onGameStart(savestate, fromSave)
    local player = Isaac.GetPlayer(0);
    local level = Game():GetLevel();
    
    player:GetData().Gems = 0;
    
    if (savestate == false and player:GetPlayerType() == Devil) or (savestate == false and player:GetPlayerType() == TaintedDevil) then
        player:AddCollectible(COLLECTIBLE_THE_DAGGER, 1, true);
    end
    
    if (savestate == false and player:GetPlayerType() == Devil) then
        player:SetPocketActiveItem(COLLECTIBLE_THE_POWER, ActiveSlot.SLOT_POCKET, false);
    end
    
    if savestate == false and Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        player:AddCollectible(COLLECTIBLE_THE_POWER, 1, true);
    end
    
    if (savestate == false and player:GetPlayerType() == Devil) or (savestate == false and player:GetPlayerType() == TaintedDevil) or (savestate == false and Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS) then
        
        Sound:Play(SoundEffect.Debut, 1, 120, false, 1);
        level:GetCurses(1);
        level:Update();
    end
    
    --Setting Devil Daggers challenge--
    if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        Isaac.ExecuteCommand("stage 10a");
        Isaac.ExecuteCommand("goto d.222");
    end
end
 
--UI Layout for the numbers--
function RenderNumber(n, Position)
    if n == nil then
        n = 0;
    end
    
    if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        HudNumbers:SetFrame("Idle", math.floor(n/100));
        HudNumbers:RenderLayer(0, Position);
        HudNumbers:SetFrame("Idle", (math.floor(n / 10) % 10));
        HudNumbers:RenderLayer(0, Position + Vector(6, 0));
        HudNumbers:SetFrame("Idle", n % 10);
        HudNumbers:RenderLayer(0, Position + Vector(12, 0));
    else
        HudNumbers:SetFrame("Idle", math.floor(n/10));
        HudNumbers:RenderLayer(0, Position);
        HudNumbers:SetFrame("Idle", n % 10);
        HudNumbers:RenderLayer(0, Position + Vector(6, 0));
    end
end

--UI layout for the gems--
function DevilDaggers:onRender()
    local player = Isaac.GetPlayer(0);
    
    if player:HasCollectible(COLLECTIBLE_THE_DAGGER) == true or player:HasCollectible(COLLECTIBLE_THE_POWER) == true then
        
        HudPickups:SetFrame("Idle", UILayout.GEMS_FRAME);
        HudPickups:RenderLayer(0, UILayout.GEMS_ICON);
        RenderNumber(player:GetData().Gems, UILayout.GEMS_NUM);        
    end
end

--Using The Power item--
function DevilDaggers:onUseItem(collectibleType)
    local player = Isaac.GetPlayer(0);
    local position = player.Position;
    local velocity = Vector(0,0);
    local direction = player:GetHeadDirection();
	local fireDirection = player:GetFireDirection();
    
    if player:HasCollectible(COLLECTIBLE_THE_POWER) == true then
        
        --Detecting head direction for the shot--
        if fireDirection ~= -1 then
            direction = fireDirection;
        end
    
        if direction == Direction.DOWN then
            position = Vector(position.X, position.Y + 8);
            velocity = Vector(0, 13);
        elseif direction == Direction.UP then
            position = Vector(position.X, position.Y - 5);
            velocity = Vector(0, -13);
        elseif direction == Direction.LEFT then
            position = Vector(position.X - 5, position.Y - 10);
            velocity = Vector(-13, 0);
        elseif direction == Direction.RIGHT then
            position = Vector(position.X + 5, position.Y - 10);
            velocity = Vector(13, 0);
        end
        
        --Shotgun type fire, sounds and homing daggers spawn chance--
        if upgraded == false then
            Sound:Play(SoundEffect.Shot, 2, 0, false, 1);
        else
            Sound:Play(SoundEffect.ShotPlus, 2, 0, false, 1);
        end
        
       
        for i = 1, 5 do 
            local tear = player:FireTear(position, velocity:Rotated(math.random(-15, 15)), true, true, false);
            local roll = math.random(100);

            if upgraded == true then

                if roll <= ((100 - homingTearsLuck.BASE_CHANCE) * player.Luck / homingTearsLuck.MID_LUCK) + homingTearsLuck.BASE_CHANCE then

                    tear.TearFlags = tear.TearFlags | TearFlagsLocal.FLAG_HOMING;
                    tear.TearFlags = tear.TearFlags | TearFlagsLocal.TEAR_QUADSPLIT;

                    if upgraded == true then
                       player:GetData().Gems = player:GetData().Gems - 1;
                    end
                end
            elseif ascended == true then

                if roll <= ((100 - homingTearsLuck.BASE_CHANCE) * player.Luck / homingTearsLuck.MAX_LUCK) + homingTearsLuck.BASE_CHANCE then

                    tear.TearFlags = tear.TearFlags | TearFlagsLocal.FLAG_HOMING;

                    if ascended == true then
                        player:GetData().Gems = player:GetData().Gems - 1;
                    end
                end
            end
        end
    end
end

--Save Gems number--
function SaveState()
    local player = Isaac.GetPlayer(0);
    local SaveData = "";
    
    if player:GetData().Gems < 10 then
        SaveData = SaveData .. "0";
    end
         
    SaveData = SaveData .. player:GetData().Gems;
    DevilDaggers:SaveData(SaveData);
end


function DevilDaggers:onUpdate(player)
    local player = Isaac.GetPlayer(0);
    local roll = math.random(100);
    local controller = player.ControllerIndex;
    local game = Game();
    local spid = nil;
        
    if game:GetFrameCount() == 1 then
        player:GetData().Gems = 0;
        scaled = false;
        upgraded = false;
        ascended = false;
    elseif player.FrameCount == 1 and DevilDaggers:HasData() then
        local DevilData = DevilDaggers:LoadData();
        player:GetData().Gems = tonumber(DevilData:sub(1, 2));
    end
    
    for _, entpede in pairs(Isaac.GetRoomEntities()) do
        if (entpede.Variant == EnemyVariant.CENTIPEDE or entpede.Variant == EnemyVariant.GIGAPEDE or entpede.Variant == EnemyVariant.GHOSTPEDE) and entpede:Exists() then
            local seg = entpede.Child;
    
            while seg do
                if seg.Position:Distance(seg.Parent.Position) > spacing then
                    seg.Position = seg.Parent.Position + (seg.Position - seg.Parent.Position):Normalized() * spacing;
                end
        
                seg = seg.Child;
            end
        end
    end
    
    --Spawning gems when certain enemy dies in the challenge mode--
    if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
                
        for _, entity in pairs(Isaac.GetRoomEntities()) do
            local data = entity:GetData();
            entity = entity:ToNPC();
            
            if entity and entity:IsActiveEnemy(true) then
                
                if entity:IsDead() and not data.Died then
                    data.Died = true;
                    
                    if entity.Variant == EnemyVariant.SKULLII or entity.Variant == EnemyVariant.SKULLIII or entity.Variant == EnemyVariant.SKULLIItransmuted or entity.Variant == EnemyVariant.SKULLIIItransmuted or entity.Type == Enemies.ENTITY_SPIDER or entity.Variant == EnemyVariant.SQUIDI then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, entity.Position, entity.Velocity, nil);
                    end
                    
                    if entity.Variant == EnemyVariant.CENTIPEDE or entity.Variant == EnemyVariant.GIGAPEDE or entity.Variant == EnemyVariant.GHOSTPEDE then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, entity.Position, entity.Velocity, nil);
                        entity:Remove();
                    end
                    
                    if entity.Variant == EnemyVariant.LEVIATHAN then
                        Isaac.Spawn(Enemies.ENTITY_LEVIATHAN, EnemyVariant.THEORB, 0, centerroom, Vector(0,0), nil);
                    end
                end
            end           
        end
    else
        --Spawning gems randomly when enemy dies--
        if (player:HasCollectible(COLLECTIBLE_THE_DAGGER) == true or player:HasCollectible(COLLECTIBLE_THE_POWER) == true) then
        
            for _, entity in pairs(Isaac.GetRoomEntities()) do
                local data = entity:GetData();
                entity = entity:ToNPC();
            
                if entity and entity:IsActiveEnemy(true) then
                
                    if entity:IsDead() and not data.Died then
                        data.Died = true;
                        
                        if player:GetPlayerType() == Devil and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) == true then
                            if roll <= ((100 - gemsDropLuck.BR_CHANCE) * player.Luck / gemsDropLuck.MAX_LUCK) + gemsDropLuck.BASE_CHANCE then

                                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, entity.Position, entity.Velocity, nil);
                            end
                        else
                            if roll <= ((100 - gemsDropLuck.BASE_CHANCE) * player.Luck / gemsDropLuck.MAX_LUCK) + gemsDropLuck.BASE_CHANCE then

                                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, entity.Position, entity.Velocity, nil);
                            end
                        end
                    elseif entity.ParentNPC then
                    
                        data.Died = true;
                    end
                end     
            end
        end
    end
    
    --The spider trying to eat gems--
    for _, entspid in pairs(Isaac.GetRoomEntities()) do
        if (entspid.Variant == EnemyVariant.SPIDERI or entspid.Variant == EnemyVariant.SPIDERII) and entspid:IsActiveEnemy(true) then
            spid = entspid:ToNPC();
        end
    end
    
    for _, entity in pairs(Isaac.GetRoomEntities()) do
        
        if entity.Variant == PickupVariant.GEMS and entity:GetSprite():IsPlaying("Idle") then
                
            if spid ~= nil and (spid.Variant == EnemyVariant.SPIDERI or spid.Variant == EnemyVariant.SPIDERII) and spid:IsActiveEnemy(true) and (spid:GetSprite():IsPlaying("Walk") or spid:GetSprite():IsPlaying("Uncover")) then
                entity.Velocity = (spid.Position - entity.Position):Normalized()*2;
            else
                --The gems move towards the player if he's not firing and the spiders are dead--
                if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, controller) then  
                
                else
                    entity.Velocity = (player.Position - entity.Position):Normalized()*7;
                end
            end
            
            --Replacing gems by eggs--
            if spid ~= nil and entity:GetData().Picked == nil then
                if spid.Variant == EnemyVariant.SPIDERI then
                    if entity.Type == EntityType.ENTITY_PICKUP and (spid.Position - entity.Position):Length() < spid.Size + entity.Size then
                        Sound:Play(SoundEffect.eat1, 2, 0, false, 1);
                        entity:GetSprite():Play("Collect", true);
                        entity:Remove();
                        Isaac.Spawn(Enemies.ENTITY_EGG, EnemyVariant.EGGI, 0, spid.Position, centerroom, nil);
                        Sound:Play(SoundEffect.spawnegg, 2, 0, false, 1);
                    end
                end
            
                if spid.Variant == EnemyVariant.SPIDERII then
                    if entity.Type == EntityType.ENTITY_PICKUP and (spid.Position - entity.Position):Length() < spid.Size + entity.Size then
                        Sound:Play(SoundEffect.eat2, 2, 0, false, 1);
                        entity:GetSprite():Play("Collect", true);
                        entity:Remove();
                        Isaac.Spawn(Enemies.ENTITY_EGG, EnemyVariant.EGGII, 0, spid.Position, centerroom, nil);
                        Sound:Play(SoundEffect.spawnegg, 2, 0, false, 1);
                    end
                end
            end
        end
        
        --Eggs spawning spiderlings--
        if entity.Variant == EnemyVariant.EGGI or entity.Variant == EnemyVariant.EGGII then
         
            if entity:Exists() then
                spiderlingpos = Isaac.GetFreeNearPosition(entity.Position, 0);
                
                timespid = timespid + 1;
            end
            
            if timespid == 300 then
                entity:BloodExplode();
                entity:Kill();
                for i = 5, 1, -1 do
                    Isaac.Spawn(EntityType.ENTITY_SPIDER_L2, EnemyVariant.SPIDERLING, 0, spiderlingpos, Vector(0,0), nil);
                end
                entity:Remove();
                timespid = 0;
            end
        end
        
        --Picking up gems with sound triggers--
        if entity.Type == EntityType.ENTITY_PICKUP and (entity.Position - player.Position):Length() < player.Size + entity.Size then

            if entity.Variant == PickupVariant.GEMS and entity:GetSprite():IsPlaying("Idle") and entity:GetData().Picked == nil then
                
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE;
                entity:GetData().Picked = true;
                entity:GetSprite():Play("Collect", true);
                
                if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
                    if entity.SubType == GEMS.SUBTYPE_GEMS then 
                        player:GetData().Gems = math.min(999, player:GetData().Gems + 1);
                    end
                else
                    if entity.SubType == GEMS.SUBTYPE_GEMS then 
                        player:GetData().Gems = math.min(99, player:GetData().Gems + 1);
                    end
                end
                
                if ascended == false then
                    
                    if upgraded == false then
                        Sound:Play(SoundEffect.GettingGems, 2, 0, false, 1);
                    else
                        Sound:Play(SoundEffect.GettingGemsPlus, 1, 0, false, 1);
                    end
                else
                    Sound:Play(SoundEffect.GettingGemsPlus, 1, 0, false, 1);
                end
                
                SaveState();
            end
        end
        
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.GEMS and entity:GetData().Picked == true and entity:GetSprite():GetFrame() == 6 then
            entity:Remove();
        end
    end
    
    --Leveling up sound triggers and stats boosters--
    if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        
        if scaled == false then
            
            if player:GetData().Gems >= 10 then
                Sound:Play(SoundEffect.levelup, 1, 150, false, 1);
                player.Damage = player.Damage + 1;
                player:AddNullCostume(dd);
                player:AddNullCostume(ddbody);
                scaled = true;
            end
        end
        if upgraded == false then
                    
            if player:GetData().Gems >= 70 then
                Sound:Play(SoundEffect.levelupplus, 1, 150, false, 1);
                player.Damage = player.Damage + 1;
                player.MaxFireDelay = player.MaxFireDelay - 1;
                player:AddNullCostume(ddblue);
                player:AddNullCostume(ddbodyblue);
                upgraded = true;
            end
        end
        if ascended == false then
            
            if player:GetData().Gems >= 150 then
                Sound:Play(SoundEffect.levelupplusplus, 1, 150, false, 1);
                player.Damage = player.Damage + 2;
                player.MaxFireDelay = player.MaxFireDelay - 2;
                ascended = true;
            end
        end
    else
        if scaled == false then
            
            if player:GetData().Gems >= 5 then
                Sound:Play(SoundEffect.levelup, 1, 150, false, 1);
                player.Damage = player.Damage + 1;
                scaled = true;
            end
        end
        if upgraded == false then
                    
            if player:GetData().Gems >= 35 then
                Sound:Play(SoundEffect.levelupplus, 1, 150, false, 1);
                player.Damage = player.Damage + 1;
                player.MaxFireDelay = player.MaxFireDelay - 1;
                
                if player:GetPlayerType() == Devil then
                    player:AddNullCostume(ddblue);
                    player:AddNullCostume(ddbodyblue);
                end
                
                if player:GetPlayerType() == TaintedDevil then
                    player:AddNullCostume(tddblue);
                    player:AddNullCostume(tddbodyblue);
                end
                upgraded = true;
            end
        end
        if ascended == false then
            
            if player:GetData().Gems >= 75 then
                Sound:Play(SoundEffect.levelupplusplus, 1, 150, false, 1);
                player.Damage = player.Damage + 2;
                player.MaxFireDelay = player.MaxFireDelay - 2;
                ascended = true;
            end
        end
    end
    
    --Timer set for challenge, events and waves order--
    if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        
        if player:HasCollectible(COLLECTIBLE_THE_DAGGER) == false then
            game.TimeCounter = 0;
        end
        
        --Initial wave--
        if game.TimeCounter == 90 then
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 180 then
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 420 then
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 510 then
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 570 then
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 660 then
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 720 then
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 810 then
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 1170 then
            DevilDaggers:Nest2();
            DevilDaggers:Spid1();
        end
        if game.TimeCounter == 1260 then
            DevilDaggers:Spawn2();
        end
        if game.TimeCounter == 1470 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 1560 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 1920 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 2010 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 2370 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 2460 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 2820 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 2910 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 3270 then
            DevilDaggers:Nest2();
        end
        if game.TimeCounter == 3360 then
            DevilDaggers:Spawn2();
        end
        if game.TimeCounter == 3270 then
            DevilDaggers:Centi();
        end
        if game.TimeCounter == 3570 then
            Isaac.ExecuteCommand("clearcache");
            DevilDaggers:Spid1();
        end
        if game.TimeCounter == 4020 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 4110 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 4320 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 4410 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 4620 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 4710 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 4920 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 5010 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 5220 then
            DevilDaggers:Centi();
            DevilDaggers:Spid1();
            DevilDaggers:Spid1();
            DevilDaggers:Spid1();
        end
        if game.TimeCounter == 5520 then
            Isaac.ExecuteCommand("clearcache");
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 5610 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 5670 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 5760 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 5820 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 5910 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 5970 then
            DevilDaggers:Spid1();
            DevilDaggers:Spid1();
            DevilDaggers:Spid1();
        end
        if game.TimeCounter == 6870 then
            DevilDaggers:Nest1();
            DevilDaggers:Nest1();
            DevilDaggers:Nest1();
            DevilDaggers:Nest1();
            DevilDaggers:Nest1();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 6960 then
            DevilDaggers:Spawn1();
            DevilDaggers:Spawn1();
            DevilDaggers:Spawn1();
            DevilDaggers:Spawn1();
            DevilDaggers:Spawn1();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 7170 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest2();
            DevilDaggers:Nest2();
        end
        if game.TimeCounter == 7260 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn2();
        end
        if game.TimeCounter == 7320 then
            Isaac.ExecuteCommand("clearcache");
            DevilDaggers:Nest3();
        end
        if game.TimeCounter == 7410 then
            DevilDaggers:Spawn3();
        end
        if game.TimeCounter == 7770 then
            DevilDaggers:Giga();
            --DevilDaggers:Giga();
            --DevilDaggers:Giga();
        end
        if game.TimeCounter == 8220 then
            Isaac.ExecuteCommand("clearcache");
            DevilDaggers:Spid2();
            DevilDaggers:Spid1();
            DevilDaggers:Spid1();
        end
        if game.TimeCounter == 8670 then
            DevilDaggers:Spid2();
            DevilDaggers:Spid1();
            DevilDaggers:Spid1();
        end
        if game.TimeCounter == 9120 then
            DevilDaggers:Nest3();
            DevilDaggers:Nest3();
            DevilDaggers:Nest3();
        end
        if game.TimeCounter == 9210 then
            DevilDaggers:Spawn3();
            DevilDaggers:Spawn3();
            DevilDaggers:Spawn3();
        end
        if game.TimeCounter == 10500 then
            Isaac.ExecuteCommand("clearcache");
            DevilDaggers:Leviathan();
            game:ShakeScreen(100);
        end
        if game.TimeCounter == 10950 then
            DevilDaggers:Nest1();
            DevilDaggers:Nest1();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 11040 then
            DevilDaggers:Spawn1();
            DevilDaggers:Spawn1();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 11100 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest2();
            DevilDaggers:Nest2();
        end
        if game.TimeCounter == 11190 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn2();
        end
        if game.TimeCounter == 11250 then
            DevilDaggers:Nest3();
        end
        if game.TimeCounter == 11340 then
            DevilDaggers:Spawn3();
        end
        if game.TimeCounter == 11910 then
            DevilDaggers:Nest3();
        end
        if game.TimeCounter == 12000 then
            Isaac.ExecuteCommand("clearcache");
            DevilDaggers:Spawn3();
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 12090 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 12180 then
            DevilDaggers:Nest2();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 12270 then
            DevilDaggers:Spawn2();
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 12360 then
            DevilDaggers:Giga();
        end
        if game.TimeCounter == 12510 then
            Isaac.ExecuteCommand("clearcache");
            DevilDaggers:Spid1();
        end
        if game.TimeCounter == 12540 then
            DevilDaggers:Spid1();
        end
        if game.TimeCounter == 12570 then
            DevilDaggers:Spid2();
        end
        if game.TimeCounter == 12720 then
            DevilDaggers:Nest1();
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 12360 then
            DevilDaggers:Spawn1();
            DevilDaggers:Spawn1();
            DevilDaggers:Nest2();
        end
        if game.TimeCounter == 12450 then
            DevilDaggers:Spawn2();
            DevilDaggers:Nest3();
        end
        if game.TimeCounter == 12540 then
            DevilDaggers:Spawn3();
        end
        if game.TimeCounter == 13200 then
            DevilDaggers:Nest1();
        end
        if game.TimeCounter == 13230 then
            DevilDaggers:Nest2();
        end
        if game.TimeCounter == 13260 then
            DevilDaggers:Ghost();
        end
        if game.TimeCounter == 13290 then
            Isaac.ExecuteCommand("clearcache");
            DevilDaggers:Spawn1();
        end
        if game.TimeCounter == 13320 then
            DevilDaggers:Spawn2();
        end
        if game.TimeCounter == 13410 then
            DevilDaggers:Thorn();
        end
        if game.TimeCounter == 13470 then
            DevilDaggers:Thorn();
        end
        if game.TimeCounter == 13530 then
            DevilDaggers:Thorn();
        end
        
        --Endless waves--
        if game.TimeCounter == 13680 then
            wavesbegin = game.TimeCounter;
        end
        
        if game.TimeCounter >= 13680 then
            if game.TimeCounter == wavesbegin then
                start = game.TimeCounter;
                giorgh = 1;
            end
            if game.TimeCounter >= start then
                DevilDaggers:Wave();
            end
            if game.TimeCounter == wavesbegin + 1650 then 
                start = game.TimeCounter;
            end
            if game.TimeCounter >= wavesbegin + 1650 then
                DevilDaggers:Wave();
            end
            if game.TimeCounter == wavesbegin + 3120 then
                DevilDaggers:Wave();
                giorgh = 2;
            end
            if game.TimeCounter >= wavesbegin + 3120 then
                DevilDaggers:Wave();
            end
            if game.TimeCounter == wavesbegin + 420 then
                wavesbegin = game.TimeCounter;
            end
        end
        
        --Waves--
        function DevilDaggers:Wave()
            local game = Game();
    
            if game.TimeCounter == start then
                Isaac.ExecuteCommand("clearcache");
                DevilDaggers:Nest1();
                DevilDaggers:Nest1();
            end
            if game.TimeCounter == start + 90 then
                DevilDaggers:Spawn1();
                DevilDaggers:Spawn1();
                DevilDaggers:Nest2();
            end
            if game.TimeCounter == start + 180 then
                DevilDaggers:Spawn2();
                DevilDaggers:Nest3();
            end
            if game.TimeCounter == start + 270 then
                DevilDaggers:Spawn3();
            end
            if giorgh == 1 then
                if game.TimeCounter == start + 420 then
                    DevilDaggers:Giga();
                end
            elseif giorgh == 2 then
                if game.TimeCounter == start + 420 then
                    DevilDaggers:Ghost();
                end
            end
            if game.TimeCounter == start + 570 then
                DevilDaggers:Spid2();
            end
            if game.TimeCounter == start + 600 then
                DevilDaggers:Spid1();
            end
            if game.TimeCounter == start + 630 then
                DevilDaggers:Spid1();
            end
            if game.TimeCounter == start + 930 then
                Isaac.ExecuteCommand("clearcache");
                DevilDaggers:Thorn();
            end
            if game.TimeCounter == start + 960 then
                DevilDaggers:Thorn();
            end
            if game.TimeCounter == start + 990 then
                DevilDaggers:Thorn();
            end
            if game.TimeCounter == start + 1140 then
                DevilDaggers:Spid1();
            end
            if game.TimeCounter == start + 1170 then
                DevilDaggers:Spid1();
            end
            if game.TimeCounter == start + 1320 then
                DevilDaggers:Nest1();
            end
            if game.TimeCounter == start + 1410 then
                DevilDaggers:Spawn1();
            end
            if game.TimeCounter == start + 1470 then
                DevilDaggers:Nest1();
            end
            if game.TimeCounter == start + 1560 then
                DevilDaggers:Spawn1();
            end
            if game.TimeCounter == start + 1710 then
                DevilDaggers:Nest1();
            end
            if game.TimeCounter == start + 1800 then
                DevilDaggers:Spawn1();
            end
        end
        
        for _, entity in pairs(Isaac.GetRoomEntities()) do
            local data = entity:GetData();
            
            --Removing dagger's pedestal--
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity.SubType == 0 then
                entity:Remove();
            end
            
            --Removing Larry's poop--
            if entity.Type == EntityType.ENTITY_POOP then
                entity:Remove();
            end
            
            --Squids spawning points for skull waves--
            if entity and entity:IsActiveEnemy(true) then
                entity = entity:ToNPC();
                
                if not data.Died then
                    
                    if entity.Variant == EnemyVariant.SQUIDI then
                        entity.Velocity = (centerroom - entity.Position):Normalized()/3;
                        if entity.FrameCount == 1 then
                            SpawnPos1 = Isaac.GetFreeNearPosition(entity.Position, 0);
                        end
                    end
                    if entity.Variant == EnemyVariant.SQUIDII then
                        entity.Velocity = (centerroom - entity.Position):Normalized()/3;
                        if entity.FrameCount == 1 then
                            SpawnPos2 = Isaac.GetFreeNearPosition(entity.Position, 0);
                        end
                    end
                    if entity.Variant == EnemyVariant.SQUIDIII then
                        entity.Velocity = (centerroom - entity.Position):Normalized()/3;
                        if entity.FrameCount == 1 then
                            SpawnPos3 = Isaac.GetFreeNearPosition(entity.Position, 0);
                        end
                    end
            
                    --Trying to make squids spawn new waves when they stay alive--
                    if entity.Variant == EnemyVariant.SQUIDI then
                        if entity.FrameCount == timesquid1 then
                            DevilDaggers:Spawn1();
                            timesquid1 = timesquid1 + 600;
                        end
                    end
                    if entity.Variant == EnemyVariant.SQUIDII then
                        if entity.FrameCount == timesquid2 then
                            DevilDaggers:Spawn2();
                            timesquid2 = timesquid2 + 600;
                        end
                    end
                    if entity.Variant == EnemyVariant.SQUIDIII then
                        if entity.FrameCount == timesquid3 then
                            DevilDaggers:Spawn3();
                            timesquid3 = timesquid3 + 600;
                        end
                    end
                else
                    if entity.Variant == EnemyVariant.SQUIDI then
                        SpawnPos1 = nil;
                    end
                    if entity.Variant == EnemyVariant.SQUIDII then
                        SpawnPos2 = nil;
                    end
                    if entity.Variant == EnemyVariant.SQUIDIII then
                        SpawnPos3 = nil;
                    end
                end
            end
            
            --The Orb turning skulls into transmuted versions--
            for _, entorb in pairs(Isaac.GetRoomEntities()) do
                
                if entorb.Type == Enemies.ENTITY_LEVIATHAN and entorb:Exists() == true then
                    
                    if entity.Variant == EnemyVariant.SKULLI or entity.Variant == EnemyVariant.SKULLII or entity.Variant == EnemyVariant.SKULLIII or entity.Variant == EnemyVariant.SKULLIV then
                        
                        entity.Target = entorb;
                        entity.Velocity = (entorb.Position - entity.Position):Normalized()/2 + entity.Velocity;
                        
                        if (entity.Position - entorb.Position):Length() < entorb.Size + entity.Size then
                            
                            Sound:Play(SoundEffect.levmuted, 1, 0, false, 1);
                            
                            if entity.Variant == EnemyVariant.SKULLI then
                                Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLItransmuted, 0, entorb.Position, Vector(0,0), nil);
                                entity:Remove();
                            end
                            if entity.Variant == EnemyVariant.SKULLII then
                                Isaac.Spawn(EntityType.ENTITY_MAGGOT, EnemyVariant.SKULLIItransmuted, 0, entorb.Position, Vector(0,0), nil);
                                entity:Remove();
                            end
                            if entity.Variant == EnemyVariant.SKULLIII then
                                Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLIIItransmuted, 0, entorb.Position, Vector(0,0), nil);
                                entity:Remove();
                            end
                            if entity.Variant == EnemyVariant.SKULLIV then
                                Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLIVtransmuted, 0, entorb.Position, Vector(0,0), nil);
                                entity:Remove();
                            end
                        end
                    end
                else
                    --Gotta go fast--
                    if entity.Variant == EnemyVariant.SKULLIII or entity.Variant == EnemyVariant.SKULLIV or entity.Variant == EnemyVariant.SKULLIIItransmuted or entity.Variant == EnemyVariant.SKULLIVtransmuted then
                        entity.Velocity = (player.Position - entity.Position):Normalized()*5;
                    end
                end
            end
            
            --The pedes slightly chase the player--
            if entity.Variant == EnemyVariant.CENTIPEDE or entity.Variant == EnemyVariant.GIGAPEDE or entity.Variant == EnemyVariant.GHOSTPEDE then
                entity.Velocity = (entity:GetPlayerTarget().Position - entity.Position):Normalized() + entity.Velocity;
            end
        end
    end
    
    --No red hearts for Devil--
	if player:GetPlayerType() == Devil then
		local red = player:GetMaxHearts();
        
		if red > 0 then 
			player:AddMaxHearts(-red);
            player:AddSoulHearts(red);
		end
	end
   
    --No hearts for Tainted Devil... Unless ?--
    if player:GetPlayerType() == TaintedDevil then
		local red = player:GetMaxHearts();
        local bone = player:GetBoneHearts();
        local soul = player:GetSoulHearts() - 1;
        
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) == false then
            player:GetHeartLimit(1);

            if red > 0 then 
                player:AddMaxHearts(-red);
            end
            if bone > 0 then 
                player:AddBoneHearts(-bone);
            end
            if soul > 1 then 
                player:AddSoulHearts(-soul);
            end
        else
            if red > 0 then 
                player:AddMaxHearts(-red);
                player:AddSoulHearts(red);
            end
        end
	end
end

--Adding Devil's costume--
function DevilDaggers:onPlayerInit(player)
    local player = Isaac.GetPlayer(0);
    
    player:GetData().Gems = 0;
    
    if player:GetPlayerType() == Devil then
        player:AddNullCostume(ddbody);
 	end
    
    if player:GetPlayerType() == TaintedDevil then
        player:AddNullCostume(tddbody);
 	end
    
    if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        player:AddBombs(-1);
    end
end


--Stats up from Dagger--
function Daggersstats:onCache(player, cacheFlag)
    local player = Isaac.GetPlayer(0);
    
    if player:HasCollectible(COLLECTIBLE_THE_DAGGER) == true then
       
        if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
            if cacheFlag == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = 3;
            end
            if cacheFlag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage - 2.5;
            end
        else
            if player:GetPlayerType() == TaintedDevil then
                if cacheFlag == CacheFlag.CACHE_FIREDELAY then
                    player.MaxFireDelay = Daggersstats.FIREDELAY;
                end
                if cacheFlag == CacheFlag.CACHE_DAMAGE then
                    player.Damage = player.Damage + Daggersstats.DAMAGE;
                end
            end
        end
        
        if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = Daggersstats.SHOTSPEED;
        end
        
        if cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearHeight = player.TearHeight + Daggersstats.TEARHEIGHT;
        end
        
        if cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + Daggersstats.SPEED;
        end
        
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + Daggersstats.LUCK;
        end
        
        if cacheFlag == CacheFlag.CACHE_FLYING and Daggersstats.FLYING then
            player.CanFly = true
        end
        
        if cacheFlag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | Daggersstats.TEARFLAG;
        end
    end
end


function DevilDaggers:Update()
    local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
    
    --Slow motion effect (kinda) when leveling up--
    if Sound:IsPlaying(SoundEffect.levelup) == true or Sound:IsPlaying(SoundEffect.levelupplus) == true or Sound:IsPlaying(SoundEffect.levelupplusplus) == true then 
        room:SetBrokenWatchState(1);
    else
        room:SetBrokenWatchState(0);
    end
    
    --No hearts in the challenge--
    if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then 
        if player:HasCollectible(COLLECTIBLE_THE_DAGGER) == true then            
            player:AddMaxHearts(-1);
        end
    end
    
    --Fixing (kinda) player firedelay problems, I don't know how to deal with it--
    if player:HasCollectible(COLLECTIBLE_THE_DAGGER) == true then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) == false then
            if player.MaxFireDelay > 5 then
                player.MaxFireDelay = player.MaxFireDelay - 2;
            end
        else
            player.MaxFireDelay = 1;
        end
    end
end


function DevilDaggers:PostUpdate()
    local player = Isaac.GetPlayer(0);
    local controller = player.ControllerIndex;
    
    --if Game():IsGreedMode() then
    --    if Game():GetFrameCount() == 1 and player:GetPlayerType() == Devil or Game():GetFrameCount() == 1 and player:GetPlayerType() == TaintedDevil then
    --        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, COLLECTIBLE_THE_DAGGER, Vector(320,340), Vector (0,0), nil);
    --    end
    --else
    --    if Game():GetFrameCount() == 1 and player:GetPlayerType() == Devil or Game():GetFrameCount() == 1 and player:GetPlayerType() == TaintedDevil then
    --        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, COLLECTIBLE_THE_DAGGER, Vector(320,280), Vector (0,0), nil);
    --    end
    --end
    
    --Spawning The Dagger item--
    if Game():GetFrameCount() == 1 and Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, COLLECTIBLE_THE_DAGGER, centerroom, Vector (0,0), nil);
    end
    
    --Death sound trigger, other sounds stop and timers reset--
    if (player:GetPlayerType() == Devil and player:GetSprite():IsFinished("Death") == true) or (player:GetPlayerType() == TaintedDevil and player:GetSprite():IsFinished("Death") == true) or (Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS and player:GetSprite():IsFinished("Death") == true) then
        Sound:Stop(SoundEffect.Firing);
        Sound:Stop(SoundEffect.FiringPlus);
        Sound:Stop(SoundEffect.FiringPlusPlus);
        Sound:Stop(SoundEffect.levelup);
        Sound:Stop(SoundEffect.levelupplus);
        Sound:Stop(SoundEffect.levelupplusplus);
        Sound:Stop(SoundEffect.idleskulli);
        Sound:Stop(SoundEffect.idleskullii);
        Sound:Stop(SoundEffect.idleskulliii);
        Sound:Stop(SoundEffect.idleskulliv);
        Sound:Stop(SoundEffect.idleskullimuted);
        Sound:Stop(SoundEffect.idleskulliimuted);
        Sound:Stop(SoundEffect.idleskulliiimuted);
        Sound:Stop(SoundEffect.idleskullivmuted);
        Sound:Stop(SoundEffect.spawnsquidi);
        Sound:Stop(SoundEffect.spawnsquidii);
        Sound:Stop(SoundEffect.spawnsquidiii);
        Sound:Stop(SoundEffect.idlesquidi);
        Sound:Stop(SoundEffect.idlesquidii);
        Sound:Stop(SoundEffect.idlesquidiii);
        Sound:Stop(SoundEffect.wave1);
        Sound:Stop(SoundEffect.wave2);
        Sound:Stop(SoundEffect.wave3);
        Sound:Stop(SoundEffect.spawnspideri);
        Sound:Stop(SoundEffect.spawnspiderii);
        Sound:Stop(SoundEffect.idlespideri);
        Sound:Stop(SoundEffect.idlespiderii);
        Sound:Stop(SoundEffect.idlecenti);
        Sound:Stop(SoundEffect.idlegiga);
        Sound:Stop(SoundEffect.idleghost);
        Sound:Stop(SoundEffect.idlelev);
        Sound:Stop(SoundEffect.spawnlev);
        Sound:Stop(SoundEffect.levmuted);
        Sound:Stop(SoundEffect.levbeckon);
        Sound:Stop(SoundEffect.levkill);
        Sound:Play(SoundEffect.Dies, 1, 0, false, 1);
        timespid = 0;
        timesquid1 = 690;
        timesquid2 = 690;
        timesquid3 = 690;
        timelev = 300;
        timeorb = 75;
        wavesbegin = 0;
        start = 0;
        giorgh = 0;
        scaled = false;
        upgraded = false;
        ascended = false;
    end
    
    --Firing sound conditions--
    if player:HasCollectible(COLLECTIBLE_THE_DAGGER) == true or Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        
        if player:HasWeaponType(WeaponType.WEAPON_TEARS) then
            
            if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, controller) then

                if ascended == true then
                    if Sound:IsPlaying(SoundEffect.FiringPlusPlus) then

                    else
                        Sound:Play(SoundEffect.FiringPlusPlus, 0.5, 0, true, 1);
                    end
                else
                    if upgraded == true then
                        if Sound:IsPlaying(SoundEffect.FiringPlus) then

                        else
                            Sound:Play(SoundEffect.FiringPlus, 0.5, 0, true, 1);
                        end
                    else
                        if Sound:IsPlaying(SoundEffect.Firing) then

                        else
                            Sound:Play(SoundEffect.Firing, 0.5, 0, true, 1);
                        end
                    end
                end
            else
                Sound:Stop(SoundEffect.Firing);
                Sound:Stop(SoundEffect.FiringPlus);
                Sound:Stop(SoundEffect.FiringPlusPlus);
            end
        end
    end
    
    --Playing enemy sounds (not really the best method but I'm not smart enough for something else)--
    for _, entity in pairs(Isaac.GetRoomEntities()) do
        
        if entity.Variant == EnemyVariant.SQUIDI then 
            if entity:IsActiveEnemy() then
                if Sound:IsPlaying(SoundEffect.idlesquidi) then

                else
                    Sound:Play(SoundEffect.idlesquidi, 1, 0, true, 1);
                end
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idlesquidi);
            end
        end
        
        if entity.Variant == EnemyVariant.SQUIDII then 
            if entity:IsActiveEnemy() then
                if Sound:IsPlaying(SoundEffect.idlesquidii) then

                else
                    Sound:Play(SoundEffect.idlesquidii, 1, 0, true, 1);
                end
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idlesquidii);
            end
        end
        
        if entity.Variant == EnemyVariant.SQUIDIII then 
            if entity:IsActiveEnemy() then
                if Sound:IsPlaying(SoundEffect.idlesquidiii) then

                else
                    Sound:Play(SoundEffect.idlesquidiii, 1, 0, true, 1);
                end
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idlesquidiii);
            end
        end
        
        if entity.Variant == EnemyVariant.SPIDERI then
            if entity:IsDead() then
                Sound:Stop(SoundEffect.idlespideri);
            else
                if entity:IsActiveEnemy() and entity:GetSprite():IsPlaying("Walk") then
                    if Sound:IsPlaying(SoundEffect.idlespideri) then

                    else
                        Sound:Play(SoundEffect.idlespideri, 1, 0, true, 1);
                    end
                elseif entity:IsActiveEnemy() and entity:GetSprite():IsPlaying("Covered") then
                    Sound:Stop(SoundEffect.idlespideri);
                end
            end
        end
        
        if entity.Variant == EnemyVariant.SPIDERII then
            if entity:IsDead() then
                Sound:Stop(SoundEffect.idlespiderii);
            else
                if entity:IsActiveEnemy() and entity:GetSprite():IsPlaying("Walk") then
                    if Sound:IsPlaying(SoundEffect.idlespiderii) then

                    else
                        Sound:Play(SoundEffect.idlespiderii, 1, 0, true, 1);
                    end
                elseif entity:IsActiveEnemy() and entity:GetSprite():IsPlaying("Covered") then
                    Sound:Stop(SoundEffect.idlespiderii);
                end
            end
        end
        
        if entity.Variant == EnemyVariant.SKULLI then 
            if entity:IsActiveEnemy() and entity:GetSprite():IsPlaying("Idle") then
                if Sound:IsPlaying(SoundEffect.idleskulli) then

                else
                    Sound:Play(SoundEffect.idleskulli, 1, 30, true, 1);
                end
                Sound:Stop(SoundEffect.SOUND_INSECT_SWARM_LOOP);
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idleskulli);
            elseif entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) or entity:HasEntityFlags(EntityFlag.FLAG_ICE) then
                Sound:Stop(SoundEffect.idleskulli);
            end
        end
        
        if entity.Variant == EnemyVariant.SKULLII then 
            if entity:IsActiveEnemy() and (entity:GetSprite():IsPlaying("Move Up") or entity:GetSprite():IsPlaying("Move Down") or entity:GetSprite():IsPlaying("Move Hori")) then
                if Sound:IsPlaying(SoundEffect.idleskullii) then

                else
                    Sound:Play(SoundEffect.idleskullii, 1, 0, true, 1);
                end
                Sound:Stop(SoundEffect.SOUND_INSECT_SWARM_LOOP);
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idleskullii);
            elseif entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) or entity:HasEntityFlags(EntityFlag.FLAG_ICE) then
                Sound:Stop(SoundEffect.idleskullii);
            end
        end
        
        if entity.Variant == EnemyVariant.SKULLIII then 
            if entity:IsActiveEnemy() and entity:GetSprite():IsPlaying("Idle") then
                if Sound:IsPlaying(SoundEffect.idleskulliii) then

                else
                    Sound:Play(SoundEffect.idleskulliii, 1, 0, true, 1);
                end
                Sound:Stop(SoundEffect.SOUND_INSECT_SWARM_LOOP);
            elseif entity:IsDead() or entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) then
                Sound:Stop(SoundEffect.idleskulliii);
            elseif entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) or entity:HasEntityFlags(EntityFlag.FLAG_ICE) then
                Sound:Stop(SoundEffect.idleskulliii);
            end
        end
        
        if entity.Variant == EnemyVariant.SKULLIV then 
            if entity:IsActiveEnemy() and entity:GetSprite():IsPlaying("Idle") then
                if Sound:IsPlaying(SoundEffect.idleskulliv) then

                else
                    Sound:Play(SoundEffect.idleskulliv, 1, 0, true, 1);
                end
                Sound:Stop(SoundEffect.SOUND_INSECT_SWARM_LOOP);
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idleskulliv);
            elseif entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) or entity:HasEntityFlags(EntityFlag.FLAG_ICE) then
                Sound:Stop(SoundEffect.idleskulliv);
            end
        end
        
        if entity.Variant == EnemyVariant.SKULLItransmuted then 
            if entity:IsActiveEnemy() and entity:GetSprite():IsPlaying("Idle") then
                if Sound:IsPlaying(SoundEffect.idleskullimuted) then

                else
                    Sound:Play(SoundEffect.idleskullimuted, 1, 0, true, 1);
                end
                Sound:Stop(SoundEffect.SOUND_INSECT_SWARM_LOOP);
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idleskullimuted);
            elseif entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) or entity:HasEntityFlags(EntityFlag.FLAG_ICE) then
                Sound:Stop(SoundEffect.idleskullimuted);
            end
        end
        
        if entity.Variant == EnemyVariant.SKULLIItransmuted then 
            if entity:IsActiveEnemy() and (entity:GetSprite():IsPlaying("Move Up") or entity:GetSprite():IsPlaying("Move Down") or entity:GetSprite():IsPlaying("Move Hori")) then
                if Sound:IsPlaying(SoundEffect.idleskulliimuted) then

                else
                    Sound:Play(SoundEffect.idleskulliimuted, 1, 0, true, 1);
                end
                Sound:Stop(SoundEffect.SOUND_INSECT_SWARM_LOOP);
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idleskulliimuted);
            elseif entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) or entity:HasEntityFlags(EntityFlag.FLAG_ICE) then
                Sound:Stop(SoundEffect.idleskulliimuted);
            end
        end
        
        if entity.Variant == EnemyVariant.SKULLIIItransmuted then 
            if entity:IsActiveEnemy() and entity:GetSprite():IsPlaying("Idle") then
                if Sound:IsPlaying(SoundEffect.idleskulliiimuted) then

                else
                    Sound:Play(SoundEffect.idleskulliiimuted, 1, 0, true, 1);
                end
                Sound:Stop(SoundEffect.SOUND_INSECT_SWARM_LOOP);
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idleskulliiimuted);
            elseif entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) or entity:HasEntityFlags(EntityFlag.FLAG_ICE) then
                Sound:Stop(SoundEffect.idleskulliiimuted);
            end
        end
        
        if entity.Variant == EnemyVariant.SKULLIVtransmuted then 
            if entity:IsActiveEnemy() and entity:GetSprite():IsPlaying("Idle") then
                if Sound:IsPlaying(SoundEffect.idleskullivmuted) then

                else
                    Sound:Play(SoundEffect.idleskullivmuted, 1, 0, true, 1);
                end
                Sound:Stop(SoundEffect.SOUND_INSECT_SWARM_LOOP);
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idleskullivmuted);
            elseif entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) or entity:HasEntityFlags(EntityFlag.FLAG_ICE) then
                Sound:Stop(SoundEffect.idleskullivmuted);
            end
        end
        if entity.Variant == EnemyVariant.CENTIPEDE then 
            if entity:IsActiveEnemy() and entity:Exists() then
                if Sound:IsPlaying(SoundEffect.idlecenti) then

                else
                    Sound:Play(SoundEffect.idlecenti, 1, 0, true, 1);
                end
                Sound:Stop(SoundEffect.SOUND_PLOP);
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idlecenti);
            end
        end
        if entity.Variant == EnemyVariant.GIGAPEDE then 
            if entity:IsActiveEnemy() and entity:Exists() then
                if Sound:IsPlaying(SoundEffect.idlegiga) then

                else
                    Sound:Play(SoundEffect.idlegiga, 1, 0, true, 1);
                end
                Sound:Stop(SoundEffect.SOUND_PLOP);
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idlegiga);
            end
        end
        if entity.Variant == EnemyVariant.GHOSTPEDE then 
            if entity:IsActiveEnemy() and entity:Exists() then
                if Sound:IsPlaying(SoundEffect.idleghost) then

                else
                    Sound:Play(SoundEffect.idleghost, 1, 0, true, 1);
                end
                Sound:Stop(SoundEffect.SOUND_PLOP);
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idleghost);
            end
        end
        if entity.Variant == EnemyVariant.LEVIATHAN then 
            if entity:IsActiveEnemy() and entity:Exists() then                    
                if Sound:IsPlaying(SoundEffect.idlelev) then

                else
                    Sound:Play(SoundEffect.idlelev, 1, 0, true, 1);
                end
                
                if entity.FrameCount == timelev then
                    Sound:Play(SoundEffect.levbeckon, 1, 0, false, 1);
                    timelev = timelev + 300;
                end
            elseif entity:IsDead() then
                Sound:Stop(SoundEffect.idlelev);
                Sound:Play(SoundEffect.levkill, 1, 0, false, 1);
            end
        end
        if entity.Variant == EnemyVariant.THEORB then
            if entity.FrameCount == timeorb then
                Sound:Play(SoundEffect.levbeckon, 1, 0, false, 1);
                timeorb = timeorb + 75;
            end
        end
    end
end


function DevilDaggers:onFireTear(tear)
    local player = Isaac.GetPlayer(0);
    
    --Setting Dagger sprites conditions--
    if player:HasCollectible(COLLECTIBLE_THE_DAGGER) == true and not player:HasCollectible(CollectibleType.COLLECTIBLE_8_INCH_NAILS) then
        
        for _, entity in pairs(Isaac.GetRoomEntities()) do
            
            if entity.Type == EntityType.ENTITY_TEAR then
                local tear = entity:ToTear();
                local tearSprite = tear:GetSprite();
                local HeadDir = player.GetHeadDirection(player);
                
                if tear.Variant == TearVariant.BLUE or tear.Variant == TearVariant.BLOOD then
                    
                    tear:ChangeVariant(TearVariant.NAIL);
                    
                    if ascended == true then
                        tearSprite:ReplaceSpritesheet(0, "gfx/effects/daggertearsviolet.png");
                        tearSprite:LoadGraphics();
                    else
                        tearSprite:ReplaceSpritesheet(0, "gfx/effects/daggertears.png");
                        tearSprite:LoadGraphics();
                    end
                    
                    if (HeadDir == Direction.UP) then
                        tearSprite.Rotation = -90;
                    end
                    
                    if (HeadDir == Direction.DOWN) then
                        tearSprite.Rotation = 90;
                    end
                    
                    if (HeadDir == Direction.LEFT) then
                        tearSprite.Rotation = 180;
                    end
                end
                  
                if (tear.TearFlags == tear.TearFlags | TearFlagsLocal.FLAG_HOMING or player:HasCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART) == true or player:HasCollectible(CollectibleType.COLLECTIBLE_GODHEAD) == true) and player:HasCollectible(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) == false then
                    
                    if ascended == true then
                        tearSprite:ReplaceSpritesheet(0, "gfx/effects/daggertearshoming.png");
                        tearSprite:LoadGraphics();
                    else
                        tearSprite:ReplaceSpritesheet(0, "gfx/effects/daggertearsblue.png");
                        tearSprite:LoadGraphics();
                    end
                end
            end  
        end
    end
end


---New variants ans enemies with spawn setups---

function DevilDaggers:EggsUpdate(entityegg)
    local sprite = entityegg:GetSprite();
    
    if entityegg.State == nil then
        entityegg.State = NpcState.STATE_INIT;
    end
    
    if entityegg.State == NpcState.STATE_INIT then
        sprite:Play("Appear");
        if sprite:IsFinished("Appear") then
            entityegg.State = NpcState.STATE_IDLE;
        end
    end
    
    if entityegg.State == NpcState.STATE_IDLE then
        sprite:Play("Idle");
    end
end


function DevilDaggers:Eggsfunc(Egg)
    local EggData = Egg:GetData();
    local chance = math.random(100);
    
    if type(EggData) == "table" and EggData.EggInit == nil and Egg:IsActiveEnemy() then
        EggData.EggInit = true;
        
        if Egg.Variant == 0 then
            if chance >= 0 and chance < 70 then
                NewEgg = Isaac.Spawn(Enemies.ENTITY_EGG, EnemyVariant.EGGI, 0, Egg.Position, Vector(0,0), nil);
                Sound:Play(SoundEffect.spawnegg, 1, 300, false, 1);
                Egg:Remove();
            elseif chance >= 70 and chance <= 100 then
                NewEgg = Isaac.Spawn(Enemies.ENTITY_EGG, EnemyVariant.EGGII, 0, Egg.Position, Vector(0,0), nil);
                Sound:Play(SoundEffect.spawnegg, 1, 300, false, 1);
                Egg:Remove();
            end
        end
    end
end


function DevilDaggers:Spiderlingfunc(Spiderlvl2)
    local Spiderlvl2Data = Spiderlvl2:GetData();
    
    if type(Spiderlvl2Data) == "table" and Spiderlvl2Data.Spiderlvl2Init == nil and Spiderlvl2:IsActiveEnemy() then
        Spiderlvl2Data.Spiderlvl2Init = true;
        
        if Spiderlvl2.Variant == 0 and math.random(100) <= VARIANT_CHANCE then
            NewSpiderlvl2 = Isaac.Spawn(EntityType.ENTITY_SPIDER_L2, EnemyVariant.SPIDERLING, 0, Spiderlvl2.Position, Vector(0,0), nil);
            Spiderlvl2:Remove();
        end
    end
end


function DevilDaggers:SquidsUpdate(entitysquid)
    local sprite = entitysquid:GetSprite();
    
    if entitysquid.State == nil then
        entitysquid.State = NpcState.STATE_INIT;
    end
    
    if entitysquid.State == NpcState.STATE_INIT then
        sprite:Play("HeartAppear");
        if sprite:IsFinished("HeartAppear") then
            entitysquid.State = NpcState.STATE_IDLE;
        end
    end
    
    if entitysquid.State == NpcState.STATE_IDLE then
        sprite:Play("HeartBeat");
    end
    
    if entitysquid.State == NpcState.STATE_DEATH then
        sprite:Play("Death");
    end
end


function DevilDaggers:onSquidDmg(TookDamage, DamageAmount, DamageFlag, DamageSource, DamageCountdownFrames)
    if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        local data = TookDamage:GetData();            
        local HPVal = TookDamage.HitPoints - DamageAmount;
        
        if TookDamage.Variant == EnemyVariant.SQUIDII then
                
            if HPVal <= 0 and not data.SquidReward1 then
                data.SquidReward1 = true;
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, TookDamage.Position, TookDamage.Velocity, nil);
            elseif HPVal <= 10 and not data.SquidReward2 then
                data.SquidReward2 = true;
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, TookDamage.Position, TookDamage.Velocity, nil);
            end
            
        elseif TookDamage.Variant == EnemyVariant.SQUIDIII then
                
            if HPVal <= 0 and not data.SquidReward1 then
                data.SquidReward1 = true;
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, TookDamage.Position, TookDamage.Velocity, nil);
            elseif HPVal <= 30 and not data.SquidReward2 then
                data.SquidReward2 = true;
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, TookDamage.Position, TookDamage.Velocity, nil);
            elseif HPVal <= 60 and not data.SquidReward3 then
                data.SquidReward3 = true;
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, TookDamage.Position, TookDamage.Velocity, nil);
            end
        end
    end
end
    

function DevilDaggers:Squidsfunc(Squid)
    local SquidData = Squid:GetData();
    local chance = math.random(100);
    
    if type(SquidData) == "table" and SquidData.SquidInit == nil and Squid:IsActiveEnemy() then
        SquidData.SquidInit = true;
        
        if Squid.Variant == 0 then
            if chance >= 0 and chance < 70 then
                NewSquid = Isaac.Spawn(Enemies.ENTITY_SQUID, EnemyVariant.SQUIDI, 0, Squid.Position, Vector(0,0), nil);
                Sound:Play(SoundEffect.spawnsquidi, 1, 300, false, 1);
                Squid:Remove();
            elseif chance >= 70 and chance < 90 then
                NewSquid = Isaac.Spawn(Enemies.ENTITY_SQUID, EnemyVariant.SQUIDII, 0, Squid.Position, Vector(0,0), nil);
                Sound:Play(SoundEffect.spawnsquidii, 1, 300, false, 1);
                Squid:Remove();
            elseif chance >= 90 and chance <= 100 then
                NewSquid = Isaac.Spawn(Enemies.ENTITY_SQUID, EnemyVariant.SQUIDIII, 0, Squid.Position, Vector(0,0), nil);
                Sound:Play(SoundEffect.spawnsquidiii, 1, 300, false, 1);
                Squid:Remove();
            end
        end
    end
end


function DevilDaggers:PedesUpdate(entitypede)
    
    if entitypede.State == nil then
        entitypede.State = NpcState.STATE_IDLE;
    end
    
    if entitypede.State == NpcState.STATE_IDLE then
        EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS;
    end
end


function DevilDaggers:Pedesfunc(Pede)
    local PedeData = Pede:GetData();
    local chance = math.random(100);
    
    if type(PedeData) == "table" and PedeData.PedeInit == nil and Pede:IsActiveEnemy() then
        PedeData.PedeInit = true;
        
        if Pede.Variant == 1 and Pede.Champion == 0 then
            if chance >= 0 and chance < 85 then
                for i = 10, 1, -1 do
                    NewPede = Isaac.Spawn(EntityType.ENTITY_LARRYJR, EnemyVariant.CENTIPEDE, 0, Pede.Position, Vector(0,0), nil);
                    Pede:Remove();
                end
                
            elseif chance >= 85 and chance < 95 then
                for i = 10, 1, -1 do
                    NewPede = Isaac.Spawn(EntityType.ENTITY_LARRYJR, EnemyVariant.GIGAPEDE, 0, Pede.Position, Vector(0,0), nil);
                    Pede:Remove();
                end
                Pede:Remove();
                
            elseif chance >= 95 and chance <= 100 then
                for i = 10, 1, -1 do
                    NewPede = Isaac.Spawn(EntityType.ENTITY_LARRYJR, EnemyVariant.GHOSTPEDE, 0, Pede.Position, Vector(0,0), nil);
                    Pede:Remove();
                end
            end
        end
    end
end


function DevilDaggers:onPedeDmg(TookDamage, DamageAmount, DamageFlag, DamageSource, DamageCountdownFrames)
    
    if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        
        if DamageSource.Type ~= EntityType.ENTITY_LARRYJR then
            
            local parentchain = TookDamage.Parent;
            local childchain = TookDamage.Child;
        
            while parentchain do
                parentchain:TakeDamage(DamageAmount, DamageFlag, EntityRef(TookDamage), DamageCountdownFrames);
                parentchain = parentchain.Parent;
            end
        
            while childchain do
                childchain:TakeDamage(DamageAmount, DamageFlag, EntityRef(TookDamage), DamageCountdownFrames);
                childchain = childchain.Child;
            end
        end
    end
end


function DevilDaggers:SpidersUpdate(entityspider)
    local sprite = entityspider:GetSprite();
    local player = Isaac.GetPlayer(0);
    local distance = (entityspider.Position - player.Position):Length();
    
    if entityspider.State == nil then
        if distance ~= nil then
            entityspider.State = SpidState.INIT;
        end
    end
    
    if entityspider.State == SpidState.INIT then
        sprite:Play("Appear");
            
        if sprite:IsFinished("Appear") then
            entityspider.State = SpidState.CHOICE;
        end
    end
        
    if entityspider.State == SpidState.CHOICE or entityspider.State == SpidState.IDLE or entityspider.State == SpidState.HIDDEN then
        if distance >= 200 then
            entityspider.State = SpidState.IDLE;
        end
        
        if distance < 200 then
            entityspider.State = SpidState.HIDDEN;
        end
    end
    
    if entityspider.State == SpidState.IDLE then
        if sprite:IsPlaying("Walk") then
            
        else
            sprite:Play("Uncover");
            
            if sprite:IsFinished("Uncover") then
                sprite:Play("Walk", true);
            end  
        end
    end
    
    if entityspider.State == SpidState.HIDDEN then
        if sprite:IsPlaying("Covered") then
            
        else
            sprite:Play("Cover");
            
            if sprite:IsFinished("Cover") then
                sprite:Play("Covered", true);
            end 
        end
    end
end


function DevilDaggers:Spidersfunc(Spider)
    local SpiderData = Spider:GetData();
    local chance = math.random(100);
    
    if type(SpiderData) == "table" and SpiderData.SquidInit == nil and Spider:IsActiveEnemy() then
        SpiderData.SpiderInit = true;
        
        if Spider.Variant == 0 then
            if chance >= 0 and chance < 80 then
                NewSpider = Isaac.Spawn(Enemies.ENTITY_SPIDER, EnemyVariant.SPIDERI, 0, Spider.Position, Vector(0,0), nil);
                Sound:Play(SoundEffect.spawnspideri, 1, 300, false, 1);
                Spider:Remove();
            elseif chance >= 80 and chance < 100 then
                NewSpider = Isaac.Spawn(Enemies.ENTITY_SPIDER, EnemyVariant.SPIDERII, 0, Spider.Position, Vector(0,0), nil);
                Sound:Play(SoundEffect.spawnspiderii, 1, 300, false, 1);
                Spider:Remove();
            end
        end
    end
end


function DevilDaggers:Thornfunc(NerveEnding)
    local NerveEndingData = NerveEnding:GetData();
    
    if type(NerveEndingData) == "table" and NerveEndingData.NerveEndingInit == nil and NerveEnding:IsActiveEnemy() then
        NerveEndingData.NerveEndingInit = true;
        
        if NerveEnding.Variant == 0 and math.random(100) <= VARIANT_CHANCE then
            NewNerveEnding = Isaac.Spawn(EntityType.ENTITY_NERVE_ENDING, EnemyVariant.THORN, 0, NerveEnding.Position, Vector(0,0), nil);
            NerveEnding:Remove();
        end
    end
end


function DevilDaggers:onLevDmg(TookDamage, DamageAmount, DamageFlag, DamageSource, DamageCountdownFrames)
    if TookDamage.Variant == EnemyVariant.LEVIATHAN then
        local data = TookDamage:GetData();            
        local HPVal = TookDamage.HitPoints - DamageAmount;
                
        if HPVal <= 0 and not data.LevReward1 then
            data.LevReward1 = true;
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, TookDamage.Position, TookDamage.Velocity, nil);
        elseif HPVal <= 250 and not data.LevReward2 then
            data.LevReward2 = true;
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, TookDamage.Position, TookDamage.Velocity, nil);
        elseif HPVal <= 500 and not data.LevReward3 then
            data.LevReward3 = true;
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, TookDamage.Position, TookDamage.Velocity, nil);
        elseif HPVal <= 750 and not data.LevReward4 then
            data.LevReward4 = true;
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, TookDamage.Position, TookDamage.Velocity, nil);
        elseif HPVal <= 1000 and not data.LevReward5 then
            data.LevReward5 = true;
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, TookDamage.Position, TookDamage.Velocity, nil);
        elseif HPVal <= 1250 and not data.LevReward6 then
            data.LevReward6 = true;
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.GEMS, GEMS.SUBTYPE_GEMS, TookDamage.Position, TookDamage.Velocity, nil);
        end
    end
end


function DevilDaggers:Skullsfunc(Flylvl2)
    local chance = math.random(100);
    local Flylvl2Data = Flylvl2:GetData();
    
    if type(Flylvl2Data) == "table" and Flylvl2Data.Flylvl2Init == nil and Flylvl2:IsActiveEnemy() then
        Flylvl2Data.Flylvl2Init = true;
        
        if Flylvl2.Variant == 0 then
            if math.random(100) >= MUTED_CHANCE then
                if chance >= 50 and chance < 70 then
                    Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLI, 0, Flylvl2.Position, Vector(0,0), nil);
                    Flylvl2:Remove();
                elseif chance >= 70 and chance < 90 then
                    Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLIII, 0, Flylvl2.Position, Vector(0,0), nil);
                    Flylvl2:Remove();
                elseif chance >= 90 and chance <= 100 then
                    Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLIV, 0, Flylvl2.Position, Vector(0,0), nil);
                    Flylvl2:Remove();
                end
            else
                if chance >= 50 and chance < 70 then
                    Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLItransmuted, 0, Flylvl2.Position, Vector(0,0), nil);
                    Flylvl2:Remove();
                elseif chance >= 70 and chance < 90 then
                    Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLIIItransmuted, 0, Flylvl2.Position, Vector(0,0), nil);
                    Flylvl2:Remove();
                elseif chance >= 90 and chance <= 100 then
                    Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLIVtransmuted, 0, Flylvl2.Position, Vector(0,0), nil);
                    Flylvl2:Remove();
                end
            end
        end
    end
end


function DevilDaggers:Skulliifunc(Maggot)
    local MaggotData = Maggot:GetData();
    
    if type(MaggotData) == "table" and MaggotData.MaggotInit == nil and Maggot:IsActiveEnemy() then
        MaggotData.MaggotInit = true;
        
        if Maggot.Variant == 0 and math.random(100) <= VARIANT_CHANCE then
            Isaac.Spawn(EntityType.ENTITY_MAGGOT, EnemyVariant.SKULLII, 0, Maggot.Position, Vector(0,0), nil);
            
            if math.random(100) <= MUTED_CHANCE then
                Isaac.Spawn(EntityType.ENTITY_MAGGOT, EnemyVariant.SKULLIItransmuted, 0, Maggot.Position, Vector(0,0), nil);
            end
            
            Maggot:Remove();
        end
    end
end


function DevilDaggers:LevUpdate(entitylev)
    local sprite = entitylev:GetSprite();
    
    if entitylev.State == nil or entitylev.State == NpcState.STATE_INIT then
        entitylev.State = NpcState.STATE_IDLE;
    end
    
    if entitylev.State == NpcState.STATE_IDLE then
        sprite:Play("Idle");
    end
end

--Challenge room style params--
function DevilDaggers:UpdateRoom()
    local game = Game();
    local room = game:GetRoom();
    local player = Isaac.GetPlayer(0);
    local level = game:GetLevel();
    local shape = room:GetRoomShape();
	
    if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        
        local room = Game():GetRoom();
        
        for i = 1, room:GetGridSize() do
            local poop = room:GetGridEntity(i);
            
            if poop ~= nil then
                if poop:GetType() == GridEntityType.GRID_POOP then
                    poop:Destroy(true);
                    room:RemoveGridEntity(i, 0, false);
                end
            end
        end
        
        if player:HasCollectible(COLLECTIBLE_THE_DAGGER) then
            room:SetFloorColor(Color(0.8, 0.4, 0.1, 1, 0.3, 0.15, 0));
        else
            room:SetFloorColor(Color(1, 1, 1, 1, -100, -100, -75));
        end
        
        room:SetWallColor(Color(1, 1 ,1, 1, -100, -150, -200));
		    
		if (room.GetDoor(room, 0) ~= nil) or (room.GetDoor(room, 1) ~= nil) or (room.GetDoor(room, 3) ~= nil) or (room.GetDoor(room, 2) ~= nil) then

			room.RemoveDoor(room, 0);
			room.RemoveDoor(room, 1);
			room.RemoveDoor(room, 2);
			room.RemoveDoor(room, 3);
        end
    else
        if Game():GetFrameCount() == 1 and player:GetPlayerType() == Devil then
            level:AddCurse(1);
        end
    end
end


---Enemies spawn functions---

function DevilDaggers:Nest1()
    Sound:Play(SoundEffect.spawnsquidi, 1, 180, false, 1);
    Isaac.Spawn(Enemies.ENTITY_SQUID, EnemyVariant.SQUIDI, 0, tablepos[math.random(1, #tablepos)], Vector(0,0), nil);
end

function DevilDaggers:Nest2()
    Sound:Play(SoundEffect.spawnsquidii, 1, 300, false, 1);
    Isaac.Spawn(Enemies.ENTITY_SQUID, EnemyVariant.SQUIDII, 0, tablepos[math.random(1, #tablepos)], Vector(0,0), nil);
end

function DevilDaggers:Nest3()
    Sound:Play(SoundEffect.spawnsquidiii, 1, 300, false, 1);
    Isaac.Spawn(Enemies.ENTITY_SQUID, EnemyVariant.SQUIDIII, 0, tablepos[math.random(1, #tablepos)], Vector(0,0), nil);
end

function DevilDaggers:Spawn1()
    if SpawnPos1 ~= nil then
        Sound:Play(SoundEffect.wave1, 1, 150, false, 1);
        Isaac.Spawn(EntityType.ENTITY_MAGGOT, EnemyVariant.SKULLII, 0, SpawnPos1, Vector(0,0), nil);

        for i = 10, 1, -1 do
            Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLI, 0, SpawnPos1, Vector(0,0), nil);
        end
    end
end

function DevilDaggers:Spawn2()
    if SpawnPos2 ~= nil then
        Sound:Play(SoundEffect.wave2, 1, 120, false, 1);
        Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLIII, 0, SpawnPos2, Vector(0,0), nil);

        for i = 10, 1, -1 do
            Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLI, 0, SpawnPos2, Vector(0,0), nil);
        end
    end
end

function DevilDaggers:Spawn3()
    if SpawnPos3 ~= nil then
        Sound:Play(SoundEffect.wave3, 1, 120, false, 1);
        Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLIV, 0, SpawnPos3, Vector(0,0), nil);

        for i = 10, 1, -1 do
            Isaac.Spawn(EntityType.ENTITY_FLY_L2, EnemyVariant.SKULLI, 0, SpawnPos3, Vector(0,0), nil);
        end
    end
end

function DevilDaggers:Spid1()
    Sound:Play(SoundEffect.spawnspideri, 1, 180, false, 1);
    Isaac.Spawn(Enemies.ENTITY_SPIDER, EnemyVariant.SPIDERI, 0, tablepos[math.random(1, #tablepos)], Vector(0,0), nil);
end

function DevilDaggers:Spid2()
    Sound:Play(SoundEffect.spawnspiderii, 1, 180, false, 1);
    Isaac.Spawn(Enemies.ENTITY_SPIDER, EnemyVariant.SPIDERII, 0, tablepos[math.random(1, #tablepos)], Vector(0,0), nil);
end

function DevilDaggers:Centi()
    for i = 25, 0, -1 do
        Isaac.Spawn(EntityType.ENTITY_LARRYJR, EnemyVariant.CENTIPEDE, 0, randompos, Vector(0,0), nil);
    end
end

function DevilDaggers:Giga()
    for i = 50, 0, -1 do
        Isaac.Spawn(EntityType.ENTITY_LARRYJR, EnemyVariant.GIGAPEDE, 0, randompos, Vector(0,0), nil);
    end
end

--function DevilDaggers:Gigax3()
    --for i = 50, 0, -1 do
        --Isaac.Spawn(EntityType.ENTITY_LARRYJR, EnemyVariant.GIGAPEDE, 0, appearNO, Vector(0,0), nil);
    --end
    --for i = 50, 0, -1 do
        --Isaac.Spawn(EntityType.ENTITY_LARRYJR, EnemyVariant.GIGAPEDE, 0, appearNE, Vector(0,0), nil);
    --end
    --for i = 50, 0, -1 do
        --Isaac.Spawn(EntityType.ENTITY_LARRYJR, EnemyVariant.GIGAPEDE, 0, appearSO, Vector(0,0), nil);
    --end
--end

function DevilDaggers:Ghost()
    for i = 10, 0, -1 do
        Isaac.Spawn(EntityType.ENTITY_LARRYJR, EnemyVariant.GHOSTPEDE, 0, randompos, Vector(0,0), nil);
    end
end

function DevilDaggers:Thorn()
    Isaac.Spawn(EntityType.ENTITY_NERVE_ENDING, EnemyVariant.THORN, 0, tableposthorn[math.random(1, #tableposthorn)], Vector(0,0), nil);
end

function DevilDaggers:Leviathan()
    Sound:Play(SoundEffect.spawnlev, 1, 0, false, 1);
    Isaac.Spawn(Enemies.ENTITY_LEVIATHAN, EnemyVariant.LEVIATHAN, 0, centerroom, centerroom, nil);
end

function DevilDaggers:onExit()
    if Isaac.GetChallenge() == CHALLENGE_DEVIL_DAGGERS then
        local player = Isaac.GetPlayer(0);
        
        player:Kill();
    end
end


DevilDaggers:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, DevilDaggers.onPlayerInit);
DevilDaggers:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Daggersstats.onCache);
DevilDaggers:AddCallback(ModCallbacks.MC_POST_RENDER, DevilDaggers.onRender);
DevilDaggers:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, DevilDaggers.onGameStart);
DevilDaggers:AddCallback(ModCallbacks.MC_USE_ITEM, DevilDaggers.onUseItem, COLLECTIBLE_THE_POWER);
DevilDaggers:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, DevilDaggers.onFireTear);
DevilDaggers:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, DevilDaggers.onUpdate);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.EggsUpdate, Enemies.ENTITY_EGG);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.Eggsfunc, Enemies.ENTITY_EGG);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.Spiderlingfunc, EntityType.ENTITY_SPIDER_L2);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.SquidsUpdate, Enemies.ENTITY_SQUID);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.Squidsfunc, Enemies.ENTITY_SQUID);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.SpidersUpdate, Enemies.ENTITY_SPIDER);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.Spidersfunc, Enemies.ENTITY_SPIDER);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.PedesUpdate, EntityType.ENTITY_LARRYJR);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.Pedesfunc, EntityType.ENTITY_LARRYJR);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.Thornfunc, EntityType.ENTITY_NERVE_ENDING);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.Skullsfunc, EntityType.ENTITY_FLY_L2);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.Skulliifunc, EntityType.ENTITY_MAGGOT);
DevilDaggers:AddCallback(ModCallbacks.MC_NPC_UPDATE, DevilDaggers.LevUpdate, Enemies.ENTITY_LEVIATHAN);
DevilDaggers:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, DevilDaggers.onPedeDmg, EntityType.ENTITY_LARRYJR);
DevilDaggers:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, DevilDaggers.onSquidDmg, EntityType.ENTITY_SQUID);
DevilDaggers:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, DevilDaggers.onLevDmg, EntityType.ENTITY_LEVIATHAN);
DevilDaggers:AddCallback(ModCallbacks.MC_POST_UPDATE, DevilDaggers.PostUpdate);
DevilDaggers:AddCallback(ModCallbacks.MC_POST_UPDATE, DevilDaggers.UpdateRoom);
DevilDaggers:AddCallback(ModCallbacks.MC_POST_UPDATE, DevilDaggers.Update);
DevilDaggers:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, DevilDaggers.onExit);