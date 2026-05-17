# Synthesis

Pasta gerada em 2026-05-14 por uma rodada de 6 agentes paralelos analisando os
dumps em `references/` (Cookie Clicker, Legends of IdleOn, Incremental Epic
Hero 2) e propondo mescla informada para o Idle Medieval.

Cada doc segue o template:

1. **Como cada jogo faz** (resumo curto por jogo, com numeros)
2. **Convergencias** (onde os 3 alinham — mescla recomendada de cara)
3. **Divergencias / Decisoes pendentes** (sistemas conflitantes lado-a-lado
   para o usuario escolher)
4. **Proposta para o Idle Medieval** (adaptada ao state-of-the-project atual)
5. **Hooks com docs existentes** (onde plugar no `planning/01_design/`,
   `02_math/`, `04_phases/`)

Conflitos serios (multiplos sistemas concorrentes onde a fusao nao e' obvia)
sao consolidados em `decisions-needed.md` apos os 6 agentes terminarem, com os
sistemas lado-a-lado e tradeoffs explicitos.

Material aqui e' **research/sintese**, nao decisao final. Apos revisao do
usuario, decisoes confirmadas migram para os catalogos em `01_design/` ou para
`pending-decisions.md`.

## Docs gerados

- `01-stats-and-progression.md` — XP curves, stats de personagem, level scaling
- `02-active-vs-idle-balance.md` — AFK gains, offline cap, idle vs active mix
- `03-combat-classes-skills.md` — classes, talents, abilities, combat math
- `04-items-crafting-equipment.md` — drops, recipes, equipment slots, upgrades
- `05-zones-enemies-quests-npcs.md` — design de zona/inimigo, questlines, NPCs
- `06-meta-progression-and-mechanics.md` — rebirth/ascension, pets, buffs, eventos
