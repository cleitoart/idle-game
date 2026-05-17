# Save / Offline Spec - Formato de Save e Progressao Offline

> Especificacao do sistema de persistencia, recovery e calculo de progresso offline.
> Cross-references: `account-vs-character.md` (boundary de dados), `progression-curves.md` (formulas usadas no replay), `glossary.md` (termos).

---

## 1. Formato do save

### 1.1 JSON ou Resource (.tres)?

**Recomendacao: JSON com hash de integridade** para o save principal (account + characters).
Tres opcoes consideradas:

| Formato | Pros | Contras |
|---|---|---|
| **JSON (texto)** | Legivel, debug facil, multiplataforma, migracao simples (read -> mutate -> write) | Modificavel sem ferramentas (cheating trivial), sem tipo forte |
| **Resource .tres (texto)** | Tipo forte, integra com Inspector da Godot | Atrelado a classes Godot — refatorar classe quebra save antigo. Migracao complexa |
| **Resource .res (binario)** | Compacto, mais rapido | Ilegivel, debug dificil, tambem quebra com refactor |

**Decisao recomendada:** JSON puro (`save_slot_X.json`) para o save principal. Resources `.tres` continuam sendo a fonte de verdade dos *catalogos* (EnemyData, ItemData, etc.) — esses sao read-only no runtime e nao mudam por jogador.

Vantagens praticas:
- Migrate scripts em puro Godot (read JSON -> mutate Dictionary -> write).
- Suporte a backup/share/copy fora do jogo (debug, suporte ao usuario).
- Independencia de versoes Godot (Godot 4.6 -> 4.7 nao pode quebrar saves do jogador por mudanca interna do tipo Resource).

**[DECISAO PENDENTE: ofuscar o save?].** Default sugerido: **nao encriptar**. Padrao em idle e save legivel + "anti-cheat soft" (hash de integridade que invalida saves modificados manualmente, opcional). Vantagem cultural do idle: jogador pode "trapacear" sem prejudicar outros (nao e MMO). Custo benificio nao justifica a complexidade.

Caso seja decidido ofuscar mais tarde:
- **Opcao 1:** XOR + Base64 (trivial, anti-curioso casual).
- **Opcao 2:** AES-256 com chave embutida (anti-curioso medio, ainda quebravel via reverse engineering).
- **Opcao 3 (over-kill):** Servidor valida saves. Fora de escopo para single-player.

### 1.2 Localizacao do save

```
user://save_slot_1.json         <- save principal
user://save_slot_1.json.bak     <- backup automatico anterior
user://save_slot_1.json.bak2    <- backup automatico ante-anterior
user://save_slot_1.json.manual_<timestamp>.bak   <- backup manual
user://save_settings.json       <- configuracoes locais (audio, video, etc.)
```

Permite **multiplos slots** (futuro: ate 3 slots por instalacao para teste de NG+ ou compartilhamento).

### 1.3 Estrutura raiz

```json
{
  "save_version": 1,
  "saved_at_unix": 1746550000,
  "last_offline_at_unix": 1746549890,
  "integrity_hash": "<sha256 do conteudo abaixo, recalculado ao salvar>",
  "account_data": { ... },
  "characters": [ { ... }, { ... } ]
}
```

### 1.4 `account_data` fields

