# Idle RPG — Roadmap Completo de Sistemas

> **Status do documento:** v1.1 — adicionado: Crusaders of the Lost Idols, Realm Grinder, Idle Heroes, Idle Skilling. Reformulações em 3.24 (formação 3x2), 3.19 (Awakening com ramos), 4.6 (alinhamentos mutuamente exclusivos).
> **Paradigma confirmado:** multi-personagem estilo IdleOn (cada um farma em paralelo, juntam-se em dungeons/bosses) + auto-battle puro (decisão antes do combate) + roadmap completo em fases (3-5 anos)

---

## 0. Como ler este documento

Este documento é um **mapa de longo prazo**, não um plano de sprint. Está organizado em camadas:

1. **Princípios e pilares** — as decisões macro que regem tudo
2. **Síntese de referências** — o que extraí dos jogos pesquisados
3. **Catálogo de sistemas** — cada sistema da sua lista, refinado, com dependências
4. **Mecânicas de bônus extras** — minhas sugestões complementares ao World Tree, Titanica e Constelações
5. **Resoluções de ambiguidade** — propostas para os pontos que estavam vagos (ex: "várias armas só pelos stats")
6. **Matriz de dependências** — o que precisa do quê
7. **Roadmap em fases** — o que entra primeiro, depois, etc.
8. **Decisões pendentes** — perguntas que ainda precisam de resposta sua

Itens marcados com **[DECISÃO]** são pontos que ainda dependem de você confirmar uma direção.
Itens marcados com **[SUGESTÃO]** são propostas minhas, abertas a discussão.
Itens marcados com **[NOVO]** são adições que não estavam na sua lista original.

---

## 1. Princípios e Pilares

### 1.1 O loop core

Todo idle vive de **três loops aninhados** que precisam coexistir, sob pena do jogo virar tédio:

- **Curto (segundos):** o personagem mata um inimigo → pop de dano + XP + dropzinho. Feedback constante.
- **Médio (minutos):** completa uma área → tela de resultados → progresso visível em algum tracker (maestria, kill stack, quest concluída, etc).
- **Longo (horas/dias):** completa uma zona inteira → desbloqueia personagem, mecânica de bônus, ou prepara um prestígio.

A regra inegociável: **todo upgrade que o jogador compra/dropa precisa afetar pelo menos um desses loops de forma perceptível.** Stat invisível morre.

### 1.2 Paradigma multi-personagem (IdleOn-style)

Implicações arquiteturais que precisam estar claras desde o dia 1:

- **Cada personagem é uma instância independente de combate ou atividade.** Quando você está vendo o Personagem A no combate, o Personagem B continua minerando em outra cena, o C pescando, etc. Tudo em paralelo, com tempo real.
- **Save é por personagem + dados de conta.** Existem stats globais (ouro, materiais, desbloqueios, mecânicas de bônus) e stats individuais (nível, equip, skill points, kill counts).
- **Trocar de personagem = trocar a "câmera"**, não pausar o resto. UI precisa deixar claro o que cada personagem está fazendo agora (idle screen no estilo "roster overview" como tela inicial).
- **Progressão offline é central.** Quando o jogador fecha o jogo, todos os personagens continuam ganhando recursos até um teto (12h, 24h, escalável com upgrades).
- **Classes diferentes farmam diferente.** Guerreiro é eficiente em mineração e combate corpo-a-corpo, mago em alquimia e magia, ranger em caça/coleta de ervas, etc. Cria decisão de "qual personagem mando pra qual atividade".
- **Dungeons e bosses são o ponto de convergência.** É lá que a party (3-5 personagens) se reúne e o jogador finalmente vê os builds combinarem.

### 1.3 Auto-battle puro

Implicações de design:

- **Build é o jogo.** Toda decisão é antes da luta: equipamento, talentos, skills equipadas, formação (em dungeons), prioridades de skill.
- **Skills com cooldown viram fila de prioridade.** O jogador define ordem/condição (ex: "Heal quando HP < 50%", "Buff quando CD pronto", "AoE quando 3+ inimigos") e o sistema executa, exceto se não configurado, então tudo ocorre baseando-se em cooldown, quando algo termina o cooldown, já é usado imediatamente, caso o jogador não defina.
- **Combate precisa ser visualmente legível.** Como o jogador só assiste, números flutuantes, ícones de status e barras precisam contar a história sozinhos.
- **Velocidade variável (2x/4x/8x) é essencial** porque o jogador precisa pular animações em farm, mas voltar pra 1x em bosses pra ler o combate. Implementação: `Engine.time_scale` afeta combate/animações; timers reais (offline, daily quests, gathering) usam relógio do sistema.

### 1.4 Conexões críticas (o "mapa do tesouro")

A graça de um idle denso é que **todo sistema alimenta 2-3 outros**. Diagrama mental:

- **Combate** dropa: gold, equipamento, materiais raros, **cards** (álbum), drops do **kill stack**, contagem extra para o bestiário
- **Coleta** (mining/wood/etc) gera: materiais para crafting, alimenta **mecânicas de bônus** (Titanica, Árvore do Mundo)
- **Crafting** consome materiais e produz: equipamento, consumíveis, **encantamentos**
- **Bestiário** dá: buffs por completar fichas, possíveis **passivas globais**
- **Cards** dão: Sensação de progressão ao colecionar o álbum **buffs** para o **combate**, insentivo para aumentar a **taxa de drop**
- **Acampamento** é o **hub**: aloja estruturas para quase todas as atividades acima
- **Prestígio/Ascensão** reseta personagem/conta e dá moeda de meta-loja (Gemas da Eternidade)→ libera **automatizações, slots, melhorias permanentes**
- **Constelações/Mecânicas de bônus** são os "vasos comunicantes" do late-game: cada uma é um mini-sistema próprio que modifica o resto

---

## 2. Síntese de Referências Pesquisadas

### Jogos que você listou

**IdleOn MMO (Legends of IdleOn)** — Para nós é a referência mais direta. O que extrair: estrutura de múltiplos personagens em paralelo, especialização por classe (cada classe é melhor em certas coisas), sistema de "stamps" e "bribes" que dão buffs globais para todos os personagens, mecânica de "talents" com pontos de stat distribuíveis, "Cards" dropados de monstros que podem ser equipados em sets (3, 5, 7) para bônus.


**Cookie Clicker** — Princípios extraídos, não mecânicas. O que importa: a estrutura matemática dos custos exponenciais, a constante introdução de mini-sistemas (Garden, Stock Market, Pantheon, Dragon) que são efetivamente sub-jogos dentro do jogo, e a paciência de design — Cookie Clicker NÃO empilha sistemas no início, ele revela conforme o jogador progride.

**Incremental Epic Hero 2** — Densidade absurda de stats e árvores de talento. Mostra que se você der uma UI clara, o jogador suporta dezenas de stats diferentes. Confirma sua intuição de ter Magic Attack, Magic Defense, Crit Chance, etc. separados.

