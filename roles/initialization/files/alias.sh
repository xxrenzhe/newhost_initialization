# alias.sh

# User specific environment and startup programs

alias shutdown='Forbidden_shutdown'
alias reboot='Forbidden_reboot'
alias poweroff='Forbidden_poweroff'
alias halt='Forbidden_halt'
alias init='Forbidden_init'
alias rm='trash'
alias d='sudo dstat -cdnylr  --top-cpu --top-mem --top-io --top-latency' 2>/dev/null
alias genpasswd='strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 32 | tr -d "\n"; echo'
alias c=clear
alias histg='history | grep'
alias ..='cd ..'
alias ...='cd ../..'
alias cmount='mount | column -t'
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
alias intercept='sudo strace -ff -e trace=write -e write=1,2 -p'
alias meminfo='free -mlt'
alias ps?='ps aux | grep'
alias listen='lsof -P -i -n'
alias port='ss -antupl'

mcd() { mkdir -p $1;cd $1; }
cls() { cd $1;ls -l --color=auto; }
backup() { cp $1{,.bak}; }
md5check() { md5sum $1 | grep $2; }
sbs() { sudo du -b --max-depth 1 | sort -nr | perl -pe 's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e'; }

extract() { 
  if [ -f $1 ] ; then 
    case $1 in
      *.tar.bz2) tar xjf $1 ;;
      *.tar.gz) tar xzf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) unrar e $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar xf $1 ;;
      *.tbz2) tar xjf $1 ;;
      *.tgz) tar xzf $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *) echo "$1 cannot be extracted via extract()" ;;
    esac
  else
    echo "$1 is not a valid file"
  fi
}

trash() {
  while [ -n "$1" ]
  do
    case $1 in
    -*) shift;break;;
    *) break;;
    esac
  done
  read -p "Do you really want to move to /tmp/.trash? [y/n]" answer
  case $answer in
  Y|y) (mv "$@" /tmp/.trash &>/dev/null || mv "$@" /tmp/.trash/$RANDOM &>/dev/null) && echo "Moved to /tmp/.trash ok." ;;
  N|n) echo "The operation cancelled.";;
  *) echo "Wrong choice,the operation cancelled.";;
  esac
}