```json
{
  "account_id": "uuid_v4_local",
  "account_name": "Carlos",
  "created_at_unix": 1745000000,
  "total_play_time_seconds": 84600,
  "preferred_language": "pt_BR",

  "currencies": {
    "gold": 2450,
    "gems_eternidade": 47,
    "glory": 145,
    "dungeon_tokens": 12,
    "moeda_galactica": 0,
    "transcended_points": 0
  },

  "selos": [
    { "id": "selo_100k_kills", "tier": 1, "unlocked_at_unix": 1745800000 },
    { "id": "selo_500_drops", "tier": 2, "unlocked_at_unix": 1746200000 }
  ],

  "achievements": {
    "total_unlocked": 18,
    "unlocked_ids": ["ach_first_kill", "ach_first_craft", "ach_zone1_clear"]
  },

  "cards_album": {
    "regular": {
      "slime_verde": { "unlocked": true, "stars": 3, "duplicates": 24 },
      "slime_azul":  { "unlocked": true, "stars": 1, "duplicates": 2 }
    },
    "corrupted": {},
    "greedy": {}
  },

  "pets_global": {
    "lobo_filhote": { "unlocked": true, "level": 3, "assigned_to": "char_warrior_uuid" }
  },

  "configuracoes": {
    "audio_master": 0.7,
    "audio_music": 0.6,
    "audio_sfx_combate": 0.8,
    "audio_sfx_ui": 0.5,
    "audio_ambient": 0.4,
    "audio_voice": 0.3,
    "video_fullscreen": false,
    "video_resolution": [1280, 720],
    "gameplay_default_speed": 2,
    "gameplay_auto_loot": true,
    "gameplay_auto_equip_best": false,
    "gameplay_show_enemy_hp_numbers": true,
    "gameplay_confirm_sell_rare_plus": true,
    "notif_quest_complete": true,
    "notif_level_up": true,
    "notif_drop_rare_plus": true
  },

  "cronicas_do_mundo": {
    "first_save_unix": 1745000000,
    "memoria_do_tempo_pontos": 24,
    "milestones_unlocked": ["1d", "7d"]
  },

  "ascension_count": 0,
  "transcendencia_tree": { },
  "ascensao_galactic_upgrades": { },
  "constelacao_pontos": 0,
  "constelacao_nodes_unlocked": [],

  "loja_eterna_compras": {
    "slots_inventario_extra": 4,
    "slot_personagem_extra": 0,
    "auto_loot": true,
    "auto_equip_best": false,
    "offline_cap_hours": 12,
    "//offline_cap_hours_note": "RESOLVIDO 2026-05-06 #18: 12h base. Loja Eterna desbloqueia 24h, 48h, 72h em Renascimento+ progressivamente."
  },

  "dev_unlocks_used": ["unlock_all_zones"]
}
```

### 1.5 Per-character fields (`characters[]`)

```json
{
  "character_id": "uuid_v4",
  "name": "Aldric",
  "class": "warrior",
  "awakening_state": {
    "stars": 4,
    "branches_chosen": [
      { "star": 3, "branch": "cavaleiro_sagrado" }
    ]
  },
  "level": 47,
  "current_xp": 12500,
  "level_cap_current": 100,

  "stat_points_unspent": 3,
  "stats_base": {
    "str": 25, "dex": 12, "int": 6, "vit": 30, "luk": 5,
    "hp_max": 500, "mp_max": 80, "atk_speed": 1.2
  },

  "equipped_items": {
    "helmet": "<item_uuid>",
    "chest": "<item_uuid>",
    "legs": null,
    "boots": "<item_uuid>",
    "necklace": null,
    "earrings": null,
    "ring1": "<item_uuid>",
    "ring2": null,
    "bracelet": null,
    "weapon": "<item_uuid>",
    "weapon_visual": null,
    "skin_full": null,
    "wings": null,
    "pickaxe": "<item_uuid>",
    "axe": null,
    "fishing_rod": null
  },

  "inventory": [
    {
      "uuid": "<item_uuid>",
      "data_id": "training_sword",
      "tier": "common",
      "level": 0,
      "refine_plus": 0,
      "affixes": [
        {"stat": "atk", "value": 5, "rolled_at_unix": 1746000000}
      ],
      "encantamentos": [],
      "stat_stones": [],
      "qty": 1
    }
  ],

  "skill_tree_nodes_unlocked": ["str_5", "atk_passive_1"],
  "skill_tree_branch_focus": "berserker",
  "active_skills_loadout": ["cleave", "rage", null, null, null, null, null, null],

  "mastery": {
    "mining_cobre": 12,
    "mining_ferro": 3,
    "fishing_truta": 8,
    "woodcutting_carvalho": 15
  },

  "kill_counts": {
    "slime_verde": 23450,
    "goblin_cobre": 8200
  },

  "cards_equipados": ["slime_verde", "goblin_cobre", null, ...],

  "current_activity": {
    "type": "combat",
    "zone": "floresta",
    "stage": 3,
    "area": 4,
    "wave": 2,
    "started_at_unix": 1746549000
  },

  "last_completed_stage": {
    "floresta": 3,
    "deserto": 0
  },

  "expedicao_atual": null,
  "shadow_active_until_unix": 0,

  "renascimento_count": 1,
  "transcendencia_count": 0
}
```

