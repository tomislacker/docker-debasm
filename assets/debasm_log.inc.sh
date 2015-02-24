log.getStamp ()
{
    date --iso-8601=${1:-${DEFAULT_ISO_8601}}
}

log.generic ()
{
    local logPipe=1
    local logLevel=$1
    shift
    local logMsg=$@

    case $logLevel in
        debug|info|notice)
            logPipe=1
            ;;
        warn|err|crit|alert|emerg)
            logPipe=2
            ;;
        *)
            logPipe=2
            ;;
    esac

    echo -e "[$(log.getStamp):${logLevel}] $logMsg" \
        >&${logPipe}
}

log.debug ()
{
    log.generic debug $@
}

log.info ()
{
    log.generic info $@
}

log.notice ()
{
    log.generic notice $@
}

log.warn ()
{
    log.generic warn $@
}

log.err ()
{
    log.generic err $@
}

log.crit ()
{
    log.generic crit $@
}

log.alert ()
{
    log.generic alert $@
}

log.emerg ()
{
    log.generic emerg $@
}

