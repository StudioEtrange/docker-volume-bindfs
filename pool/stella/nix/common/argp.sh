#!/usr/bin/env bash
# -*- shell-script -*-


# Copyright (C) 2008-2013 Bob Hepple
#               2014 StudioEtrange
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# http://sourceforge.net/projects/argpsh
# http://bhepple.freeshell.org/oddmuse/wiki.cgi/arpg

# Certainly would not work on plain old sh, csh, ksh ... .

# Modified by StudioEtrange
#          * modification of the way to declare option and
#          * adding parameter
#          * support mandatory option AND parameter
#          * check validity of parameter (foo.sh parameter -option)
#          * remove generation of man page
#          * lot of tweaks
#          * getopt command is now a parameter,
#                and could be a pure bash implementation  if we choose "PURE_BASH"
#                from Aron Griffis https://github.com/agriffis/pure-getopt
#          * remove read/print xml conf
#       ARGP_OPTION_SEP have no puropose, multiple values separator is defined with type (in example : 's:' or 's#')
ARGP_argp_sh_usage() {
    cat <<"EOF"
Usage: argp.sh

A wrapper for getopt(1) which simulates argp(3) for bash. Normally
other scripts pipe their option descriptions in here for automatic
help and man mpage production and for generating the code for
getopt(1). Requires bash-3+. See also argp(1) which is a binary (and
much faster) version of this.

See http://sourceforge.net/projects/argpsh
See http://bhepple.freeshell.org/oddmuse/wiki.cgi/argp

It buys you:

o all the goodness of getopt
o define options and parameters in one central place together with descriptions.
o fewer 'magic' and duplicated values in your code
o better consistency between the getopt calling parameters, the case
  statement processing the user's options and the help/man pages
o less spaghetti in your own code
o easier to maintain
o checking of option and parameter consistency at runtime
o range checking of option and parameter values at runtime
o pretty easy to use
o portable to OS's without long option support - the help page
  adapts too


############# USAGE ###########################
The full usage is something like this assuming the option description is in
the variable STRING (in flat as above or in XML) :

STRING="
--HEADER--

ARGP_PROG=my-script-name


# this defines the program's version string to be displayed by the -V option:
ARGP_VERSION=1.6

# delete '--quiet' and '--verbose' built-in options (quiet, verbose, help are default built-in options)
ARGP_DELETE=quiet verbose

# if this is set then multiple invocations of a string or array option will
# be concatenated using this separator eg '-s s -s b' will give 'a:b'
ARGP_OPTION_SEP=:

ARGP_SHORT=This is a short description for the first line of the man page.


ARGP_LONG_DESC=
This is a longer description.
Spring the flangen dump. Spring the flingen dump. Spring the flangen
dump. Spring the flingen dump.


--OPTIONS--
#NAME=DEFAULT  'SHORT_NAME'  'LABEL'   TYPE  MANDATORY  'RANGE'  DESCRIPTION

# An hidden option (looks like : --hidden) which does not appear in the help
# pages. It is a simple flag (boolean) with a default
# value of '' and 'set' if --hidden is on the command line.
HIDDEN=''       ''      ''          b   0     ''

# a boolean option with a short name and a numeric default which is
# incremented every time the --bool, -b option is given:
BOOL='0'        'b'     ''          b   0     ''                description of this option

# this is a (boolean) flag which gets set to the string 'foobar' when
# --flag, -f is on the command line otherwise it is set to 'barfoo':
FLAG='barfoo'   'f'     ''          b   0     'foobar'          a flag

# here is an integer value option which must sit in a given range:
INT=1           'i'     'units'     i   0   '1:3'               an integer

# here is an array value ie just a string which must take one of
# the values in the 'range':
ARRAY=a         'a'     'widgets'   a   0   'a b'               an array

# this option is a simple string which will be checked against a regex(7):
STRING=''       's'     'string'    s   0   '^foo.*bar$|^$'     a string

# a double value which is checked against a range:
DOUBLE=1        'd'     'miles'     d   0   '0.1:1.3'           a double

# this is a URL which will be checked against the URL regex and has a
# default value
URL='http://www.foobar.com'     'u'    'url'     u   0   ''     a url

# this uses the same short letter 'q' as the --quiet option which was
# deleted above
QUAINT=''       'q'      ''         s   0   ''                  a quaint description


--PARAMETERS--
#NAME=                 'LABEL'      TYPE     'RANGE'           DESCRIPTION          MANDATORY
ACTION=                 ''          a       'build run'         Action to compute.      '1'  
"

exec 4>&1
eval $( echo "$STRING" | ./argp.sh "$@" 3>&1 1>&4 || echo exit $? )
exec 4>&-
# $@ now contains args not processed. Parameters and options have been processed and removed.



############################ DEFINITION OF OPTIONS ############################

name=default : name must be present and unique. default may be ''
               for boolean type, default value is 0

sname        : the single-letter short name of the option
               (use '' if not needed)

label        : the name of this option to be used in --help.
               If empty, it will be autogenerated depending on the type
               (do not use label for booleans, leave it empty with '')

type         : i (integer)
               d (double)
               s[:] (string)
               a[:] (array) a value to pick in a list of valid string
               u (url)
               b (boolean)
               When used a boolean option is set to the range value
               (if range value is not setted the boolean is set to +1 each time it is used -b -b -b will be set to 3),
               When a boolean option is not used on command line, it is set to the default value  (if default value is not setted, then the value option is empty)
               If 's:' or 'a:' then ':' overrides ARGP_OPTION_SEP for this option.
               Any syntactically clean string can be used instead of ':' (ie not ' or ".)

mandatory    : 1 for mandatory option
               0 for non mandatory option

range        : for numeric options (type i, d): min-max eg 1.2-4.5
               for string options (type s)    : an extended regexp
               for array options    : a space separated list of alternates. array type must have a range specified.
               for boolean options  : the value to assign the option when set (default is 1)
               for url options : do not use. argp use an internal fixed regexp

desc         : long description of this option
               leave empty for hidden options
               long description could use '\' at the end of each line

############################ DEFINITION OF PARAMETERS ############################

name         : name must be present and unique.

label        : the name of the parameter to be used in --help.
               If empty, it will be autogenerated depending on the type

type         : i (integer)
               d (double)
               s (string)
               a (array) a value to pick in a list of valid string
               u (url)

range        : for numeric parameters (type i, d): min-max eg 1.2-4.5
               for string parameters (type s)    : an extended regexp
               for array parameters  : a space separated list of alternates. array type must have a range specified.
               for url parameters : do not use. argp use an internal fixed regexp

desc         : long description of this parameter. long description could use '\' at the end of each line

mandatory    : 1 for mandatory parameter
               0 for non mandatory parameter
###############################################################################


Note that --verbose, --help, --quiet and --version options will be
added automatically.
Use ARGP_DELETE to disable them.


If POSIXLY_CORRECT is set, then option parsing will end on the first
non-option argument (eg like ssh(1)).

GETOPT_CMD is an env variable we can choose a getopt command instead of default getopt
if GETOPT_CMD equal PURE_BASH, then a pure bash getopt implementation from Aron Griffis is used (https://github.com/agriffis/pure-getopt)



###############################################################################

Here is a sample of the output when the command is called with --help:

Usage: my-script [OPTION...] [--] [parameters]
This is a longer description. Spring the flangen dump. Spring the
flingen dump. Spring the flangen dump. Spring the flingen dump."

Parameters :


Options:

  -a, --array=<widgets>      an array Must be of type 'a'. Must be in the range 'a b'.
  -b, --bool                 description of this option
  -d, --double=<miles>       a double. Must be of type 'd'. Must be in the range '0.1:1.3'.
  -f, --flag                 a flag
  -i, --int=<units>          an integer. Must be of type 'i'. Must be in the range '1:3'.
  -q, --quaint               a quaint description Must fit the regex ''.
  -s, --string=<string>      a string. Must fit the regex '^foo.*bar$|^$'.
  -u, --url=<url>            a url. Must fit the regex '^(nfs|http|https|ftp|file)://[[:alnum:]_.-]*[^[:space:]]*$'.
  -v, --verbose              be verbose
  -h, --help                 print this help message
  -V, --version              print version and exit

EOF
}

argp_sh_version() {
    echo "$GARGP_VERSION"
}

print_array() {
    let n=0
    for i in "$@"; do printf %s " [$n]='$i'"; let n+=1; done
}

debug_args() {
    {
        local i
        printf %s "${FUNCNAME[1]} "
        print_array "$@"
        echo
    } >&2
}

abend() {
    STAT=$1; shift
    default_usage
    echo "* ERROR *"
    local FMT="fmt -w $GARGP_RMARGIN"
    type fmt &> /dev/null || FMT=cat
    echo "$ARGP_PROG: $@" | $FMT >&2
    echo "exit $STAT;" >&3
    exit $STAT
}


add_param() {
  local NAME DESC TYPE RANGE MANDATORY LABEL ORIGINAL_NAME

    NAME=$(convert_to_env_name "$1")
    ORIGINAL_NAME="$1" # original name of the param
    LABEL="${2:-}" # argument label - optional
    TYPE="${3:-}" # type of the argument - optional
    RANGE="${4:-}" # range for the argument - optional
    MANDATORY="${5:-}" # mandatory for the argument - optional - default 1
    [[ "$MANDATORY" = "" ]] && MANDATORY=1
    DESC="${6:-}"

    local ALLOWED_CHARS='[a-zA-Z0-9_][a-zA-Z0-9_]*'
    local PARAM
    local OPT

    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    [[ "$NAME" ]] || abend 1 "$ARGP_PROG: argp.sh: add_param requires a name"

    # [[ "$NAME" =~ $ALLOWED_CHARS ]] || { ... this needs bash-3
    [[ `echo $NAME |tr -d '[:alnum:]' |tr -d '[_]'` ]] && {
        abend 1 "argp.sh: add_param: NAME (\"$NAME\") must obey the regexp $ALLOWED_CHARS"
    }

    # check it's not already in use
    for PARAM in ${ARGP_PARAM_LIST:-}; do
        if [[ "$NAME" = "$PARAM" ]]; then
            abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: param name \"$NAME\" is already in use"
        fi
    done
    for OPT in ${ARGP_OPT_LIST:-}; do
        if [[ "$NAME" = "$PARAM" ]]; then
            abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: param name \"$NAME\" is already in use"
        fi
    done

    export ARGP_ORIGINAL_NAME_$NAME="$ORIGINAL_NAME"

    if [[ "$DESC" ]]; then
        export ARGP_DESC_PARAM_$NAME="$DESC"
    fi

    export ARGP_MANDATORY_$NAME="$MANDATORY"

    [[ "$LABEL" ]] && export ARGP_LABEL_$NAME="$LABEL"

    TYPE=$(echo $TYPE| tr 'A-Z' 'a-z')
    # use a while loop just for the 'break':
  while true; do
    case "$TYPE" in
      i)
        [[ "$LABEL" ]] || export ARGP_LABEL_$NAME="integer"
        [[ "$RANGE" ]] || break
        echo "$RANGE" | egrep -q "$GARGP_INT_RANGE_REGEX" && break
        ;;
      d)
        [[ "$LABEL" ]] || export ARGP_LABEL_$NAME="double"
        [[ "$RANGE" ]] || break
        echo "$RANGE" | egrep -q "$GARGP_FLOAT_RANGE_REGEX" && break
        ;;
      s)
        [[ "$LABEL" ]] || export ARGP_LABEL_$NAME="string"
        [[ "$RANGE" ]] || break
        # just test the regex:
        echo "" | egrep -q "$RANGE"
        [[ $? -eq 2 ]] || break
        ;;
      a)
        [[ "$LABEL" ]] || export ARGP_LABEL_$NAME="string"
        [[ "$RANGE" ]] || abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: array type must have a list of value for parameter '$ORIGINAL_NAME'."
        break
        ;;
      url)
        [[ "$LABEL" ]] || export ARGP_LABEL_$NAME="url"
        local SEP=${TYPE:1:1}
        TYPE=s$SEP
        RANGE="$GARGP_URL_REGEX"
        break
        ;;
	   s*|a*|b)
	     abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: illegal argument type ('$TYPE') for parameter '$ORIGINAL_NAME'."
    	break
    	;;
    *)
          abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: need type for parameter '$ORIGINAL_NAME'."
          break
          ;;
    esac
    abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: bad type ('$TYPE') or range ('$RANGE') for parameter '$ORIGINAL_NAME'."
  done
  export ARGP_TYPE_$NAME="$TYPE"
  export ARGP_RANGE_$NAME="$RANGE"

  ARGP_PARAM_LIST="${ARGP_PARAM_LIST:-} $NAME"

}

