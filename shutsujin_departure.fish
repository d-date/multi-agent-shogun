#!/usr/bin/env fish
# 🏯 multi-agent-shogun 出陣スクリプト（毎日の起動用）
# Daily Deployment Script for Multi-Agent Orchestration System
# Zellij + fish version
#
# 使用方法:
#   ./shutsujin_departure.fish           # 全エージェント起動（通常）
#   ./shutsujin_departure.fish -s        # セットアップのみ（Claude起動なし）
#   ./shutsujin_departure.fish -h        # ヘルプ表示

# スクリプトのディレクトリを取得
set SCRIPT_DIR (cd (dirname (status --current-filename)); and pwd)
cd $SCRIPT_DIR

# 言語設定を読み取り（デフォルト: ja）
set LANG_SETTING "ja"
if test -f "./config/settings.yaml"
    set LANG_SETTING (grep "^language:" ./config/settings.yaml 2>/dev/null | awk '{print $2}'; or echo "ja")
end

# 色付きログ関数（戦国風）
function log_info
    printf "\033[1;33m【報】\033[0m %s\n" $argv[1]
end

function log_success
    printf "\033[1;32m【成】\033[0m %s\n" $argv[1]
end

function log_war
    printf "\033[1;31m【戦】\033[0m %s\n" $argv[1]
end

# ═══════════════════════════════════════════════════════════════════════════════
# オプション解析
# ═══════════════════════════════════════════════════════════════════════════════
set SETUP_ONLY false
set OPEN_TERMINAL false

for arg in $argv
    switch $arg
        case -s --setup-only
            set SETUP_ONLY true
        case -t --terminal
            set OPEN_TERMINAL true
        case -h --help
            echo ""
            echo "🏯 multi-agent-shogun 出陣スクリプト (Zellij + fish版)"
            echo ""
            echo "使用方法: ./shutsujin_departure.fish [オプション]"
            echo ""
            echo "オプション:"
            echo "  -s, --setup-only  Zellijセッションのセットアップのみ（Claude起動なし）"
            echo "  -t, --terminal    ターミナルでセッションを開く"
            echo "  -h, --help        このヘルプを表示"
            echo ""
            echo "例:"
            echo "  ./shutsujin_departure.fish      # 全エージェント起動（通常の出陣）"
            echo "  ./shutsujin_departure.fish -s   # セットアップのみ（手動でClaude起動）"
            echo ""
            echo "セッション接続:"
            echo "  zellij attach shogun       # 将軍セッションに接続"
            echo "  zellij attach multiagent   # 家老・足軽セッションに接続"
            echo ""
            exit 0
        case '*'
            echo "不明なオプション: $arg"
            echo "./shutsujin_departure.fish -h でヘルプを表示"
            exit 1
    end
end