---

## 2. Versionamento de save

Campo `save_version` na raiz. Estrategia de migracao:

```gdscript
const CURRENT_SAVE_VERSION = 5

func load_save(path: String) -> Dictionary:
    var json = read_json(path)
    if json.is_empty():
        return {}
    var v = json.get("save_version", 1)
    if v < CURRENT_SAVE_VERSION:
        json = migrate_save(json, v)
    return json

func migrate_save(save: Dictionary, from_version: int) -> Dictionary:
    if from_version < 2:
        save = _migrate_1_to_2(save)
    if from_version < 3:
        save = _migrate_2_to_3(save)
    if from_version < 4:
        save = _migrate_3_to_4(save)
    if from_version < 5:
        save = _migrate_4_to_5(save)
    save["save_version"] = CURRENT_SAVE_VERSION
    return save
```

### 2.1 Exemplos de migracao previstos

- **v1 -> v2:** adicionar campo `account_data.cronicas_do_mundo` (default `{ first_save_unix: now, memoria_do_tempo_pontos: 0, milestones_unlocked: [] }`).
- **v2 -> v3:** renomear `chars[]` para `characters[]`.
- **v3 -> v4:** itens passaram a ter `uuid` separado de `data_id`. Migration: gerar uuid v4 para cada item existente.
- **v4 -> v5:** estrutura de awakening passou de `stars: int` para objeto `awakening_state {stars, branches_chosen}`.

### 2.2 Estrategia geral

- **Nunca quebrar save antigo sem migracao.** Save antigo carregado em build novo deve sempre funcionar.
- **Migracao e push-only**: saves novos nao precisam abrir em build antigo.
- **Migracao testada:** cada `_migrate_X_to_Y` deve ter teste unitario com fixture de save da versao X.
- **Log de migracao:** ao migrar, append em `user://migration_log.txt` com `from -> to` e timestamp.

---

## 3. Save corruption recovery

### 3.1 Backup automatico (rotacao)

Sempre que o jogo for salvar:

1. Se `save.json` existe -> renomeia para `save.json.bak2` (sobrescreve antigo `bak2`).
2. Se `save.json.bak` existe -> renomeia para `save.json.bak2` (mas cuidado, ja foi renomeado em 1: usar nomes intermediarios).

**Algoritmo correto (3 slots rotativos, mais recente em `save.json`):**

```gdscript
func save_with_rotation(data: Dictionary) -> void:
    if FileAccess.file_exists("user://save_slot_1.json.bak"):
        DirAccess.copy_absolute(...)  # bak -> bak2
    if FileAccess.file_exists("user://save_slot_1.json"):
        DirAccess.copy_absolute(...)  # current -> bak
    write_json("user://save_slot_1.json", data)
```

### 3.2 Validacao de schema basica ao carregar

Ao carregar:

1. Tentar JSON parse de `save.json`. Se falhar -> usar `save.json.bak`.
2. Validar campos obrigatorios (`save_version`, `account_data`, `characters`). Se faltam -> usar `save.json.bak`.
3. Validar `integrity_hash` (sha256 do conteudo serializado sem o campo `integrity_hash`). Se hash nao bater:
   - Mostrar warning ao usuario: "Save modificado manualmente. Carregar mesmo assim?"
   - Sim -> carrega ignorando hash (modo cheat).
   - Nao -> tenta backup.
