# Localization Plan - i18n do Projeto

> Estrategia de internacionalizacao para suportar PT-BR (idioma primario) e expandir para EN/ES e potencialmente FR/JP/KR/ZH em fases tardias.
>
> **Quando comecar:** Fase 02 (Expansion). Antes disso e' cedo demais (muitas strings ainda mudam de redacao). Mais tarde gera divida tecnica grande.

---

## 1. Idioma primario

**PT-BR** e' o idioma de desenvolvimento. Todas strings nascem em portugues (Brasil) e sao traduzidas a partir dali.

Razao: usuario e' brasileiro, mais fluente para iterar rapido em diologos, lore, tooltips.

---

## 2. Idiomas alvo (em ordem)

**Release 1.0 (decidido 2026-05-06, #36):** PT-BR + EN apenas. Outros idiomas entram em updates pos-1.0.

1. **PT-BR** (primario, idioma de desenvolvimento).
2. **EN** (Ingles - mercado global Steam, obrigatorio para 1.0).
3. **ES** (Espanhol - mercado latino, custo baixo) - **pos-1.0**.
4. **FR** (Frances) - pos-1.0, conforme demanda.
5. **JP** (Japones) - pos-1.0, conforme demanda.
6. **KR** (Coreano) - pos-1.0, conforme demanda.
7. **ZH-CN** (Chines simplificado) - pos-1.0, conforme demanda.
8. **ZH-TW** (Chines tradicional) - pos-1.0, conforme demanda.

A escolha por 2 idiomas no 1.0 reduz custo de manutencao durante a fase de iteracao mais agressiva. Steam mostra `Languages: Portuguese - Brazil, English` na pagina da loja.

---

## 3. Estrategia tecnica

### Engine: Godot 4.6

Godot tem suporte nativo a localizacao via:
- `tr("CHAVE")` - retorna string localizada.
- `Translation` resource (`.translation`) carregado em `project.godot`.
- Fontes de dados aceitas: **CSV** ou **PO/POT**.

### Decisao: CSV (na Fase 02 inicial) -> migracao para PO em Release 1.0

**Justificativa:**
- CSV e' simples para comecar; cada coluna = um idioma.
- PO e' padrao da industria, melhor para tradutores profissionais e ferramentas como POEdit, Crowdin.
- Migrar de CSV para PO e' simples (script de conversao).

### Estrutura de arquivos

```
res://i18n/
  keys.csv               # base de strings (PT-BR + EN inicialmente)
  translation_pt_br.translation
  translation_en.translation
  translation_es.translation  # quando chegar
```

### Como extrair strings hardcoded

**Regra inegociavel:** A PARTIR DA FASE 02, toda nova string visivel ao jogador usa `tr("KEY")`. Strings antigas hardcoded em codigo serao migradas em uma sprint dedicada no inicio da Fase 02.

Padrao em codigo:
```gdscript
# RUIM
$Label.text = "Atacar"

# CERTO
$Label.text = tr("combat.button.attack")
```

`keys.csv` exemplo:
```
key,pt_br,en
combat.button.attack,"Atacar","Attack"
combat.button.flee,"Fugir","Flee"
ui.modal.title.inventory,"Inventario","Inventory"
```

---

## 4. Naming convention de keys

Padrao: `<area>.<elemento>.<modificador>`

Exemplos:
- `combat.button.attack` - botao de atacar no combate.
- `combat.button.flee` - botao de fugir.
- `ui.modal.title.inventory` - titulo do modal de inventario.
- `npc.taverneiro.greeting_1` - dialogo do taverneiro.
- `npc.taverneiro.greeting_2` - dialogo alternativo.
- `item.training_sword.name` - nome do item.
- `item.training_sword.desc` - descricao do item.
- `skill.warrior.cleave.name` - nome da skill.
- `skill.warrior.cleave.desc` - descricao da skill.
- `enemy.slime_green.name` - nome do inimigo.
- `enemy.slime_green.lore` - lore do inimigo no codex.
- `zone.floresta.name` - nome da zona.
- `zone.floresta.description` - descricao para mapa.
- `tutorial.combat.step_1` - passo 1 do tutorial de combate.
- `event.harvest_festival.title` - evento sazonal.
- `achievement.first_kill.title` - achievement.
- `achievement.first_kill.desc` - descricao do achievement.

**Areas comuns:**
- `combat.*` - tudo do combate.
- `ui.*` - chrome de UI (botoes, labels generic).
- `modal.*` - titulos e textos de modais.
- `item.*` - items (name, desc, lore).
- `skill.*` - skills (name, desc, tooltip).
- `enemy.*` - inimigos (name, lore).
- `zone.*`, `area.*`, `stage.*` - mundo.
- `class.*` - classes.
- `npc.*` - dialogos.
- `quest.*` - quests.
- `tutorial.*` - tutoriais.
- `event.*` - eventos.
- `achievement.*` - achievements.
- `title.*` - titulos.
- `seal.*` - selos.
- `card.*` - cards.
- `pet.*` - pets.
- `tooltip.*` - tooltips de stats, buffs, etc.
- `error.*` - mensagens de erro/aviso.

---

## 4.1 Convencao de Termos (decidido 2026-05-06, #39)

Estrategia **MISTA**: termos universais do genero idle/RPG ficam em INGLES em ambas versoes (player ja conhece, evita traducao "estranha"); termos narrativos/proprios do projeto traduzem normalmente.

### Termos em INGLES nas duas versoes (PT-BR e EN)

Acrosnimos e jargao de combate/idle padronizados internacionalmente:

| Termo | Categoria |
|---|---|
| DPS | combate |
| Tank | combate |
| AoE | combate |
| HP | combate |
| MP | combate |
| ATK | combate |
| DEF | combate |
| Buff | combate |
| Debuff | combate |
| Crit / Critical | combate |
| Lifesteal | combate |
| Cooldown | combate |
| Mob | combate |
| Spawn | combate |
| Drop / Drop rate | loot |
| Loot | loot |
| Shiny | inimigo |
| Elite | inimigo |
| Boss | inimigo |
| Mob Slaughter | sistema (ja em ingles no original) |
| Kill Stack | sistema (ja em ingles no original) |
| XP | progressao |
| Idle | genero |
| Tier | item |
| Stack | combate |
| Proc | combate |
| Hit / Hit Chance | combate |

Justificativa: jogador de idle/RPG espera ver "DPS", "Tank", "Buff" em qualquer versao; traduzir gera friccao ("Dano por Segundo" ocupa 3x o espaco e parece amador). Texto em UI compacta agradece.

### Termos TRADUZIDOS

Conceitos narrativos, sistemas-marca do projeto e termos de mundo:

| EN | PT-BR | Notas |
|---|---|---|
| Awakening | Acordar (ou Despertar) | sistema-marca |
| Mob Slaughter | manter "Mob Slaughter" | excecao: e' termo-marca, fica em ingles |
| Mastery | Maestria | progressao de item |
| Bestiary | Bestiario | codex |
| Rebirth | Renascimento | prestigio 1 |
| Transcendence | Transcendencia | prestigio 2 |
| Ascension / Cosmic Ascension | Ascensao / Ascensao Cosmica | prestigio 3 |
| Camp / Village / City / Kingdom / Empire | Acampamento / Vilarejo / Cidade / Reino / Imperio | progressao do hub |
| Constellation | Constelacao | arvore late-game |
| Cosmic Forge | Forja Cosmica | end-game |
| Library of the Ancients | Biblioteca dos Antigos | end-game |
| Mirror of the Twins | Espelho dos Gemeos | end-game |
| World Chronicles | Cronicas do Mundo | end-game |
| Seal | Selo | achievement |
| Title | Titulo | achievement |
| Glory | Gloria | moeda Arena |
| Dungeon Token | Token de Dungeon | moeda |
| Gems of Eternity | Gemas da Eternidade | moeda premium |
| Galactic Coin | Moeda Galactica | moeda Ascensao |
| Stellar Shard | Esquirla Estelar | material end-game |
| Memory of Time | Memoria do Tempo | recompensa |
| Spirit Pact | Pacto com Espiritos | faccao |
| Limit Break | Quebra de Limite | crafting |
| Reforge | Reforjar | crafting |
| Refine | Refinar | crafting |
| Enchanting / Enchantment | Encantamento | crafting |
| Codex | Codice / Codex | aceitar ambos; prefere "Codex" curto |
| Star (Awakening) | Estrela | "★3" lido como "tres estrelas" / "star three" |
| Card Corrupted / Greedy | Card Corrompido / Card Cobicoso | items de Elite/Shiny |
| Stat Stone | Pedra de Stat | "Stat" fica em ingles dentro do termo |
| Pet | Pet | aceitar como emprestimo (universal) |
| Skill | Skill | emprestimo (player de RPG aceita) |

### Casos hibridos

Quando o termo cabe nas duas listas, decidir caso a caso conforme feedback de player. Exemplo: "Skill Tree" pode virar "Arvore de Habilidades" ou ficar "Skill Tree" — testar com jogadores e fixar.

Cross-ref `glossary.md` para definicoes; cross-ref secao 9 deste arquivo para tabela de tradutor.

---

## 5. Pluralizacao e gender (delicado em PT-BR)

PT-BR tem flexao de genero (masculino/feminino) e numero (singular/plural) que afetam quase toda string com substantivo+adjetivo.

**Estrategia:**
- **Genero:** todo personagem tem `pronoun_set` (ele/ela). Strings usam placeholders `{personagem.nome}`, `{personagem.classe.flexao_genero}`. Ex: "{personagem.nome} foi {derrotado_a}" -> resolver em runtime para "derrotado" ou "derrotada".
- **Plural:** Godot tem suporte a plural via segunda string em CSV/PO. Usar quando aplicavel.
- **Placeholders:** usar `{0}`, `{1}` ou `{nome_var}` em strings: `"{nome} ganhou {qtd} de gold"`.

Exemplo CSV:
```
key,pt_br,en
combat.victory,"{personagem} foi vitorioso{a}!","{personagem} was victorious!"
```

`{a}` resolvido por funcao `localize_with_gender()` baseada no pronoun_set do personagem.

**Decisoes especificas:**
- `[DECISAO PENDENTE: queremos suportar pronome neutro (elu/delu) desde o inicio?]`
- Se sim, todas keys com flexao precisam de 3 variantes (m/f/n).

---

## 6. QA de localizacao

### Revisao por nativo
- PT-BR: usuario revisa.
- EN: `[DECISAO PENDENTE: tradutor profissional ou speaker fluente conhecido?]`. Custo estimado para 5000 strings: 200-500 USD.
- ES: idem.

### Teste de UI overflow

Strings em ingles tendem a ser **20-30% maiores** que portugues em alguns casos (e o oposto em outros). Strings em alemao podem ser **40% maiores**. Strings em japones/chines sao curtas mas verticalmente densas.

**Procedimento de QA:**
1. Trocar idioma para EN.
2. Verificar todas modais, botoes, tooltips.
3. Procurar texto cortado, overflow, quebras feias.
4. Ajustar layout (auto-resize ou abreviacao).

Testes prioritarios:
- Botoes principais (Attack, Flee, Buy, Sell).
- Tooltips de stats.
- Nomes de skills/items longos.
- Notificacoes de achievement.
- Tutorial.

### Validacao
Cada release oficial passa por:
- 1 sessao completa em PT-BR (jogabilidade).
- 1 sessao completa em EN (UI overflow + sentido).
- Idiomas adicionais: revisao por nativo + screenshots de telas-chave.

---

## 7. Quando comecar

| Marco | Acao |
|---|---|
| Fase 00-01 | Strings hardcoded sao toleradas (proto). Documentar em `[TODO: localizar]` quando aparecerem. |
| **Fase 02 (inicio)** | **Primeira sprint dedicada a i18n.** Migrar strings existentes para `tr()`. Criar `keys.csv` PT-BR. |
| Fase 02 (meio) | Adicionar coluna EN ao CSV. Comecar tradutor revisando. |
| Fase 03 | Adicionar ES. UI overflow audit. |
| Release 1.0 | Migrar de CSV para PO. Idiomas oficiais: PT-BR + EN + ES (proposta). |
| Pos-1.0 | Idiomas adicionais conforme demanda. |

---

## 8. Riscos

- **Critico:** comecar tarde demais. Estimado: tradutor leva 2-4 semanas para 5000 strings. Comecar a juntar strings cedo.
- **Critico:** mudar redacao de strings ja traduzidas. Cada mudanca requer re-traducao. Mitigacao: estabilizar redacao PT-BR antes de pedir traducao.
- **Medio:** UI overflow descoberto perto do release. Mitigacao: audits regulares.
- **Medio:** termos do dominio (Awakening, Transcendencia) com traducao errada. Mitigacao: glossario de localizacao (subset do `glossary.md`) compartilhado com tradutor.

---

## 9. Glossario de localizacao (subset)

Termos do projeto que tradutor precisa manter consistencia. Cross-ref `glossary.md`.

| PT-BR                    | EN sugerido             | Notas             |
| ------------------------ | ----------------------- | ----------------- |
| Acampamento              | Camp                    | estagio 1         |
| Vilarejo                 | Village                 | estagio 2         |
| Cidade                   | City                    | estagio 3         |
| Reino                    | Kingdom                 | estagio 4         |
| Imperio                  | Empire                  | estagio 5         |
| Renascimento             | Rebirth                 | prestigio nivel 1 |
| Transcendencia           | Transcendence           | prestigio nivel 2 |
| Ascensao Cosmica         | Cosmic Ascension        | prestigio nivel 3 |
| Estrela (Awakening)      | Star                    | ★                 |
| Despertar                | Awakening               |                   |
| Constelacao              | Constellation           |                   |
| Forja Cosmica            | Cosmic Forge            |                   |
| Biblioteca dos Antigos   | Library of the Ancients |                   |
| Espelho dos Gemeos       | Mirror of the Twins     |                   |
| Cronicas do Mundo        | World Chronicles        |                   |
| Selo                     | Seal                    |                   |
| Selo de Lideranca        | Leadership Seal         |                   |
| Titulo                   | Title                   |                   |
| Glória                   | Glory                   |                   |
| Token de Dungeon         | Dungeon Token           |                   |
| Gemas da Eternidade      | Gems of Eternity        |                   |
| Moeda Galactica          | Galactic Coin           |                   |
| Esquirla Estelar         | Stellar Shard           |                   |
| Pontos de Transcendência | Transcended Points      |                   |
| Memoria do Tempo         | Memory of Time          |                   |
| Pacto com Espiritos      | Spirit Pact             |                   |
| Mob Slaughter            | Mob Slaughter           | manter ingles     |
| Kill Stack               | Kill Stack              | manter ingles     |
| Card Corrupted           | Corrupted Card          |                   |
| Card Greedy              | Greedy Card             |                   |
| Pedra de Stat            | Stat Stone              |                   |
| Quebra de Limite         | Limit Break             |                   |
| Reforjar                 | Reforge                 |                   |
| Refinar                  | Refine                  |                   |
| Bestiario                | Bestiary                |                   |
| Códice                   | Codex                   |                   |
| Maestria                 | Mastery                 |                   |

---

## 10. Decisoes pendentes

**Resolvidas (2026-05-06):**
- ~~Lista oficial de idiomas no Release 1.0~~ (#36): PT-BR + EN. Outros pos-1.0.
- ~~Estrategia de traducao de termos do dominio~~ (#39): MISTA. Ver secao 4.1.

**Ainda em aberto:**
- `[DECISAO PENDENTE]` (#37): suportar pronome neutro (elu/delu) em PT-BR desde o inicio? Impacto: triplicar variantes (m/f/n) em todas keys com flexao de genero. Decisao influencia diretamente o design do `pronoun_set` em `character_instance.gd`.
- `[DECISAO PENDENTE]` (#38): EN traduzido por tradutor profissional ou voluntario/speaker fluente conhecido? Custo estimado: 200-500 USD para 5000 strings via profissional. Decisao influencia o cronograma de localizacao na Fase 02.

---

## Cross-references

- `glossary.md`
- `release-plan.md`
- `self-instructions.md`
- `roadmap-sistemas.md`