add_opt() {
    local NAME DEFAULT DESC SOPT LABEL LOPT TYPE RANGE MANDATORY ORIGINAL_NAME
    ORIGINAL_NAME="$1" # ie (debug)
    NAME=$(convert_to_env_name "$1") # ie (debug => DEBUG)
    LOPT=$(convert_to_option_name "$1") # long name in 'command line option style' (ie ARGP_DEBUG => argp-debug)
    DEFAULT=${2:-}
    SOPT="${3:-}" # short option letter - optional
    LABEL="${4:-}" # argument label - optional
    TYPE="${5:-}" # type of the argument - optional
    MANDATORY="${6:-}" # mandatory or not - optional
    RANGE="${7:-}" # range for the argument - optional
    DESC="${8:-}" # if not set, the option is considered as hidden
    local ALLOWED_CHARS='[a-zA-Z0-9_][a-zA-Z0-9_]*'
    local OPT
    local PARAM

    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    [[ "$NAME" ]] || abend 1 "$ARGP_PROG: argp.sh: add_opt requires a name"

    # [[ "$NAME" =~ $ALLOWED_CHARS ]] || { ... this needs bash-3
    [[ `echo $NAME |tr -d '[:alnum:]' |tr -d '[_]'` ]] && {
        abend 1 "argp.sh: apt_opt: NAME (\"$NAME\") must obey the regexp $ALLOWED_CHARS"
    }

    export ARGP_ORIGINAL_NAME_$NAME="$ORIGINAL_NAME"
    export ARGP_DEFAULT_$NAME="$DEFAULT"

    # check it's not already in use
    for OPT in ${ARGP_OPTION_LIST:-}; do
        if [[ "$NAME" = "$OPT" ]]; then
            abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: option name \"$NAME\" is already in use"
        fi
        # check that the (short) option letter is not already in use:
        if [[ "$SOPT" ]]; then
            if [[ "$SOPT" == "$(get_opt_letter $OPT)" ]]; then
                abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: short option \"$SOPT\" is already in use by $OPT"
            fi
        fi
    done
    for PARAM in ${ARGP_PARAM_LIST:-}; do
        if [[ "$NAME" = "$PARAM" ]]; then
            abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: opt name \"$NAME\" is already in use"
        fi
    done

    if [[ "$SOPT" ]]; then
        [[ ${#SOPT} -ne 1 ]] && {
            abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: short option \"$SOPT\" for option $ORIGINAL_NAME is not a single character"
        }
        export ARGP_SOPT_$NAME="$SOPT"
    fi
    export ARGP_LOPT_$NAME="$LOPT"

    if [[ "$DESC" ]]; then
        export ARGP_DESC_OPT_$NAME="$DESC"
    fi

    if [[ "$MANDATORY" == "1" ]]; then
        export ARGP_MANDATORY_$NAME="1"
    else
        export ARGP_MANDATORY_$NAME="0"
   fi

   [[ "$LABEL" ]] && export ARGP_LABEL_$NAME="$LABEL"

    TYPE=$(echo $TYPE| tr 'A-Z' 'a-z')
    # use a while loop just for the 'break':
  while true; do
    case "$TYPE" in
      b)
        [[ "$LABEL" ]] && abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: boolean type can not have label for option '$ORIGINAL_NAME'."
        [[ "$DEFAULT" ]] || export ARGP_DEFAULT_$NAME=""
        export ARGP_LABEL_$NAME=
        break
        ;;
      i)
        [[ "$LABEL" ]] || export ARGP_LABEL_$NAME="integer"
        [[ "$RANGE" ]] || break
        echo "$RANGE" | egrep -q "$GARGP_INT_RANGE_REGEX" && break
        ;;
      d)
        [[ "$LABEL" ]] || export ARGP_LABEL_$NAME="double"
        [[ "$RANGE" ]] || break
        echo "$RANGE" | egrep -q "$GARGP_FLOAT_RANGE_REGEX" && break
        ;;
      s*)
        [[ "$LABEL" ]] || export ARGP_LABEL_$NAME="string"
        [[ "$RANGE" ]] || break
        # just test the regex:
        echo "" | egrep -q "$RANGE"
        [[ $? -eq 2 ]] || break
        ;;
      a)
        [[ "$LABEL" ]] || export ARGP_LABEL_$NAME="string"
        [[ "$RANGE" ]] || abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: array type must have a list of value for option '$ORIGINAL_NAME'."
        break
        ;;
      url)
        [[ "$LABEL" ]] || export ARGP_LABEL_$NAME="url"
        local SEP=${TYPE:1:1}
        TYPE=s$SEP
        RANGE="$GARGP_URL_REGEX"
        break
        ;;
      *)
          abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: need type for option '$ORIGINAL_NAME'."
          break
          ;;
    esac
    abend 1 "$ARGP_PROG: argp.sh: $FUNCNAME: bad type ('$TYPE') or range ('$RANGE') for option '$ORIGINAL_NAME'."
  done
  export ARGP_TYPE_$NAME="$TYPE"
  export ARGP_RANGE_$NAME="$RANGE"

    ARGP_OPTION_LIST="${ARGP_OPTION_LIST:-} $NAME"
}