# ═══════════════════════════════════════════════════════════════════════════════
# 出陣バナー表示
# ═══════════════════════════════════════════════════════════════════════════════
function show_battle_cry
    clear

    # タイトルバナー（色付き）
    echo ""
    printf "\033[1;31m╔══════════════════════════════════════════════════════════════════════════════════╗\033[0m\n"
    printf "\033[1;31m║\033[0m \033[1;33m███████╗██╗  ██╗██╗   ██╗████████╗███████╗██╗   ██╗     ██╗██╗███╗   ██╗\033[0m \033[1;31m║\033[0m\n"
    printf "\033[1;31m║\033[0m \033[1;33m██╔════╝██║  ██║██║   ██║╚══██╔══╝██╔════╝██║   ██║     ██║██║████╗  ██║\033[0m \033[1;31m║\033[0m\n"
    printf "\033[1;31m║\033[0m \033[1;33m███████╗███████║██║   ██║   ██║   ███████╗██║   ██║     ██║██║██╔██╗ ██║\033[0m \033[1;31m║\033[0m\n"
    printf "\033[1;31m║\033[0m \033[1;33m╚════██║██╔══██║██║   ██║   ██║   ╚════██║██║   ██║██   ██║██║██║╚██╗██║\033[0m \033[1;31m║\033[0m\n"
    printf "\033[1;31m║\033[0m \033[1;33m███████║██║  ██║╚██████╔╝   ██║   ███████║╚██████╔╝╚█████╔╝██║██║ ╚████║\033[0m \033[1;31m║\033[0m\n"
    printf "\033[1;31m║\033[0m \033[1;33m╚══════╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝  ╚════╝ ╚═╝╚═╝  ╚═══╝\033[0m \033[1;31m║\033[0m\n"
    printf "\033[1;31m╠══════════════════════════════════════════════════════════════════════════════════╣\033[0m\n"
    printf "\033[1;31m║\033[0m       \033[1;37m出陣じゃーーー！！！\033[0m    \033[1;36m⚔\033[0m    \033[1;35m天下布武！\033[0m                          \033[1;31m║\033[0m\n"
    printf "\033[1;31m╚══════════════════════════════════════════════════════════════════════════════════╝\033[0m\n"
    echo ""

    # 足軽隊列
    printf "\033[1;34m  ╔═════════════════════════════════════════════════════════════════════════════╗\033[0m\n"
    printf "\033[1;34m  ║\033[0m                    \033[1;37m【 足 軽 隊 列 ・ 八 名 配 備 】\033[0m                      \033[1;34m║\033[0m\n"
    printf "\033[1;34m  ╚═════════════════════════════════════════════════════════════════════════════╝\033[0m\n"

    echo '
       /\      /\      /\      /\      /\      /\      /\      /\
      /||\    /||\    /||\    /||\    /||\    /||\    /||\    /||\
     /_||\   /_||\   /_||\   /_||\   /_||\   /_||\   /_||\   /_||\
       ||      ||      ||      ||      ||      ||      ||      ||
      /||\    /||\    /||\    /||\    /||\    /||\    /||\    /||\
      /  \    /  \    /  \    /  \    /  \    /  \    /  \    /  \
     [足1]   [足2]   [足3]   [足4]   [足5]   [足6]   [足7]   [足8]
'

    printf "                    \033[1;36m「「「 はっ！！ 出陣いたす！！ 」」」\033[0m\n"
    echo ""

    # システム情報
    printf "\033[1;33m  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\033[0m\n"
    printf "\033[1;33m  ┃\033[0m  \033[1;37m🏯 multi-agent-shogun\033[0m  〜 \033[1;36m戦国マルチエージェント統率システム\033[0m 〜           \033[1;33m┃\033[0m\n"
    printf "\033[1;33m  ┃\033[0m                                                                           \033[1;33m┃\033[0m\n"
    printf "\033[1;33m  ┃\033[0m    \033[1;35m将軍\033[0m: プロジェクト統括    \033[1;31m家老\033[0m: タスク管理    \033[1;34m足軽\033[0m: 実働部隊×8      \033[1;33m┃\033[0m\n"
    printf "\033[1;33m  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\033[0m\n"
    echo ""
end

# バナー表示実行
show_battle_cry

printf "  \033[1;33m天下布武！陣立てを開始いたす\033[0m (Setting up the battlefield)\n"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 1: 既存セッションクリーンアップ
# ═══════════════════════════════════════════════════════════════════════════════
log_info "🧹 既存の陣を撤収中..."
if zellij delete-session multiagent 2>/dev/null
    log_info "  └─ multiagent陣、撤収完了"
else
    log_info "  └─ multiagent陣は存在せず"
end
if zellij delete-session shogun 2>/dev/null
    log_info "  └─ shogun本陣、撤収完了"
else
    log_info "  └─ shogun本陣は存在せず"
end

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 2: 報告ファイルリセット
# ═══════════════════════════════════════════════════════════════════════════════
log_info "📜 前回の軍議記録を破棄中..."
for i in (seq 1 8)
    printf "worker_id: ashigaru%s
task_id: null
timestamp: \"\"
status: idle
result: null
" $i > ./queue/reports/ashigaru{$i}_report.yaml
end

# キューファイルリセット
echo "queue: []" > ./queue/shogun_to_karo.yaml

printf "assignments:
  ashigaru1:
    task_id: null
    description: null
    target_path: null
    status: idle
  ashigaru2:
    task_id: null
    description: null
    target_path: null
    status: idle
  ashigaru3:
    task_id: null
    description: null
    target_path: null
    status: idle
  ashigaru4:
    task_id: null
    description: null
    target_path: null
    status: idle
  ashigaru5:
    task_id: null
    description: null
    target_path: null
    status: idle
  ashigaru6:
    task_id: null
    description: null
    target_path: null
    status: idle
  ashigaru7:
    task_id: null
    description: null
    target_path: null
    status: idle
  ashigaru8:
    task_id: null
    description: null
    target_path: null
    status: idle