4. Se `bak` falha tambem -> tentar `bak2`.
5. Se tudo falhar:
   - Modal "Save corrompido. Opcoes:"
     - [Tentar recuperar parcial] (best-effort: pega o que conseguir)
     - [Comecar novo personagem]
     - [Cancelar (nao perde nada, fecha jogo)]

### 3.3 Backup manual

Botao no Settings: "Backup manual agora".
- Salva em `user://save_slot_1.json.manual_<timestamp>.bak`.
- Lista de backups manuais visivel em Settings com data + tamanho + opcao "Carregar este".
- Limite: maximo 10 backups manuais (ao criar 11, deleta o mais antigo, com confirmacao).

---

## 4. Offline progression

### 4.1 Quando o jogo fecha

- Salvar `last_offline_at_unix = Time.get_unix_time_from_system()`.
- Salvar estado completo (rotacao normal de backup).

### 4.2 Quando o jogo abre

```gdscript
var now = Time.get_unix_time_from_system()
var last = save.last_offline_at_unix
var delta_t_seconds = now - last
var cap_seconds = save.account_data.loja_eterna_compras.offline_cap_hours * 3600
delta_t_seconds = min(delta_t_seconds, cap_seconds)

if delta_t_seconds < 60:
    return  # menos de 1 min, ignora

simulate_offline_progress(save, delta_t_seconds)
show_offline_welcome_modal(...)
```

### 4.3 Simulacao por personagem

Para cada personagem em `characters[]`, com base em `current_activity.type`:

#### Combate

```
kills_per_second = combat_stats.kills_per_second_estimate(zone, stage, area)
total_kills = int(kills_per_second * delta_t)

xp_gained = total_kills * avg_xp_per_kill
gold_gained = total_kills * avg_gold_per_kill

# Drops uteis (materiais comuns) consolidam:
materials_dict = {}
for drop_id, drop_chance in drop_table:
    expected = total_kills * drop_chance
    if expected >= 1:
        # Aplica variancia (poisson aproximada): qty = round(expected * uniform(0.8, 1.2))
        materials_dict[drop_id] = int(expected * randf_range(0.8, 1.2))

# Drops raros: chance proporcional, item-a-item
rare_drops = []
for rare_drop in rare_drop_table:
    rolls = total_kills
    expected = rolls * rare_drop.chance
    # Para evitar gerar 1000 drops, processar como Poisson amostrado:
    qty = sample_poisson(expected)
    if qty > 0:
        rare_drops.append({drop_id: rare_drop.id, qty: qty})

# Aplicar XP (com level-up resolvido), gold, drops.
```

#### Gathering

```
nodes_per_second = mastery.gather_speed(item)
total_nodes = int(nodes_per_second * delta_t)
materials = total_nodes * yield_per_node
mastery_gain = total_nodes * mastery_xp_per_node
```

#### Expedicao

```
# Expedicao tem timer absoluto.
remaining = expedicao.start_unix + expedicao.duration - now
if remaining <= 0:
    expedicao.status = "completed_pending_collect"
```

#### Idle

Nada.

#### Sombra ativa (Espelho dos Gemeos)

```
if save.shadow_active_until_unix > now:
    # Sombra ainda ativa. Simular como personagem-fantasma com 50% stats.
    simulate_combat(shadow_character, delta_t)
elif save.shadow_active_until_unix > last:
    # Sombra expirou DURANTE offline. Simular ate expirar.
    delta_shadow = save.shadow_active_until_unix - last
    simulate_combat(shadow_character, delta_shadow)
```

### 4.4 Tela de Boas-Vindas Offline

Modal exibido na primeira tela apos load:

```
+----------------------------------------------------------------+
|        BEM-VINDO DE VOLTA                                      |
|        Voce ficou offline por: 8h 23min (capped 12h)           |
|                                                                |
| Warrior (combate em Floresta St 3):                            |
|   +12.450 XP    +890 Gold                                      |
|   +234 Slime Goo, +18 Madeira de Carvalho                      |
|   Itens raros encontrados: 2 (1x Espada de Bronze Uncommon)    |
|                                                                |
| Mage (mining em Caverna):                                      |
|   +1200 mastery xp em "mining_cobre"                           |
|   +180 Cobre, +45 Ferro                                        |
|                                                                |
| Ranger (pesca em Lago):                                        |
|   +320 mastery xp em "fishing_truta"                           |
|   +56 Truta, +8 Salmao                                         |
|                                                                |
| Sombra ativa (Warrior, 18h restantes):                         |
|   +6230 XP, +445 Gold, +120 Slime Goo                          |
|                                                                |
|        [Coletar tudo]                                          |
+----------------------------------------------------------------+
```

Notas:
- **Limite de drops simulados:** nao gerar 1000 entradas de drop separadas. Consolidar em "qty" por item.
- **Cap por classe de drop:** se `expected_drop > 999`, capar em 999 + flag de "limitado offline".
- **Performance:** simulacao deve completar em < 200ms para 5 personagens x 12h.

---

## 5. Cloud save (opcional)

[DECISAO PENDENTE: cloud save - Steam Cloud / Google Drive / proprio backend?].

Para fase posterior. Recomendacoes:
- **Steam Cloud:** mais simples se for distribuir via Steam. Auto-sync de pasta `user://`.
- **Google Drive / Dropbox API:** OAuth do usuario, complexidade media.
- **Backend proprio:** controle total, mas custo de hosting + obrigacao de manter.

Em todos os casos: **save local continua sendo a fonte primaria**. Cloud e backup/sync.

---

## 6. Testes do sistema de save

### 6.1 Testes unitarios

- Migrate de v1 para vN funciona.
- Schema validation rejeita save invalido.
- Hash de integridade detecta modificacao.
- Rotacao de backup nao perde dados.

### 6.2 Testes integrados

- Save -> close -> reopen -> tudo igual.
- Save -> close -> avancar relogio do sistema 8h -> reopen -> offline progress correto.
- Save -> corromper arquivo -> reopen -> recovery via .bak funciona.
- Save -> salvar 100 vezes seguidas -> tres backups rotativos consistentes.

### 6.3 Smoke test do offline

- Ferramenta de dev: botao "Simular 1h offline" no Dev Modal (`scenes/ui/dev_panel.gd`). Avanca `last_offline_at` em 3600s e roda simulacao sem precisar fechar o jogo.

---

## 7. Privacidade e GDPR-friendly

- Save fica **100% local**. Nao envia dados a nenhum servidor sem consentimento explicito.
- Caso cloud save seja adicionado, opcional + opt-in.
- Botao "Excluir todos os dados locais" no Settings -> Conta.

---

## Decisoes pendentes consolidadas

1. **[DECISAO PENDENTE: ofuscar o save]** — recomendacao: nao, mas validar com hash.
2. **[DECISAO PENDENTE: cloud save]** — Steam Cloud / Drive / proprio?
3. **[DECISAO PENDENTE: multiplos slots de save por instalacao]** — 1 ou 3?
4. ~~Cap default offline~~ (RESOLVIDO 2026-05-06 #18: **12h base**. Campo `offline_cap_hours` do save = 12 por default. Loja Eterna desbloqueia upgrades sucessivos para 24h, 48h e 72h em Renascimento+. Ver `00_meta/pending-decisions.md` #18).
5. **[DECISAO PENDENTE: simulacao offline considera mudancas de zona automaticas?]** — ex: personagem mata todos waves do estagio durante offline, deveria avancar para o proximo estagio? Recomendacao: sim, com cap (so avanca se a area ja foi 100%-cleared antes; nao "passa areas novas" automaticamente).
6. **[DECISAO PENDENTE: drops raros e cards offline]** — usar Poisson real ou aproximado? Poisson real e mais correto mas mais lento. Ate 1000 kills/h de cap pra evitar overflow numerico.
7. **[DECISAO PENDENTE: alteracao de relogio do sistema (cheating)]** — detectar `now < last_save` e usar `last_save` como referencia.