get_opt_letter() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    local NAME="$1"
    local L="ARGP_SOPT_$NAME"
    printf %s  "${!L:-}"
    [[ "$ARGP_DEBUG" ]] && echo "returning ${!L:-}" >&2
}

# get original name of parameter
get_param_original_name() {
  get_opt_original_name "$@"
}

# get original name of option
get_opt_original_name() {
  [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    local NAME="$1"
    local L="ARGP_ORIGINAL_NAME_$NAME"
    printf %s  "${!L:-}"
}

get_opt_long_name() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    local NAME="$1"
    local L="ARGP_LOPT_$NAME"
    printf %s  "${!L:-}"
}

get_param_label() {
  get_opt_label "$@"
}

# option label
get_opt_label() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    local NAME="$1"
    local L="ARGP_LABEL_$NAME"
    printf %s "${!L:-}"
}

# convert an environment name (eg ARGP_DEBUG) to a long option name (eg argp-debug)
convert_to_option_name() {
    echo "$1" | tr '[:upper:]_' '[:lower:]-'
}

convert_to_env_name() {
    echo "$1" | tr '[:lower:]-' '[:upper:]_'
}

get_opt_type() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
  local NAME="$1"
  local T="ARGP_TYPE_$NAME"

  printf %s "${!T:-}"
}

get_param_type() {
	get_opt_type "$@"
}

get_opt_mandatory() {
 [[ "$ARGP_DEBUG" ]] && debug_args "$@"
  local NAME="$1"
  local T="ARGP_MANDATORY_$NAME"

  printf %s "${!T:-}"

}

get_param_mandatory() {
  get_opt_mandatory "$@"
}

get_param_range() {
	get_opt_range "$@"
}

get_opt_range() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
  local NAME="$1"
  local R="ARGP_RANGE_$NAME"

  printf %s "${!R:-}"
}

get_opt_default() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    local NAME="$1"
    local D=ARGP_DEFAULT_$NAME
    local DEFAULT="${!D}"
  printf %s "${DEFAULT:-}"
}



get_opt_short_desc() {
   [[ "$ARGP_DEBUG" ]] && debug_args "$@"
   local NAME="$1"
   local L="ARGP_DESC_OPT_$NAME"
   printf %s "${!L:-}"
}

get_param_short_desc() {
   [[ "$ARGP_DEBUG" ]] && debug_args "$@"
   local NAME="$1"
   local L="ARGP_DESC_PARAM_$NAME"
   printf %s "${!L:-}"
}

get_param_desc() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    local NAME="$1"
    local L="ARGP_DESC_PARAM_$NAME"

    printf %s "${!L:-}"
  local TYPE=$(get_param_type "$NAME")
  local RANGE=$(get_param_range "$NAME")
  local MANDATORY=$(get_param_mandatory "$NAME")

if [[ "$MANDATORY" == "1" ]]; then
	echo -n " Mandatory."
fi

  if  [[ "$TYPE" && "$TYPE" != "b" && "$TYPE" != "h" ]]; then
        if [[ "$TYPE" != s* || "$RANGE" ]]; then
            if [[ "$TYPE" != s* && "$TYPE" != "a" ]]; then
              echo -n " Must be of type '$TYPE'."
            fi
            if [[ "$RANGE" ]]; then
              case "$TYPE" in
                s*|S*)
                  echo -n " Must fit the regex '$RANGE'."
                  ;;
                a)
                  echo -n " Must be one of these values '$RANGE'."
                  ;;
                *)
                  echo -n " Must be in the range '$RANGE'."
                  ;;
              esac
            fi
        fi
  fi
}

get_opt_desc() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    local NAME="$1"
    local L="ARGP_DESC_OPT_$NAME"

    printf %s "${!L:-}"
  local TYPE=$(get_opt_type "$NAME")
  local RANGE=$(get_opt_range "$NAME")
local MANDATORY=$(get_opt_mandatory "$NAME")

if [[ "$MANDATORY" == "1" ]]; then
	echo -n " Mandatory."
fi
    DEFAULT=$(get_opt_default "$NAME")
    [[ "$DEFAULT" ]] && echo -n " Default is '$DEFAULT'."

  if  [[ "$TYPE" && "$TYPE" != "b" && "$TYPE" != "h" ]]; then
        if [[ "$TYPE" != s* || "$RANGE" ]]; then
            if [[ "$TYPE" != s* && "$TYPE" != "a" ]]; then
              echo -n " Must be of type '$TYPE'."
            fi
            if [[ "$RANGE" ]]; then
              case "$TYPE" in
                s*|S*)
                  echo -n " Must fit the regex '$RANGE'."
                  ;;
                a)
                  echo -n " Must be one of these values '$RANGE'."
                  ;;
                *)
                  echo -n " Must be in the range '$RANGE'."
                  ;;
              esac
            fi
        fi
  fi
}


# allow them to specify the long option name or the environment parameter
del_opt() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"

    local OPT_NAME PRE ENV_NAME
    for OPT_NAME in "$@"; do
        ENV_NAME=$(convert_to_env_name "$OPT_NAME")
        OPT_NAME=$(convert_to_option_name "$OPT_NAME")
        for PRE in ARGP_SOPT_ ARGP_LOPT_ ARGP_DESC_OPT_ ARGP_LABEL_  ARGP_TYPE_ ARGP_ORIGINAL_NAME_ ARGP_MANDATORY_ ARGP_RANGE_; do
            local N=$PRE$ENV_NAME
            [[ "${!N:-}" ]] && unset $PRE$ENV_NAME
        done
        local OPT_LIST OPT
        OPT_LIST=""
        for OPT in ${ARGP_OPTION_LIST:-}; do
            [[ $OPT = $ENV_NAME ]] || OPT_LIST="$OPT_LIST $OPT"
        done
        ARGP_OPTION_LIST="$OPT_LIST"

        [[ "$OPT_NAME" == "$GARGP_HELP_loption" ]] && {
            GARGP_HELP_option=
            GARGP_HELP_loption=
        }
        [[ "$OPT_NAME" == "$GARGP_VERSION_loption" ]] && {
            GARGP_VERSION_option=
            GARGP_VERSION_loption=
        }
        [[ "$OPT_NAME" == "$GARGP_PRINTMAN_loption" ]] && {
            GARGP_PRINTMAN_loption=
        }
    done
}

# prints an abstract of short options that take no parameter
print_abstract_opt_short_without_arg() {
    local NAME DESC L A FLAGS=""

    for NAME in ${ARGP_OPTION_LIST:-}; do
        [[ "$NAME" == $( convert_to_env_name "$GARGP_ENDOPTS_loption") ]] && continue
        DESC=$(get_opt_desc $NAME)
        [[ "$DESC" ]] || continue
        L=$(get_opt_letter $NAME)
        [[ "$L" ]] || continue
        A=$(get_opt_label $NAME)
        [[ "$A" ]] && continue
        FLAGS="$FLAGS$L"
    done
    printf %s "$FLAGS"
}

