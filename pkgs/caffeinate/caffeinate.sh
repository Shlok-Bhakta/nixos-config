usage() {
  echo "Usage: caffeinate             # until Ctrl-C"
  echo "       caffeinate -t SECONDS  # for a duration"
  echo "       caffeinate COMMAND...  # while command runs"
}

peach() {
  if [[ -t 1 ]]; then
    printf '\033[38;2;250;179;135m%s\033[0m\n' "$*"
  else
    printf '%s\n' "$*"
  fi
}

coffee() {
  if [[ -t 1 ]]; then
    printf '\033[38;2;250;179;135m'
  fi
  cat <<'EOF'
      ( (
       ) )
    .______.
    |      |]
    \      /
     `----'
EOF
  if [[ -t 1 ]]; then
    printf '\033[0m'
  fi
}

quips=(
  "cmon just one more cup"
  "did you know Java was named after coffee? the island, technically. the mug is still valid documentation."
  "decaf is just brown water with a pr team"
  "espresso yourself. the type checker won't."
  "you can sleep when hypridle says so. it just didn't."
  "a second cup isn't a cup. it's a personality"
  "this session is 12% code and 88% beans"
  "coffee: because 'I'll sleep later' is a valid architecture"
  "one more sip. then we refactor. then another sip."
  "latte to the party, but at least we're awake"
  "error 418: I'm a teapot. close, but this is a mug"
  "grind now, crash later. that's the sprint plan"
  "your sleep debt bounced. insufficient funds"
  "caffeine doesn't give you energy. it just hides the tired. shh."
  "we named a language Java and a bug a moth. we should not be in charge of naming."
  "\"just a quick cup\" — the original estimated-time-of-arrival lie"
  "americano is espresso that studied abroad and came back boring. still counts."
  "if it compiles, coffee. if it doesn't, also coffee. this is called a default."
  "going back to sleep is so last timeout"
  "the mug is empty. the kernel is not. tragic."
)

goodbye() {
  coffee
  peach "${quips[RANDOM % ${#quips[@]}]}"
}

inhibit_pid=""

on_stop() {
  trap - INT TERM
  if [[ -n "$inhibit_pid" ]]; then
    kill -TERM "$inhibit_pid" 2>/dev/null || true
    wait "$inhibit_pid" 2>/dev/null || true
  fi
  goodbye
  exit 0
}

run_inhibit() {
  trap on_stop INT TERM
  systemd-inhibit \
    --what=idle \
    --who=caffeinate \
    --why="user requested" \
    --mode=block \
    bash -c 'trap "exit 0" INT TERM; "$@"' bash "$@" &
  inhibit_pid=$!
  wait "$inhibit_pid" || true
}

case "${1:-}" in
  -h | --help)
    usage
    ;;
  -t)
    if [[ $# -lt 2 ]]; then
      echo "caffeinate: -t needs a duration in seconds" >&2
      exit 1
    fi
    coffee
    echo "caffeinated for $2s — idle lock/sleep off."
    run_inhibit sleep "$2"
    ;;
  "")
    coffee
    echo "caffeinated — idle lock/sleep off. Ctrl-C to stop."
    run_inhibit sleep infinity
    ;;
  *)
    coffee
    run_inhibit "$@"
    ;;
esac
