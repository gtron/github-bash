# -*-Shell-script-*-
#

. ${BASH_SOURCE[0]%/*}/base.sh


task_get() {
  # http://developer.github.com/v3/repos/hooks/#json-http
  # /repos/:owner/:repo/git/commits/:sha
  local owner=$1 repo=$2 id=$3

  call_api -X GET \
   $(base_uri)/repos/${owner}/${repo}/git/commits/${id}
}