**Idle Slayer** — Active idle com pixel art, combate satisfatório com side-scrolling. Pra nós, lição principal: **efeitos visuais de combate importam muito quando o jogador só assiste.** Slow-motion em crit, screen shake em kill streak, partículas em element damage.

### Jogos novos pesquisados (que você não listou)

**Melvor Idle** — Inspirado em RuneScape, é a referência ABSOLUTA para a parte de coleta/profissões da sua lista. 29 skills (9 combat + 20 não-combat), todas com mastery individual por item/atividade. Não tem prestígio (decisão deliberada). Tem progressão offline real até 24h. **O que extrair:** sistema de Mastery por item específico (não só por skill — você tem nível em "pescar trutas" separado de "pescar tubarões"), interconexão obrigatória das skills (mineração → smithing → combate), Township (tipo seu Acampamento que evolui).

**NGU Idle** — Densidade de prestígio levada ao limite. Camadas: Rebirth (reseta cada run), Tiers/Sadistic (modos de dificuldade), Hacks (multiplicadores que decaem em velocidade), Wishes, Macguffins, Augments. **O que extrair:** a noção de que cada "feature" desbloqueada deve ter uma curva própria de progresso, visível no UI principal, e que prestígios consecutivos viram a moeda de longevidade do jogo.

**Crusaders of the Lost Idols [NOVO]** — Idle de formação com sinergias por adjacência. Cruzados ficam em uma grade fixa (front/middle/back); cada um tem auras com range específico (afeta vizinhos diretos, mesma coluna, mesma linha, etc). Trocar a posição de um Cruzado reformula todas as sinergias da party. **O que extrair:** formação não é só decorativa — é um quebra-cabeça mecânico real. Aplica diretamente na nossa Dungeon Party (3.24). Sem isso, party de 5 personagens vira "5 personagens de pé enfileirados," que é desperdício do paradigma multi-personagem.

**Realm Grinder [NOVO]** — Sistema de **facções mutuamente exclusivas** que reformulam o jogo todo. Você se alia com Bem (Fairy/Elf/Angel), Mal (Demon/Undead/Goblin) ou Neutro (Druid/Mercenary/Dwarf), e isso muda quais buildings você pode construir, quais spells, quais bônus de research. Reincarnação permite trocar. **O que extrair:** o conceito de **escolha que importa em escala macro**. Aplico isso fundindo Pacto com Espíritos (4.6) com a ideia de alinhamento — em vez de "subir Pacto Fogo às vezes reduz Pacto Água", facções inteiras competem entre si.

**Idle Heroes [NOVO]** — Coleção de heróis com 6 facções (Fortress/Forest/Abyss/Shadow/Light/Dark), Hero Stars (1-10★ via duplicatas/fusão), e Awakening (transcendência a tier maior, com ramos de evolução que o jogador escolhe). **O que extrair:** ascensão de personagem (3.19) com ramos. Em vez de só ★1→★5 linear, em ★3 ou ★5 o personagem ganha um nó de escolha (ex: Guerreiro pode evoluir para "Cavaleiro Sagrado" ou "Berserker do Caos"), reformulando build, skills, e visual.

**Idle Skilling [NOVO]** — Mesmo dev do IdleOn, versão solo simplificada. Sistema de pets mais desenvolvido (raids de pets independentes), forja com slots de gemas, e a mistura skilling + combat é exatamente o que você quer. **O que extrair:** referência primária junto com IdleOn. Particularmente útil para o sistema de Pets (3.13) — Idle Skilling tem pets ativamente farmando enquanto o personagem faz outra coisa, modelo que vale considerar para o "papel Gather" dos nossos pets.

### Jogos extras (menção honrosa)

**Milky Way Idle [NOVO]** — Multiplayer Idle RPG estilo Runescape, com marketplace player-driven e leaderboards. Vale conhecer pra futuro caso queira adicionar componente social/online (não é prioridade agora, mas dá pra deixar a porta aberta).

**Idle Iktah [NOVO]** — Pequeno mas com uma ideia que destacou: **interdependência ecológica entre recursos.** Se você sobreexplora um recurso, cadeias de produção downstream colapsam. Ideia que pode ser adaptada como mecânica anti-grind degenerado: regiões "esgotam" e precisam ser rotacionadas. **[SUGESTÃO]** vou propor uma versão disso na seção de mecânicas extras.

**Almost a Hero, Idle Champions, AFK Arena** — Referências de sistema de party/formação. Como sua party só aparece em dungeons/bosses, vale dar uma olhada na UI deles, mas a maior parte das mecânicas (sinergias de fação, formações de combate) podem ser muito "RPG mobile gacha" pra sua proposta. Use com moderação.

---

## 3. Catálogo Completo de Sistemas

Cada subsistema abaixo segue o formato:
- **Função** — o que ele resolve no jogo
- **Dependências** — o que precisa existir antes
- **Conexões** — o que ele alimenta ou é alimentado por
- **Notas de design** — refinamentos, alternativas, riscos

### 3.1 Combate (já existente, refinar)

**Função:** loop curto principal. Onde o jogador passa o tempo "ativo" e onde o personagem em foco está farmando.

**Estado atual:** Zona → 5 estágios → 10 áreas → N waves. Funciona.

**Refinamentos propostos:**

- **Modal de info da área/estágio/zona** com: inimigos presentes, drops possíveis (com taxas), recomendações de stat (HP min, DPS min para idle eficiente), elementos predominantes, materiais coletáveis nessa zona, NPCs presentes, status de completude (% áreas limpas, % bestiário).
- **Tela de resultados pós-clear**: mostrar XP ganho, drops, kill stack progresso, qualquer trigger que disparou (raid, elite, etc.).
- **Inimigos elite**: spawn aleatório com chance ~2-5% por wave, multiplicador de stats (1.5-3x), drop especial garantido (maior quantidade de materiais, EXP, Gold e material raro ou card de elite).
- **Mini-bosses e bosses** — boss no estágio 10 de cada zona. Mini-boss em áreas específicas (ex: entre as áreas 5~7 de cada estágio).
- **Inimigos Elite:** Aparecem raramente em condições comuns, tem stats maiores que os comuns da sua versão, geralmente tem algum buff especial também, porém ao passar pelo desafio, dropam o loot comum em 3x, além de loot raro do inimigo garantido, e chance de drop exclusívo.
- **Raids**: trigger condicional: após X kills no kill stack daquela zona, jogador pode "ativar raid" gastando recurso (energia/token), substituindo o farming normal por uma raid de 30-50 waves seguidas com drop rate aumentado (~3x) e chance de raid boss único. Além do Trigger, ela tem chance de ativar com o tempo (A cada 10:00-12:00 minutos por exemplo) em um mapa aleatório.

### 3.2 Stats do jogador e inimigos

**Função:** o vocabulário matemático do jogo. Define o que pode ser modificado, encantado, buffado, debuffado.

**Lista consolidada (sua + minhas adições):**

- **Stats primários:** STR, DEX, INT, VIT, LUK (afeta crit, drop, esquiva)
- **Stats derivados de combate:** HP, MP, Physical Attack, Magic Attack, Physical Defense, Magic Defense, Hit Number, Attack Speed, Cast Speed, Cooldown Reduction
- **Stats de regen:** HP Regen, MP Regen, Life Steal, MP Leech
- **Stats de chance:** Crit Chance, Magic Crit Chance, Crit Damage, Block Chance, Dodge Chance, Hit Chance, Resist Status (% por status), Extra Hit, Accuracy (pode ser reduzida em estágios avançados de mais se comparado ao último estágio completo, e por debuffs, faz com que o jogador dê "Missed" nos golpes)
- **Stats elementais (por elemento — Fire/Ice/Electric/Water/Wind/Rock/[NOVO] Light/Dark):** Elemental Damage % por elemento, Elemental Resistance % por elemento
- **Stats de aquisição:** EXP Gain %, Gold Gain %, Loot Gain % (drops em geral), Equip Drop Chance %, Material Drop Chance %, Card Drop Chance %
- **Stats meta:** Skill EXP Gain % (afeta gain de XP em skills de coleta), Mastery EXP Gain %

**Tipos de ataque**: Estocada (stab), Corte (slash), Esmagamento (crush), Golpe Corporal (blunt), Mágico (magic), Perfuração (pierce), Dilacerar (lacerate). 
**[SUGESTÃO]** cada arma tem 1-2 tipos predominantes; cada inimigo tem resistências/fraquezas. Cria meta-decisão de "que arma equipar pra esse boss".

Exemplos:
Espadas: Slash
Lanças e Rapieiras: Stab
Clava: Crush
Punhos, Luvas de Combate: Blunt
Machado: Lacerate
Adagas: Slash + Stab
Katana: Slash + Lacerate
Giant Swords: Crush + Lacerate
Arco e Flecha: Pierce
Armas de Fogo: Pierce + Lacerate
Tomos, Cajados, Varinhas: Magic

### 3.3 Status de batalha (debuffs/buffs)

**Função:** profundidade tática sem precisar do jogador clicar.
- **Stats:** 
	- Poison, Burning (Causa Damage Over Time no inimigo por um certo tempo).
	- Slowed (Reduz a velocidade de ataque)
	- Blind (Reduz a chance de acerto de golpes e habilidades)
	- Bleeding (Ao stackar "Lacerate" no inimigo até 20x, explode um multiplicador que causa um dano massivo no alvo.)
	- Freeze, Curse, Stun, Petrified (Impossibilita o personagem de atacar tanto normalmente, quanto com habilidades)
	- Silence (não pode usar habilidades)
	- Disarm (sem ataque físico)
	- Weakess (causa menos dano)
	- Broken Armor (defesa reduzida)
	- Health Regen (Restaura o HP com o tempo)
	- Mana Regen (Restaura o MP com o tempo)
	- ATK Up! (Aumenta o dano físico)
	-  Def Up! (Aumenta a defesa física)
	- (Outras variações de Up! para outros stats base)
	- Variações de Up!! e Up!!! para os mesmos stats (amplificando mais os bonus).
	- Shielded (absorve N de dano)
	- Thorns (devolve % de dano físico)
	- Reflect (devolve % de dano mágico)
	- Berserker (estado de fúria, aumenta o ataque, velocidade de ataque, porém recebe dano ao longo do tempo)
	- Extasis (não recebe danos e se regenera por um certo tempo, porém não pode executar outras ações)
	- Confused (ataques são voltados aos aliados, durante o efeito, não pode usar habilidades)

**Notas:**
- Cada status tem **chance de aplicação** (do atacante) vs **resistência** (do alvo). Resistência não anula o efeito, pode diminuir o dano causado, ou o tempo sob-efeito do debuff/buff, o personagem só se torna imune ao debuff/buff se a resistência chegar a 100%.
- Status podem **se acumular em stacks** (até um máximo) ou apenas se renovar em duração — defina isso por status, não global.
- Inimigos também aplicam status no jogador. Builds podem focar em "imunidade total a Freeze" como counter de zona específica.

### 3.4 Categorização de inimigos

**Função:** permite que itens, skills, encantamentos e cards tenham efeitos condicionais ricos ("dano +30% contra Dragões", "Freeze chance +50% em Aquáticos").

**Sua taxonomia (mantida e refinada):**

- **Raça:** Human, Slime, Animal, Golem, Bird, Devil, Angel, Dragon, Elemental, Undead, Plant, Insect, Construct, Aberration, Robot/Drone, Spirit
- **Comportamento:** Grounded, Flying, Ghost, Ethereal, Aquatic, Burrowing, Climbing
- **Tipo de combate:** Melee, Ranged, Support, Totem, Summoner, Tank, Caster, Berserker, Healer
- **Elemento principal:** [um dos elementos definidos]
- **Tipo de ataque**: Os tipos de ataque definidos acima também se aplicam aos inimigos, contra o jogador.

**Nota:** cada inimigo carrega múltiplas tags (raça + comportamento + tipo + elemento, tipo de ataque), o que cria espaço enorme pra modificadores condicionais.

### 3.5 Equipamento

**Slots:**
- Armadura: Capacete, Peitoral, Calças, Botas (4 slots)
- Acessórios: Colar, Brincos (1 slot), Anéis (2 slots), Bracelete (1 slot)
- Arma: 1 slot
- Picareta: 1 slot
- Machado: 1 slot
- Vara de Pesca: 1 slot

**Total: ~10 slots equipáveis de equipamentos, 3 slots de ferramentas.**

**Slots visuais:** Armadura e Arma podem ter um slot apenas visual, como um transmog. Itens equipados em slots visuais não passam stats ao personagem, pode ter também um slot de asas.
**Skin Completa:** Substitui completamente a armadura separada, e aplica uma skin exclusiva ao personagem, que muda completamente sua aparência, e retrato.

**Atributos de cada equipamento:**

- **Tier/Raridade** (ex: Common, Uncommon, Rare, Epic, Legendary, Mythic) — **[DECISÃO]** quantos tiers? 5 ou 6 é o sweet spot.
- **Nível do item** (afeta stats base)
- **Stats fixos** (definidos pelo tipo do item)
- **Affixes/atributos aleatórios** (rolados no drop ou crafting)
- **Encantamento** (slot adicional, aplicado depois — ver 3.13)
- **Slot de gema/runa** aplicar gemas para mais customização
- **Set bonus** usar 3/5/7 peças do mesmo set ativa bônus.

### 3.6 Crafting de equipamentos

**Dependências:** materiais (de coleta + drops), receitas (desbloqueadas por progressão), estação de crafting (no Acampamento).

**Camadas de crafting:**

1. **Crafting de equipamentos** — armaduras, armas, acessórios, materiais mais complexos, itens de quest, utilitários, chaves, etc.
2. **Smelting** — local de refinamento de barras de itens mineráis.
3.  **Sawmill** — local de refinamento de toras de madeira.
4. **Kitchen** — local de cozinhar com ingredientes de plantação, drops de inimigos, etc.
5. **Leatherworking** — local de refinamento de couro dropado dos animais de caça.
6. **Enchanting** — aplicar encantamentos em equipamentos prontos (ver 3.13).
7. **Alquimia** — não é equipamento, mas faz parte: poções, óleos, reagentes.

