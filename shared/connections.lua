local Planets = require 'shared.planets'
local Type = require 'shared.connection_types'

local Edge = 'solar-system-edge'
local Aquilo = Planets.aquilo
local Fulgora = Planets.fulgora
local Gleba = Planets.gleba
local Nauvis = Planets.nauvis
local Vulcanus = Planets.vulcanus

return {
  -- Aquilo triangle connections
  { Aquilo[1], Edge, Type.aquilo.edge },
  { Aquilo[2], Edge, Type.aquilo.edge },
  { Aquilo[3], Edge, Type.aquilo.edge },
  { Aquilo[1], Aquilo[2], Type.aquilo.aquilo },
  { Aquilo[1], Aquilo[3], Type.aquilo.aquilo },
  { Aquilo[2], Aquilo[3], Type.aquilo.aquilo },

  -- System A
  -- Group 1
  { Gleba[1], Aquilo[1], Type.gleba.aquilo },
  { Fulgora[1], Aquilo[1], Type.fulgora.aquilo },
  { Gleba[1], Fulgora[1], Type.gleba.fulgora },
  { Gleba[1], Vulcanus[1], Type.gleba.vulcanus },
  { Fulgora[1], Vulcanus[1], Type.fulgora.vulcanus },

  -- Group 2
  { Gleba[2], Aquilo[1], Type.gleba.aquilo },
  { Fulgora[2], Aquilo[1], Type.fulgora.aquilo },
  { Gleba[2], Fulgora[2], Type.gleba.fulgora },
  { Gleba[2], Vulcanus[2], Type.gleba.vulcanus },
  { Fulgora[2], Vulcanus[2], Type.fulgora.vulcanus },

  -- Group 3
  { Gleba[3], Aquilo[1], Type.gleba.aquilo },
  { Fulgora[3], Aquilo[1], Type.fulgora.aquilo },
  { Gleba[3], Fulgora[3], Type.gleba.fulgora },
  { Gleba[3], Vulcanus[3], Type.gleba.vulcanus },
  { Fulgora[3], Vulcanus[3], Type.fulgora.vulcanus },

  -- System B
  -- Group 4
  { Gleba[4], Aquilo[2], Type.gleba.aquilo },
  { Fulgora[4], Aquilo[2], Type.fulgora.aquilo },
  { Gleba[4], Fulgora[4], Type.gleba.fulgora },
  { Gleba[4], Vulcanus[4], Type.gleba.vulcanus },
  { Fulgora[4], Vulcanus[4], Type.fulgora.vulcanus },

  -- Group 5
  { Gleba[5], Aquilo[2], Type.gleba.aquilo },
  { Fulgora[5], Aquilo[2], Type.fulgora.aquilo },
  { Gleba[5], Fulgora[5], Type.gleba.fulgora },
  { Gleba[5], Vulcanus[5], Type.gleba.vulcanus },
  { Fulgora[5], Vulcanus[5], Type.fulgora.vulcanus },

  -- Group 6
  { Gleba[6], Aquilo[2], Type.gleba.aquilo },
  { Fulgora[6], Aquilo[2], Type.fulgora.aquilo },
  { Gleba[6], Fulgora[6], Type.gleba.fulgora },
  { Gleba[6], Vulcanus[6], Type.gleba.vulcanus },
  { Fulgora[6], Vulcanus[6], Type.fulgora.vulcanus },

  -- System C
  -- Group 7
  { Gleba[7], Aquilo[3], Type.gleba.aquilo },
  { Fulgora[7], Aquilo[3], Type.fulgora.aquilo },
  { Gleba[7], Fulgora[7], Type.gleba.fulgora },
  { Gleba[7], Vulcanus[7], Type.gleba.vulcanus },
  { Fulgora[7], Vulcanus[7], Type.fulgora.vulcanus },

  -- Group 8
  { Gleba[8], Aquilo[3], Type.gleba.aquilo },
  { Fulgora[8], Aquilo[3], Type.fulgora.aquilo },
  { Gleba[8], Fulgora[8], Type.gleba.fulgora },
  { Gleba[8], Vulcanus[8], Type.gleba.vulcanus },
  { Fulgora[8], Vulcanus[8], Type.fulgora.vulcanus },

  -- Group 9
  { Gleba[9], Aquilo[3], Type.gleba.aquilo },
  { Fulgora[9], Aquilo[3], Type.fulgora.aquilo },
  { Gleba[9], Fulgora[9], Type.gleba.fulgora },
  { Gleba[9], Vulcanus[9], Type.gleba.vulcanus },
  { Fulgora[9], Vulcanus[9], Type.fulgora.vulcanus },

  -- Home planets
  { Nauvis[1], Vulcanus[1], Type.nauvis.vulcanus },
  { Nauvis[2], Gleba[1], Type.nauvis.gleba },
  { Nauvis[3], Fulgora[1], Type.nauvis.fulgora },
  { Nauvis[4], Vulcanus[2], Type.nauvis.vulcanus },
  { Nauvis[5], Gleba[2], Type.nauvis.gleba },
  { Nauvis[6], Fulgora[2], Type.nauvis.fulgora },
  { Nauvis[7], Vulcanus[3], Type.nauvis.vulcanus },
  { Nauvis[8], Gleba[3], Type.nauvis.gleba },
  { Nauvis[9], Fulgora[3], Type.nauvis.fulgora },
  { Nauvis[10], Vulcanus[4], Type.nauvis.vulcanus },
  { Nauvis[11], Gleba[4], Type.nauvis.gleba },
  { Nauvis[12], Fulgora[4], Type.nauvis.fulgora },
  { Nauvis[13], Vulcanus[5], Type.nauvis.vulcanus },
  { Nauvis[14], Gleba[5], Type.nauvis.gleba },
  { Nauvis[15], Fulgora[5], Type.nauvis.fulgora },
  { Nauvis[16], Vulcanus[6], Type.nauvis.vulcanus },
  { Nauvis[17], Gleba[6], Type.nauvis.gleba },
  { Nauvis[18], Fulgora[6], Type.nauvis.fulgora },
  { Nauvis[19], Vulcanus[7], Type.nauvis.vulcanus },
  { Nauvis[20], Gleba[7], Type.nauvis.gleba },
  { Nauvis[21], Fulgora[7], Type.nauvis.fulgora },
  { Nauvis[22], Vulcanus[8], Type.nauvis.vulcanus },
  { Nauvis[23], Gleba[8], Type.nauvis.gleba },
  { Nauvis[24], Fulgora[8], Type.nauvis.fulgora },
  { Nauvis[25], Vulcanus[9], Type.nauvis.vulcanus },
  { Nauvis[26], Gleba[9], Type.nauvis.gleba },
  { Nauvis[27], Fulgora[9], Type.nauvis.fulgora },
}