" > ./queue/karo_to_ashigaru.yaml

log_success "✅ 陣払い完了"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 3: ダッシュボード初期化
# ═══════════════════════════════════════════════════════════════════════════════
log_info "📊 戦況報告板を初期化中..."
set TIMESTAMP (date "+%Y-%m-%d %H:%M")

if test "$LANG_SETTING" = "ja"
    printf "# 📊 戦況報告
最終更新: %s

## 🚨 要対応 - 殿のご判断をお待ちしております
なし

## 🔄 進行中 - 只今、戦闘中でござる
なし

## ✅ 本日の戦果
| 時刻 | 戦場 | 任務 | 結果 |
|------|------|------|------|

## 🎯 スキル化候補 - 承認待ち
なし

## 🛠️ 生成されたスキル
なし

## ⏸️ 待機中
なし

## ❓ 伺い事項
なし
" $TIMESTAMP > ./dashboard.md
else
    printf "# 📊 戦況報告 (Battle Status Report)
最終更新 (Last Updated): %s

## 🚨 要対応 - 殿のご判断をお待ちしております (Action Required - Awaiting Lord's Decision)
なし (None)

## 🔄 進行中 - 只今、戦闘中でござる (In Progress - Currently in Battle)
なし (None)

## ✅ 本日の戦果 (Today's Achievements)
| 時刻 (Time) | 戦場 (Battlefield) | 任務 (Mission) | 結果 (Result) |
|------|------|------|------|

## 🎯 スキル化候補 - 承認待ち (Skill Candidates - Pending Approval)
なし (None)

## 🛠️ 生成されたスキル (Generated Skills)
なし (None)

## ⏸️ 待機中 (On Standby)
なし (None)

## ❓ 伺い事項 (Questions for Lord)
なし (None)
" $TIMESTAMP > ./dashboard.md
end

log_success "  └─ ダッシュボード初期化完了 (言語: $LANG_SETTING)"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 4: Zellijセッション作成
# ═══════════════════════════════════════════════════════════════════════════════
log_war "⚔️ 家老・足軽の陣を構築中（9名配備）..."

# multiagentセッション作成（バックグラウンドで起動）
zellij --session multiagent --layout ./layouts/multiagent.kdl &
sleep 2

log_success "  └─ 家老・足軽の陣、構築完了"
echo ""

log_war "👑 将軍の本陣を構築中..."

# shogunセッション作成
zellij --session shogun --layout ./layouts/shogun.kdl &
sleep 2

log_success "  └─ 将軍の本陣、構築完了"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 5: Claude Code 起動（--setup-only でスキップ）
# ═══════════════════════════════════════════════════════════════════════════════
if test "$SETUP_ONLY" = "false"
    log_war "👑 全軍に Claude Code を召喚中..."

    # 将軍
    zellij -s shogun action write-chars "MAX_THINKING_TOKENS=0 claude --model opus --dangerously-skip-permissions\n"
    log_info "  └─ 将軍、召喚完了"

    sleep 1

    # 家老
    zellij -s multiagent action write-chars "claude --dangerously-skip-permissions\n" --pane-name karo

    # 足軽1-8
    for i in (seq 1 8)
        zellij -s multiagent action write-chars "claude --dangerously-skip-permissions\n" --pane-name ashigaru$i
    end
    log_info "  └─ 家老・足軽、召喚完了"

    log_success "✅ 全軍 Claude Code 起動完了"
    echo ""

    # ═══════════════════════════════════════════════════════════════════════════
    # STEP 5.5: 各エージェントに指示書を読み込ませる
    # ═══════════════════════════════════════════════════════════════════════════
    log_war "📜 各エージェントに指示書を読み込ませ中..."
    echo ""

    echo "  Claude Code の起動を待機中（15秒）..."
    sleep 15

    # 将軍に指示書を読み込ませる
    log_info "  └─ 将軍に指示書を伝達中..."
    zellij -s shogun action write-chars "instructions/shogun.md を読んで役割を理解せよ。\n"

    # 家老に指示書を読み込ませる
    sleep 2
    log_info "  └─ 家老に指示書を伝達中..."
    zellij -s multiagent action write-chars "instructions/karo.md を読んで役割を理解せよ。\n" --pane-name karo

    # 足軽に指示書を読み込ませる（1-8）
    sleep 2
    log_info "  └─ 足軽に指示書を伝達中..."
    for i in (seq 1 8)
        zellij -s multiagent action write-chars "instructions/ashigaru.md を読んで役割を理解せよ。汝は足軽"$i"号である。\n" --pane-name ashigaru$i
        sleep 0.5
    end

    log_success "✅ 全軍に指示書伝達完了"
    echo ""