"tiers de receitas" — uma receita Common produz item Common; receitas raras (descobertas por achievements, drops, NPCs) produzem itens de tier maior.

### 3.7 Melhoria de equipamentos (upgrade/refine)

**Função:** sink de materiais, garante que equipamento "antigo legal" possa continuar relevante.

**Sistema sugerido [SUGESTÃO baseada em padrões do gênero]:**

- **Reforjar:** consome materiais, re-rola affixes (não muda tier ou nível).
- **Refinar (+1, +2... +20):** consome materiais + fragmentos, sobe stats base do item. Cada nível tem chance de falha crescente; equip pode ser destruído sem proteção (consumível "scroll de proteção").
- **Refinar Transcendental** tier extra late-game. 
- **Evoluir:** transforma item Common+10 em Uncommon+0, mantendo affixes. Caminho de progressão para itens favoritos.
- **Quebra de Limite:** combinar 3 itens do mesmo tier para tentar 1 item do tier superior, ou usar pedra especial com chance de falha, falhar tem chance de reduzir o nível do equipamento, itens que garantem permanencia podem ser utilizados, mas serão raros. Até 10 estrelas.
- **Refinamento de Stat:** utiliza pedras de stat base (ATK,DEF,etc.) para boostar esse stat específico da arma. Pedras de stat variam de nível entre 1 e 8, cada uma buffa um valor acima do anterior, devem ser valores flat, pode ser que ajude no inicio, e mais pra frente não seja tão forte assim, mas não quero usar porcentagem aqui para não desbalancear.

**Conexão crítica:** isso resolve um problema clássico — quando o jogador acha um item Legendary com affix perfeito mas o nível tá baixo. Refinar e evoluir mantém esse item viável.

### 3.8 Encantamentos

**Função:** camada extra de customização aplicada sobre equipamento já existente.

**Sistema proposto:**

- Cada equipamento tem **N slots de encantamento** (1-3 dependendo do tier).
- Encantamentos são **descobertos** via:
  - Drop raro de inimigos elite/boss
  - Receitas em pergaminhos (NPCs, achievements)
  - Decifrados de fragmentos coletados
- **Aplicar encantamento** consome o pergaminho + materiais + ouro.
- **Remover encantamento** é caro mas possível, libera o slot.
- Encantamentos podem ser utilizados tanto em armas, armaduras, acessórios, porém existem encantamentos específicos para essas 3 categorias.

**Exemplos:** "Sede de Sangue" (HP leech +5%), "Filho do Dragão" (dano +30% vs Dragões), "Toque do Inverno" (Freeze chance +10% em ataques físicos).

- **Tiers de encantamento:** Encantamentos também tem tiers, os de tier mais básico seriam apenas buffs simples, como "Combatente" (Attack +5), "Escudeiro (Defesa +3%)", "Vitalidade HP Max +50)". Encantamentos de tier mais altos liberam buffs mais poderosos, com porcentagem mais alta, ou porcentagem baixa em stats mais fortes, que os encantamentos mais básicos nem tocam. Encantamentos de tiers baixos não podem ser encontrados naturalmente em tiers maiores, mas podem ser evoluídos no late game para tiers de raridade mais altos, podendo assim, liberar níveis novos.
- **Rarirdade:** Encantamentos só terão os tiers (mundane (trava até o nível 3), refined (trava até o nível 6), unreal (trava até o nível 9), eternal (desbloqueia o nível 10))
- **Níveis de Encantamento:** Os encantamentos também devem ter níveis que variam de 1-10, representados por algoritimos romanos, assim como no Minecraft. Os níveis amplificam o encantamentoe são exponenciais, encantamentos até nível 3 sobem pouco o stat que o encantamento proporciona, nível 6 aumentam bem o stat, até o nível 9 aumentam bastante, e o nível 10 boosta bastante o stat, fazendo com que seja quase outro encantamento. Tiers de raridade travam o nível máximo daquele encantamento.

### 3.9 Coleta (Gathering Skills)

**Função:** segundo loop principal. Cada personagem inativo no combate pode estar coletando algo.

**Skills [sua lista + adições]:**

- **Mining** — minérios e gemas brutas (insumo de Smithing e Jewelcrafting)
- **Woodcutting** — madeira de várias árvores (insumo de Fletching, Carpentry, Cooking)
- **Fishing** — peixes e itens aquáticos (insumo de Cooking)
- **Cooking** — receitas (consumíveis de buff, food para regen)
- **Herbalism** — ervas e flores (insumo de Alquimia)
- **Planting/Gardening** — plantar sementes em canteiros do Acampamento, colher após timer real (mecânica de retorno diário)
- **Livestock** — criar animais no Acampamento (carne, leite, lã, ovos)
- **Alchemy** — produzir poções (a partir de ervas e reagentes)
- **Hunting** — caça de animais (couros, ossos, peles raras)
- **Archaeology** — escavar áreas específicas para fósseis (cards arqueológicos, fragmentos de set, pedaços de criaturas pre-históricas que ao montar completamente concedem buffs)

**Mastery por item específico (do Melvor):**
Cada item coletado tem seu próprio nível de mastery. Por exemplo, "Pescar Truta" tem nível 1-99, separado de "Pescar Tubarão". Mastery alta dá: tempo de coleta menor, drop chance bonus, mais XP, chance de drop duplo.

**No MVP vamos começar apenas com Mining, Woodcutting, Fishing, Herbalism e Cooking. O resto vamos adicionar em fases.**

### 3.10 Múltiplos personagens

**Função:** núcleo do paradigma IdleOn-style.

**Modelo proposto:**

- **Roster:** começa com 1 personagem, expande até 10, de inicio.
- **Aquisição de novos personagens**
  - Níveis dos personagens somam, ao atingir cada 50 níveis gerais, desbloqueia um novo personagem para ser recrutado.
  - Recrutamento na Taverna do Acampamento (a contratação é gratuita)
  - Achievements raros ("matar 10000 goblins" desbloqueia Caçador de Goblins)
  - Eventos sazonais (limited-time)
- **Cada personagem tem:**
  - Classe (define skills básicas, afinidade com gathering, stats base)
  - Nível próprio 1-100 de inicio
  - Equip próprio
  - Skill tree própria
  - Atribuição atual (em qual zona/atividade está)
  - Mastery individual em cada gathering skill

**Tela de roster overview:**
Tela inicial do jogo. Lista todos os personagens, o que cada um está fazendo, progresso atual, alertas (equip melhor disponível, level up pendente, etc.).

### 3.11 Skill tree (árvore de habilidades)

**Função:** principal eixo de customização do build.

**Modelo sugerido:**

- **Por personagem:** árvore própria, com ramos definidos pela classe.
- **Pontos de talento:** ganhos por nível + drops raros + achievements + quests especiais.
- **Estrutura:** pelo menos 3 ramos por classe (ex: Guerreiro = Berserker / Defender / Tactician).
- **Resetável:** consumível "Pergaminho de Reset" disponível mas caro.

**Conexão com Constelações (3.20):** árvore de habilidades é mid-game; constelações são late-game (segunda camada).

### 3.12 Skills com cooldown

**Função:** decisão de build no auto-battle.

**Modelo proposto:**

- Cada personagem pode equipar **até 8 skills ativas**.
- Cada skill tem cooldown próprio em segundos.
- **Sistema de prioridade/condição:**
  - Modo simples: disparo constante de skills, dispara uma skill pronta após a outra, com um buffer curto de tempo, para não soltar todas as skills juntas e travar o jogo, ou ficar uma bagunça de efeitos visuais. Uma skill só deve ser usada quando a animação de outra terminar.
  - **Modo avançado:** cada skill tem trigger configurável ("HP < 50%", "3+ inimigos visíveis", "Boss presente", "Stack de buff Y ≥ 5"). Desbloqueado em mid-game como progressão de QoL.

### 3.13 Pets [da sua lista]

1. **Pets em combate:** acompanham personagem, lutam junto, têm apenas stats de ataque, pois não vão receber dano, apenas complementar a força de ataque do jogador. Pets também devem ter 2 habilidades.
2. **Buffs passivos de Pets:** equipados em slot, dão um ou mais bônus passívos escpecíficos.
3. **Expedições com Pets:** atribuídos a uma atividade de coleta para acelerar/diversificar drops.

**Aquisição:**
- Drop raro de inimigos boss/elite (estilo Melvor)
- Poucos achievements (X kills, Y itens coletados)
- Eclosão de ovos (encontrados em coleta ou drops, quests ou achievements)
- Captura via Hunting

### 3.14 Sistema de Cards de Inimigos [da sua lista]

**Função:** colecionismo + bônus passivos. Diferenciado do Bestiário.

**Modelo proposto:**

- Inimigos comuns dropam Cards Comuns; elites dropam Card Raro; bosses dropam Card Único.
- Cada card tem stats/buff atrelado (ex: "Card de Goblin: +1% gold gain").
- **Equipável em slots de card:** o jogador equipa N cards (sugestão: 3 sets de 5, totalizando 15 slots em endgame, desbloqueados gradualmente).
- **Sets de cards:** equipar 3, 5 ou 7 cards de uma mesma "categoria" (ex: 5 cards de raça Animal) ativa bônus de set.
- **Upgrade de card:** dropar duplicatas evolui o card para tier maior (Common → Uncommon → Rare → Epic) com bônus aumentado.
- **Álbum:** UI de coleção, mostra completude geral, completar uma página inteira dá um bônus permanente. Cada carta desbloqueada a primeira vez também dá um pequeno bonus, mas bem pequeno mesmo.
- **Cards Elite/Shiny:** As vezes podem aparecer inimigos elite, derrota-los também dá chance de desbloquear cards, porém bem mais raramente, ao desbloquear o primeiro card, o álbum libera uma nova aba chamada "corrupted", onde é possível acumular cards elite, bônus de card elite aumentam stats contra os inimigos, geram buffs de combate, etc. Mais raro que os inimigos elite e mais raro ainda de dropar cards, serão os inimigos Shiny, eles serão versões douradas dos inimigos, aparecerão com uma chance minúscula e quando droparem cards shiny, desbloquearão outra aba, chamada GREEDY! nessa aba, cada card aumenta as quantidades de drops no geral, de todos os inimigos.

**Diferença para Bestiário:** cards são **equipáveis e dão buffs ativos**; bestiário é informacional e dá buffs por completude/kill stack (ver 3.15).

### 3.15 Kill Stack Bonus / Bestiário [da sua lista]

**Função:** recompensar farming sustentado em uma zona/inimigo.

**Modelo proposto:**

- Cada inimigo tem **contador de kills total** (por personagem e global).
- **Mob Slaughter** (ex: 10, 100, 1k, 10k, 100k, 1M kills) liberam:
  - **Info no bestiário** (HP, drops, comportamento, stats — revelado progressivamente)
  - **Buff permanente contra esse inimigo** (ex: 100 kills = +5% dano vs ele; 1k = +10%; 10k = +20%; 100k = +50%)
  - Em marcos altos: **drop adicional desbloqueado** (item exclusivo só dropa após X kills)
  - Inimigos raros, pseudo-bosses, mini-bosses e bosses, requerem menos kills para liberar os bônus sucessivamente.
  - Variações Elite e Shiny também poderão ser vistas aqui, porém ao derrotar apenas 1 dessas versões, as informações já aparecem.

### 3.16 Acampamento que evolui

**Função:** hub. **A mecânica meta mais central depois do combate.**

**Estágios de evolução:**

1. **Acampamento (start)** — fogueira, 2-3 estruturas básicas (bancada de trabalho, fornalha, banca de cozinha simples).
2. **Vilarejo** — desbloqueia: Forja, Alquimia, Casa de Plantio, Currais, Taverna (recrutamento).
3. **Cidade** — desbloqueia: Mercado (loja maior), Guilda (quests diárias/semanais), Armazém (slots de inventário extras e compartilhados entre os jogadores, porém apenas para materiais, e que já foram desbloqueados no códice do personagem específico, armas, armaduras, acessórios, equipamentos, itens de quest, etc. não entram aqui).
4. **Reino** — desbloqueia: Embaixadas (eventos cross-zona), Catedral (mecânicas de bônus tipo World Tree), Academia (auto-treinos de skill com tempo real, para evoluir o tier das skills, exemplo "Fireball" vira "Meteor Shoot" onde ao invés de criar apenas uma bola de fogo, lança vários meteóros, todas as skills base de personagem podem ser evoluídas no mínimo uma vez aqui).
5. **Império** — late-game: portais para outros mundos, fortaleza (raids), torre dos sábios (constelações).

**Evolução requer:** acumular materiais em grande quantidade por etapa do jogo, os materiais devem ser de partes do mundo cada vez mais avançadas. Cada estágio dá um boost global pra todos os personagens.

**Conexão crítica:** quase TODA outra mecânica tem uma estrutura representante no Acampamento. Visualmente, o jogador "constrói" o jogo dele aqui.

### 3.17 Loja com gold

**Função:** sink básico de gold + acessibilidade de itens.

**Categorias:**
- Equipamento básico (tier baixo, sempre disponível)
- Consumíveis (poções, óleos, scrolls de proteção)
- Materiais (alguns vendidos por NPCs em quantidades limitadas/dia)
- Itens rotativos diários (dá motivo pra abrir o jogo todo dia)
- Algumas poucas skins exclusívas simples, porém BEM caras
- Alguns pets
- Melhorias resetáveis

### 3.18 Moeda exclusiva (premium, tanto paga quanto não paga)

**Função:** moeda de meta-progressão, ganha via prestígio/achievements/eventos/quest diária/free-gift na loja/tempo de jogo/quests raras/cards repetidos apartir do limite até uma certa quantidade. **NÃO confundir com pay-to-win** pois existem muitas formas de conseguir no jogo — ela existe pra dar peso a decisões de longo prazo. Elas também podem ser compradas, mas para não quebrar completamente o jogo, os conteúdos serão liberados conforme o jogador avança, exemplo: Guia de Zona 1 - Upgrades para inicio de jogo. Guia de Zona 10 - Upgrades para Late-Game de primeira run, Guia de Transcendência 1 - Melhorias para Late-Game, primeira transcendência, etc.: 

**Sugestão de nome:** "Gemas da Eternidade" ou "Gems of Eternity"

**Loja exclusiva oferece:**
- Slots de inventário extras
- Slots de personagem extras (acima do start)
- Automações (auto-loot, auto-equip melhor item, auto-craft, auto-replant)
- Melhorias de fornalha/coleta (multiplicador permanente de XP em uma skill, plantação maior, curral maior, armazém da cidade maior)
- Cosméticos/títulos exclusivos/UI alternativas
- Resets de skill tree gratuitos
- Tempo offline maior (12h → 24h → 48h → ...)

### 3.19 Renascimento, Transcendência, Ascensão

**Função:** longevidade. **A camada mais delicada do design.**

**Modelo em 4 camadas:**

1. **Renascimento de personagem** — cada personagem pode renascer pela primeira vez ao  atingir primeiro level cap (100). Reseta nível inventário, equipamentos, skills, slots (não os da loja eterna), codex de inimigos, equipamentos, armas, armaduras, visuais, acessórios, etc, permanecem, álbum permanece, pets permanecem, porém o de códex itens (materiais) daquele personagem, reseta. Ganha **estrelas (★)** que são multiplicadores permanentes daquele personagem. Cap de ★: 10. Além de aumentarem o nível máximo do personagem em 100 e obter acesso ao "Chakra" (Loja de renascimento). Renasceres depois do primeiro no nível 100 do personagem, podem ser feitos em níveis menores, para garantirem alguns pontos de renascimento, que devem ser usados para comprar buffs para o personagem (flat, porcentagem ou multiplicadores)

   **Awakening / Ramos de Evolução:** ao atingir  os níveis 1★, 3★, 5★, 7★, 9★ e 10★, o personagem chega num **nó de escolha** que possibilita a melhoria as skills atuais do seu kit no reino, e desbloqueia 4 novas skills, porém mantém tudo do kit anterior caso o jogador queira colocar. Exemplos:

   - **Guerreiro ★3:** escolher entre **Cavaleiro Sagrado** (foco em defesa, healing aliado, status Shielded) ou **Berserker do Caos** (foco em DPS bruto, status Bleeding/Vulnerable, autodano permitido).
   - **Mago ★3:** **Pirômano** (Burning, AoE) vs **Cronomante** (Slowed, controle de tempo, cooldown reduction).
   - **Ranger ★3:** **Caçador de Sombras** (crit + dano vs categorias de raça) vs **Druida** (invocar familiares, buffs naturais).

   Em 5★ libera o primeiro nó com skill assinatura e ★10, último nó (mais sutil) masteriza a build, liberando uma skill assinatura daquele nó da classe. Com 5★ e 10★ skins exclusivas + títulos único.

   **Isso é diferente de classe inicial:** o personagem mantém a classe-mãe (Guerreiro continua Guerreiro), mas ganha uma **especialização permanente** que muda kit de skills, árvore de talentos disponível, e visual.

2. **Transcendência** — Ao atingir o level cap de 1000, adquirir todos os desbloqueios de inimigos e materiais e zonas do códex pre-transcendido (excluíndo receitas de comida, armas, armaduras, acessórios, e outras coisas que podem ter no códex), consome toda experiência ganha até agora para aquele personagem, itens, álbum, tudo, com excessão de compras da loja eterna, pets, conteúdos do códex (agora deve permanecer, porque o personagem em teoria absorve o conhecmimento dele), conquistas, mistura em uma matemática que você deve fazer, e converter para Transcended Points (Devem ser pouquíssimos, sinalizando que tudo que você juntou até agora, não valerá muita coisa na transcendência). Níveis apartir desse ponto são exibidos com base na quantidade de desbloqueios da "Árvore de Transcendência". Um personagem com 1 nivel de transcendência, deve ter no minimo o dobro de força e facilidade em fazer as coisas do personagem level 1000. Cada nível de transcendência, além de entregar o bônus da árvore, continua aumentando os stats do personagem. Ao transcender, o códice evolui para códice transcendido, onde deverá registrar novos inimigos, variações de alguns já existentes, porém transcendidos, dando-lhes novas aparencias, comportamentos, buffs, tipos, etc. Além de o tipo "transcendido"

3. **Ascensão Cósmica** — reseta tudo (incluindo gathering, equip), mas:
   - Mantém Cards, Bestiário, Pets, Conquistas, Compras da Loja Eterna
   - Mantém pontos de Constelação
   - Ganha multiplicador "Cósmico" permanente (1.5x → 2x → 3x...)
   - Desbloqueia novos níveis de dificuldade do mundo (NG+, NG++)
   - **Eleva a dificuldade pós-ascensão**
   - Desbloqueia novos inimigos, novas criaturas, novos NPCs, novas evoluções, etc. Em futuras updates, planejo adicionar mais acensões de desbloqueio. Porém no inicio vai desbloquear apenas alguns inimigos novos, uma ou duas zonas novas e as dificuldades mais elevadas.
   - Desbloqueia "Moedas Galácticas" que podem ser usadas na "Forja Galáctica" que vai servir para evoluir melhorias permanentes globais. Apartir do momento da primeira acensão, inimigos comuns tem uma chance baixa de droparem moedas galácticas em poucas quantidades, essa chance só pode ser aumentada através de melhorias da própria loja galáctica.
   - Usuário ganha desbloqueio ao "Acelerador cósmico/dobra cósmica" que serve para aumentar multiplicar a quantidade de vezes que uma área vai ser cleanada baseando-se apenas em uma cleanada. Isso deve ter uma matemática de proporções e chances, para lidar por exemplo com inimigos elite e shiny.

Expoentes sub-lineares evitam inflação descontrolada.

### 3.20 Constelações

**Função:** segunda árvore de talentos, late-game. Mecânica de bônus de longo prazo.

**Modelo proposto:**

- **Desbloqueada após Renascimento #1** (pra não atrapalhar o early-game).
- Acessível através do NPC que vai começar a aparecer desde o acampamento, chamado "O transcendido", Ele vai pedir uma quantidade alta de ítens de drops/coleta que vão variar de drops iniciais de slimes, madeira comum, etc, até itens da última zona. Cada zona tem uma constelação específica, que vai exigir as quantidades de ítens daquela zona.
- Cada constelação é um "set de nodes" (5-15 nodes por constelação).
- **Pontos de Constelação** ganhos por: completar a constelação anterior, ascensões, descobertas de Astrology, achievements raros.
- **Constelações:**
  - **Caçador** — bônus de drop e XP em combate
  - **Coletor** — bônus em gathering skills
  - **Forjador** — bônus em crafting e refinamento
  - **Andarilho** — velocidade, offline progression
  - **Sortudo** — luck, rare drops

### 3.21 Passivas entre todos os personagens

**Função:** sensação de "team progress" mesmo cada um farmando solo.

 **"Selos":**
- Conquistadas via achievements globais ("100k kills totais entre todos personagens", "Maior nível atingido = X").
- Cada selo dá um bônus pequeno mas permanente que aplica a TODOS os personagens (presentes e futuros).
- Display em uma tela própria (Conta → Selos).

### 3.22 Títulos

**Função:** showcase de feitos + buff passivo.

**Modelo:**
- Conquistados via achievements específicos.
- Cada título dá um buff passivo único (small to medium).
- Todos os títulos vão ser equipados no momento do desbloqueio, o personagem vai ter sua lista de títulos e todos eles ficarão ativos ao mesmo tempo.

### 3.23 Itens usáveis (poções, etc.) [da sua lista]

**Função:** consumíveis de buff e regen.

**Categorias:**
- **Poções de regen** — HP, MP (cooldown próprio em combate)
- **Poções de buff** — XP boost, drop boost, dano boost (timer real-time, ex: 30 min)
- **Pergaminhos** — encantamento, reset, teleporte
- **Comida** — buff permanente na primeira vez consumida + buff longo (1-2h real-time), produzida por Cooking

### 3.24 Dungeons

**Função:** conteúdo de party. Onde os múltiplos personagens se reúnem.

**Modelo:**

- Cada dungeon tem **wave count fixo + boss final**.
- **Party de 3-5 personagens** (definida pelo jogador antes da entrada).
- **Modo de combate diferente** do solo: party em formação (front/back), abilities ativadas em sequência ou em paralelo.
- **Loot de dungeon** é diferente de loot de zona normal — drops únicos, set pieces, materiais raros.
- **Dificuldades:** Normal, Hard, Heroic, Mythic. Cada uma exige progressão prévia.
- **Tokens de Dungeon** — recompensa secundária, gasta na loja específica de dungeons (cosméticos, set pieces específicas).

**Formação e sinergias [NOVO, inspirado em Crusaders of the Lost Idols]:**

A party não é uma fileira passiva. É uma **grade 3x2** (3 colunas: front/middle/back; 2 linhas) com 5 slots usáveis. Cada personagem tem auras passivas com range específico:

- **Adjacente (4 slots vizinhos)** — ex: "Aura de Proteção: +20% defesa pra adjacentes"
- **Mesma coluna (front/middle/back da coluna)** — ex: "Coluna Sangrenta: +15% leech pra mesma coluna"
- **Mesma linha (linha frontal ou traseira)** — ex: "Linha de Apoio: +30% velocidade de cast pra mesma linha"
- **Toda a party** — auras raras
- **Diagonal / posição específica** — ex: "Atirador de Elite: +50% crit se nas 2 colunas traseiras"

**Implicações de design:**

- Trocar 1 personagem de posição **reformula todas as sinergias** — vira mini-puzzle.
- Builds otimizadas pra solo podem não ser ótimas em party (e vice-versa) — incentiva flexibilidade.
- desbloquear posições gradualmente: começa com 3 slots em linha, expande pra 2x2, depois 3x2 conforme progride em dungeons.
- Pré-set de formações salvos (até 5 layouts nomeados) pra trocar rápido entre conteúdos.

### 3.25 Arena dos Gladiadores

**Função:** conteúdo competitivo (PvE), aberto cedo mas com escalamento late-game.

**Modelo:**

- Aberta após zona 2-3 (cedo).
- Sequência de combates 1v1 ou party-vs-party com inimigos de stats fixos altos.
- **Glory** — moeda específica da Arena, gasta em itens cosméticos, títulos exclusivos, talentos especiais.
- **Escalamento late-game:** Arena tem rankings infinitos (Bronze, Prata, Ouro, Platina, Diamante, Mestre, Gladiador, Lendário, Mítico, Eternizado) com inimigos cuja dificuldade escala por nível conquistado.

### 3.26 Eventos

**Função:** retenção. Conteúdo limitado por tempo.

**Tipos:**

- **Eventos sazonais** (Halloween, Natal, etc.) — temas visuais + drops temáticos + boss único + recompensas exclusivas.
- **Invasões** — uma zona é "invadida" por um tipo de inimigo durante alguns minutos, drops aumentados.
- **Festivais do Acampamento** — buff global de XP/drop por X horas, ativado por evento gerado aleatoriamente por tempo, variando entre 1-2 horas reais e duram vários minutos.

### 3.27 Códex

**Função:** referência interna do jogo.

**Subseções:**
- Bestiário (já coberto em 3.15)
- Locais de coleta (mapa de onde dropa o quê)
- Materiais (lista completa, taxa de drop, fontes)
- NPCs (descrição, lore, quests oferecidas)
- Zonas (lore, recomendações, status)
- Receitas (todas descobertas + sinalizador de não descobertas)
- Cards (álbum)
- Pets (album)

### 3.28 Expedições

**Função:** atividade direcionada por objetivo, fora do farm passivo.

**Modelo proposto:**

- Aberta em mid-game.
- Jogador escolhe 1-3 pets, atribui uma "missão" com duração real (ex: 4h, 8h, 24h).
- Missão pede recursos específicos como objetivo (ex: "trazer 50 Couro de Dragão de Gelo").
- Pets ficam **indisponíveis** durante a expedição.
- Recompensa garantida + chance de drop especial.
- Pets específicos tem vantagens específicas para adquirir certas coisas.

### 3.29 Multiplicador de velocidade do jogo

**Função:** QoL crítico para auto-battle idle.

**Implementação técnica em Godot:**

- `Engine.time_scale` afeta delta time global → animações e cooldowns escalam automaticamente.
- Timers reais (offline progress, daily quests, expedições, plantio) usam `Time.get_unix_time_from_system()` — independente do time_scale, exatamente como você quer.
- Multiplicadores: 1x, 2x, 4x, 8x.
- **Custos de uso:** ou consumo de recurso (Stored Boost)
- Unlock por loja eterna (1x sempre, 2x cedo, 4x mid, 8x late) < isso na primeira run.
- Em bosses/dungeons: jogador pode forçar 1x para ler combate.

### 3.30 Tela de resultados pós-clear de área

**Função:** feedback satisfatório do loop médio.

**Conteúdo:**
- XP ganho (com barra de progresso animada)
- Drops obtidos (resumo por raridade)
- Marcos de kill stack atingidos
- Bestiário atualizações
- Tempo total na área
- Comparativo com clear anterior (você ficou 30s mais rápido!)
- Próxima área prevista (preview de inimigos)

### 3.31 Mais informações no mapa e modal de batalha

Coberto na seção 3.1 (refinamentos do Combate).

### 3.32 Encantamentos de equipamento

Coberto em 3.8.

### 3.33 Resolução: "várias armas só pelos stats"

**Sua restrição:** você quer **1 arma equipada visualmente**, mas quer que outras armas/equipamentos coletados ainda contribuam.

**[SUGESTÃO ESCOLHIDA]: Sistema de Coleção de Equipamentos**

Inspiração: Codex of Power (Diablo 4), Achievements de coleta (Genshin).

- **Cada equipamento que o jogador obtém pela primeira vez é registrado na "Coleção".**
- A Coleção é organizada por slot (todas armas, todas armaduras, etc.) e tier.
- Cada item registrado dá **um stat permanente pequeno** (proporcional ao tier do item):
  - Common: +0.1% damage / +1 HP / etc.
  - Uncommon: +0.3% / +3 HP
  - Rare: +1% / +10 HP
  - Epic: +3% / +30 HP
  - Legendary: +8% / +100 HP
  - Mythic: +20% / +300 HP
- **Coleções completas (todas armas Rare+)** dão bônus de set adicional.
- **Aplicado a TODOS os personagens** (incentivo a coletar tudo, mesmo de classes que você não usa).

**Vantagens desse modelo:**
- Não trivializa a arma equipada (que ainda dá os stats principais)
- Recompensa o coletor sem precisar de espaço de inventário
- Gera "long tail" de progresso (Mythic é raríssimo, completar Mythic Collection é meta de 1000+ horas)
- Combina perfeitamente com Bestiário/Cards (mesma filosofia de "tudo conta")

## 4. Mecânicas de Bônus Extras (sugestões além de World Tree, Titanica e Constelações)

**8 sugestões [NOVO]** que se conectam com a filosofia do que você já tem:

### 4.1 Forja Cósmica
**Conceito:** uma forja gigante destrancada após Renascimento #1. Cada equipamento Mythic ou completa-Coleção alimenta a Forja com "Esquirla Estelar". Esquirlas evoluem a Forja, que dá bônus globais de crafting (success rate, qualidade, custo reduzido) e desbloqueia receitas únicas só forjáveis lá.

### 4.2 Biblioteca dos Antigos
**Conceito:** biblioteca dentro do Acampamento (estágio Cidade+). Cada vez que o jogador completa uma página de Bestiário/Cards/Receitas, "Conhecimento" é depositado. Conhecimento desbloqueia Tomos, e cada Tomo lido dá um pequeno boost permanente em uma categoria de stat. Conexão direta com Códex.

### 4.4 Espelho dos Gêmeos
**Conceito:** espelho mágico no Acampamento (estágio Reino+). Uma vez por dia (real-time), o jogador escolhe um personagem; aquele personagem ganha uma "sombra" com 50% dos seus stats por 24h, que farma em paralelo (ou seja, vira um 9º personagem temporário). Limite: 1 sombra ativa por vez.

### 4.7 Crônicas do Mundo
**Conceito:** sistema de "tempo decorrido na conta" (real-time desde a criação do save). A cada milestone de tempo (1 dia, 7 dias, 30 dias, 100 dias, 365 dias, 1000 dias), o jogador ganha "Memória do Tempo", que pode ser aplicada em uma trilha de bônus. Recompensa lealdade pura, não habilidade.

### 4.8 Selos de Liderança
**Conceito:** ganhos por completar feitos com TODA a party em conjunto (clear de dungeon mítica com 5 personagens, achievement "todos personagens nível 100", etc.). Selos dão bônus de party (formação) — só ativos quando o personagem está em dungeon/boss com outros. Incentiva manter o roster equilibrado, não só 1 personagem broken.

---

## 6. Matriz de Dependências

Grupo "Foundation" precisa ser sólido antes de qualquer outra fase.

```
FOUNDATION (já tem ou implementar primeiro):
├── Combate (zona/estágio/área) [TEM]
├── Stats básicos do jogador [TEM A BASE MAS PRECISA SER EXPANDIDA]
├── Inventário + Equipamento (slots, raridades, stats) [TEM A BASE, MAS PRECISA SER EXPANDIDA]
├── Save/Load + Offline progression
├── Roster de personagens (1 personagem único pra começar) [JÁ TEMOS 1 PERSONAGEM]
├── Gold + Loot básico [TEM]

CORE LOOPS (Fase 1):
├── Mapa + navegação entre zonas [TEM, MAS PRECISA COMPORTAR MAIS COISAS]
├── Skill tree básica (1 personagem, 1 árvore) [PODE SER UMA LISTA DE INICIO
DEPOIS TRABALHAMOS EM UMA REPRESENTAÇÃO VISUAL DE NÓS]
├── Coleta básica (1-2 skills: Mining, Woodcutting)
├── Crafting básico (Smithing)
├── Acampamento estágio 1 (3-5 estruturas) [ESTRUTURAS SERÃO POSICIONADAS
MANUALMENTE E APENAS FICARÃO VISÍVEIS AO SEREM DESBLOQUEADAS, NÃO DEVEM TER
MEIO DE ORGANIZAÇÃO MANUAL, PERSONAGENS DESBLOQUEADOS DEVEM ANDAR ALEATÓRIAMENTE
PELO ACAMPAMENTO]
├── Bestiário simples (info, sem buffs ainda)
├── Tela de resultados pós-clear
├── Sistema de velocidade (1x/2x)

EXPANSION (Fase 2-3):
├── Múltiplos personagens (3-5 no roster)
├── Múltiplas classes (cada uma com árvore própria)
├── Mais skills de coleta (Fishing, Cooking, Herbalism)
├── Acampamento estágio 2 (Vilarejo)
├── Status effects + Elementos
├── Pets (papel inicial: Buff)
├── Cards de inimigos
├── Kill Stack ativo (com buffs)
├── Encantamentos
├── Refinamento de equipamento
├── Loja (gold)

MID-GAME (Fase 3-4):
├── Acampamento estágio 3 (Cidade)
├── Dungeons (party, formação)
├── Mini-bosses e Bosses regulares
├── Inimigos elites e sinhy
├── Raids
├── Arena dos Gladiadores (early access)
├── Skills com cooldown + sistema de prioridade
├── Coleção de Equipamentos
├── Mob Slaughter expandido
├── Códex completo
├── Eventos rotativos
├── Selos de Conta (passivas globais)
├── Itens usáveis (poções, comida buff)
├── Pets
├── Renascimento (1ª camada de prestígio)
├── Moeda exclusiva + loja exclusiva
├── Títulos
├── Expedições

LATE-GAME (Fase 4-5):
├── Acampamento estágio 4 (Reino)
├── Mecânicas de bônus: World Tree, Titanica [ENCONTRADOS NA ZONA 1, FLORESTA]
├── Transcendência
├── Constelações (segunda árvore)
├── Ascensão Cósmica
├── Múltiplos NG+ de dificuldade
├── Eventos sazonais

END-GAME (Fase 5-6):
├── Acampamento estágio 5 (Império)
├── Forja Cósmica
├── Biblioteca dos Antigos
├── Espelho dos Gêmeos
├── Pacto com Espíritos
├── Crônicas do Mundo
├── Selos de Liderança
├── Coleção Mythic completa
├── Arena Grão-Mestre+
├── Conteúdo de season/expansão
```
---

*Fim do documento v1.*