# prints an abstract of long options that take no parameter
print_abstract_opt_long_without_arg() {
    local NAME
    local FLAGS=""
    local SPACE=""

    for NAME in ${ARGP_OPTION_LIST:-}; do
        local DESC=$(get_opt_desc $NAME)
        [[ "$DESC" ]] || continue
        local L=$(get_opt_long_name $NAME)
        [[ "$L" = "$GARGP_ENDOPTS_loption" ]] && continue
        [[ "$L" ]] || continue
        local A=$(get_opt_label $NAME)
        [[ "$A" ]] && continue
        printf -- "$SPACE--%s" $L
        SPACE=" "
    done
    printf %s "$FLAGS"
}


# prints an abstract of short and long options that take values
print_abstract_opt_with_args() {

    local NAME FMT
    for NAME in ${ARGP_OPTION_LIST:-}; do
        local DESC=$(get_opt_desc $NAME)
        [[ "$DESC" ]] || continue
        local LABEL=$(get_opt_label "$NAME")
        [[ "$LABEL" ]] || continue

        local SOPT=$(get_opt_letter "$NAME")
        local LOPT=$(get_opt_long_name "$NAME")

      	local MANDATORY=$(get_opt_mandatory "$NAME")

      	echo -n " "
      	[[ "$MANDATORY" == "0" ]] && echo -n "["

      	[[ "$SOPT" ]] && (
      		FMT="-%s <%s>"
          [[ "$LABEL" ]] && printf -- "$FMT" $SOPT $LABEL
      		[[ "$LABEL" ]] && echo -n ","
      	)

       FMT="--%s=<%s>"
       [[ "$LABEL" ]] && printf -- "$FMT" $LOPT $LABEL
       [[ "$MANDATORY" == "0" ]] && echo -n "]"
    done
}

# prints an abstract of parameter
print_abstract_param() {
    local NAME FMT
    for NAME in ${ARGP_PARAM_LIST:-}; do
      local DESC=$(get_param_desc $NAME)
      [[ "$DESC" ]] || continue
      local LABEL=$(get_param_label "$NAME")
      [[ "$LABEL" ]] || continue


      local ORIGINAL_NAME=$(get_param_original_name "$NAME")

      echo -n " "

      FMT="%s"
      printf -- "$FMT" $LABEL
    done
}

# print the help line for all options
print_full_opts() {
    local NAME
    for NAME in ${ARGP_OPTION_LIST:-}; do
        print_opt $NAME
    done
}

# print the help line for all options
print_full_params() {
    local NAME
    for NAME in ${ARGP_PARAM_LIST:-}; do
        print_param $NAME
    done
}



add_std_opts() {
    get_opt_name -$GARGP_HELP_option >/dev/null && GARGP_HELP_option=
    get_opt_name --$GARGP_HELP_loption  >/dev/null && GARGP_HELP_loption=
    if [[ "$GARGP_HELP_option$GARGP_HELP_loption" ]]; then
        add_opt "$GARGP_HELP_loption" "" "$GARGP_HELP_option" "" b 0 "" "print this help and exit"
    fi

    get_opt_name -$GARGP_VERSION_option  >/dev/null && GARGP_VERSION_option=
    get_opt_name --$GARGP_VERSION_loption  >/dev/null && GARGP_VERSION_loption=
    if [[ "$GARGP_VERSION_option$GARGP_VERSION_loption" ]]; then
        add_opt "$GARGP_VERSION_loption" "" "$GARGP_VERSION_option" "" b 0 "" "print version and exit"
    fi

    get_opt_name -$GARGP_VERBOSE_option >/dev/null  && GARGP_VERBOSE_option=
    get_opt_name --$GARGP_VERBOSE_loption >/dev/null  && GARGP_VERBOSE_loption=
    if [[ "$GARGP_VERBOSE_option$GARGP_VERBOSE_loption" ]]; then
        add_opt "$GARGP_VERBOSE_loption" "" "$GARGP_VERBOSE_option" "" b 0 "" "do it verbosely"
    fi

    get_opt_name -$GARGP_QUIET_option >/dev/null  && GARGP_QUIET_option=
    get_opt_name --$GARGP_QUIET_loption  >/dev/null && GARGP_QUIET_loption=
    if [[ "$GARGP_QUIET_option$GARGP_QUIET_loption" ]]; then
        add_opt "$GARGP_QUIET_loption" "" "$GARGP_QUIET_option" "" b 0 "" "do it quietly"
    fi

    add_opt "$GARGP_ENDOPTS_loption" "" "-" "" b 0 "" "explicitly ends the options"
}