end

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 6: 環境確認・完了メッセージ
# ═══════════════════════════════════════════════════════════════════════════════
log_info "🔍 陣容を確認中..."
echo ""
echo "  ┌──────────────────────────────────────────────────────────┐"
echo "  │  📺 Zellij陣容 (Sessions)                                │"
echo "  └──────────────────────────────────────────────────────────┘"
zellij list-sessions 2>/dev/null | sed 's/^/     /'
echo ""
echo "  ┌──────────────────────────────────────────────────────────┐"
echo "  │  📋 布陣図 (Formation)                                   │"
echo "  └──────────────────────────────────────────────────────────┘"
echo ""
echo "     【shogunセッション】将軍の本陣"
echo "     ┌─────────────────────────────┐"
echo "     │  Pane: 将軍 (SHOGUN)        │  ← 総大将・プロジェクト統括"
echo "     └─────────────────────────────┘"
echo ""
echo "     【multiagentセッション】家老・足軽の陣（3x3 = 9ペイン）"
echo "     ┌─────────┬─────────┬─────────┐"
echo "     │  karo   │ashigaru3│ashigaru6│"
echo "     │  (家老) │ (足軽3) │ (足軽6) │"
echo "     ├─────────┼─────────┼─────────┤"
echo "     │ashigaru1│ashigaru4│ashigaru7│"
echo "     │ (足軽1) │ (足軽4) │ (足軽7) │"
echo "     ├─────────┼─────────┼─────────┤"
echo "     │ashigaru2│ashigaru5│ashigaru8│"
echo "     │ (足軽2) │ (足軽5) │ (足軽8) │"
echo "     └─────────┴─────────┴─────────┘"
echo ""

echo ""
echo "  ╔══════════════════════════════════════════════════════════╗"
echo "  ║  🏯 出陣準備完了！天下布武！                              ║"
echo "  ╚══════════════════════════════════════════════════════════╝"
echo ""

if test "$SETUP_ONLY" = "true"
    echo "  ⚠️  セットアップのみモード: Claude Codeは未起動です"
    echo ""
    echo "  手動でClaude Codeを起動するには:"
    echo "  ┌──────────────────────────────────────────────────────────┐"
    echo "  │  # 将軍を召喚                                            │"
    echo "  │  zellij -s shogun action write-chars \\                   │"
    echo "  │    'claude --dangerously-skip-permissions\\n'             │"
    echo "  │                                                          │"
    echo "  │  # 家老・足軽を一斉召喚                                   │"
    echo "  │  for i in (seq 0 8)                                      │"
    echo "  │    zellij -s multiagent action write-chars \\             │"
    echo "  │      'claude --dangerously-skip-permissions\\n'           │"
    echo "  │  end                                                     │"
    echo "  └──────────────────────────────────────────────────────────┘"
    echo ""
end

echo "  次のステップ:"
echo "  ┌──────────────────────────────────────────────────────────┐"
echo "  │  将軍の本陣にアタッチして命令を開始:                      │"
echo "  │     zellij attach shogun                                 │"
echo "  │                                                          │"
echo "  │  家老・足軽の陣を確認する:                                │"
echo "  │     zellij attach multiagent                             │"
echo "  │                                                          │"
echo "  │  ※ 各エージェントは指示書を読み込み済み。                 │"
echo "  │    すぐに命令を開始できます。                             │"
echo "  └──────────────────────────────────────────────────────────┘"
echo ""
echo "  ════════════════════════════════════════════════════════════"
echo "   天下布武！勝利を掴め！ (Tenka Fubu! Seize victory!)"
echo "  ════════════════════════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 7: ターミナルでセッションを開く（-t オプション時のみ）
# ═══════════════════════════════════════════════════════════════════════════════
if test "$OPEN_TERMINAL" = "true"
    log_info "📺 セッションを開いています..."
    zellij attach shogun
end
