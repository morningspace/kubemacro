##
# @Name: get-pod-containers
# @Description: List the pods with their containers.
#
# This is a sample macro to demonstrate how to write a macro by your own.
#
# It can be used to list a set of pods with their containers.
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro get-pod-containers [options]
# @Options:
#   -A, --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
#   context is ignored even if specified with --namespace.
#   -h, --help: Print the help information.
#   -n, --namespace='': If present, the namespace scope for this CLI request.
#   -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
#       --version: Print the version information.
#   -w, --watch=false: After listing/getting the requested object, watch for changes. Uninitialized objects are excluded
#   if no object name is provided.
#       --watch-only=false: Watch for changes to the requested object(s), without listing/getting first.
# @Examples:
#   # To list all pods with their containers in a namespace.
#   kubectl macro get-pod-containers -n foo
#   # To list all pods with their containers in all namespaces.
#   kubectl macro get-pod-containers -A
# @Dependencies: kubectl
##
function get-pod-containers {
  local args=()
  local ns=''
  # Parse the arguments input from command line
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -n|--namespace|-n=*|--namespace=*)
      ns=$2
      args+=("$1 $2")
      shift
      shift ;;
    -A|--all-namespaces)
      ns="all namespaces"
      args+=("$1")
      shift ;;
    *)
      args+=("$1")
      shift ;;
    esac
  done
  # Run kubectl get and define custom columns to include pod container names
  local custom_columns="NAME:.metadata.name,CONTAINERS:.spec.containers[*].name"
  if [[ $ns == "all namespaces" ]]; then
    custom_columns="NAMESPACE:.metadata.namespace,$custom_columns"
  fi
  kubectl get pods ${args[@]} -o custom-columns=$custom_columns
}