print_param() {
    local NAME="$1"
    local L N DESC ORIGINAL_NAME LABEL

    DESC=$(get_param_desc $NAME)
    [[ "$DESC" ]] || return 0
    ORIGINAL_NAME=$(get_param_original_name $NAME)
    LABEL=$(get_param_label $NAME)

    LINE=""
    for (( N=0 ; ${#LINE} < GARGP_SHORT_OPT_COL ; N++ )) ; do
        LINE="$LINE "
    done

    if [[ "$ORIGINAL_NAME" ]]; then
        LONG_START=$GARGP_SHORT_OPT_COL
        for (( N=0 ; ${#LINE} < LONG_START ; N++ )); do
            LINE="$LINE "
        done
        [[ "$LABEL" ]] && LINE="${LINE}$LABEL"
        #[[ "$LABEL" ]] && LINE="$LINE ($LABEL)"
    fi

    LINE="$LINE "
    while (( ${#LINE} < GARGP_OPT_DOC_COL - 1)) ; do LINE="$LINE " ; done
    # NB 'echo "-E"' swallows the -E!! and it has no -- so use printf
    printf -- "%s" "$LINE"

    FIRST="FIRST_yes"
    if (( ${#LINE} >= GARGP_OPT_DOC_COL )); then
        echo
        FIRST=""
    fi
    local WIDTH=$(( GARGP_RMARGIN - GARGP_OPT_DOC_COL ))
    if ! type fmt &> /dev/null || [[ "$WIDTH" -lt 10 ]]; then
        printf -- "%s\n" "$DESC"
        return 0
    fi

    export ARGP_INDENT=""
    while (( ${#ARGP_INDENT} < GARGP_OPT_DOC_COL - 1)); do
        ARGP_INDENT="$ARGP_INDENT "
    done
    echo "$DESC" |fmt -w "$WIDTH" -s | {
        while read L; do
            [[ "$FIRST" ]] ||
            printf %s "$ARGP_INDENT"; FIRST=""; printf -- "%s\n" "$L"
        done
    }
    unset ARGP_INDENT
}



print_opt() {
    local NAME="$1"
    local L N DESC SOPT LOPT LABEL

    DESC=$(get_opt_desc $NAME)
    [[ "$DESC" ]] || return 0
    SOPT=$(get_opt_letter $NAME)
    LOPT=$(get_opt_long_name $NAME)
    LABEL=$(get_opt_label $NAME)

    # if LABEL is not set (so the description, this option is hidden)
    LINE=""
    for (( N=0 ; ${#LINE} < GARGP_SHORT_OPT_COL ; N++ )) ; do
        LINE="$LINE "
    done
    [[ "$SOPT" ]] && LINE="${LINE}-$SOPT"
    [[ "$SOPT" ]] && [[ "$LABEL" ]] && LINE="${LINE} $LABEL"
    if [[ "$GARGP_LONG_GETOPT" && "$LOPT" != "$GARGP_ENDOPTS_loption" ]]; then
        [[ "$SOPT" ]] && [[ "$LOPT" ]] && LINE="$LINE, "
        if [[ "$LOPT" ]]; then
            if [[ "$SOPT" ]]; then
                LONG_START=${LONG_COL_OPT:-}
            else
                LONG_START=$GARGP_SHORT_OPT_COL
            fi
            for (( N=0 ; ${#LINE} < LONG_START ; N++ )); do
                LINE="$LINE "
            done
            [[ "$LOPT" ]] && LINE="${LINE}--$LOPT"
            [[ "$LOPT" ]] && [[ "$LABEL" ]] && LINE="$LINE=$LABEL"
        fi
    fi
    LINE="$LINE "
    while (( ${#LINE} < GARGP_OPT_DOC_COL - 1)) ; do LINE="$LINE " ; done
    # NB 'echo "-E"' swallows the -E!! and it has no -- so use printf
    printf -- "%s" "$LINE"

    FIRST="FIRST_yes"
    if (( ${#LINE} >= GARGP_OPT_DOC_COL )); then
        echo
        FIRST=""
    fi
    local WIDTH=$(( GARGP_RMARGIN - GARGP_OPT_DOC_COL ))
    if ! type fmt &> /dev/null || [[ "$WIDTH" -lt 10 ]]; then
        printf -- "%s\n" "$DESC"
        return 0
    fi

    export ARGP_INDENT=""
    while (( ${#ARGP_INDENT} < GARGP_OPT_DOC_COL - 1)); do
        ARGP_INDENT="$ARGP_INDENT "
    done
    echo "$DESC" |fmt -w "$WIDTH" -s | {
        while read L; do
            [[ "$FIRST" ]] ||
            printf %s "$ARGP_INDENT"; FIRST=""; printf -- "%s\n" "$L"
        done
    }
    unset ARGP_INDENT
}

# honour GNU ARGP_HELP_FMT parameter
load_help_fmt() {
    [[ "${ARGP_HELP_FMT:-}" ]] || return 0
    OFS="$IFS"
    IFS=','
    set -- $ARGP_HELP_FMT
    IFS="$OFS"
    while [[ "$1" ]]; do
        case "$1" in
            short-opt-col*)
                GARGP_SHORT_OPT_COL=$(echo "$1"|cut -d'=' -f 2)
                shift
                ;;
            long-opt-col*)
                GARGP_LONG_OPT_COL=$(echo "$1"|cut -d'=' -f 2)
                shift
                ;;
            opt-doc-col*)
                GARGP_OPT_DOC_COL=$(echo "$1"|cut -d'=' -f 2)
                shift
                ;;
            rmargin*)
                GARGP_RMARGIN=$(echo "$1"|cut -d'=' -f 2)
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
}

default_usage() {
    local FLAGS=$(print_abstract_opt_short_without_arg)
    [[ "$FLAGS" ]] && FLAGS="[-$FLAGS]"
    local LFLAGS=$(print_abstract_opt_long_without_arg)
    [[ "$LFLAGS" ]] && LFLAGS=" [$LFLAGS]"
    local OPT_ARGS=$(print_abstract_opt_with_args)
    local PARAM_ABSTRACT=$(print_abstract_param)
    local FMT="fmt -w $GARGP_RMARGIN -s"
    type fmt &> /dev/null || FMT=cat
    echo "${SHORT_DESC:-}"
    echo
    echo -e "Usage: $ARGP_PROG ${PARAM_ABSTRACT:-} $FLAGS$LFLAGS $OPT_ARGS" |$FMT
    echo
    echo "${LONG_DESC:-}"
    echo
    echo "Parameters:"
    echo
    print_full_params
    echo
    echo "Options:"
    echo
    print_full_opts
}

check_type_and_value() {
  local NAME="$1"
  local VALUE="$2"
  local TYPE="$3"
  local RANGE="$4"

    [[ "$ARGP_DEBUG" ]] && echo "$FUNCNAME: NAME='$NAME' VALUE='$VALUE' TYPE='$TYPE' RANGE='$RANGE'" >&2
  # just using 'while' for the sake of the 'break':
  while [[ "$TYPE" ]]; do
    case "$TYPE" in
      i)
        [[ "$VALUE" =~ $GARGP_INT_REGEX ]] || break
        [[ "$RANGE" ]] && {
          local LOWER=$(echo "$RANGE" | cut -d: -f1)
          local UPPER=$(echo "$RANGE" | cut -d: -f2)
          [[ "$LOWER" && "$VALUE" -lt "$LOWER" ]] && break
          [[ "$UPPER" && "$VALUE" -gt "$UPPER" ]] && break
        }
        return 0
        ;;
      d)
        [[ "$VALUE" =~ $GARGP_FLOAT_REGEX ]] || break
        [[ "$RANGE" ]] && {
          local LOWER=$(echo "$RANGE" | cut -d: -f1)
          local UPPER=$(echo "$RANGE" | cut -d: -f2)
          [[ "$LOWER" ]] && {
            awk "BEGIN {if ($VALUE < $LOWER) {exit 1} else {exit 0}}" || break
          }
          [[ "$UPPER" ]] && {
            awk "BEGIN {if ($VALUE > $UPPER) {exit 1} else {exit 0}}" || break
          }
        }
        return 0
        ;;
      s*)
        [[ "$RANGE" ]] && {
          [[ "$VALUE" =~ $RANGE ]] || break
        }
        return 0
        ;;
      a)
        local VAL
        for VAL in $RANGE; do
          [[ "$VAL" == "$VALUE" ]] && return 0
        done
        break
        ;;
    esac
  done

  MSG="$ARGP_PROG: value '$VALUE' given for '$NAME'"
  if [[ "$TYPE" != s* ]]; then
      MSG+=" must be of type '$TYPE'"
  fi
  [[ "$RANGE" ]] && {
    case "$TYPE" in
      s*)
        MSG+=" and must fit the regex '$RANGE'"
        ;;
      a)
        MSG+=" and must be one of these values: $RANGE"
        ;;
      f|d|i)
                MSG+=" and in the range '$RANGE'"
        ;;
    esac
  }
    abend 1 "$MSG"
}


get_opt_name() {
    # returns the name for an option letter or word
    local OPT="$1" # an option eg -c or --foobar
    local NAME
    for NAME in ${ARGP_OPTION_LIST:-}; do
        local ARGP_L=ARGP_LOPT_$NAME
        local ARGP_S=ARGP_SOPT_$NAME
        if  [[ "--${!ARGP_L:-}" = "$OPT" ]] || \
            [[ "-${!ARGP_S:-}" = "$OPT" ]]; then
            echo "${NAME}"
            return 0
        fi
    done
    return 1
}


# NOTE : reset options value to EMPTY by default
reset_params() {
    local PARAM_NAME=
    for PARAM_NAME in $ARGP_PARAM_LIST; do
        export $PARAM_NAME=
    done
}


# NOTE : reset options value to EMPTY by default
reset_opts() {
    local OPT_NAME=
    for OPT_NAME in $ARGP_OPTION_LIST; do
        export $OPT_NAME=
    done
}



process_extra_params() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    local SHIFT_NUM=0 VALUE TOTAL_SIZE=0 TMP COUNT=0

    TMP="$@"
    # total size of parameters + arg after ending options (@ do not contains ' -- ' here)
    TOTAL_SIZE="${#TMP}"
    [[ $ENDING_ARG_SIZE -gt 0 ]] && TOTAL_SIZE=$(( TOTAL_SIZE - ENDING_ARG_SIZE ))

    while true; do
        VALUE="${1:-}"

        ((SHIFT_NUM++))
        shift

        [[ "$VALUE" ]] && {
          TMP="${#VALUE}"
          COUNT=$(( COUNT + TMP ))
        }
        [[ $COUNT -gt $TOTAL_SIZE ]] && {
          # we have reached the ending option arg (the ones after --)
          break;
        }

        COUNT=$(( COUNT + 1 ))
        EXTRA_PARAM="$EXTRA_PARAM '$VALUE'"
    done
    return $SHIFT_NUM
}

process_params() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    local SHIFT_NUM=0 PARAM PARAM_NAME TYPE RANGE MANDATORY VALUE TOTAL_SIZE=0 TMP COUNT=0 END_OF_DEFINED_PARAM=

    TMP="$@"
    # total size of parameters + arg after ending options (@ do not contains ' -- ' here)
    TOTAL_SIZE="${#TMP}"

    [[ $ENDING_ARG_SIZE -gt 0 ]] && TOTAL_SIZE=$(( TOTAL_SIZE - ENDING_ARG_SIZE ))

    for PARAM_NAME in $ARGP_PARAM_LIST; do
        VALUE="${1:-}"
        MANDATORY=$(get_param_mandatory "$PARAM_NAME")
        TYPE=$(get_param_type "$PARAM_NAME")
        [[ "$TYPE" ]] || {
            abend 1 "$ARGP_PROG: argp.sh: no type for param \"$PARAM_NAME\""
        }
        RANGE=$(get_param_range "$PARAM_NAME")



        [[ "$VALUE" ]] && {
          TMP="${#VALUE}"
          COUNT=$(( COUNT + TMP ))
        }

        [[ $COUNT -gt $TOTAL_SIZE ]] && {
          # we have reached the ending option arg (the ones after --)
          END_OF_DEFINED_PARAM=1
          VALUE=
        }
        COUNT=$(( COUNT + 1 ))

        [[ "$VALUE" ]] && {
            check_type_and_value "$PARAM_NAME" "$VALUE" "$TYPE" "$RANGE"
        } || {
            [[ "$MANDATORY" == "1" ]] && abend 1 "$PARAM_NAME is mandatory"
        }
        
        [[ $END_OF_DEFINED_PARAM ]] && break;

        ((SHIFT_NUM++))
        shift

        [[ "$ARGP_DEBUG" ]] &&
        echo "process_params: param='$PARAM_NAME' value='$VALUE' type='$TYPE' range='$RANGE'"

        export $PARAM_NAME="$VALUE"
        set +x
    done

    [[ "$ARGP_DEBUG" ]]  && {
      [[ $COUNT -lt $TOTAL_SIZE ]] && {
          echo "process_params: there is extra parameter not treated"
      }
    }

    return $SHIFT_NUM
}

process_opts() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    local SHIFT_NUM=0 OPTION= OPT_NAME= TYPE= RANGE=

    while true; do
        OPTION="${1:-}"
        if  [[ "$GARGP_HELP_option"  &&  "-$GARGP_HELP_option"  == "$OPTION" ]] ||
            [[ "$GARGP_HELP_loption" && "--$GARGP_HELP_loption" == "$OPTION" ]]; then
            usage 2>/dev/null || default_usage
            echo "exit 0;" >&3
            exit 0
        fi

        if  [[ "$GARGP_VERSION_option"  &&  "-$GARGP_VERSION_option"  == "$OPTION" ]] ||
            [[ "$GARGP_VERSION_loption" && "--$GARGP_VERSION_loption" == "$OPTION" ]]; then
            echo "echo $ARGP_PROG: version: '$ARGP_VERSION'; exit 0;" >&3
            exit 0
        fi


        ((SHIFT_NUM++))
        shift

        [[ "$OPTION" = "--" ]] && break
        [[ "$OPTION" = "" ]] && break

        # here is where all the user options get done:
        OPT_NAME=$(get_opt_name "$OPTION")
        [[ "$OPT_NAME" ]] || {
            abend 1 "$ARGP_PROG: argp.sh: no name for option \"$OPTION\""
        }

        TYPE=$(get_opt_type "$OPT_NAME")
        [[ "$TYPE" ]] || {
            abend 1 "$ARGP_PROG: argp.sh: no type for option \"$OPTION\""
        }
        RANGE=$(get_opt_range "$OPT_NAME")

        [[ "$ARGP_DEBUG" ]] && echo "process_opts: option='$OPTION' name='$OPT_NAME' type='$TYPE' range='$RANGE'"
        case $TYPE in
            b)
                if [[ "$RANGE" ]]; then
                    export $OPT_NAME="$RANGE"
                else
                    # if no previous value, reset it
                    [[ "${!OPT_NAME}" ]] || export $OPT_NAME=
                    if [[ "${!OPT_NAME}" =~ ^[0-9]+$ ]]; then
                        export $OPT_NAME=$(( OPT_NAME + 1 ))
                    else
                        export $OPT_NAME=1
                    fi
                fi
                ;;
            *)
                local VALUE="$1"
                [[ "$RANGE" ]] && check_type_and_value "$OPT_NAME" "$VALUE" "$TYPE" "$RANGE"
                case $TYPE in
                    a|s*)
                        local SEP=${TYPE:1}
                        if [[ "$SEP" && "${!OPT_NAME}" ]]; then
                            export $OPT_NAME="${!OPT_NAME}${SEP}$VALUE"
                        elif [[ "$OPTION_SEP" && "${!OPT_NAME}" ]]; then
                            export $OPT_NAME="${!OPT_NAME}${OPTION_SEP}$VALUE"
                        else
                            export $OPT_NAME="$VALUE"
                        fi
                        ;;
                    *)
                        export $OPT_NAME="$VALUE"
                        ;;
                esac
                ((SHIFT_NUM++))
                shift
                set +x
                ;;
        esac
    done
    return $SHIFT_NUM
}

output_values_param() {
  local PARAM_NAME VALUE MANDATORY
  # NOTE : use local PARAM_NAME to not override param name which can be "NAME"
  for PARAM_NAME in $ARGP_PARAM_LIST; do
        VALUE="${!PARAM_NAME}"
        MANDATORY=$(get_param_mandatory $PARAM_NAME)

        [[ "$VALUE" ]] || {
          [[ "$MANDATORY" == "1" ]] && abend 1 "$PARAM_NAME is mandatory"
        }
        [[ "$VALUE" == *\'* ]] && VALUE=$(echo "${VALUE}" |sed -e "s/'/'\\\''/g")
        echo -n "export $PARAM_NAME='$VALUE'; "
    done

}

output_values_extra_param() {
  [[ "$EXTRA_PARAM" == *\'* ]] && EXTRA_PARAM=$(echo "${EXTRA_PARAM}" |sed -e "s/'/'\\\''/g")
  echo -n "export $ARGP_EXTRA_PARAMETER_VAR='$EXTRA_PARAM'; "
}

parse_after_end_options() {
  local i s
  i=0
  for s in "$@"; do
    ((i++))
    [ "$s" = "--" ] && break
  done
  shift $i

  output_values_after_end_options "$@" >&3
  # nb char of after end options
  local TMP="$@"
  return "${#TMP}"
}

# https://stackoverflow.com/a/45449744
shell_quote()
{
    local result=''
    local arg
    for arg in "$@" ; do

        # Append a space to our result, if necessary
        #
        result=${result}${result:+ }

        # Convert each embedded ' to \' , then insert ' at the
        # beginning of the line, and append ' at the end of
        # the line.
        #
        result=${result}$(printf "%s\n" "$arg" | \
          sed -e "s/'/'\\\\''/g" -e "1s/^/'/" -e "\$s/\$/'/")
    done

    # use printf(1) instead of echo to avoid weird "echo"
    # implementations.
    #
    printf "%s\n" "$result"
}


# https://stackoverflow.com/a/45449744
output_values_after_end_options() {
  # inject instructions to set @
  printf "set -- %s;\n" "$(shell_quote "$@")"
  # save values of @ into a variable DO NOT WORK
  #[[ "$ARGP_EXTRA_ARG_VAR" ]] && printf "export $ARGP_EXTRA_ARG_VAR=%s\n;" "$(shell_quote "$@")"
  # save instructions to set @ into a variable to evaluate
  [[ "$ARGP_EXTRA_ARG_EVAL_VAR" ]] && printf "export $ARGP_EXTRA_ARG_EVAL_VAR=%s\n;" "$(shell_quote "set --  $(shell_quote "$@")")"
}


parse_options_and_params() {
    local shift_option=0 shift_param=0 TMP= something_to_parse=1

    TMP="$@"

    # total size of options and parameters without ending options if any (--)
    TOTAL_SIZE="${#TMP}"
    [[ $ENDING_ARG_SIZE -gt 0 ]] && TOTAL_SIZE=$(( TOTAL_SIZE - ENDING_ARG_SIZE - 3))

    # if there is nothing left
    [[ ${TOTAL_SIZE} -eq 0 ]] && something_to_parse=

    [[ $something_to_parse ]] && {
      # reorder @ and put options at the beginning of ${ARGS[@]}
      call_getopt "$@"
      set -- "${ARGS[@]}"
      [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    }

    # PARSE OPTIONS ARG
    reset_opts
    process_opts "$@"
    # nb option shifted
    shift_option=$?
    shift $shift_option
    [[ $something_to_parse ]] && {
      [[ "$ARGP_DEBUG" ]] && debug_args "$@"
      output_values_options "$@" >&3
    }

    # PROCESS PARAMETERS ARG
    reset_params
    process_params "$@"
    # nb param shifted
    shift_param=$?
    shift $shift_param
    [[ $something_to_parse ]] && {
      [[ "$ARGP_DEBUG" ]] && debug_args "$@"
      output_values_param "$@" >&3
    }

    [[ $something_to_parse ]] && {
      [[ "$ARGP_EXTRA_PARAMETER_VAR" ]] && {
        # PROCESS EXTRA PARAMETERS
        process_extra_params "$@"
        # nb param shifted
        shift_param=$?
        shift $shift_param
        output_values_extra_param "$@" >&3
      }
    }
}


output_values_options() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"
    local OPT_NAME= VALUE= MANDATORY= DEF=
    # NOTE : use local OPT_NAME to not override option name which can be "NAME"
    for OPT_NAME in $ARGP_OPTION_LIST; do
        VALUE="${!OPT_NAME}"
        MANDATORY=$(get_opt_mandatory $OPT_NAME)

        [[ "$VALUE" ]] || {
            DEF=$(get_opt_default $OPT_NAME)
            [[ "$DEF" ]] || {
              [[ "$MANDATORY" == "1" ]] && abend 1 "$OPT_NAME is mandatory"
            }
            VALUE=$(get_opt_default $OPT_NAME)
        }
        [[ "$VALUE" == *\'* ]] && VALUE=$(echo "${VALUE}" |sed -e "s/'/'\\\''/g")
        echo -n "export $OPT_NAME='$VALUE'; "
    done

}

call_getopt() {
    [[ "$ARGP_DEBUG" ]] && debug_args "$@"

    local SHORT_OPTIONS=""
    local SHORT_OPTIONS_ARG=""
    local LONG_OPTIONS=""
    local LONG_OPTIONS_ARG=""
    local STOP_EARLY=""
    local OPT TEMP NAME LONG LABEL

    for NAME in $ARGP_OPTION_LIST; do
        OPT=$(get_opt_letter $NAME)
        LABEL=$(get_opt_label $NAME)
        LONG=$(get_opt_long_name $NAME)
        [[ "$OPT" == '-' ]] && continue
        if [[ "$OPT" ]]; then
            if [[ "$LABEL" ]]; then
                SHORT_OPTIONS_ARG+="$OPT:"
            else
                SHORT_OPTIONS+="$OPT"
            fi
        fi

        if [[ "$LABEL" ]]; then
            [[ "$LONG_OPTIONS_ARG" ]] && LONG_OPTIONS_ARG+=","
            LONG_OPTIONS_ARG+="$LONG:"
        else
            [[ "$LONG_OPTIONS" ]] && LONG_OPTIONS+=","
            LONG_OPTIONS+="$LONG"
        fi
    done

    [[ "$STOP_ON_FIRST_NON_OPT" ]] && STOP_EARLY="+"
    if [[ "${GARGP_LONG_GETOPT:-''}" ]]; then
        local SHORT_ARGS=""
        local LONG_ARGS=""
        [[ -n "$SHORT_OPTIONS$SHORT_OPTIONS_ARG" ]] && SHORT_ARGS="-o $STOP_EARLY$SHORT_OPTIONS$SHORT_OPTIONS_ARG"
        [[ -n "$LONG_OPTIONS" ]] && LONG_ARGS="--long $LONG_OPTIONS"
        [[ -n "$LONG_OPTIONS_ARG" ]] && LONG_ARGS="$LONG_ARGS --long $LONG_OPTIONS_ARG"
        [[ "$ARGP_DEBUG" ]] && echo "call_getopt: set -- \$($GETOPT_CMD $SHORT_ARGS $LONG_ARGS -n $ARGP_PROG -- $@)" >&2
        TEMP=$($GETOPT_CMD $SHORT_ARGS $LONG_ARGS -n "$ARGP_PROG" -- "$@") || abend $? "$GETOPT_CMD failure"
    else
        [[ "$ARGP_DEBUG" ]] && echo "call_getopt: set -- \$($GETOPT_CMD $SHORT_OPTIONS$SHORT_OPTIONS_ARG $@)" >&2
        TEMP=$($GETOPT_CMD $SHORT_OPTIONS$SHORT_OPTIONS_ARG "$@") || abend $? "$GETOPT_CMD failure"
    fi

    eval set -- "$TEMP"

    [[ "$ARGP_DEBUG" ]] && debug_args "$@"

    ARGS=( "$@" )
}

sort_option_names_by_key()
{
    [[ "$ARGP_DEBUG" ]] && echo "sort_option_names_by_key: before: $ARGP_OPTION_LIST" >&2
    local NEW_OPTION_LIST= NAME= KEY=
    local TMP=/tmp/$$.options

    for NAME in ${ARGP_OPTION_LIST:-}; do
        KEY=$(get_opt_letter $NAME)
        [[ "$KEY" ]] || KEY="~" # ie collate last
        [[ "$KEY" == - ]] && KEY="~" # ie collate last
        echo "$KEY $NAME"
    done | sort -f >$TMP

    while read KEY NAME; do
        NEW_OPTION_LIST+="$NAME "
    done < $TMP
    rm -f $TMP

    ARGP_OPTION_LIST="$NEW_OPTION_LIST"
    [[ "$ARGP_DEBUG" ]] && echo "sort_option_names_by_key: after: $NEW_OPTION_LIST" >&2
}

initialise() {
    GARGP_VERSION="2.3"
    STOP_ON_FIRST_NON_OPT=${POSIXLY_CORRECT:-}
    unset POSIXLY_CORRECT

    # by setting this env variable we can choose a getopt command
    [[ "$GETOPT_CMD" == "" ]] && GETOPT_CMD=getopt

    ARGP_PARAM_LIST=""
    LONG_DESC=
    ARGP_OPTION_LIST=""
    ARGP_OPTION_SEP=
    GARGP_LONG_GETOPT=""
    # decide if this getopt supports long options:
    {
        $GETOPT_CMD --test &>/dev/null; ARGP_STAT=$?
    } || :
    [[ $ARGP_STAT -eq 4 ]] && GARGP_LONG_GETOPT="GARGP_LONG_GETOPT_yes"

    GARGP_HELP_loption="help"
    GARGP_HELP_option="h"
    GARGP_VERBOSE_loption="verbose"
    GARGP_VERBOSE_option="v"
    VERBOSE=
    GARGP_QUIET_option="q"
    GARGP_QUIET_loption="quiet"
    QUIET=
    GARGP_VERSION_loption="version"
    GARGP_VERSION_option="V"
    GARGP_ENDOPTS_loption="end-all-options"

    GARGP_SHORT_OPT_COL=2
    GARGP_LONG_OPT_COL=6
    GARGP_OPT_DOC_COL=29

    GARGP_INT_REGEX="[+-]*[[:digit:]]+"
    GARGP_INT_RANGE_REGEX="$GARGP_INT_REGEX:$GARGP_INT_REGEX"
    GARGP_FLOAT_REGEX="[+-]*[[:digit:]]+(\\.[[:digit:]]+)*"
    GARGP_FLOAT_RANGE_REGEX="$GARGP_FLOAT_REGEX:$GARGP_FLOAT_REGEX"
    # TODO FIXME: this needs a few tweaks:
    GARGP_URL_REGEX="(nfs|http|https|ftp|file)://[[:alnum:]_.-]*[^[:space:]]*"

    # cron jobs have TERM=dumb and tput throws errors:
    type tput &>/dev/null && \
    _GPG_COLUMNS=$( [[ "$TERM" && "$TERM" != "dumb" ]] && tput cols || echo 80) \
    _GPG_COLUMNS=80
    GARGP_RMARGIN=$_GPG_COLUMNS

    load_help_fmt
    [[ "$GARGP_RMARGIN" -gt "$_GPG_COLUMNS" ]] && GARGP_RMARGIN=$_GPG_COLUMNS

    # we're being called directly from the commandline (possibly in error
    # but maybe the guy is just curious):
    # fix : have problem in some case
    # tty -s && {
    #     ARGP_VERSION=$GARGP_VERSION
    #     add_std_opts
    #     ARGP_PROG=${0##*/} # == basename
    #     ARGP_argp_sh_usage
    #     exit 0
    # }

}



read_config() {
    # note that we can't use process substitution:
    # foobar < <( barfoo )
    # as POSIXLY_CORRECT disables it! So we'll use a temp file for the xml.
    local TMP=/tmp/argp.sh.$$

    trap "rm -f $TMP" EXIT

    local FILE_TYPE= LINE=
    local READING_OPT=0
    local READING_PARAM=0
    local READING_HEADER=0
    local READING_LONG_DESC=0

    while read LINE; do

        [[ "$FILE_TYPE" ]] || {
            [[ "$LINE" == "<?xml"* ]] && {

                FILE_TYPE="xml"
                {
                    echo "$LINE"
                    cat
                } | read_xml_format > $TMP
                exec <$TMP
                continue
            }
        }

        [[ "$ARGP_DEBUG" ]] && echo "read: $LINE" >&2
        case "$LINE" in
            "--HEADER--")
                READING_HEADER=1
                READING_PARAM=0
                READING_OPT=0
                READING_LONG_DESC=0
                ;;
            "--PARAMETERS--")
                READING_HEADER=0
                READING_PARAM=1
                READING_OPT=0
                READING_LONG_DESC=0
                ;;
            "--OPTIONS--")
                READING_HEADER=0
                READING_PARAM=0
                READING_OPT=1
                READING_LONG_DESC=0
                ;;
            "ARGP_PROG="*)
                ARGP_PROG="${LINE#ARGP_PROG=}"
                ;;
            "ARGP_DELETE="*)
                del_opt ${LINE#ARGP_DELETE=}
                ;;
            "ARGP_SHORT="*)
                SHORT_DESC="${LINE#ARGP_SHORT=}"
                ;;
            "ARGP_VERSION="*)
                ARGP_VERSION="${LINE#ARGP_VERSION=}"
                ;;
            "ARGP_OPTION_SEP="*)
                ARGP_OPTION_SEP="${LINE#ARGP_OPTION_SEP=}"
                ;;
            "ARGP_EXTRA_PARAMETER_VAR="*)
                ARGP_EXTRA_PARAMETER_VAR="${LINE#ARGP_EXTRA_PARAMETER_VAR=}"
                ;;
            #"ARGP_EXTRA_ARG_VAR="*)
            #    ARGP_EXTRA_ARG_VAR="${LINE#ARGP_EXTRA_ARG_VAR=}"
            #    ;;
            "ARGP_EXTRA_ARG_EVAL_VAR="*)
                ARGP_EXTRA_ARG_EVAL_VAR="${LINE#ARGP_EXTRA_ARG_EVAL_VAR=}"
                ;;
            "ARGP_LONG_DESC="*)
                READING_HEADER=1
                READING_PARAM=0
                READING_OPT=0
                READING_LONG_DESC=1
                if [[ "${LINE#ARGP_LONG_DESC=}" ]]; then
                    LONG_DESC="${LINE#ARGP_LONG_DESC=} "$'\n'
                fi
                ;;

            *)  case "$LINE" in

              [A-Za-z]*)
                  if [[ "$READING_HEADER" == "1" ]]; then
                      if [[ "$READING_LONG_DESC" == "1" ]]; then
                          LONG_DESC+="$LINE"$'\n'
                       fi
                  fi

                  if [[ "$READING_PARAM" == "1" ]]; then
                    local NAME= REGEX= TYPE= RANGE= DESC= VAR= ORIGINAL_NAME= LABEL= MANDATORY=
                    NAME="${LINE%%=*}"
                    LINE="${LINE#$NAME=}"
                    ORIGINAL_NAME="$NAME"
                    NAME=$(convert_to_env_name $NAME)
                    # initial value could contain spaces, quotes, anything -
                    # but I don't think we need to support escaped quotes:
                    REGEX="^[[:space:]]*('[^']*'|[^[:space:]]+)[[:space:]]*(.*)"
                    for VAR in LABEL TYPE RANGE MANDATORY; do
                        [[ "$LINE" =~ $REGEX ]] || break
                        V="${BASH_REMATCH[1]}"
                        V="${V%\'}"
                        V="${V#\'}"
                        local $VAR="$V"
                        LINE="${BASH_REMATCH[2]}"
                    done

                    DESC="$LINE"
                    while [[ "$DESC" = *\\ ]]; do
                        DESC="${DESC%\\}"
                        read LINE
                        DESC+="$LINE"
                        [[ "$ARGP_DEBUG" ]] && echo "read for DESC: $LINE" >&2
                    done
                    add_param "$ORIGINAL_NAME" "$LABEL" "$TYPE" "$RANGE" "$MANDATORY" "$DESC"
                  fi

                  if [[ "$READING_OPT" == "1" ]]; then

                    local NAME= REGEX= DEFAULT= SNAME= LABEL= TYPE= MANDATORY= RANGE= DESC= VAR=
                    NAME="${LINE%%=*}"
                    LINE="${LINE#$NAME=}"
                    ORIGINAL_NAME="$NAME"
                    NAME=$(convert_to_env_name $NAME)
                    # initial value could contain spaces, quotes, anything -
                    # but I don't think we need to support escaped quotes:
                    REGEX="^[[:space:]]*('[^']*'|[^[:space:]]+)[[:space:]]*(.*)"
                    for VAR in DEFAULT SNAME LABEL TYPE MANDATORY RANGE; do
                        [[ "$LINE" =~ $REGEX ]] || break
                        V="${BASH_REMATCH[1]}"
                        V="${V%\'}"
                        V="${V#\'}"
                        local $VAR="$V"
                        LINE="${BASH_REMATCH[2]}"
                    done
                    DESC="$LINE"
                    while [[ "$DESC" = *\\ ]]; do
                        DESC="${DESC%\\}"
                        read LINE
                        DESC+="$LINE"
                        [[ "$ARGP_DEBUG" ]] && echo "read for DESC: $LINE" >&2
                    done
                    add_opt "$ORIGINAL_NAME" "$DEFAULT" "$SNAME" "$LABEL" "$TYPE" "$MANDATORY" "$RANGE" "$DESC"
                  fi
                  ;;
                  *) # includes comments
                    ;;
                esac
              ;;
        esac
    done
}

main() {
    add_std_opts
    read_config
    sort_option_names_by_key


    # PROCESS ARG AFTER END OPTIONS
    parse_after_end_options "$@"
    ENDING_ARG_SIZE=$?

    # PROCESS OPTIONS ARG, PARAMETERS ARG, AND EXTRA PARAMETERS ARG
    parse_options_and_params "$@"
}

check_bash() {
    [[ "$ARGP_DEBUG" ]] && echo "$ARGP_PROG: arpg.sh: debug is on" >&2

    ARGP_GOOD_ENOUGH=""
    if [ "x$BASH_VERSION" = "x" -o "x$BASH_VERSINFO" = "x" ]; then
        :
    elif [ "${BASH_VERSINFO[0]}" -gt 2 ]; then
        ARGP_GOOD_ENOUGH="1"
    fi
    if [ "x$ARGP_GOOD_ENOUGH" = "x" ]; then
        echo "$0: This version of the shell does not support this program." >&2
        echo "bash-3 or later is required" >&2
        echo "exit 1;" >&3
        exit 1
    fi
}

try_c_version() {
    [[ "${ARGP_PROCESSOR##*/}" != "${0##*/}" ]] && type argp &>/dev/null && {
        [[ "$ARGP_DEBUG" ]] &&
      echo "$ARGP_PROG: argp.sh exec'ing argp: you can use ARGP_PROCESSOR to override this" >&2
        exec argp "$@"
    }
}


if [[ "$GETOPT_CMD" == "PURE_BASH" ]]; then
  # include pure-getopt from Aron Griffis https://github.com/agriffis/pure-getopt
  source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../pool/artefact/pure-getopt/getopt.bash"
  GETOPT_CMD=getopt
fi

try_c_version "$@"
check_bash
initialise
main "$@"

# just to make sure we don't return with non-zero $?:
:
